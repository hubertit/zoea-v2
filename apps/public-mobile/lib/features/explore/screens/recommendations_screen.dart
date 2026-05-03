import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/providers/listings_provider.dart';
import '../../../core/providers/categories_provider.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/category_localization.dart';

/// One top-level category tab: label + every category id in that subtree (root and descendants).
class _RecommendationRootTab {
  final String name;
  final Set<String> descendantIds;

  const _RecommendationRootTab({
    required this.name,
    required this.descendantIds,
  });
}

Set<String> _collectDescendantCategoryIds(Map<String, dynamic> node) {
  final out = <String>{};
  final id = node['id']?.toString();
  if (id != null && id.isNotEmpty) out.add(id);
  final children = node['children'];
  if (children is List) {
    for (final c in children) {
      if (c is Map<String, dynamic>) {
        out.addAll(_collectDescendantCategoryIds(c));
      }
    }
  }
  return out;
}

/// Root slugs excluded from Recommendations tabs (e.g. events live elsewhere in the app).
const _recommendationsExcludedRootSlugs = {'events'};

List<_RecommendationRootTab> _rootTabsFromCategoryTree(
  List<Map<String, dynamic>> roots,
  Locale locale,
) {
  final out = <_RecommendationRootTab>[];
  for (final r in roots) {
    if (r['isActive'] == false) continue;
    final slug = (r['slug'] as String?)?.trim().toLowerCase() ?? '';
    if (slug.isNotEmpty && _recommendationsExcludedRootSlugs.contains(slug)) continue;
    final display = localizedCategoryName(r, locale).trim();
    if (display.isEmpty) continue;
    final ids = _collectDescendantCategoryIds(r);
    if (ids.isEmpty) continue;
    out.add(_RecommendationRootTab(name: display, descendantIds: ids));
  }
  return out;
}

