import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/auth_prompt_dialog.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/cart.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../l10n/app_localizations.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isUpdating = false;
  bool _isClearing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartAsync = ref.watch(cartProvider);

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
          l10n.shopCartScreenTitle,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          if (!cartAsync.isLoading && cartAsync.valueOrNull?.items.isNotEmpty == true)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: context.primaryTextColor,
              ),
              onPressed: _isClearing ? null : _clearCart,
              tooltip: l10n.shopCartClearTooltip,
            ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: context.primaryColorTheme,
                  backgroundColor: context.cardColor,
                  onRefresh: () async {
                    ref.invalidate(cartProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(cart.items[index]);
                    },
                  ),
                ),
              ),
              _buildBottomBar(l10n, cart),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
        error: (error, stack) => _buildErrorState(l10n, error),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = item.itemImage != null
        ? '${AppConfig.apiBaseUrl.replaceAll('/api', '')}/media/${item.itemImage}'
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: context.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: context.grey100,
                    child: Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: context.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getItemIcon(item.itemType),
                  color: context.secondaryTextColor,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.resolvedItemName(l10n),
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getItemTypeLabel(l10n, item.itemType),
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                    if (item.serviceBookingDate != null && item.serviceBookingTime != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: context.secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_formatDate(item.serviceBookingDate!)} at ${item.serviceBookingTime}',
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          PriceFormatter.formatFull(item.unitPrice, currency: AppConfig.currencySymbol),
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryColorTheme,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '× ${item.quantity}',
                          style: context.bodySmall.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          PriceFormatter.formatFull(item.totalPrice, currency: AppConfig.currencySymbol),
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: context.errorColor,
                  onPressed: _isUpdating
                      ? null
                      : () => _removeItem(item.id),
                  tooltip: l10n.commonRemove,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.grey300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _isUpdating || item.quantity <= 1
                            ? null
                            : () => _updateQuantity(item.id, item.quantity - 1),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        iconSize: 18,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _isUpdating
                            ? null
                            : () => _updateQuantity(item.id, item.quantity + 1),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        iconSize: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n, Cart cart) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.shopCartTotalLabel,
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                ),
                Text(
                  PriceFormatter.formatFull(cart.totalAmount, currency: AppConfig.currencySymbol),
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColorTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty ? null : _checkout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.shopProceedToCheckout,
                  style: const TextStyle(fontSize: 16),
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
              Icons.shopping_cart_outlined,
              size: 64,
              color: context.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.cartEmptyMessage,
              style: context.headlineSmall.copyWith(
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.shopCartEmptySubtitle,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/explore');
              },
              child: Text(l10n.commonStartShopping),
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
              l10n.shopCartLoadFailed,
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
                ref.invalidate(cartProvider);
              },
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(CartItemType type) {
    switch (type) {
      case CartItemType.product:
        return Icons.shopping_bag;
      case CartItemType.service:
        return Icons.room_service;
      case CartItemType.menuItem:
        return Icons.restaurant;
    }
  }

  String _getItemTypeLabel(AppLocalizations l10n, CartItemType type) {
    switch (type) {
      case CartItemType.product:
        return l10n.shopCartItemTypeProduct;
      case CartItemType.service:
        return l10n.shopCartItemTypeService;
      case CartItemType.menuItem:
        return l10n.shopCartItemTypeMenuItem;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _updateQuantity(String itemId, int quantity) async {
    if (quantity < 1) {
      await _removeItem(itemId);
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final cartService = CartService();
      await cartService.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonFailedUpdate(e.toString().replaceFirst('Exception: ', ''))),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _removeItem(String itemId) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final cartService = CartService();
      await cartService.removeCartItem(itemId);

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonFailedRemove(e.toString().replaceFirst('Exception: ', ''))),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _clearCart() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cartTitle),
        content: Text(l10n.cartClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: context.errorColor,
            ),
            child: Text(l10n.commonClear),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isClearing = true;
    });

    try {
      final cartService = CartService();
      await cartService.clearCart();

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.commonFailedClearCart(e.toString().replaceFirst('Exception: ', ''))),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClearing = false;
        });
      }
    }
  }

  void _checkout() {
    final l10n = AppLocalizations.of(context)!;
    // Check if user is logged in
    final isLoggedIn = ref.read(isLoggedInProvider);
    
    if (!isLoggedIn) {
      // Show login prompt for guests
      AuthPromptDialog.show(
        context: context,
        title: l10n.shopCheckoutSignInTitle,
        message: l10n.shopCheckoutSignInMessage,
        returnPath: '/cart',
        icon: Icons.shopping_cart,
      );
      return;
    }
    
    final cart = ref.read(cartProvider).valueOrNull;
    if (cart == null || cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cartEmptyMessage),
          backgroundColor: context.errorColor,
        ),
      );
      return;
    }

    // Get listing ID from first cart item
    final listingId = cart.items.first.product?['listingId'] ??
        cart.items.first.service?['listingId'] ??
        cart.items.first.menuItem?['listingId'];

    context.push('/checkout${listingId != null ? '?listingId=$listingId' : ''}');
  }
}

