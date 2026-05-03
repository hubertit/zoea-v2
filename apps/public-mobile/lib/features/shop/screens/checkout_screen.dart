import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/orders_service.dart';
import '../../../core/models/order.dart';
import '../../../core/models/cart.dart';
import '../../../core/utils/price_formatter.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String? listingId;

  const CheckoutScreen({
    super.key,
    this.listingId,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();

  FulfillmentType _fulfillmentType = FulfillmentType.pickup;
  DateTime? _deliveryDate;
  String? _deliveryTimeSlot;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  void _prefillUserData() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.chevron_left,
            size: 32,
            color: context.primaryTextColor,
          ),
        ),
        title: Text(
          l10n.checkoutScreenTitle,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return Center(
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
                    style: context.titleMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.commonContinueShopping),
                  ),
                ],
              ),
            );
          }

          // Get listing ID from first cart item or widget parameter
          String? listingId = widget.listingId;
          
          if (listingId == null && cart.items.isNotEmpty) {
            final firstItem = cart.items.first;
            listingId = firstItem.product?['listingId'] as String? ??
                firstItem.service?['listingId'] as String? ??
                firstItem.menuItem?['listingId'] as String?;
          }

          if (listingId == null) {
            return Center(
              child: Text(
                l10n.checkoutUnableListing,
                style: context.bodyMedium.copyWith(
                  color: context.errorColor,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  _buildOrderSummary(l10n, cart),
                  const SizedBox(height: 24),
                  
                  // Fulfillment Type
                  _buildFulfillmentTypeSection(l10n),
                  const SizedBox(height: 24),
                  
                  // Delivery Address (if delivery selected)
                  if (_fulfillmentType == FulfillmentType.delivery) ...[
                    _buildDeliveryAddressSection(l10n),
                    const SizedBox(height: 24),
                  ],
                  
                  // Customer Information
                  _buildCustomerInfoSection(l10n),
                  const SizedBox(height: 24),
                  
                  // Special Notes
                  _buildNotesSection(l10n),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: context.primaryColorTheme)),
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
                l10n.shopCartLoadFailed,
                style: context.titleMedium.copyWith(
                  color: context.errorColor,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(cartProvider);
                },
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(l10n, cartAsync.valueOrNull),
    );
  }

  Widget _buildOrderSummary(AppLocalizations l10n, Cart cart) {
    final subtotal = cart.totalAmount;
    final shipping = _fulfillmentType == FulfillmentType.delivery ? 2000.0 : 0.0;
    final tax = subtotal * 0.18; // 18% VAT
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            l10n.checkoutOrderSummary,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          // Items List
          ...cart.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.resolvedItemName(l10n),
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.primaryTextColor,
                        ),
                      ),
                      Text(
                        l10n.checkoutQtyLine(item.quantity),
                        style: context.bodySmall.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  PriceFormatter.formatFull(item.totalPrice, currency: item.currency),
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
              ],
            ),
          )),
          const Divider(height: 24),
          // Price Breakdown
          _buildPriceRow(l10n.checkoutSubtotalLabel, subtotal, cart.items.first.currency),
          const SizedBox(height: 8),
          _buildPriceRow(l10n.checkoutTaxVatLabel, tax, cart.items.first.currency),
          if (shipping > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(l10n.checkoutShippingLabel, shipping, cart.items.first.currency),
          ],
          const Divider(height: 24),
          _buildPriceRow(
            l10n.shopCartTotalLabel,
            total,
            cart.items.first.currency,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, String currency, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryTextColor,
                )
              : context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
        ),
        Text(
          PriceFormatter.formatFull(amount, currency: currency),
          style: isTotal
              ? context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryColorTheme,
                )
              : context.bodyMedium.copyWith(
                  color: context.primaryTextColor,
                ),
        ),
      ],
    );
  }

  Widget _buildFulfillmentTypeSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkoutDeliveryMethod,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          RadioListTile<FulfillmentType>(
            title: Text(l10n.checkoutFulfillmentPickup),
            subtitle: Text(l10n.checkoutFulfillmentPickupSubtitle),
            value: FulfillmentType.pickup,
            groupValue: _fulfillmentType,
            onChanged: (value) {
              setState(() {
                _fulfillmentType = value!;
                _deliveryDate = null;
                _deliveryTimeSlot = null;
              });
            },
            activeColor: context.primaryColorTheme,
          ),
          RadioListTile<FulfillmentType>(
            title: Text(l10n.checkoutFulfillmentDelivery),
            subtitle: Text(l10n.checkoutFulfillmentDeliverySubtitle),
            value: FulfillmentType.delivery,
            groupValue: _fulfillmentType,
            onChanged: (value) {
              setState(() {
                _fulfillmentType = value!;
              });
            },
            activeColor: context.primaryColorTheme,
          ),
          RadioListTile<FulfillmentType>(
            title: Text(l10n.checkoutFulfillmentDineIn),
            subtitle: Text(l10n.checkoutFulfillmentDineInSubtitle),
            value: FulfillmentType.dineIn,
            groupValue: _fulfillmentType,
            onChanged: (value) {
              setState(() {
                _fulfillmentType = value!;
                _deliveryDate = null;
                _deliveryTimeSlot = null;
              });
            },
            activeColor: context.primaryColorTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkoutDeliveryAddress,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: l10n.checkoutStreetAddressLabel,
              hintText: l10n.checkoutStreetAddressHint,
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (_fulfillmentType == FulfillmentType.delivery && 
                  (value == null || value.trim().isEmpty)) {
                return l10n.checkoutStreetAddressRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: l10n.checkoutCityLabel,
              hintText: l10n.checkoutCityHint,
              prefixIcon: const Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (_fulfillmentType == FulfillmentType.delivery && 
                  (value == null || value.trim().isEmpty)) {
                return l10n.checkoutCityRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkoutContactInformation,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.checkoutFullNameLabel,
              hintText: l10n.checkoutFullNameHint,
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.checkoutFullNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: l10n.checkoutEmailOptionalLabel,
              hintText: l10n.checkoutEmailHint,
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: l10n.checkoutPhoneLabel,
              hintText: l10n.checkoutPhoneHint,
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.checkoutPhoneRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkoutSpecialInstructionsTitle,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: l10n.checkoutSpecialInstructionsHint,
              prefixIcon: const Icon(Icons.note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n, Cart? cart) {
    if (cart == null || cart.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final subtotal = cart.totalAmount;
    final shipping = _fulfillmentType == FulfillmentType.delivery ? 2000.0 : 0.0;
    final tax = subtotal * 0.18;
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode 
                ? Colors.black.withOpacity(0.3) 
                : Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                Text(
                  PriceFormatter.formatFull(total, currency: cart.items.first.currency),
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.primaryColorTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.checkoutPlaceOrder,
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
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

    // Get listing ID
    String? listingId = widget.listingId;
    
    if (listingId == null && cart.items.isNotEmpty) {
      listingId = cart.items.first.product?['listingId'] as String? ??
          cart.items.first.service?['listingId'] as String? ??
          cart.items.first.menuItem?['listingId'] as String?;
    }

    if (listingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.checkoutUnableListing),
          backgroundColor: context.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ordersService = OrdersService();
      
      // Prepare delivery address if needed
      Map<String, dynamic>? deliveryAddress;
      if (_fulfillmentType == FulfillmentType.delivery) {
        deliveryAddress = {
          'street': _addressController.text.trim(),
          'city': _cityController.text.trim(),
        };
      }

      // Calculate totals
      final subtotal = cart.totalAmount;
      final shipping = _fulfillmentType == FulfillmentType.delivery ? 2000.0 : 0.0;
      final tax = subtotal * 0.18;

      final order = await ordersService.createOrder(
        listingId: listingId,
        fulfillmentType: _fulfillmentType,
        deliveryAddress: deliveryAddress,
        pickupLocation: _fulfillmentType == FulfillmentType.pickup 
            ? l10n.checkoutStorePickup 
            : null,
        deliveryDate: _deliveryDate,
        deliveryTimeSlot: _deliveryTimeSlot,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim() 
            : null,
        customerPhone: _phoneController.text.trim(),
        customerNotes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
        taxAmount: tax,
        shippingAmount: shipping,
      );

      // Clear cart
      ref.invalidate(cartProvider);

      // Navigate to order confirmation
      if (mounted) {
        context.pushReplacement('/order-confirmation/${order.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonFailedPlaceOrder(
              e.toString().replaceFirst('Exception: ', ''),
            )),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

