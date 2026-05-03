import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/models/event.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/auth_prompt_dialog.dart';
import '../../user_data_collection/utils/prompt_helper.dart';
import '../../../core/providers/user_data_collection_provider.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/event_flyer_image.dart';
import '../../../l10n/app_localizations.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final event = widget.event;
    final eventDetails = event.event;
    final startDate = eventDetails.startDate;
    final endDate = eventDetails.endDate;
    final lc = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy', lc);
    final timeFormat = DateFormat('HH:mm', lc);

    // Track event view for analytics (after first frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackEventView();
      
      // Check and show prompt after viewing event
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          PromptHelper.checkAndShowPromptAfterViewEvent(context, ref);
        }
      });
    });

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _isScrolled ? context.backgroundColor : context.backgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: _isScrolled ? context.primaryTextColor : Colors.white, // White on image overlay is intentional
                size: 32,
              ),
              onPressed: () => context.go('/events'),
            ),
            actions: const [], // Buttons moved to flexibleSpace
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  EventFlyerImage(
                    flyer: eventDetails.flyer,
                    fit: BoxFit.cover,
                    expandToParent: true,
                    indicatorColor: context.primaryColorTheme,
                    placeholderColor: context.dividerColor,
                    errorIconColor: context.secondaryTextColor,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Action buttons at top right
                  Positioned(
                    top: 50,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Favorite button
                        Consumer(
                          builder: (context, ref, child) {
                            final eventIdString = event.id.toString();
                            final isFavoritedAsync = ref.watch(isEventFavoritedProvider(eventIdString));
                            final isFavorited = isFavoritedAsync.value ?? false;

                            return Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorited ? context.errorColor : Colors.white, // White on dark overlay is intentional
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  // Check if user is logged in
                                  final isLoggedIn = ref.read(isLoggedInProvider);
                                  
                                  if (!isLoggedIn) {
                                    // Show login prompt for guests
                                    AuthPromptDialog.show(
                                      context: context,
                                      title: l10n.eventsFavoriteSignInTitle,
                                      message: l10n.eventsFavoriteSignInMessage,
                                      returnPath: '/events/${widget.event.id}',
                                      icon: Icons.favorite,
                                    );
                                    return;
                                  }
                                  
                                  try {
                                    final favoritesService = ref.read(favoritesServiceProvider);
                                    
                                    // Use toggleFavorite for add/remove in one call
                                    await favoritesService.toggleFavorite(eventId: eventIdString);
                                    
                                    // Invalidate to refresh
                                    ref.invalidate(isEventFavoritedProvider(eventIdString));
                                    ref.invalidate(favoritesProvider(const FavoritesParams(page: 1, limit: 20)));
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        AppTheme.successSnackBar(
                                          message: isFavorited
                                              ? l10n.commonFavoriteRemoved
                                              : l10n.commonFavoriteAdded,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    final errorText = e.toString();
                                    if (mounted) {
                                      if (errorText.contains('Unauthorized')) {
                                        AuthPromptDialog.show(
                                          context: context,
                                          title: l10n.exploreFavoriteSessionTitle,
                                          message: l10n.eventsFavoriteSessionMessage,
                                          returnPath:
                                              '/events/${widget.event.id}',
                                          icon: Icons.favorite,
                                        );
                                        return;
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        AppTheme.errorSnackBar(
                                          message: l10n.exploreFavoriteUpdateFailed(
                                            errorText.replaceFirst('Exception: ', ''),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        // Share button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white, // White on dark overlay is intentional
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final eventName = eventDetails.name;
                              final location = eventDetails.locationName.isNotEmpty
                                  ? eventDetails.locationName
                                  : '';
                              final dateText = dateFormat.format(startDate);

                              final shareText = location.isNotEmpty
                                  ? l10n.eventsShareWithLocation(
                                      eventName,
                                      location,
                                      dateText,
                                    )
                                  : l10n.eventsShareNoLocation(eventName, dateText);
                              final footer = 'https://www.sinc.events/${event.slug}';

                              await SharePlus.instance.share(
                                  ShareParams(text: '$shareText\n$footer'));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Event content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    eventDetails.name,
                    style: context.headlineMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Date and time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: context.primaryColorTheme,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(startDate),
                        style: context.titleMedium.copyWith(
                          color: context.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 20,
                        color: context.primaryColorTheme,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${timeFormat.format(startDate)} - ${timeFormat.format(endDate)}',
                        style: context.titleMedium.copyWith(
                          color: context.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: context.primaryColorTheme,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          eventDetails.locationName,
                          style: context.titleMedium.copyWith(
                            color: context.primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Organizer
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: context.grey200,
                        backgroundImage:
                            event.owner.imageUrl.trim().isEmpty
                                ? null
                                : CachedNetworkImageProvider(
                                      event.owner.imageUrl),
                        onBackgroundImageError:
                            event.owner.imageUrl.trim().isEmpty
                                ? null
                                : (_, __) {},
                        child:
                            event.owner.imageUrl.trim().isEmpty
                                ? Icon(
                                    Icons.business,
                                    color: context.primaryColorTheme,
                                  )
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.eventsOrganizedBy,
                              style: context.bodySmall.copyWith(
                                color: context.secondaryTextColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  event.owner.name,
                                  style: context.titleMedium.copyWith(
                                    color: context.primaryTextColor,
                                  ),
                                ),
                                if (event.owner.isVerified) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: context.primaryColorTheme,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    l10n.eventsAboutTitle,
                    style: context.titleLarge.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventDetails.description,
                    style: context.bodyMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Event context/category
                  if (eventDetails.eventContext?.name.isNotEmpty == true) ...[
                    Text(
                      l10n.eventsSectionCategory,
                      style: context.titleLarge.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.primaryColorTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.primaryColorTheme.withOpacity(0.3)),
                      ),
                      child: Text(
                        eventDetails.eventContext!.name,
                        style: context.bodyMedium.copyWith(
                          color: context.primaryColorTheme,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Attendance info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.primaryColorTheme.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.dividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          icon: Icons.people,
                          label: l10n.eventsLabelAttending,
                          value: '${eventDetails.attending}',
                          context: context,
                        ),
                        _buildInfoItem(
                          icon: Icons.group,
                          label: l10n.eventsLabelCapacity,
                          value: '${eventDetails.maxAttendance}',
                          context: context,
                        ),
                        _buildInfoItem(
                          icon: Icons.event_available,
                          label: l10n.eventsLabelStatus,
                          value: eventDetails.ongoing
                              ? l10n.eventsStatusOngoing
                              : l10n.eventsStatusUpcoming,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tickets section
                  if (eventDetails.tickets.isNotEmpty) ...[
                    Text(
                      l10n.eventsTicketsSection,
                      style: context.titleLarge.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...eventDetails.tickets.map((ticket) => _buildTicketCard(context, l10n, ticket, eventDetails.name)),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, l10n),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Icon(icon, color: context.primaryColorTheme, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        Text(
          label,
          style: context.bodySmall.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    AppLocalizations l10n,
    EventTicket ticket,
    String eventName,
  ) {
    final event = widget.event;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.name,
                    style: context.titleMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  if (ticket.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      ticket.description!,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_formatPrice(ticket.price)} ${ticket.currency}',
                        style: context.titleLarge.copyWith(
                          color: context.primaryColorTheme,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (ticket.disabled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.eventsTicketSoldOut,
                            style: context.bodySmall.copyWith(
                              color: context.errorColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: ticket.disabled ? null : () {
                _openTicketWebview(context, event.slug, eventName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white, // White text for maximum contrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                ticket.disabled ? l10n.eventsTicketSoldOut : l10n.eventsTicketBuy,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations l10n) {
    final event = widget.event;
    final eventDetails = event.event;
    final hasTickets = eventDetails.tickets.isNotEmpty;
    final cheapestTicket = hasTickets 
        ? eventDetails.tickets.where((t) => !t.disabled).fold<EventTicket?>(
            null, (cheapest, ticket) => cheapest == null || ticket.price < cheapest.price ? ticket : cheapest)
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(
          top: BorderSide(color: context.dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (cheapestTicket != null) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.eventsBottomPriceFrom(
                        _formatPrice(cheapestTicket.price, abbreviated: true),
                        cheapestTicket.currency,
                      ),
                      style: context.titleMedium.copyWith(
                        color: context.primaryColorTheme,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      l10n.eventsBottomPerPerson,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  _openTicketWebview(context, event.slug, eventDetails.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColorTheme,
                  foregroundColor: Colors.white, // White text for maximum contrast
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  hasTickets ? l10n.eventsBottomSelectTickets : l10n.eventsBottomJoinEvent,
                  style: const TextStyle(
                    fontSize: 16,
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

  String _formatPrice(int price, {bool abbreviated = false}) {
    if (abbreviated) {
      return PriceFormatter.formatAbbreviated(price.toDouble(), currency: '');
    }
    final formatter = NumberFormat(
      '#,##0',
      Localizations.localeOf(context).toString(),
    );
    return formatter.format(price);
  }

  void _trackEventView() {
    try {
      final event = widget.event;
      final analyticsService = ref.read(analyticsServiceProvider);
      analyticsService.trackEventView(
        eventId: event.id.toString(),
        eventType: event.type.isNotEmpty ? event.type : null,
      );
    } catch (e) {
      // Silently fail - analytics should never break the app
    }
  }

  Future<void> _openTicketWebview(BuildContext context, String eventSlug, String eventName) async {
    // Check if user has selected "Don't show again"
    final prefs = await SharedPreferences.getInstance();
    final dontShowAgain = prefs.getBool('sinc_ticket_dialog_dont_show') ?? false;

    if (dontShowAgain) {
      // Open webview directly
      _navigateToWebview(context, eventSlug, eventName);
    } else {
      // Show dialog first
      final shouldProceed = await _showSincRedirectDialog(context);
      if (shouldProceed == true && context.mounted) {
        _navigateToWebview(context, eventSlug, eventName);
      }
    }
  }

  Future<bool?> _showSincRedirectDialog(BuildContext context) async {
    bool dontShowAgain = false;
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Title in one row
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ctx.primaryColorTheme.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: ctx.primaryColorTheme,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.eventsSincRedirectTitle,
                      style: ctx.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ctx.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                l10n.eventsSincRedirectMessage,
                style: ctx.bodySmall.copyWith(
                  color: ctx.secondaryTextColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              // Don't show again checkbox
              InkWell(
                onTap: () {
                  setDialogState(() {
                    dontShowAgain = !dontShowAgain;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: dontShowAgain,
                          onChanged: (value) {
                            setDialogState(() {
                              dontShowAgain = value ?? false;
                            });
                          },
                          activeColor: ctx.primaryColorTheme,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.eventsSincDontShowAgain,
                          style: ctx.bodySmall.copyWith(
                            color: ctx.secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: ctx.secondaryTextColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save "Don't show again" preference
                if (dontShowAgain) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('sinc_ticket_dialog_dont_show', true);
                }
                Navigator.of(ctx).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.commonContinue,
                style: ctx.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToWebview(BuildContext context, String eventSlug, String eventName) {
    final sincUrl = 'https://www.sinc.events/$eventSlug';
    context.push(
      '/webview?url=${Uri.encodeComponent(sincUrl)}&title=${Uri.encodeComponent(eventName)}',
    );
  }
}

