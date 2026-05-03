import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/providers/categories_provider.dart';
import '../../../core/providers/listings_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/category_localization.dart';

class CategorySearchScreen extends ConsumerStatefulWidget {
  final String category;
  
  const CategorySearchScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends ConsumerState<CategorySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSubCategory = 'All';
  String? _selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, size: 32),
          style: IconButton.styleFrom(
            foregroundColor: context.primaryTextColor,
          ),
        ),
        title: Text(
          l10n.categorySearchAppBar(_localizedCategoryName(l10n)),
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: context.backgroundColor,
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: _searchHint(l10n),
                hintStyle: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: context.grey50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: context.primaryColorTheme,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          
          // Sub-category Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.backgroundColor,
            child: _buildSubCategoryChips(),
          ),
          
          // Search Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  String _localizedCategoryName(AppLocalizations l10n) {
    switch (widget.category) {
      case 'dining':
        return l10n.categoryTitleDining;
      case 'nightlife':
        return l10n.categoryTitleNightlife;
      case 'experiences':
        return l10n.categoryTitleExperiences;
      default:
        return l10n.categoryTitlePlaces;
    }
  }

  String _searchHint(AppLocalizations l10n) {
    switch (widget.category) {
      case 'dining':
        return l10n.categorySearchHintDining;
      case 'nightlife':
        return l10n.categorySearchHintNightlife;
      case 'experiences':
        return l10n.categorySearchHintExperiences;
      default:
        return l10n.categorySearchHintDefault;
    }
  }

  Widget _buildSubCategoryChips() {
    // Fetch category by slug to get subcategories
    final categoryAsync = ref.watch(categoryBySlugProvider(widget.category));
    
    return categoryAsync.when(
      data: (categoryData) {
        final l10n = AppLocalizations.of(context)!;
        final children = categoryData['children'] as List?;
        List<Map<String, String?>> subCategories = [
          {'label': l10n.stayTabAll, 'value': 'All', 'id': null}
        ];
        
        // Add subcategories from API if available
        if (children != null && children.isNotEmpty) {
          for (var child in children) {
            final childMap = child as Map<String, dynamic>;
            final canonical = childMap['name'] as String? ?? '';
            final id = childMap['id'] as String?;
            if (canonical.isNotEmpty && id != null) {
              final locLabel = localizedCategoryName(
                childMap,
                Localizations.localeOf(context),
              );
              final label =
                  locLabel.isNotEmpty ? locLabel : canonical;
              subCategories.add({
                'label': label,
                'value': canonical,
                'id': id,
              });
            }
          }
        } else {
          // Fallback to hardcoded subcategories if API doesn't provide children
          switch (widget.category) {
            case 'dining':
              subCategories.addAll([
                {'label': l10n.catSubDiningRestaurants, 'value': 'Restaurants', 'id': null},
                {'label': l10n.catSubDiningCafes, 'value': 'Cafes', 'id': null},
                {'label': l10n.catSubDiningFastFood, 'value': 'Fast Food', 'id': null},
              ]);
              break;
            case 'nightlife':
              subCategories.addAll([
                {'label': l10n.catSubNightBars, 'value': 'Bar', 'id': null},
                {'label': l10n.catSubNightClubs, 'value': 'Club', 'id': null},
                {'label': l10n.catSubNightLounges, 'value': 'Lounge', 'id': null},
              ]);
              break;
            case 'experiences':
              subCategories.addAll([
                {'label': l10n.catSubExpTours, 'value': 'Tours', 'id': null},
                {'label': l10n.catSubExpAdventures, 'value': 'Adventures', 'id': null},
                {'label': l10n.catSubExpCultural, 'value': 'Cultural', 'id': null},
                {'label': l10n.catSubExpOperators, 'value': 'Operators', 'id': null},
              ]);
              break;
          }
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: subCategories.map((subCategory) {
              final isSelected = _selectedSubCategory == subCategory['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    subCategory['label']!,
                    style: context.bodySmall.copyWith(
                      color: isSelected ? context.primaryTextColor : context.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSubCategory = subCategory['value']!;
                        _selectedSubCategoryId = subCategory['id'];
                      });
                    }
                  },
                  selectedColor: context.primaryColorTheme,
                  backgroundColor: context.backgroundColor,
                  side: BorderSide(
                    color: isSelected ? context.primaryColorTheme : context.dividerColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildSearchResults() {
    // Fetch category by slug to get category ID
    final categoryAsync = ref.watch(categoryBySlugProvider(widget.category));
    
    return categoryAsync.when(
      data: (categoryData) {
        final l10n = AppLocalizations.of(context)!;
        final categoryId = categoryData['id'] as String?;
        
        if (categoryId == null) {
          return Center(
            child: Text(
              l10n.categoryNotFound,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          );
        }
        
        // Use subcategory ID if available, otherwise use main category ID
        final categoryIdForListings = _selectedSubCategoryId ?? categoryId;
        
        // Fetch listings with search query and category filter
        final listingsAsync = ref.watch(
          listingsProvider(
            ListingsParams(
              page: 1,
              limit: 100, // Fetch enough results for search
              category: categoryIdForListings,
              search: _searchQuery.isEmpty ? null : _searchQuery,
              status: 'active', // Only fetch active listings
            ),
          ),
        );
        
        return listingsAsync.when(
          data: (response) {
            List listings = List.from(response['data'] as List? ?? []);
            
            // If subcategory ID is not available, filter by name as fallback
            if (_selectedSubCategory != 'All' && _selectedSubCategoryId == null) {
              listings = listings.where((listing) {
                final listingCategory = listing['category'] as Map<String, dynamic>?;
                final categoryName = listingCategory?['name'] as String?;
                return categoryName == _selectedSubCategory;
              }).toList();
            }
            
            if (listings.isEmpty) {
              return _buildEmptyState(l10n);
            }
            
            return RefreshIndicator(
              color: context.primaryColorTheme,
              backgroundColor: context.cardColor,
              onRefresh: () async {
                ref.invalidate(
                  listingsProvider(
                    ListingsParams(
                      page: 1,
                      limit: 100,
                      category: categoryIdForListings,
                      search: _searchQuery.isEmpty ? null : _searchQuery,
                      status: 'active',
                    ),
                  ),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index] as Map<String, dynamic>;
                  
                  // Special handling for tour operators
                  if (widget.category == 'experiences' && _selectedSubCategory == 'Operators') {
                    return _buildTourOperatorCard(context, listing);
                  }
                  
                  return _buildListingCard(listing);
                },
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: context.primaryColorTheme),
          ),
          error: (error, stack) {
            return Center(
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
                    l10n.categoryErrorListings,
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
                            page: 1,
                            limit: 100,
                            category: categoryIdForListings,
                            search: _searchQuery.isEmpty ? null : _searchQuery,
                            status: 'active',
                          ),
                        ),
                      );
                    },
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: context.primaryColorTheme),
      ),
      error: (error, stack) {
        final l10n = AppLocalizations.of(context)!;
        return Center(
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
                l10n.categoryErrorCategory,
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
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildListingCard(Map<String, dynamic> listing) {
    final l10n = AppLocalizations.of(context)!;
    // Extract listing data
    final name = listing['name'] as String? ?? l10n.exploreListingUnknown;
    final location = listing['location'] as Map<String, dynamic>?;
    final city = location?['city'] as Map<String, dynamic>?;
    final locationName = city?['name'] as String? ?? l10n.exploreListingUnknown;
    final images = listing['images'] as List?;
    final imageUrl = images != null && images.isNotEmpty 
        ? images[0] as String? 
        : null;
    final rating = (listing['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (listing['reviews'] as List?)?.length ?? 0;
    final priceRange = listing['priceRange'] as String?;
    final category = listing['category'] as Map<String, dynamic>?;
    final categoryName = category != null
        ? localizedCategoryName(category, Localizations.localeOf(context))
        : '';
    final id = listing['id'] as String? ?? '';
    final isFavorite = listing['isFavorite'] as bool? ?? false;
    
    return PlaceCard(
      name: name,
      location: locationName,
      image: imageUrl ?? 'https://via.placeholder.com/400x300',
      rating: rating,
      reviews: reviews,
      priceRange: priceRange ?? '',
      category: categoryName,
      isFavorite: isFavorite,
      onFavorite: () {
        // TODO: Implement favorite toggle
      },
      onTap: () {
        context.push('/place/$id');
      },
    );
  }

  Widget _buildTourOperatorCard(BuildContext context, Map<String, dynamic> operator) {
    final l10n = AppLocalizations.of(context)!;
    // Extract operator data
    final name = operator['name'] as String? ?? l10n.exploreListingUnknown;
    final location = operator['location'] as Map<String, dynamic>?;
    final city = location?['city'] as Map<String, dynamic>?;
    final locationName = city?['name'] as String? ?? l10n.exploreListingUnknown;
    final images = operator['images'] as List?;
    final imageUrl = images != null && images.isNotEmpty 
        ? images[0] as String? 
        : null;
    final rating = (operator['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (operator['reviews'] as List?)?.length ?? 0;
    final description = operator['description'] as String?;
    final id = operator['id'] as String? ?? '';
    
    return GestureDetector(
      onTap: () {
        context.push('/place/$id');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.primaryTextColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/400x300',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: context.grey200,
                  child: const Icon(Icons.business, size: 50),
                ),
              ),
            ),
            // Operator content
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
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColorTheme.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.catTourOperatorBadge,
                          style: context.bodySmall.copyWith(
                            color: context.primaryColorTheme,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                          locationName,
                          style: context.bodyMedium.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
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
                        l10n.listingReviewsCountParen(reviews),
                        style: context.bodySmall.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: context.bodyMedium.copyWith(
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildEmptyState(AppLocalizations l10n) {
    final catName = _localizedCategoryName(l10n);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: context.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty 
                ? l10n.categoryEmptyPrompt(catName)
                : l10n.categoryEmptyNoResults,
            style: context.headlineSmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? _searchSuggestions(l10n)
                : l10n.categoryEmptyTryDifferentKeywords,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _searchSuggestions(AppLocalizations l10n) {
    switch (widget.category) {
      case 'dining':
        return l10n.categorySearchSuggestionsDining;
      case 'nightlife':
        return l10n.categorySearchSuggestionsNightlife;
      case 'experiences':
        return l10n.categorySearchSuggestionsExperiences;
      default:
        return l10n.categorySearchSuggestionsDefault;
    }
  }

  void _showFilterBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    final catName = _localizedCategoryName(l10n);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.categoryFilterSheetTitle(catName),
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              
              // Price Range Filter
              Text(
                l10n.categorySectionPriceRange,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildPriceRangeFilters(l10n),
              ),
              
              const SizedBox(height: 20),
              
              // Rating Filter
              Text(
                l10n.stayMinimumRating,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(l10n.categoryRatingStars40, false),
                  _buildFilterChip(l10n.categoryRatingStars45, false),
                  _buildFilterChip(l10n.categoryRatingStars50, false),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Features Filter
              Text(
                l10n.categorySectionFeatures,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildFeatureFilters(l10n),
              ),
              
              const SizedBox(height: 30),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.primaryColorTheme,
                        side: BorderSide(color: context.primaryColorTheme),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(l10n.commonClearAll),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(l10n.stayApplyFilters),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPriceRangeFilters(AppLocalizations l10n) {
    switch (widget.category) {
      case 'dining':
        return [
          _buildFilterChip(l10n.catPriceDiningU5k, false),
          _buildFilterChip(l10n.catPriceDining5to15k, false),
          _buildFilterChip(l10n.catPriceDining15to30k, false),
          _buildFilterChip(l10n.catPriceDiningOver30k, false),
        ];
      case 'nightlife':
        return [
          _buildFilterChip(l10n.catPriceNightU10k, false),
          _buildFilterChip(l10n.catPriceNight10to20k, false),
          _buildFilterChip(l10n.catPriceNight20to30k, false),
          _buildFilterChip(l10n.catPriceNightOver30k, false),
        ];
      case 'experiences':
        return [
          _buildFilterChip(l10n.catPriceExpU50k, false),
          _buildFilterChip(l10n.catPriceExp50to100k, false),
          _buildFilterChip(l10n.catPriceExp100to200k, false),
          _buildFilterChip(l10n.catPriceExpOver200k, false),
        ];
      default:
        return [
          _buildFilterChip(l10n.catPriceDefU10k, false),
          _buildFilterChip(l10n.catPriceDef10to30k, false),
          _buildFilterChip(l10n.catPriceDefOver30k, false),
        ];
    }
  }

  List<Widget> _buildFeatureFilters(AppLocalizations l10n) {
    switch (widget.category) {
      case 'dining':
        return [
          _buildFilterChip(l10n.catFeatDiningWifi, false),
          _buildFilterChip(l10n.catFeatDiningParking, false),
          _buildFilterChip(l10n.catFeatDiningOutdoorSeating, false),
          _buildFilterChip(l10n.catFeatDiningDelivery, false),
          _buildFilterChip(l10n.catFeatDiningTakeaway, false),
          _buildFilterChip(l10n.catFeatDiningVegetarian, false),
        ];
      case 'nightlife':
        return [
          _buildFilterChip(l10n.catFeatNightLiveMusic, false),
          _buildFilterChip(l10n.catFeatNightDanceFloor, false),
          _buildFilterChip(l10n.catFeatNightOutdoorSeating, false),
          _buildFilterChip(l10n.catFeatNightVip, false),
          _buildFilterChip(l10n.catFeatNightParking, false),
          _buildFilterChip(l10n.catFeatNightWifi, false),
        ];
      case 'experiences':
        return [
          _buildFilterChip(l10n.catFeatExpGuidedTours, false),
          _buildFilterChip(l10n.catFeatExpTransport, false),
          _buildFilterChip(l10n.catFeatExpMeals, false),
          _buildFilterChip(l10n.catFeatExpEquipment, false),
          _buildFilterChip(l10n.catFeatExpGroup, false),
          _buildFilterChip(l10n.catFeatExpPrivate, false),
        ];
      default:
        return [
          _buildFilterChip(l10n.catFeatDefWifi, false),
          _buildFilterChip(l10n.catFeatDefParking, false),
          _buildFilterChip(l10n.catFeatDefAccessible, false),
        ];
    }
  }

  void _showSortBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    final catName = _localizedCategoryName(l10n);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.categorySortSheetTitle(catName),
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              
              // Sort Options
              _buildSortOption(l10n.staySortDistance, Icons.location_on, true),
              _buildSortOption(l10n.staySortRatingHighLow, Icons.star, false),
              _buildSortOption(l10n.staySortPriceLowHigh, Icons.arrow_upward, false),
              _buildSortOption(l10n.staySortPriceHighLow, Icons.arrow_downward, false),
              _buildSortOption(l10n.staySortPopularity, Icons.trending_up, false),
              _buildSortOption(l10n.shopSortNewest, Icons.schedule, false),
              _buildSortOption(l10n.shopSortNameAz, Icons.sort_by_alpha, false),
              
              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.primaryColorTheme,
                        side: BorderSide(color: context.primaryColorTheme),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(l10n.commonCancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(l10n.commonApply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: context.bodySmall.copyWith(
          color: isSelected ? context.primaryTextColor : context.primaryTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        // Handle filter selection
      },
      selectedColor: context.primaryColorTheme,
      backgroundColor: context.backgroundColor,
      side: BorderSide(
        color: isSelected ? context.primaryColorTheme : context.dividerColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildSortOption(String label, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Handle sort selection
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? context.primaryColorTheme : context.dividerColor,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: context.bodyMedium.copyWith(
                    color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: context.primaryColorTheme,
                ),
            ],
          ),
        ),
      ),
    );
  }

}
