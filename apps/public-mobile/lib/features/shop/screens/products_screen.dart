import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/products_provider.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  final String? listingId;
  final String? category;
  final String? search;

  const ProductsScreen({
    super.key,
    this.listingId,
    this.category,
    this.search,
  });

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  int _currentPage = 1;
  final int _pageSize = 20;
  String? _selectedStatus;
  String? _selectedSort = 'popular';
  double? _minPrice;
  double? _maxPrice;
  bool? _isFeatured;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final params = ProductsParams(
      page: _currentPage,
      limit: _pageSize,
      listingId: widget.listingId,
      status: _selectedStatus ?? 'active',
      search: widget.search,
      category: widget.category,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      isFeatured: _isFeatured,
      sortBy: _selectedSort,
    );

    final productsAsync = widget.listingId != null
        ? ref.watch(productsByListingProvider(params))
        : ref.watch(productsProvider(params));

    return Scaffold(
      backgroundColor: context.grey50,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/explore'),
          icon: Icon(
            Icons.chevron_left,
            size: 32,
            color: context.primaryTextColor,
          ),
        ),
        title: Text(
          widget.listingId != null ? l10n.shopScreenTitleProducts : l10n.shopScreenTitleShop,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: context.primaryTextColor),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: context.primaryTextColor),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: productsAsync.when(
        data: (data) {
          final products = (data['data'] as List? ?? [])
              .map((p) => p as Map<String, dynamic>)
              .toList();
          final meta = data['meta'] as Map<String, dynamic>? ?? {};
          final total = meta['total'] as int? ?? 0;
          final totalPages = meta['totalPages'] as int? ?? 1;

          if (products.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return RefreshIndicator(
            color: context.primaryColorTheme,
            backgroundColor: context.cardColor,
            onRefresh: () async {
              ref.invalidate(productsProvider(params));
              if (widget.listingId != null) {
                ref.invalidate(productsByListingProvider(params));
              }
            },
            child: Column(
              children: [
                if (total > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: context.cardColor,
                    child: Row(
                      children: [
                        Text(
                          l10n.shopProductCount(total),
                          style: context.bodyMedium.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedSort != null)
                          GestureDetector(
                            onTap: _showSortBottomSheet,
                            child: Row(
                              children: [
                                Text(
                                  l10n.shopSortLine(_getSortLabel(l10n, _selectedSort!)),
                                  style: context.bodySmall.copyWith(
                                    color: context.primaryColorTheme,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: context.primaryColorTheme,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length + (_currentPage < totalPages ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == products.length) {
                        return _buildLoadMoreButton(l10n, totalPages);
                      }
                      return _buildProductCard(products[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
        error: (error, stack) => _buildErrorState(l10n, error),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['name'] as String? ?? 'Unknown';
    final basePrice = (product['basePrice'] ?? product['base_price'] ?? 0).toDouble();
    final compareAtPrice = product['compareAtPrice'] != null || product['compare_at_price'] != null
        ? ((product['compareAtPrice'] ?? product['compare_at_price']) as num).toDouble()
        : null;
    final images = product['images'] as List? ?? [];
    final imageUrl = images.isNotEmpty
        ? '${AppConfig.apiBaseUrl.replaceAll('/api', '')}/media/${images[0]}'
        : null;
    final isAvailable = product['status'] == 'active' &&
        (!(product['trackInventory'] ?? product['track_inventory'] ?? true) ||
            (product['inventoryQuantity'] ?? product['inventory_quantity'] ?? 0) > 0);
    final discountPercent = compareAtPrice != null && compareAtPrice > basePrice
        ? ((compareAtPrice - basePrice) / compareAtPrice * 100).round()
        : null;

    return GestureDetector(
      onTap: () {
        context.push('/product/${product['id']}');
      },
      child: Card(
        elevation: 0,
        color: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: 140,
                            color: context.grey100,
                            child: Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: 140,
                            color: context.grey100,
                            child: Icon(
                              Icons.image_not_supported,
                              color: context.secondaryTextColor,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 140,
                          color: context.grey100,
                          child: Icon(
                            Icons.image_not_supported,
                            color: context.secondaryTextColor,
                          ),
                        ),
                ),
                if (discountPercent != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.errorColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: context.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.shopOutOfStock,
                          style: context.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          PriceFormatter.formatAbbreviated(basePrice, currency: AppConfig.currencySymbol),
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryColorTheme,
                          ),
                        ),
                        if (compareAtPrice != null && compareAtPrice > basePrice) ...[
                          const SizedBox(width: 8),
                          Text(
                            PriceFormatter.formatAbbreviated(compareAtPrice, currency: AppConfig.currencySymbol),
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: context.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.shopEmptyNoProducts,
              style: context.headlineSmall.copyWith(
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.shopEmptyAdjustFilters,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedStatus = null;
                  _selectedSort = 'popular';
                  _minPrice = null;
                  _maxPrice = null;
                  _isFeatured = null;
                });
              },
              child: Text(l10n.shopClearFilters),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              l10n.shopErrorLoadProducts,
              style: context.headlineSmall.copyWith(
                color: context.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceFirst('Exception: ', ''),
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final params = ProductsParams(
                  page: _currentPage,
                  limit: _pageSize,
                  listingId: widget.listingId,
                  status: _selectedStatus ?? 'active',
                  search: widget.search,
                  category: widget.category,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  isFeatured: _isFeatured,
                  sortBy: _selectedSort,
                );
                ref.invalidate(productsProvider(params));
                if (widget.listingId != null) {
                  ref.invalidate(productsByListingProvider(params));
                }
              },
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(AppLocalizations l10n, int totalPages) {
    if (_currentPage >= totalPages) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _currentPage++;
            });
          },
          child: Text(l10n.commonLoadMore),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shopSearchProductsTitle),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.shopSearchProductNameHint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            context.push('/products?search=$value');
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) {
          final statusSelected = _selectedStatus == null
              ? 'All'
              : (_selectedStatus == 'active' ? 'Active' : 'Inactive');
          final featuredSelected = _isFeatured == true ? 'Featured Only' : 'All';

          return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.shopFilterTitle,
                style: context.headlineSmall.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterSection(
                title: l10n.shopStatusSection,
                options: [
                  ('All', l10n.stayTabAll),
                  ('Active', l10n.shopFilterActive),
                  ('Inactive', l10n.shopFilterInactive),
                ],
                selectedValue: statusSelected,
                onSelect: (value) {
                  setModalState(() {
                    _selectedStatus = value == 'All' ? null : value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildFilterSection(
                title: l10n.shopFeaturedSection,
                options: [
                  ('All', l10n.stayTabAll),
                  ('Featured Only', l10n.shopFeaturedOnly),
                ],
                selectedValue: featuredSelected,
                onSelect: (value) {
                  setModalState(() {
                    _isFeatured = value == 'All' ? null : true;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedStatus = null;
                          _isFeatured = null;
                          _minPrice = null;
                          _maxPrice = null;
                        });
                      },
                      child: Text(l10n.shopFilterReset),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      child: Text(l10n.commonApply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<(String, String)> options,
    required String selectedValue,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((pair) {
            final (value, label) = pair;
            final isSelected = value == selectedValue;
            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onSelect(value);
              },
              selectedColor: context.primaryColorTheme.withOpacity(0.2),
              checkmarkColor: context.primaryColorTheme,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showSortBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.staySortBy,
              style: context.headlineSmall.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...[
                'popular',
                'name_asc',
                'name_desc',
                'price_asc',
                'price_desc',
                'createdAt_desc'
              ].map((sort) => RadioListTile<String>(
                      title: Text(_getSortLabel(l10n, sort)),
                      value: sort,
                      groupValue: _selectedSort,
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value;
                          _currentPage = 1;
                        });
                        Navigator.pop(context);
                      },
                    )),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(AppLocalizations l10n, String sort) {
    switch (sort) {
      case 'popular':
        return l10n.shopSortPopular;
      case 'name_asc':
        return l10n.shopSortNameAz;
      case 'name_desc':
        return l10n.shopSortNameZa;
      case 'price_asc':
        return l10n.shopSortPriceLowHigh;
      case 'price_desc':
        return l10n.shopSortPriceHighLow;
      case 'createdAt_desc':
        return l10n.shopSortNewest;
      default:
        return sort;
    }
  }
}

