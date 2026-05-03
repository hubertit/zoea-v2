import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/products_provider.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/product.dart';
import '../../../core/models/cart.dart';
import '../../../core/utils/price_formatter.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  int _selectedQuantity = 1;
  ProductVariant? _selectedVariant;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 200 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      backgroundColor: context.grey50,
      body: productAsync.when(
        data: (product) => _buildContent(l10n, product),
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
                l10n.shopErrorLoadProduct,
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
                  ref.invalidate(productByIdProvider(widget.productId));
                },
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, Product product) {
    final images = product.images;
    final primaryImage = images.isNotEmpty
        ? '${AppConfig.apiBaseUrl.replaceAll('/api', '')}/media/${images[0]}'
        : null;
    final currentPrice = _selectedVariant?.price != null
        ? _selectedVariant!.price!
        : product.basePrice;
    final compareAtPrice = _selectedVariant?.compareAtPrice ?? product.compareAtPrice;
    final discountPercent = compareAtPrice != null && compareAtPrice > currentPrice
        ? ((compareAtPrice - currentPrice) / compareAtPrice * 100).round()
        : null;
    final isAvailable = product.isAvailable &&
        (_selectedVariant == null || _selectedVariant!.isAvailable);

    return Scaffold(
      backgroundColor: context.grey50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: context.backgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: _isScrolled ? context.primaryTextColor : Colors.white,
                size: 32,
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: _isScrolled ? context.primaryTextColor : Colors.white,
                ),
                onPressed: () {
                  Share.share(l10n.listingShareOnZoea(product.name));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: primaryImage != null
                  ? CachedNetworkImage(
                      imageUrl: primaryImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: context.grey100,
                        child: Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: context.grey100,
                        child: Icon(
                          Icons.image_not_supported,
                          color: context.secondaryTextColor,
                        ),
                      ),
                    )
                  : Container(
                      color: context.grey100,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: context.secondaryTextColor,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: context.cardColor,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: context.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.primaryTextColor,
                              ),
                            ),
                          ),
                          if (product.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColorTheme,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.shopFeaturedSection,
                                style: context.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (product.shortDescription != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          product.shortDescription!,
                          style: context.bodyMedium.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            PriceFormatter.formatFull(currentPrice, currency: AppConfig.currencySymbol),
                            style: context.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.primaryColorTheme,
                            ),
                          ),
                          if (compareAtPrice != null && compareAtPrice > currentPrice) ...[
                            const SizedBox(width: 12),
                            Text(
                              PriceFormatter.formatFull(compareAtPrice, currency: AppConfig.currencySymbol),
                              style: context.bodyLarge.copyWith(
                                color: context.secondaryTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            if (discountPercent != null) ...[
                              const SizedBox(width: 8),
                              Container(
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
                            ],
                          ],
                        ],
                      ),
                      if (product.rating > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.primaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.listingReviewsCountParen(product.reviewCount),
                              style: context.bodySmall.copyWith(
                                color: context.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (product.hasVariants && product.variants != null && product.variants!.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    color: context.cardColor,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.shopProductVariantHeading,
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.variants!.map((variant) {
                            final isSelected = _selectedVariant?.id == variant.id;
                            return ChoiceChip(
                              label: Text(variant.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedVariant = variant;
                                  });
                                }
                              },
                              selectedColor: context.primaryColorTheme.withOpacity(0.2),
                              checkmarkColor: context.primaryColorTheme,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                if (product.description != null) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    color: context.cardColor,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.shopProductDescription,
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description!,
                          style: context.bodyMedium.copyWith(
                            color: context.primaryTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (product.tags.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    color: context.cardColor,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.shopProductTags,
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: context.grey100,
                              labelStyle: context.bodySmall.copyWith(
                                color: context.primaryTextColor,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product.hasVariants && product.variants != null && product.variants!.isNotEmpty)
                if (_selectedVariant == null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text(l10n.commonSelectVariant),
                    ),
                  )
                else
                  Row(
                    children: [
                      _buildQuantitySelector(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isAvailable && !_isAddingToCart
                              ? () => _addToCart(product)
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
                                  isAvailable ? l10n.shopAddToCart : l10n.shopOutOfStock,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  )
              else
                Row(
                  children: [
                    _buildQuantitySelector(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isAvailable && !_isAddingToCart
                            ? () => _addToCart(product)
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
                                isAvailable ? l10n.shopAddToCart : l10n.shopOutOfStock,
                                style: const TextStyle(fontSize: 16),
                              ),
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

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _selectedQuantity > 1
                ? () {
                    setState(() {
                      _selectedQuantity--;
                    });
                  }
                : null,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_selectedQuantity',
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _selectedQuantity++;
              });
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(Product product) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final cartService = CartService();
      await cartService.addToCart(
        itemType: CartItemType.product,
        productId: product.id,
        productVariantId: _selectedVariant?.id,
        quantity: _selectedQuantity,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonProductAddedToCart),
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

