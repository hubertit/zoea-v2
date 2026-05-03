import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/services_provider.dart';
import '../../../core/services/services_service.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/service.dart';
import '../../../core/utils/price_formatter.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  @override
  ConsumerState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isBooking = false;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();

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
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final serviceAsync = ref.watch(serviceByIdProvider(widget.serviceId));

    return Scaffold(
      backgroundColor: context.grey50,
      body: serviceAsync.when(
        data: (service) => _buildContent(l10n, service),
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
                l10n.shopErrorLoadService,
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
                  ref.invalidate(serviceByIdProvider(widget.serviceId));
                },
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, Service service) {
    final images = service.images;
    final primaryImage = images.isNotEmpty
        ? '${AppConfig.apiBaseUrl.replaceAll('/api', '')}/media/${images[0]}'
        : null;
    final priceLabel = _getPriceLabel(l10n, service.basePrice, service.priceUnit);
    final isAvailable = service.isAvailable && service.status == ServiceStatus.active;

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
                  Share.share(l10n.listingShareOnZoea(service.name));
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
                              service.name,
                              style: context.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.primaryTextColor,
                              ),
                            ),
                          ),
                          if (service.isFeatured)
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
                      if (service.shortDescription != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          service.shortDescription!,
                          style: context.bodyMedium.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            priceLabel,
                            style: context.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.primaryColorTheme,
                            ),
                          ),
                        ],
                      ),
                      if (service.durationMinutes != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: context.secondaryTextColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.shopServiceDurationLine(service.durationMinutes!),
                              style: context.bodyMedium.copyWith(
                                color: context.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!isAvailable) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: context.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: context.errorColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.shopServiceUnavailableBanner,
                                style: context.bodyMedium.copyWith(
                                  color: context.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (service.description != null) ...[
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
                          service.description!,
                          style: context.bodyMedium.copyWith(
                            color: context.primaryTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (service.tags.isNotEmpty) ...[
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
                          children: service.tags.map((tag) {
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
          child: ElevatedButton(
            onPressed: isAvailable && !_isBooking ? () => _showBookingDialog(l10n, service) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isBooking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    isAvailable ? l10n.shopBookService : l10n.shopServiceUnavailable,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }

  String _getPriceLabel(AppLocalizations l10n, double price, ServicePriceUnit unit) {
    final priceStr = PriceFormatter.formatFull(price, currency: AppConfig.currencySymbol);
    switch (unit) {
      case ServicePriceUnit.perHour:
        return '$priceStr / ${l10n.shopPricePerHour}';
      case ServicePriceUnit.perSession:
        return '$priceStr / ${l10n.shopPricePerSession}';
      case ServicePriceUnit.perPerson:
        return '$priceStr / ${l10n.shopPricePerPerson}';
      default:
        return priceStr;
    }
  }

  Future<void> _showBookingDialog(AppLocalizations l10n, Service service) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
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
                Text(
                  l10n.shopBookService,
                  style: context.headlineSmall.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: l10n.shopBookingFullNameRequiredLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _customerPhoneController,
                  decoration: InputDecoration(
                    labelText: l10n.shopBookingPhoneRequiredLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _customerEmailController,
                  decoration: InputDecoration(
                    labelText: l10n.shopBookingEmailOptionalLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setModalState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.grey300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: context.primaryTextColor),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate != null
                              ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                              : l10n.shopBookingSelectDateRequired,
                          style: context.bodyMedium.copyWith(
                            color: _selectedDate != null
                                ? context.primaryTextColor
                                : context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setModalState(() {
                        _selectedTime = time;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.grey300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: context.primaryTextColor),
                        const SizedBox(width: 12),
                        Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : l10n.shopBookingSelectTimeRequired,
                          style: context.bodyMedium.copyWith(
                            color: _selectedTime != null
                                ? context.primaryTextColor
                                : context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _specialRequestsController,
                  decoration: InputDecoration(
                    labelText: l10n.shopBookingSpecialRequestsLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.commonCancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _selectedDate != null &&
                                _selectedTime != null &&
                                _customerNameController.text.isNotEmpty &&
                                _customerPhoneController.text.isNotEmpty &&
                                !_isBooking
                            ? () => _bookService(service)
                            : null,
                        child: _isBooking
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.commonBookNow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _bookService(Service service) async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.commonPleaseSelectDateTime),
          backgroundColor: context.errorColor,
        ),
      );
      return;
    }

    if (_customerNameController.text.isEmpty || _customerPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.commonPleaseFillRequiredFields),
          backgroundColor: context.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      final servicesService = ServicesService();
      final bookingTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      
      await servicesService.bookService(service.id, {
        'bookingDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'bookingTime': bookingTime,
        'customerName': _customerNameController.text,
        'customerPhone': _customerPhoneController.text,
        if (_customerEmailController.text.isNotEmpty)
          'customerEmail': _customerEmailController.text,
        if (_specialRequestsController.text.isNotEmpty)
          'specialRequests': _specialRequestsController.text,
      });

      if (mounted) {
        Navigator.pop(context); // Close booking dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonServiceBookedSuccess),
            backgroundColor: context.primaryColorTheme,
          ),
        );
        // Clear form
        _customerNameController.clear();
        _customerPhoneController.clear();
        _customerEmailController.clear();
        _specialRequestsController.clear();
        _selectedDate = null;
        _selectedTime = null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commonFailedBookService(
              e.toString().replaceFirst('Exception: ', ''),
            )),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }
}

