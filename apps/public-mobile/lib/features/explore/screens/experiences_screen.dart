import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/providers/tours_provider.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/auth_prompt_dialog.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';

/// Tab keys for API/filter logic — labels come from [AppLocalizations].
enum _ExperienceTab {
  all,
  tours,
  adventures,
  cultural,
  operators,
}

class ExperiencesScreen extends ConsumerStatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  ConsumerState<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends ConsumerState<ExperiencesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSort = 'Popular';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? _typeFilterForTab(_ExperienceTab tab) {
    switch (tab) {
      case _ExperienceTab.all:
      case _ExperienceTab.tours:
        return null;
      case _ExperienceTab.adventures:
        return 'adventure';
      case _ExperienceTab.cultural:
        return 'cultural';
      case _ExperienceTab.operators:
        return null;
    }
  }

  bool _isAllTab(_ExperienceTab tab) => tab == _ExperienceTab.all;

  String _emptyTitle(AppLocalizations loc, _ExperienceTab tab) {
    switch (tab) {
      case _ExperienceTab.all:
        return loc.experiencesEmptyAll;
      case _ExperienceTab.tours:
        return loc.experiencesEmptyTours;
      case _ExperienceTab.adventures:
        return loc.experiencesEmptyAdventures;
      case _ExperienceTab.cultural:
        return loc.experiencesEmptyCultural;
      case _ExperienceTab.operators:
        return loc.experiencesEmptyOperators;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.grey50,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.go('/explore'),
          icon: const Icon(Icons.chevron_left, size: 32),
          style: IconButton.styleFrom(
            foregroundColor: context.primaryTextColor,
          ),
        ),
        title: Text(
          loc.categoryTitleExperiences,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search?category=experiences'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.primaryColorTheme,
          labelColor: context.primaryColorTheme,
          unselectedLabelColor: context.secondaryTextColor,
          labelStyle: context.bodySmall.copyWith(fontWeight: FontWeight.w600),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: [
            Tab(text: loc.stayTabAll),
            Tab(text: loc.experiencesTabTours),
            Tab(text: loc.experiencesTabAdventures),
            Tab(text: loc.experiencesTabCultural),
            Tab(text: loc.experiencesTabOperators),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExperiencesList(_ExperienceTab.all),
          _buildExperiencesList(_ExperienceTab.tours),
          _buildExperiencesList(_ExperienceTab.adventures),
          _buildExperiencesList(_ExperienceTab.cultural),
          _buildTourOperatorsList(),
        ],
      ),
    );
  }

  Widget _buildExperiencesList(_ExperienceTab tab) {
    final typeFilter = _typeFilterForTab(tab);
    final isAllTab = _isAllTab(tab);

    final toursAsync = ref.watch(
      toursProvider(
        ToursParams(
          page: 1,
          limit: 100,
          status: 'active',
          type: isAllTab ? null : typeFilter,
          search: null,
        ),
      ),
    );

    return toursAsync.when(
      data: (response) {
        final tours = (response['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        if (tours.isEmpty) {
          return _buildEmptyState(tab);
        }

        return RefreshIndicator(
          color: context.primaryColorTheme,
          backgroundColor: context.cardColor,
          onRefresh: () async {
            ref.invalidate(
              toursProvider(
                ToursParams(
                  page: 1,
                  limit: 100,
                  status: 'active',
                  type: isAllTab ? null : typeFilter,
                  search: null,
                ),
              ),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return _buildExperienceCard(tour, showSubcategoryBadge: isAllTab);
            },
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: context.primaryColorTheme,
        ),
      ),
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
              AppLocalizations.of(context)!.experiencesFailedLoad,
              style: context.titleMedium.copyWith(
                color: context.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(
                  toursProvider(
                    ToursParams(
                      page: 1,
                      limit: 100,
                      status: 'active',
                      type: isAllTab ? null : typeFilter,
                      search: null,
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

  Widget _buildExperienceCard(Map<String, dynamic> tour, {bool showSubcategoryBadge = false}) {
    final loc = AppLocalizations.of(context)!;
    final id = tour['id'] as String? ?? '';
    final name = tour['name'] as String? ?? loc.exploreListingUnknown;
    final startLocationName = tour['startLocationName'] as String? ?? '';
    final city = tour['city'] as Map<String, dynamic>?;
    final cityName = city?['name'] as String? ?? '';
    final location = startLocationName.isNotEmpty 
        ? '$startLocationName${cityName.isNotEmpty ? ', $cityName' : ''}'
        : cityName.isNotEmpty ? cityName : loc.stayLocationUnavailable;
    
    final images = tour['images'] as List? ?? [];
    String? imageUrl;
    if (images.isNotEmpty && images[0] != null) {
      if (images[0] is Map) {
        final imageMap = images[0] as Map<String, dynamic>;
        imageUrl = imageMap['media']?['url'] as String?;
      } else {
        imageUrl = images[0] as String?;
      }
    }
    
    final rating = (tour['rating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = (tour['reviewCount'] as num?)?.toInt() ?? 
                       (tour['review_count'] as num?)?.toInt() ?? 0;
    
    final pricePerPerson = tour['pricePerPerson'] as num?;
    final currency = tour['currency'] as String? ?? 'USD';
    final priceRange = pricePerPerson != null
        ? '${PriceFormatter.formatAbbreviated(pricePerPerson.toDouble(), currency: currency)}/person'
        : '';
    
    final category = tour['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'] as String? ?? loc.tourListingFallbackName;
    final tourType = tour['type'] as String? ?? loc.tourListingFallbackName;
    
    // For "All" tab, show the tour type as category badge
    String displayCategory = categoryName.isNotEmpty ? categoryName : tourType;
    if (showSubcategoryBadge && tourType.isNotEmpty) {
      // Capitalize first letter of tour type
      displayCategory = tourType[0].toUpperCase() + tourType.substring(1);
    }

    // Check if favorite (tours use tourId, not listingId)
    final favoritesAsync = ref.watch(favoritesProvider(const FavoritesParams(page: 1, limit: 1000)));
    final isFavorite = favoritesAsync.maybeWhen(
      data: (favoritesData) {
        final favorites = (favoritesData['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        return favorites.any((fav) => fav['tourId'] == id || fav['tour_id'] == id);
      },
      orElse: () => false,
    );

    return PlaceCard(
      name: name,
      location: location,
      image: imageUrl ?? '',
      rating: rating,
      reviews: reviewCount,
      priceRange: priceRange,
      category: displayCategory,
      onTap: () {
        // Navigate to tour detail screen
        context.push('/tour/$id');
      },
      onFavorite: () async {
        final l10n = AppLocalizations.of(context)!;
        final isLoggedIn = ref.read(isLoggedInProvider);
        if (!isLoggedIn) {
          AuthPromptDialog.show(
            context: context,
            title: l10n.exploreFavoriteSignInTitle,
            message: l10n.tourFavoriteSignInMessage,
            returnPath: '/tour/$id',
            icon: Icons.favorite,
          );
          return;
        }

        try {
          // Toggle favorite for tour
          final favoritesService = ref.read(favoritesServiceProvider);
          if (isFavorite) {
            await favoritesService.removeFromFavorites(tourId: id);
          } else {
            await favoritesService.addTourToFavorites(id);
          }
          ref.invalidate(
            favoritesProvider(const FavoritesParams(page: 1, limit: 1000)),
          );
        } catch (e) {
          final errorText = e.toString();
          if (errorText.contains('Unauthorized')) {
            AuthPromptDialog.show(
              context: context,
              title: l10n.exploreFavoriteSessionTitle,
              message: l10n.exploreFavoriteSessionMessage,
              returnPath: '/tour/$id',
              icon: Icons.favorite,
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            AppTheme.errorSnackBar(
              message: l10n.commonFavoriteUpdateFailed(
                errorText.replaceFirst('Exception: ', ''),
              ),
            ),
          );
        }
      },
      isFavorite: isFavorite,
    );
  }

  Widget _buildTourOperatorsList() {
    // Fetch tours and group by operator
    // In the future, this could fetch from a dedicated tour operators endpoint
    final toursAsync = ref.watch(
      toursProvider(
        ToursParams(
          page: 1,
          limit: 100,
          status: 'active',
        ),
      ),
    );

    return toursAsync.when(
      data: (response) {
        final loc = AppLocalizations.of(context)!;
        final tours = (response['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        
        // Group tours by operator
        final operatorMap = <String, Map<String, dynamic>>{};
        for (final tour in tours) {
          final operator = tour['operator'] as Map<String, dynamic>?;
          if (operator != null) {
            final operatorId = operator['id'] as String? ?? '';
            if (operatorId.isNotEmpty && !operatorMap.containsKey(operatorId)) {
              operatorMap[operatorId] = {
                'id': operatorId,
                'name': operator['companyName'] as String? ?? loc.tourOperatorUnknown,
                'rating': operator['averageRating'] as num? ?? 0.0,
                'tours': <Map<String, dynamic>>[],
              };
            }
            if (operatorMap.containsKey(operatorId)) {
              (operatorMap[operatorId]!['tours'] as List).add(tour);
            }
          }
        }
        
        final operators = operatorMap.values.toList();

        if (operators.isEmpty) {
          return _buildEmptyState(_ExperienceTab.operators);
        }

        return RefreshIndicator(
          color: context.primaryColorTheme,
          backgroundColor: context.cardColor,
          onRefresh: () async {
            ref.invalidate(
              toursProvider(
                ToursParams(
                  page: 1,
                  limit: 100,
                  status: 'active',
                ),
              ),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: operators.length,
            itemBuilder: (context, index) {
              final operator = operators[index];
              return _buildTourOperatorCard(operator);
            },
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: context.primaryColorTheme,
        ),
      ),
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
              AppLocalizations.of(context)!.experiencesOperatorsFailedLoad,
              style: context.titleMedium.copyWith(
                color: context.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(
                  toursProvider(
                    ToursParams(
                      page: 1,
                      limit: 100,
                      status: 'active',
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

  Widget _buildTourOperatorCard(Map<String, dynamic> operator) {
    final loc = AppLocalizations.of(context)!;
    final name = operator['name'] as String? ?? loc.tourOperatorUnknown;
    final rating = (operator['rating'] as num?)?.toDouble() ?? 0.0;
    final tours = operator['tours'] as List<Map<String, dynamic>>? ?? [];
    
    // Get location from first tour
    String location = loc.stayLocationUnavailable;
    String? imageUrl;
    String priceFormatted = '';
    String? phone;
    String? description;
    
    if (tours.isNotEmpty) {
      final firstTour = tours[0];
      final city = firstTour['city'] as Map<String, dynamic>?;
      final cityName = city?['name'] as String? ?? '';
      final startLocationName = firstTour['startLocationName'] as String? ?? '';
      location = startLocationName.isNotEmpty 
          ? '$startLocationName${cityName.isNotEmpty ? ', $cityName' : ''}'
          : cityName.isNotEmpty ? cityName : loc.stayLocationUnavailable;
      
      final images = firstTour['images'] as List? ?? [];
      if (images.isNotEmpty && images[0] != null) {
        if (images[0] is Map) {
          final imageMap = images[0] as Map<String, dynamic>;
          imageUrl = imageMap['media']?['url'] as String?;
        } else {
          imageUrl = images[0] as String?;
        }
      }
      
      final pricePerPerson = firstTour['pricePerPerson'] as num?;
      final currency = firstTour['currency'] as String? ?? 'USD';
      if (pricePerPerson != null) {
        priceFormatted = PriceFormatter.formatAbbreviated(
          pricePerPerson.toDouble(),
          currency: currency,
        );
      }
      
      final operatorData = firstTour['operator'] as Map<String, dynamic>?;
      phone = operatorData?['contactPhone'] as String?;
      description = firstTour['description'] as String? ?? firstTour['shortDescription'] as String?;
    }
    
    final reviewCount = tours.length; // Use tour count as a proxy

    return GestureDetector(
      onTap: () {
        // Navigate to operator detail or first tour
        if (tours.isNotEmpty) {
          final firstTour = tours[0];
          final tourId = firstTour['id'] as String? ?? '';
          context.push('/tour-booking', extra: {
            'tourId': tourId,
            'tourName': firstTour['name'] as String? ?? loc.tourListingFallbackName,
            'tourLocation': location,
            'tourImage': imageUrl ?? '',
            'tourRating': (firstTour['rating'] as num?)?.toDouble() ?? 0.0,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imageUrl != null && imageUrl.isNotEmpty
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
                                color: context.primaryColorTheme,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: context.grey200,
                            child: Icon(
                              Icons.business,
                              size: 50,
                              color: context.secondaryTextColor,
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: context.grey200,
                          child: Icon(
                            Icons.business,
                            size: 50,
                            color: context.secondaryTextColor,
                          ),
                        ),
                ),
              ],
            ),
            // Business details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
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
                          location,
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
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.primaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.tourOperatorReviewsCount(reviewCount),
                        style: context.bodySmall.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description.length > 100 
                          ? '${description.substring(0, 100)}...'
                          : description,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (priceFormatted.isNotEmpty ||
                      (phone != null && phone.isNotEmpty))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (priceFormatted.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tourCardStartingFromLabel,
                                style: context.bodySmall.copyWith(
                                  color: context.secondaryTextColor,
                                ),
                              ),
                              Text(
                                priceFormatted,
                                style: context.bodyLarge.copyWith(
                                  color: context.primaryColorTheme,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        if (phone != null && phone.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                loc.commonContact,
                                style: context.bodySmall.copyWith(
                                  color: context.secondaryTextColor,
                                ),
                              ),
                              Text(
                                phone,
                                style: context.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: context.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(_ExperienceTab tab) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore,
            size: 80,
            color: context.secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _emptyTitle(loc, tab),
            style: context.headlineSmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.experiencesEmptySubtitle,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final loc = AppLocalizations.of(sheetContext)!;
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.experiencesFilterBy,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption(sheetContext, loc.stayTabAll, 'All'),
              _buildFilterOption(
                  sheetContext, loc.experiencesTabTours, 'Tours'),
              _buildFilterOption(
                  sheetContext, loc.experiencesTabAdventures, 'Adventures'),
              _buildFilterOption(
                  sheetContext, loc.experiencesTabCultural, 'Cultural'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
      BuildContext sheetContext, String label, String value) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedFilter,
        onChanged: (value) {
          setState(() {
            _selectedFilter = value!;
          });
          Navigator.pop(sheetContext);
        },
        activeColor: context.primaryColorTheme,
      ),
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(sheetContext);
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final loc = AppLocalizations.of(sheetContext)!;
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.staySortBy,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption(sheetContext, loc.shopSortPopular, 'Popular'),
              _buildSortOption(
                  sheetContext, loc.experiencesSortRating, 'Rating'),
              _buildSortOption(
                  sheetContext, loc.staySortDistance, 'Distance'),
              _buildSortOption(
                  sheetContext, loc.experiencesSortPrice, 'Price'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
      BuildContext sheetContext, String label, String value) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedSort,
        onChanged: (value) {
          setState(() {
            _selectedSort = value!;
          });
          Navigator.pop(sheetContext);
        },
        activeColor: context.primaryColorTheme,
      ),
      onTap: () {
        setState(() {
          _selectedSort = value;
        });
        Navigator.pop(sheetContext);
      },
    );
  }
}
