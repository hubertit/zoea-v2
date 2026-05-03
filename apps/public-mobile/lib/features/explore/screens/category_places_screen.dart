import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/providers/categories_provider.dart';
import '../../../core/providers/listings_provider.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/auth_prompt_dialog.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/category_localization.dart';

class CategoryPlacesScreen extends ConsumerStatefulWidget {
  final String category; // This is the slug

  const CategoryPlacesScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<CategoryPlacesScreen> createState() =>
      _CategoryPlacesScreenState();
}

class _CategoryPlacesScreenState extends ConsumerState<CategoryPlacesScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  int _currentPage = 1;
  final int _pageSize = 20;
  String? _categoryId;
  String? _categoryName;
  bool _isAccommodation = false;

  // Subcategories and navigation
  List<Map<String, dynamic>> _subcategories = [];
  String?
      _selectedCategoryId; // Currently selected category/subcategory ID for listings
  // ignore: unused_field
  int _selectedTabIndex =
      0; // 0 = All, 1 = Popular, 2+ = subcategories (tracked for state management)
  String?
      _currentParentCategoryId; // Root category for this screen (scope of "All" tab)
  bool _isInitializingTabs =
      false; // Prevent listener from firing during initialization
  /// Detects when API children list changes so TabController is rebuilt.
  String? _tabsInitSignature;

  // Filter state
  double? _minRating;
  double? _minPrice;
  double? _maxPrice;
  bool? _isFeatured;

  // Sort state
  String? _sortBy;

  bool get _hasActiveFilters =>
      _minRating != null ||
      _minPrice != null ||
      _maxPrice != null ||
      _isFeatured != null;

  @override
  void initState() {
    super.initState();
    // TabController will be initialized after we know the number of tabs

    // Shimmer animation controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start shimmer animation
    _shimmerController.repeat();

    // Shimmer animation
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _initializeTabs(List<Map<String, dynamic>>? children) {
    _isInitializingTabs = true;

    // Extract direct children only (not nested)
    _subcategories =
        (children ?? []).where((child) => child['isActive'] != false).toList();

    final tabCount = 1 + _subcategories.length; // All + subcategories

    // Dispose old controller if exists
    _tabController?.dispose();

    // Create new controller with correct number of tabs
    _tabController = TabController(length: tabCount, vsync: this);
    _tabController!.addListener(() {
      // Don't handle tab change during initialization
      if (!_isInitializingTabs) {
        // Handle both during swipe (indexIsChanging) and after completion
        _handleTabChange(_tabController!.index);
      }
    });

    // Set initial selected category
    if (_selectedCategoryId == null) {
      _selectedCategoryId = _categoryId;
      _currentParentCategoryId = _categoryId;
    }

    _isInitializingTabs = false;
  }

  void _handleTabChange(int index) {
    if (!mounted || _tabController == null) return;

    setState(() {
      _selectedTabIndex = index;
      _currentPage = 1;

      if (index == 0) {
        _selectedCategoryId = _currentParentCategoryId ?? _categoryId;
        _sortBy = null;
      } else {
        final subcategoryIndex = index - 1;
        if (subcategoryIndex < _subcategories.length) {
          final subcategory = _subcategories[subcategoryIndex];
          _selectedCategoryId = subcategory['id'] as String?;
          _sortBy = null;
        }
      }
    });
  }

  bool _isAccommodationCategory(String? apiCategorySlug, String routeSlug) {
    final slug = (apiCategorySlug ?? routeSlug).toLowerCase();
    return slug.contains('hotel') || slug.contains('accommodation');
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryBySlugProvider(widget.category));

    return categoryAsync.when(
      data: (categoryData) {
        final categoryId = categoryData['id'] as String?;
        final categorySlugApi = categoryData['slug'] as String?;
        final localizedTitle = localizedCategoryName(
          Map<String, dynamic>.from(categoryData),
          Localizations.localeOf(context),
        );
        final categoryDisplayName = localizedTitle.isNotEmpty
            ? localizedTitle
            : (categoryData['name'] as String? ?? '');
        if (categoryId == null) {
          return Scaffold(
            backgroundColor: context.grey50,
            appBar: AppBar(
              backgroundColor: context.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => context.pop(),
                color: context.primaryTextColor,
              ),
              title: Text(widget.category),
            ),
            body: Center(child: Text(AppLocalizations.of(context)!.categoryNotFound)),
          );
        }

        final childrenAsync = ref.watch(categoryChildrenProvider(categoryId));

        return childrenAsync.when(
          data: (children) {
            final isAccommodation =
                _isAccommodationCategory(categorySlugApi, widget.category);
            final sig = '$categoryId|${children.map((c) => c['id']).join(',')}';

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (_tabsInitSignature != sig) {
                setState(() {
                  _categoryId = categoryId;
                  _categoryName = categoryDisplayName;
                  _currentParentCategoryId = categoryId;
                  _isAccommodation = isAccommodation;
                  _initializeTabs(children);
                  _tabsInitSignature = sig;
                });
              }
            });

            return Scaffold(
              backgroundColor: context.grey50,
              appBar: AppBar(
                backgroundColor: context.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.chevron_left, size: 32),
                  onPressed: () => context.pop(),
                  color: context.primaryTextColor,
                ),
                title: Text(
                  _categoryName ?? widget.category,
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        context.push('/search?category=${widget.category}'),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _showFilterBottomSheet,
                      ),
                      if (_hasActiveFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.primaryColorTheme,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: _showSortBottomSheet,
                      ),
                      if (_sortBy != null && _sortBy != 'popular')
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.primaryColorTheme,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                bottom: _isAccommodation || _tabController == null
                    ? null
                    : TabBar(
                        controller: _tabController,
                        indicatorColor: context.primaryColorTheme,
                        labelColor: context.primaryColorTheme,
                        unselectedLabelColor: context.secondaryTextColor,
                        labelStyle: context.bodySmall
                            .copyWith(fontWeight: FontWeight.w600),
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        onTap: (index) async {
                          if (index > 0) {
                            final subcategory = _subcategories[index - 1];
                            final subcategoryId = subcategory['id'] as String?;
                            final slug = subcategory['slug'] as String?;

                            if (subcategoryId != null && slug != null) {
                              try {
                                // Check condition in app by testing the endpoint response
                                final children = await ref.read(
                                    categoryChildrenProvider(subcategoryId)
                                        .future);
                                if (children.isNotEmpty) {
                                  if (context.mounted) {
                                    // Small delay to allow the ripple effect to show
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      if (context.mounted) {
                                        context.push('/category/$slug');
                                      }
                                    });
                                  }
                                }
                              } catch (e) {
                                // If it fails or has no children, just act as a normal tab
                              }
                            }
                          }
                        },
                        tabs: [
                          Tab(text: AppLocalizations.of(context)!.stayTabAll),
                          ..._subcategories.map((subcategory) {
                            final label = localizedCategoryName(
                              Map<String, dynamic>.from(subcategory),
                              Localizations.localeOf(context),
                            );
                            return Tab(
                              text: label.isNotEmpty
                                  ? label
                                  : AppLocalizations.of(context)!
                                      .exploreListingUnknown,
                            );
                          }),
                        ],
                      ),
              ),
              body: _categoryId != null && _tabController != null
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        // "All" tab
                        _buildListingsListForTab(0),
                        // Subcategory tabs
                        ..._subcategories.asMap().entries.map((entry) {
                          return _buildListingsListForTab(entry.key + 1);
                        }),
                      ],
                    )
                  : _categoryId == null
                      ? Center(
                          child: Text(AppLocalizations.of(context)!.categoryNotFound),
                        )
                      : _buildSkeletonLoader(), // Show skeleton while tabs initialize
            );
          },
          loading: () => Scaffold(
            backgroundColor: context.grey50,
            appBar: AppBar(
              backgroundColor: context.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => context.pop(),
                color: context.primaryTextColor,
              ),
              title: Text(
                widget.category,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
            ),
            body: _buildSkeletonLoader(),
          ),
          error: (error, stack) => Scaffold(
            backgroundColor: context.grey50,
            appBar: AppBar(
              backgroundColor: context.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => context.pop(),
                color: context.primaryTextColor,
              ),
              title: Text(
                widget.category,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.secondaryTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.categoryErrorSubcategories,
                    style: context.headlineSmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: context.bodyMedium.copyWith(
                      color: context.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(categoryChildrenProvider(categoryId));
                    },
                    child: Text(AppLocalizations.of(context)!.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: context.grey50,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () => context.pop(),
            color: context.primaryTextColor,
          ),
          title: Text(
            widget.category,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
        ),
        body: _buildSkeletonLoader(), // Show skeleton while loading category
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: context.grey50,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () => context.pop(),
            color: context.primaryTextColor,
          ),
          title: Text(
            widget.category,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.secondaryTextColor,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.categoryErrorCategory,
                style: context.headlineSmall.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(categoryBySlugProvider(widget.category));
                },
                child: Text(AppLocalizations.of(context)!.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Getter for the category ID to use for listings
  String? get _categoryIdForListings => _selectedCategoryId ?? _categoryId;

  ListingsParams _listingsParamsForCategoryTab({
    required String categoryId,
    String? sortBy,
    required bool includeSubtree,
  }) {
    return ListingsParams(
      page: 1,
      limit: _pageSize,
      category: categoryId,
      includeChildren: includeSubtree,
      rating: _minRating,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      isFeatured: _isFeatured,
      sortBy: sortBy,
    );
  }

  // Get category ID and sort for a specific tab index
  Map<String, dynamic> _getTabParams(int tabIndex) {
    if (tabIndex == 0) {
      return {
        'categoryId': _currentParentCategoryId ?? _categoryId,
        'sortBy': 'rating_desc',
        'showSubcategoryBadge': true,
        'includeChildren': true,
      };
    }
    final subcategoryIndex = tabIndex - 1;
    if (subcategoryIndex < _subcategories.length) {
      final subcategory = _subcategories[subcategoryIndex];
      return {
        'categoryId': subcategory['id'] as String?,
        'sortBy': null,
        'showSubcategoryBadge': false,
        'includeChildren': false,
      };
    }
    return {
      'categoryId': _categoryId,
      'sortBy': null,
      'showSubcategoryBadge': false,
      'includeChildren': false,
    };
  }

  Widget _buildListingsListForTab(int tabIndex) {
    final tabParams = _getTabParams(tabIndex);
    final categoryId = tabParams['categoryId'] as String?;
    final sortBy = tabParams['sortBy'] as String?;
    final includeSubtree = tabParams['includeChildren'] as bool? ?? false;
    final showSubcategoryBadge =
        tabParams['showSubcategoryBadge'] as bool? ?? false;

    if (categoryId == null) {
      return Center(child: Text(AppLocalizations.of(context)!.categoryNotFound));
    }

    final listingsAsync = ref.watch(
      listingsProvider(
        _listingsParamsForCategoryTab(
          categoryId: categoryId,
          sortBy: sortBy,
          includeSubtree: includeSubtree,
        ),
      ),
    );

    return listingsAsync.when(
      data: (response) {
        final listings = response['data'] as List? ?? [];
        final meta = response['meta'] as Map<String, dynamic>?;
        final totalPages = meta?['totalPages'] ?? 1;

        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore,
                  size: 64,
                  color: context.secondaryTextColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.stayEmptyNoMatchesForCategory(
                    _categoryName ?? widget.category,
                  ),
                  style: context.headlineSmall.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.categoryPlacesEmptySubtitle,
                  style: context.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: context.primaryColorTheme,
          backgroundColor: context.cardColor,
          onRefresh: () async {
            ref.invalidate(
              listingsProvider(
                _listingsParamsForCategoryTab(
                  categoryId: categoryId,
                  sortBy: sortBy,
                  includeSubtree: includeSubtree,
                ),
              ),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index] as Map<String, dynamic>;
              if (_isAccommodation) {
                return _buildAccommodationCard(listing,
                    showSubcategoryBadge: showSubcategoryBadge);
              } else {
                return _buildRegularListingCard(listing,
                    showSubcategoryBadge: showSubcategoryBadge);
              }
            },
          ),
        );
      },
      loading: () => _buildSkeletonLoader(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.categoryErrorListings,
              style: context.headlineSmall.copyWith(
                color: context.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(
                  listingsProvider(
                    _listingsParamsForCategoryTab(
                      categoryId: categoryId,
                      sortBy: sortBy,
                      includeSubtree: includeSubtree,
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsList() {
    if (_categoryId == null) {
      return Center(child: Text(AppLocalizations.of(context)!.categoryNotFound));
    }

    final listingsAsync = ref.watch(
      listingsProvider(
        ListingsParams(
          page: _currentPage,
          limit: _pageSize,
          category: _categoryIdForListings,
          rating: _minRating,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          isFeatured: _isFeatured,
          sortBy: _sortBy,
        ),
      ),
    );

    return listingsAsync.when(
      data: (response) {
        final listings = response['data'] as List? ?? [];
        final meta = response['meta'] as Map<String, dynamic>?;
        final totalPages = meta?['totalPages'] ?? 1;

        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore,
                  size: 64,
                  color: context.secondaryTextColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.stayEmptyNoMatchesForCategory(
                    _categoryName ?? widget.category,
                  ),
                  style: context.headlineSmall.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.categoryPlacesEmptySubtitle,
                  style: context.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: context.primaryColorTheme,
          backgroundColor: context.cardColor,
          onRefresh: () async {
            ref.invalidate(
              listingsProvider(
                ListingsParams(
                  page: _currentPage,
                  limit: _pageSize,
                  category: _categoryIdForListings,
                  rating: _minRating,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  isFeatured: _isFeatured,
                  sortBy: _sortBy,
                ),
              ),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listings.length + (_currentPage < totalPages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == listings.length) {
                // Load more indicator
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentPage++;
                        });
                        // Invalidate to fetch next page with current filters and sort
                        ref.invalidate(
                          listingsProvider(
                            ListingsParams(
                              page: _currentPage,
                              limit: _pageSize,
                              category: _categoryIdForListings,
                              rating: _minRating,
                              minPrice: _minPrice,
                              maxPrice: _maxPrice,
                              isFeatured: _isFeatured,
                              sortBy: _sortBy,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.commonLoadMore),
                    ),
                  ),
                );
              }

              final listing = listings[index] as Map<String, dynamic>;

              if (_isAccommodation) {
                return _buildAccommodationCard(listing);
              } else {
                return _buildRegularListingCard(listing);
              }
            },
          ),
        );
      },
      loading: () => _buildSkeletonLoader(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.categoryErrorListings,
              style: context.headlineSmall.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(
                  listingsProvider(
                    ListingsParams(
                      page: _currentPage,
                      limit: _pageSize,
                      category: _categoryIdForListings,
                      rating: _minRating,
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                      isFeatured: _isFeatured,
                      sortBy: _sortBy,
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularListingCard(Map<String, dynamic> listing,
      {bool showSubcategoryBadge = false}) {
    final listingId = listing['id'] as String? ?? '';
    final name = listing['name'] as String? ?? 'Unknown';

    // Extract image URL - images is a List of Maps with media objects
    String? imageUrl;
    if (listing['images'] != null &&
        listing['images'] is List &&
        (listing['images'] as List).isNotEmpty) {
      final firstImage = (listing['images'] as List).first;
      if (firstImage is Map && firstImage['media'] != null) {
        imageUrl =
            firstImage['media']['url'] ?? firstImage['media']['thumbnailUrl'];
      } else if (firstImage is String) {
        imageUrl = firstImage;
      }
    }

    // Extract address - address is directly on listing, city is an object
    final address = listing['address'] as String? ?? '';
    String cityName = '';
    final city = listing['city'];
    if (city is Map) {
      cityName = (city as Map<String, dynamic>)['name'] as String? ?? '';
    } else if (city is String) {
      cityName = city;
    }
    final locationText = address.isNotEmpty && cityName.isNotEmpty
        ? '$address, $cityName'
        : address.isNotEmpty
            ? address
            : cityName.isNotEmpty
                ? cityName
                : 'Location not available';

    // Extract rating
    final rating = listing['rating'] != null
        ? (listing['rating'] is String
            ? double.tryParse(listing['rating']) ?? 0.0
            : (listing['rating'] as num?)?.toDouble() ?? 0.0)
        : 0.0;
    // Backend returns _count.reviews, not reviewCount directly
    final reviewCount =
        (listing['_count'] as Map<String, dynamic>?)?['reviews'] as int? ??
            listing['reviewCount'] as int? ??
            0;

    // Extract price - minPrice and currency are directly on listing
    final minPrice = listing['minPrice'] != null
        ? (listing['minPrice'] is String
            ? double.tryParse(listing['minPrice']) ?? 0.0
            : (listing['minPrice'] as num?)?.toDouble() ?? 0.0)
        : 0.0;
    final maxPrice = listing['maxPrice'] != null
        ? (listing['maxPrice'] is String
            ? double.tryParse(listing['maxPrice']) ?? 0.0
            : (listing['maxPrice'] as num?)?.toDouble() ?? 0.0)
        : 0.0;
    final currency = listing['currency'] as String? ?? 'RWF';
    final priceText = minPrice > 0
        ? (maxPrice > minPrice
            ? PriceFormatter.formatAbbreviatedRange(minPrice, maxPrice,
                currency: currency)
            : PriceFormatter.formatAbbreviated(minPrice, currency: currency))
        : '';

    // Extract subcategory name if showing badge
    String displayCategory = _categoryName ?? widget.category;
    if (showSubcategoryBadge && listing['category'] != null) {
      final categoryData = listing['category'];
      if (categoryData is Map<String, dynamic>) {
        final locName = localizedCategoryName(
          categoryData,
          Localizations.localeOf(context),
        );
        displayCategory =
            locName.isNotEmpty ? locName : displayCategory;
      }
    }

    // Check if favorited
    final isFavoritedAsync = ref.watch(isListingFavoritedProvider(listingId));

    return PlaceCard(
      name: name,
      location: locationText,
      image: imageUrl ?? '',
      rating: rating,
      reviews: reviewCount,
      priceRange: priceText,
      category: displayCategory,
      isFavorite: isFavoritedAsync.when(
        data: (isFavorited) => isFavorited,
        loading: () => false,
        error: (_, __) => false,
      ),
      onTap: () {
        context.push('/listing/$listingId');
      },
      onFavorite: () async {
        final l10n = AppLocalizations.of(context)!;
        final isLoggedIn = ref.read(isLoggedInProvider);
        if (!isLoggedIn) {
          AuthPromptDialog.show(
            context: context,
            title: l10n.exploreFavoriteSignInTitle,
            message: l10n.exploreFavoriteSignInMessage,
            icon: Icons.favorite,
          );
          return;
        }

        try {
          final favoritesService = ref.read(favoritesServiceProvider);
          final isFavorited = isFavoritedAsync.value ?? false;

          await favoritesService.toggleFavorite(listingId: listingId);

          ref.invalidate(isListingFavoritedProvider(listingId));
          ref.invalidate(
            favoritesProvider(const FavoritesParams(page: 1, limit: 100)),
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              AppTheme.successSnackBar(
                message: isFavorited
                    ? AppConfig.favoriteRemovedMessage
                    : AppConfig.favoriteAddedMessage,
              ),
            );
          }
        } catch (e) {
          final errorText = e.toString();
          if (context.mounted && errorText.contains('Unauthorized')) {
            AuthPromptDialog.show(
              context: context,
              title: l10n.exploreFavoriteSessionTitle,
              message: l10n.exploreFavoriteSessionMessage,
              icon: Icons.favorite,
            );
            return;
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              AppTheme.errorSnackBar(
                message: l10n.commonFavoriteUpdateFailed(
                  errorText.replaceFirst('Exception: ', ''),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildAccommodationCard(Map<String, dynamic> listing,
      {bool showSubcategoryBadge = false}) {
    final listingId = listing['id'] as String? ?? '';
    final name = listing['name'] as String? ?? 'Unknown';

    // Extract image URL - images is a List of Maps with media objects
    String? imageUrl;
    if (listing['images'] != null &&
        listing['images'] is List &&
        (listing['images'] as List).isNotEmpty) {
      final firstImage = (listing['images'] as List).first;
      if (firstImage is Map && firstImage['media'] != null) {
        imageUrl =
            firstImage['media']['url'] ?? firstImage['media']['thumbnailUrl'];
      } else if (firstImage is String) {
        imageUrl = firstImage;
      }
    }

    // Extract address - address is directly on listing, city is an object
    final address = listing['address'] as String? ?? '';
    String cityName = '';
    final city = listing['city'];
    if (city is Map) {
      cityName = (city as Map<String, dynamic>)['name'] as String? ?? '';
    } else if (city is String) {
      cityName = city;
    }
    final locationText = address.isNotEmpty && cityName.isNotEmpty
        ? '$address, $cityName'
        : address.isNotEmpty
            ? address
            : cityName.isNotEmpty
                ? cityName
                : 'Location not available';

    // Extract rating
    final rating = listing['rating'] != null
        ? (listing['rating'] is String
            ? double.tryParse(listing['rating']) ?? 0.0
            : (listing['rating'] as num?)?.toDouble() ?? 0.0)
        : 0.0;
    // Backend returns _count.reviews, not reviewCount directly
    final reviewCount =
        (listing['_count'] as Map<String, dynamic>?)?['reviews'] as int? ??
            listing['reviewCount'] as int? ??
            0;

    // Extract price - minPrice and currency are directly on listing
    final minPrice = listing['minPrice'] != null
        ? (listing['minPrice'] is String
            ? double.tryParse(listing['minPrice']) ?? 0.0
            : (listing['minPrice'] as num?)?.toDouble() ?? 0.0)
        : 0.0;
    final currency = listing['currency'] as String? ?? 'RWF';

    // Extract amenities
    final amenities = listing['amenities'] as List? ?? [];

    // Extract subcategory name if showing badge
    String? subcategoryName;
    if (showSubcategoryBadge && listing['category'] != null) {
      final categoryData = listing['category'];
      if (categoryData is Map<String, dynamic>) {
        final locName = localizedCategoryName(
          categoryData,
          Localizations.localeOf(context),
        );
        subcategoryName = locName.isNotEmpty ? locName : null;
      }
    }

    // Check if favorited
    final isFavoritedAsync = ref.watch(isListingFavoritedProvider(listingId));

    return GestureDetector(
      onTap: () {
        context.push('/listing/$listingId');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 200,
                            color: context.grey200,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: context.primaryColorTheme)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: context.grey200,
                            child: Icon(
                              Icons.image_not_supported,
                              color: context.grey400,
                              size: 48,
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: context.grey200,
                          child: Icon(
                            Icons.image_not_supported,
                            color: context.grey400,
                            size: 48,
                          ),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      final l10n = AppLocalizations.of(context)!;
                      final isLoggedIn = ref.read(isLoggedInProvider);
                      if (!isLoggedIn) {
                        AuthPromptDialog.show(
                          context: context,
                          title: l10n.exploreFavoriteSignInTitle,
                          message: l10n.exploreFavoriteSignInMessage,
                          returnPath: '/listing/$listingId',
                          icon: Icons.favorite,
                        );
                        return;
                      }

                      try {
                        final favoritesService =
                            ref.read(favoritesServiceProvider);
                        final isFavorited = isFavoritedAsync.value ?? false;

                        await favoritesService.toggleFavorite(
                            listingId: listingId);

                        ref.invalidate(isListingFavoritedProvider(listingId));
                        ref.invalidate(favoritesProvider(
                            const FavoritesParams(page: 1, limit: 100)));

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppTheme.successSnackBar(
                              message: isFavorited
                                  ? AppConfig.favoriteRemovedMessage
                                  : AppConfig.favoriteAddedMessage,
                            ),
                          );
                        }
                      } catch (e) {
                        final errorText = e.toString();
                        if (context.mounted &&
                            errorText.contains('Unauthorized')) {
                          AuthPromptDialog.show(
                            context: context,
                            title: l10n.exploreFavoriteSessionTitle,
                            message: l10n.exploreFavoriteSessionMessage,
                            returnPath: '/listing/$listingId',
                            icon: Icons.favorite,
                          );
                          return;
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppTheme.errorSnackBar(
                              message: l10n.commonFavoriteUpdateFailed(
                                errorText.replaceFirst('Exception: ', ''),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: isFavoritedAsync.when(
                        data: (isFavorited) => Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.white,
                          size: 20,
                        ),
                        loading: () => const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                        error: (_, __) => const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                // Price badge
                if (minPrice > 0)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.primaryColorTheme,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        PriceFormatter.formatAbbreviated(minPrice,
                            currency: currency),
                        style: context.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: context.headlineSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: context.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewCount)',
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: context.secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationText,
                          style: context.bodySmall.copyWith(
                            color: context.secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (subcategoryName != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.primaryColorTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: context.primaryColorTheme.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        subcategoryName,
                        style: context.bodySmall.copyWith(
                          color: context.primaryColorTheme,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                  if (amenities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: amenities.take(4).map<Widget>((amenity) {
                        final amenityName = amenity is String
                            ? amenity
                            : amenity['name'] as String? ?? '';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.grey100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            amenityName,
                            style: context.bodySmall.copyWith(
                              color: context.primaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    // Local state for bottom sheet
    double? tempMinRating = _minRating;
    double? tempMinPrice = _minPrice;
    double? tempMaxPrice = _maxPrice;
    bool? tempIsFeatured = _isFeatured;

    final minPriceController = TextEditingController(
      text: _minPrice != null ? _minPrice!.toStringAsFixed(0) : '',
    );
    final maxPriceController = TextEditingController(
      text: _maxPrice != null ? _maxPrice!.toStringAsFixed(0) : '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final loc = AppLocalizations.of(context)!;
          return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.categoryFilterSheetTitle(
                          _categoryName ?? widget.category),
                      style: context.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Minimum Rating
                Text(
                  loc.stayMinimumRating,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildRatingChip(
                      context,
                      loc.categoryRatingStars40,
                      4.0,
                      tempMinRating,
                      (value) {
                        setModalState(() {
                          tempMinRating = tempMinRating == value ? null : value;
                        });
                      },
                    ),
                    _buildRatingChip(
                      context,
                      loc.categoryRatingStars45,
                      4.5,
                      tempMinRating,
                      (value) {
                        setModalState(() {
                          tempMinRating = tempMinRating == value ? null : value;
                        });
                      },
                    ),
                    _buildRatingChip(
                      context,
                      loc.categoryRatingStars50,
                      5.0,
                      tempMinRating,
                      (value) {
                        setModalState(() {
                          tempMinRating = tempMinRating == value ? null : value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Price Range
                Text(
                  loc.categorySectionPriceRange,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: loc.exploreFilterLabelMinPrice,
                          hintText: loc.exploreFilterBudgetHintMin,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.grey300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.grey300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: context.primaryColorTheme),
                          ),
                          prefixText: 'RWF ',
                        ),
                        onChanged: (value) {
                          final price = double.tryParse(value);
                          setModalState(() {
                            tempMinPrice = price;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: loc.exploreFilterLabelMaxPrice,
                          hintText: loc.exploreFilterBudgetHintNoLimit,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.grey300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.grey300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: context.primaryColorTheme),
                          ),
                          prefixText: 'RWF ',
                        ),
                        onChanged: (value) {
                          final price = double.tryParse(value);
                          setModalState(() {
                            tempMaxPrice = price;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Featured Only
                CheckboxListTile(
                  title: Text(
                    loc.listingFeaturedOnlyTitle,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.primaryTextColor,
                    ),
                  ),
                  subtitle: Text(
                    loc.listingFeaturedOnlySubtitle,
                    style: context.bodySmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                  value: tempIsFeatured == true,
                  onChanged: (bool? value) {
                    setModalState(() {
                      tempIsFeatured = (value == true) ? true : null;
                    });
                  },
                  activeColor: context.primaryColorTheme,
                  contentPadding: EdgeInsets.zero,
                ),

                // Action buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            tempMinRating = null;
                            tempMinPrice = null;
                            tempMaxPrice = null;
                            tempIsFeatured = null;
                            minPriceController.clear();
                            maxPriceController.clear();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.primaryColorTheme,
                          side: BorderSide(color: context.primaryColorTheme),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(AppLocalizations.of(context)!.commonClearAll),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minRating = tempMinRating;
                            _minPrice = tempMinPrice;
                            _maxPrice = tempMaxPrice;
                            _isFeatured = tempIsFeatured;
                            _currentPage = 1; // Reset to first page
                          });
                          minPriceController.dispose();
                          maxPriceController.dispose();
                          Navigator.pop(context);
                          // Invalidate provider to refresh with new filters
                          ref.invalidate(
                            listingsProvider(
                              ListingsParams(
                                page: 1,
                                limit: _pageSize,
                                category: _categoryIdForListings,
                                rating: _minRating,
                                minPrice: _minPrice,
                                maxPrice: _maxPrice,
                                isFeatured: _isFeatured,
                                sortBy: _sortBy,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(AppLocalizations.of(context)!.stayApplyFilters),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildRatingChip(BuildContext ctx, String label, double value,
      double? selectedValue, Function(double) onSelected) {
    final isSelected = selectedValue == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      selectedColor: ctx.primaryColorTheme.withOpacity(0.2),
      checkmarkColor: ctx.primaryColorTheme,
      labelStyle: context.bodySmall.copyWith(
        color: isSelected ? ctx.primaryColorTheme : ctx.primaryTextColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _showSortBottomSheet() {
    // Local state for bottom sheet
    String? tempSortBy = _sortBy;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        final categoryLabel = _categoryName ?? widget.category;
        return StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.categorySortSheetTitle(categoryLabel),
                        style: context.headlineSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sort Options
                  _buildSortOption(loc.shopSortPopular, 'popular', tempSortBy,
                      (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.staySortRatingHighLow, 'rating_desc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.staySortRatingLowHigh, 'rating_asc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.staySortPriceLowHigh, 'price_asc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.staySortPriceHighLow, 'price_desc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.shopSortNameAz, 'name_asc', tempSortBy,
                      (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.shopSortNameZa, 'name_desc', tempSortBy,
                      (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.shopSortNewest, 'createdAt_desc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),
                  _buildSortOption(loc.listingSortOldestFirst, 'createdAt_asc',
                      tempSortBy, (value) {
                    setModalState(() {
                      tempSortBy = tempSortBy == value ? null : value;
                    });
                  }),

                  // Action buttons
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempSortBy = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.primaryColorTheme,
                            side: BorderSide(color: context.primaryColorTheme),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(loc.commonClear),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _sortBy = tempSortBy;
                              _currentPage = 1; // Reset to first page
                            });
                            Navigator.pop(context);
                            // Invalidate provider to refresh with new sort
                            ref.invalidate(
                              listingsProvider(
                                ListingsParams(
                                  page: 1,
                                  limit: _pageSize,
                                  category: _categoryIdForListings,
                                  rating: _minRating,
                                  minPrice: _minPrice,
                                  maxPrice: _maxPrice,
                                  isFeatured: _isFeatured,
                                  sortBy: _sortBy,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(loc.exploreApplySort),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, String value, String? selectedValue,
      Function(String) onSelected) {
    final isSelected = selectedValue == value;
    return ListTile(
      title: Text(
        label,
        style: context.bodyMedium.copyWith(
          color: context.primaryTextColor,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: context.primaryColorTheme)
          : null,
      onTap: () => onSelected(value),
      selected: isSelected,
      selectedTileColor: context.primaryColorTheme.withOpacity(0.1),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        if (_isAccommodation) {
          return _buildSkeletonAccommodationCard();
        } else {
          return _buildSkeletonRegularCard();
        }
      },
    );
  }

  Widget _buildSkeletonRegularCard() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.grey200,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.grey200,
                          context.grey100,
                          context.grey200,
                        ],
                        stops: [
                          0.0,
                          _shimmerAnimation.value,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                  // Favorite button skeleton
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              // Content skeleton
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.grey300,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.grey300,
                                  context.grey200,
                                  context.grey300,
                                ],
                                stops: [
                                  0.0,
                                  _shimmerAnimation.value,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: context.grey300,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.grey300,
                                  context.grey200,
                                  context.grey300,
                                ],
                                stops: [
                                  0.0,
                                  _shimmerAnimation.value,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 40,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonAccommodationCard() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.grey200,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.grey200,
                          context.grey100,
                          context.grey200,
                        ],
                        stops: [
                          0.0,
                          _shimmerAnimation.value,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                  // Favorite button skeleton
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Price badge skeleton
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      width: 70,
                      height: 28,
                      decoration: BoxDecoration(
                        color: context.grey300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              // Content skeleton
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.grey300,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.grey300,
                                  context.grey200,
                                  context.grey300,
                                ],
                                stops: [
                                  0.0,
                                  _shimmerAnimation.value,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: context.grey300,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.grey300,
                                  context.grey200,
                                  context.grey300,
                                ],
                                stops: [
                                  0.0,
                                  _shimmerAnimation.value,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Amenities skeleton
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 60 + (index * 20),
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.grey300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
