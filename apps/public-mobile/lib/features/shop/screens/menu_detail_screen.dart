import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/menus_provider.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/menu.dart';
import '../../../core/models/cart.dart';
import '../../../core/utils/price_formatter.dart';

class MenuDetailScreen extends ConsumerStatefulWidget {
  final String menuId;

  const MenuDetailScreen({
    super.key,
    required this.menuId,
  });

  @override
  ConsumerState<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends ConsumerState<MenuDetailScreen> {
  String? _selectedCategoryId;
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuAsync = ref.watch(menuByIdProvider(widget.menuId));

    return Scaffold(
      backgroundColor: context.grey50,
      body: menuAsync.when(
        data: (menu) => _buildContent(l10n, menu),
        loading: () => Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
        error: (error, stack) => _buildErrorState(l10n, error),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, Object error) {
    return Scaffold(
      backgroundColor: context.grey50,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 32, color: context.primaryTextColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
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
                l10n.shopErrorLoadMenu,
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
                  ref.invalidate(menuByIdProvider(widget.menuId));
                },
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, Menu menu) {
    final items = menu.items ?? [];
    final categories = _getCategoriesFromItems(items);
    final filteredItems = _selectedCategoryId == null
        ? items
        : items.where((item) => item.categoryId == _selectedCategoryId).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 32, color: context.primaryTextColor),
            onPressed: () => context.pop(),
          ),
          title: Text(
            menu.name,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
            ),
          ),
        ),
        if (menu.description != null)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                menu.description!,
                style: context.bodyMedium.copyWith(
                  color: context.primaryTextColor,
                ),
              ),
            ),
          ),
        if (categories.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isSelected = _selectedCategoryId == null;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(l10n.bookingsTabAll),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                          }
                        },
                        selectedColor: context.primaryColorTheme.withOpacity(0.2),
                        checkmarkColor: context.primaryColorTheme,
                      ),
                    );
                  }
                  final category = categories[index - 1];
                  final isSelected = _selectedCategoryId == category.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        }
                      },
                      selectedColor: context.primaryColorTheme.withOpacity(0.2),
                      checkmarkColor: context.primaryColorTheme,
                    ),
                  );
                },
              ),
            ),
          ),
        if (filteredItems.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                l10n.shopMenuCategoryEmpty,
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = filteredItems[index];
                return _buildMenuItemCard(l10n, item);
              },
              childCount: filteredItems.length,
            ),
          ),
      ],
    );
  }

  List<MenuCategory> _getCategoriesFromItems(List<MenuItem> items) {
    final categoryMap = <String, MenuCategory>{};
    for (final item in items) {
      if (item.category != null && !categoryMap.containsKey(item.category?.id)) {
        categoryMap[item.category!.id] = item.category!;
      }
    }
    return categoryMap.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Widget _buildMenuItemCard(AppLocalizations l10n, MenuItem item) {
    final imageUrl = item.imageId != null
        ? '${AppConfig.apiBaseUrl.replaceAll('/api', '')}/media/${item.imageId}'
        : null;
    final discountPercent = item.discountPercent != null
        ? item.discountPercent!.round()
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showItemDetails(l10n, item),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 100,
                    color: context.grey100,
                    child: Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: context.grey100,
                    child: Icon(
                      Icons.image_not_supported,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.grey100,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: context.secondaryTextColor,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: context.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.primaryTextColor,
                            ),
                          ),
                        ),
                        if (item.isPopular)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.shopSortPopular,
                              style: context.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        if (item.isChefSpecial)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: context.primaryColorTheme,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.shopMenuChefSpecial,
                              style: context.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: context.bodySmall.copyWith(
                          color: context.secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.dietaryTags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: item.dietaryTags.take(3).map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: context.grey100,
                            labelStyle: context.bodySmall.copyWith(
                              fontSize: 10,
                              color: context.primaryTextColor,
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          PriceFormatter.formatFull(item.price, currency: AppConfig.currencySymbol),
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryColorTheme,
                          ),
                        ),
                        if (item.compareAtPrice != null && item.compareAtPrice! > item.price) ...[
                          const SizedBox(width: 8),
                          Text(
                            PriceFormatter.formatFull(item.compareAtPrice!, currency: AppConfig.currencySymbol),
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          if (discountPercent != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '-$discountPercent%',
                              style: context.bodySmall.copyWith(
                                color: context.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

  void _showItemDetails(AppLocalizations l10n, MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: context.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.primaryTextColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            if (item.description != null) ...[
              const SizedBox(height: 16),
              Text(
                item.description!,
                style: context.bodyMedium.copyWith(
                  color: context.primaryTextColor,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  PriceFormatter.formatFull(item.price, currency: AppConfig.currencySymbol),
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColorTheme,
                  ),
                ),
                if (item.compareAtPrice != null && item.compareAtPrice! > item.price) ...[
                  const SizedBox(width: 12),
                  Text(
                    PriceFormatter.formatFull(item.compareAtPrice!, currency: AppConfig.currencySymbol),
                    style: context.bodyLarge.copyWith(
                      color: context.secondaryTextColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            if (item.dietaryTags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.shopMenuDietaryInformation,
                style: context.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.dietaryTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: context.grey100,
                  );
                }).toList(),
              ),
            ],
            if (item.allergens.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.shopMenuAllergensTitle,
                style: context.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.allergens.map((allergen) {
                  return Chip(
                    label: Text(allergen),
                    backgroundColor: context.errorColor.withOpacity(0.1),
                    labelStyle: context.bodySmall.copyWith(
                      color: context.errorColor,
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: item.isAvailable && !_isAddingToCart
                    ? () => _addToCart(item)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isAddingToCart
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        item.isAvailable ? l10n.shopAddToCart : l10n.shopServiceUnavailable,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(MenuItem item) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final cartService = CartService();
      await cartService.addToCart(
        itemType: CartItemType.menuItem,
        menuItemId: item.id,
        quantity: 1,
      );

      if (mounted) {
        Navigator.pop(context); // Close item details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonItemAddedToCart),
            backgroundColor: context.primaryColorTheme,
            action: SnackBarAction(
              label: l10n.shopViewCart,
              textColor: Colors.white,
              onPressed: () {
                context.push('/cart');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonFailedAddToCart(
              e.toString().replaceFirst('Exception: ', ''),
            )),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }
}