String? _listingCategoryId(Map<String, dynamic> listing) {
  final cat = listing['category'];
  if (cat is Map<String, dynamic>) {
    return cat['id']?.toString();
  }
  return null;
}

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  final Set<String> _favoritePlaces = {};

  List<Map<String, dynamic>> _filterByCategorySubtree(
    List<Map<String, dynamic>> listings,
    Set<String>? allowedCategoryIds,
  ) {
    if (allowedCategoryIds == null || allowedCategoryIds.isEmpty) return listings;
    return listings.where((listing) {
      final cid = _listingCategoryId(listing);
      return cid != null && allowedCategoryIds.contains(cid);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () => context.pop(),
            color: context.primaryTextColor,
          ),
          title: Text(
            'Recommendations',
            style: context.headlineSmall.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: context.primaryColorTheme),
        ),
      ),
      error: (_, __) => _buildScaffoldWithTabs(context, const []),
      data: (roots) => _buildScaffoldWithTabs(
            context,
            _rootTabsFromCategoryTree(roots, Localizations.localeOf(context)),
          ),
    );
  }

  Widget _buildScaffoldWithTabs(BuildContext context, List<_RecommendationRootTab> rootTabs) {
    final tabCount = 1 + rootTabs.length;

    return DefaultTabController(
      length: tabCount,
      key: ValueKey<int>(tabCount),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () => context.pop(),
            color: context.primaryTextColor,
          ),
          title: Text(
            'Recommendations',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/search?category=recommendations'),
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
            indicatorColor: context.primaryColorTheme,
            labelColor: context.primaryColorTheme,
            unselectedLabelColor: context.secondaryTextColor,
            labelStyle: context.bodySmall.copyWith(fontWeight: FontWeight.w600),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: [
              const Tab(text: 'All'),
              ...rootTabs.map((t) => Tab(text: t.name)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecommendationsList(null),
            ...rootTabs.map((t) => _buildRecommendationsList(t.descendantIds)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(Set<String>? allowedCategoryIds) {
    final featuredAsync = ref.watch(featuredListingsWithHomeFallbackProvider);

    return featuredAsync.when(
      data: (listings) {
        final filteredListings = _filterByCategorySubtree(listings, allowedCategoryIds);

        if (filteredListings.isEmpty) {
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
                  AppLocalizations.of(context)!.exploreRecommendationsEmptyTitle,
                  style: context.headlineSmall.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  allowedCategoryIds == null
                      ? AppLocalizations.of(context)!.exploreRecommendationsEmptySubtitleSoon
                      : AppLocalizations.of(context)!.exploreRecommendationsEmptySubtitleCategory,
                  style: context.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: context.primaryColorTheme,
          backgroundColor: context.cardColor,
          onRefresh: () async {
            ref.invalidate(featuredListingsWithHomeFallbackProvider);
            ref.invalidate(categoriesProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredListings.length,
            itemBuilder: (context, index) {
              final listing = filteredListings[index];
              return _buildPlaceCardFromListing(listing);
            },
          ),
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildSkeletonCard();
        },
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
              AppLocalizations.of(context)!.exploreRecommendationsLoadFailed,
              style: context.headlineSmall.copyWith(
                color: context.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: context.bodySmall.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(featuredListingsWithHomeFallbackProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColorTheme,
              ),
              child: Text(AppLocalizations.of(context)!.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCardFromListing(Map<String, dynamic> listing) {
    String? imageUrl;
    if (listing['images'] != null && listing['images'] is List && (listing['images'] as List).isNotEmpty) {
      final firstImage = (listing['images'] as List).first;
      if (firstImage is Map && firstImage['media'] != null) {
        imageUrl = firstImage['media']['url'] ?? firstImage['media']['thumbnailUrl'];
      } else if (firstImage is String) {
        imageUrl = firstImage;
      }
    }

    final address = listing['address'] as String? ?? '';
    String cityName = '';
    final city = listing['city'];
    if (city is Map) {
      cityName = (city)['name'] as String? ?? '';
    } else if (city is String) {
      cityName = city;
    }
    final locationText = address.isNotEmpty && cityName.isNotEmpty
        ? '$address, $cityName'
        : address.isNotEmpty
            ? address
            : cityName.isNotEmpty
                ? cityName
                : AppLocalizations.of(context)!.stayLocationUnavailable;

    final rating = listing['rating'] != null
        ? (listing['rating'] is String
            ? double.tryParse(listing['rating']) ?? 0.0
            : (listing['rating'] as num?)?.toDouble() ?? 0.0)
        : 0.0;

    final reviewCount = (listing['_count'] as Map<String, dynamic>?)?['reviews'] as int? ??
        listing['reviewCount'] as int? ??
        0;

    final minPrice = listing['minPrice'] != null
        ? (listing['minPrice'] is String
            ? double.tryParse(listing['minPrice'])
            : (listing['minPrice'] as num?)?.toDouble())
        : null;
    final currency = listing['currency'] as String? ?? 'RWF';
    final priceRange = minPrice != null
        ? 'From ${_formatPrice(minPrice, currency)}'
        : '';

    final catMap = listing['category'];
    late final String category;
    if (catMap is Map<String, dynamic>) {
      final locCat = localizedCategoryName(catMap, Localizations.localeOf(context)).trim();
      category =
          locCat.isNotEmpty ? locCat : (listing['type'] as String? ?? 'Place');
    } else {
      category = listing['type'] as String? ?? 'Place';
    }

    final id = listing['id'] as String? ?? '';

    return PlaceCard(
      name: listing['name'] as String? ?? 'Unknown',
      location: locationText,
      image: imageUrl ?? 'https://via.placeholder.com/400x300',
      rating: rating,
      reviews: reviewCount,
      priceRange: priceRange,
      category: category,
      isFavorite: _favoritePlaces.contains(id),
      onTap: () {
        context.push('/listing/$id');
      },
      onFavorite: () {
        setState(() {
          if (_favoritePlaces.contains(id)) {
            _favoritePlaces.remove(id);
          } else {
            _favoritePlaces.add(id);
          }
        });
      },
    );
  }

  String _formatPrice(double price, String currency) {
    return PriceFormatter.formatAbbreviated(price, currency: currency);
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: context.grey200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: context.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
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
                AppLocalizations.of(context)!.exploreRecommendationsFilterSheetTitle,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Minimum Rating',
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
                  _buildFilterChip('4.0+ Stars', false),
                  _buildFilterChip('4.5+ Stars', false),
                  _buildFilterChip('5.0 Stars', false),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Features',
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
                  _buildFilterChip('Family Friendly', false),
                  _buildFilterChip('Photography', false),
                  _buildFilterChip('Guided Tours', false),
                  _buildFilterChip('Accessible', false),
                  _buildFilterChip('Parking', false),
                  _buildFilterChip('Restrooms', false),
                ],
              ),
              const SizedBox(height: 30),
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
                      child: Text(AppLocalizations.of(context)!.commonClearAll),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColorTheme,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      ),
    );
  }

  void _showSortBottomSheet() {
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
                'Sort Recommendations',
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption('Popular', true),
              _buildSortOption('Rating (High to Low)', false),
              _buildSortOption('Rating (Low to High)', false),
              _buildSortOption('Distance (Near to Far)', false),
              _buildSortOption('Distance (Far to Near)', false),
              _buildSortOption('Name (A to Z)', false),
              _buildSortOption('Name (Z to A)', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      selectedColor: context.primaryColorTheme.withOpacity(0.2),
      checkmarkColor: context.primaryColorTheme,
      labelStyle: context.bodySmall.copyWith(
        color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
      ),
    );
  }

  Widget _buildSortOption(String label, bool isSelected) {
    return ListTile(
      title: Text(
        label,
        style: context.bodyMedium.copyWith(
          color: context.primaryTextColor,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: context.primaryColorTheme) : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
