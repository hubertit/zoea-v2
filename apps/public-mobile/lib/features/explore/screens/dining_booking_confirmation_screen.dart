import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';

class DiningBookingConfirmationScreen extends ConsumerStatefulWidget {
  final String? bookingId;
  final String? bookingNumber;
  final String placeName;
  final String placeLocation;
  final DateTime? date;
  final String time;
  final int guests;
  final String fullName;
  final String phone;
  final String email;
  final String specialRequests;

  const DiningBookingConfirmationScreen({
    super.key,
    this.bookingId,
    this.bookingNumber,
    required this.placeName,
    required this.placeLocation,
    this.date,
    required this.time,
    required this.guests,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.specialRequests,
  });

  @override
  ConsumerState<DiningBookingConfirmationScreen> createState() => _DiningBookingConfirmationScreenState();
}

class _DiningBookingConfirmationScreenState extends ConsumerState<DiningBookingConfirmationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.grey50,
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
          l10n.diningBookingConfirmationTitle,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Header
            _buildSuccessHeader(l10n),
            const SizedBox(height: 24),
            
            // Booking Details
            _buildBookingDetails(l10n),
            const SizedBox(height: 24),
            
            // Restaurant Info
            _buildRestaurantInfo(l10n),
            const SizedBox(height: 24),
            
            // Guest Information
            _buildGuestInfo(l10n),
            const SizedBox(height: 24),
            
            // Special Requests
            if (widget.specialRequests.isNotEmpty) ...[
              _buildSpecialRequests(l10n),
              const SizedBox(height: 24),
            ],
            
            // Important Notes
            _buildImportantNotes(l10n),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(l10n),
    );
  }

  Widget _buildSuccessHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.successColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 64,
            color: context.successColor,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.diningBookingReservationConfirmedTitle,
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.successColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.diningBookingReservationConfirmedSubtitle,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.bookingNumber case final n?) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.successColor.withOpacity(0.3)),
              ),
              child: Text(
                l10n.diningBookingNumberLine(n),
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.successColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingDetails(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.grey200),
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
          Text(
            l10n.diningBookingReservationDetailsSection,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            l10n,
            icon: Icons.calendar_today,
            label: l10n.diningBookingLabelDate,
            value: widget.date != null 
                ? '${widget.date!.day}/${widget.date!.month}/${widget.date!.year}'
                : l10n.diningBookingNotSpecified,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            l10n,
            icon: Icons.access_time,
            label: l10n.diningBookingLabelTime,
            value: widget.time,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            l10n,
            icon: Icons.people,
            label: l10n.diningBookingLabelGuests,
            value: l10n.stayGuestCount(widget.guests),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.grey200),
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
          Text(
            l10n.diningBookingRestaurantInfoSection,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            l10n,
            icon: Icons.restaurant,
            label: l10n.diningBookingLabelRestaurant,
            value: widget.placeName,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            l10n,
            icon: Icons.location_on,
            label: l10n.diningBookingLabelLocation,
            value: widget.placeLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.grey200),
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
          Text(
            l10n.diningBookingGuestInfoSection,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            l10n,
            icon: Icons.person,
            label: l10n.diningBookingLabelName,
            value: widget.fullName,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            l10n,
            icon: Icons.phone,
            label: l10n.diningBookingLabelPhone,
            value: widget.phone,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            l10n,
            icon: Icons.email,
            label: l10n.diningBookingLabelEmail,
            value: widget.email,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRequests(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.grey200),
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
          Text(
            l10n.diningBookingSpecialRequestsSection,
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.specialRequests,
            style: context.bodyMedium.copyWith(
              color: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotes(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.diningBookingImportantInfoTitle,
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.diningBookingImportantInfoBody,
            style: context.bodySmall.copyWith(
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    AppLocalizations l10n, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.primaryColorTheme,
        ),
        const SizedBox(width: 12),
        Text(
          l10n.diningBookingDetailLine(label),
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.secondaryTextColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: context.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(
          top: BorderSide(color: context.grey200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/explore'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.primaryColorTheme,
                  side: BorderSide(color: context.primaryColorTheme),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.diningBookingBrowseMore,
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _viewMyBookings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColorTheme,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.diningBookingViewMyBookings,
                        style: context.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewMyBookings() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      context.go('/my-bookings');
    });
  }
}
