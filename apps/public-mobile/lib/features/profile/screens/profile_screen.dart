import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/package_info_provider.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/models/user.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // User preferences state - will be loaded from user data
  String _selectedCurrency = 'RWF';
  String _selectedCountry = 'Rwanda';
  String _selectedLocation = 'Kigali';
  String _selectedLanguageCode = 'en';
  
  // Track if location was manually changed in this session to avoid overwriting
  bool _locationManuallyChanged = false;
  
  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }
  
  Future<void> _loadUserPreferences() async {
    final initial = ref.read(currentUserProvider);
    if (initial == null) return;

    // Non-null `User` — inferred `User?` from `getCurrentUser()` would break promotion.
    User user = initial;

    // `currentUserProvider` can lag behind the server after profile edits elsewhere.
    // Refresh auth cache so labels match DB and we never push stale cityId into prefs.
    try {
      final fresh = await ref.read(authServiceProvider).getCurrentUser();
      if (fresh != null) user = fresh;
    } catch (_) {
      // Keep cached user if refresh fails (offline, etc.).
    }

    if (!mounted) return;

    setState(() {
      _selectedCurrency = user.preferences?.currency ?? 'RWF';
      final langCode = user.preferences?.language ?? 'en';
      _selectedLanguageCode = _normalizeLanguageCode(langCode);
      _selectedCountry = AppConfig.countrySelectionLockedToRwanda
          ? 'Rwanda'
          : (user.countryName ?? _selectedCountry);
      // Only update location from user if it hasn't been manually changed
      if (!_locationManuallyChanged) {
        _selectedLocation = user.cityName ?? _selectedLocation;
      }
    });

    if (AppConfig.countrySelectionLockedToRwanda) {
      try {
        final countriesService = ref.read(countriesServiceProvider);
        final rwanda = await countriesService.getCountryByCode('RW');
        if (rwanda != null) {
          await ref.read(selectedCountryProvider.notifier).selectCountry(rwanda);
        }
      } catch (_) {
        // Ignore provider sync failures; local labels are still shown.
      }
    } else {
      final countryId = user.countryId;
      if (countryId != null && countryId.isNotEmpty) {
        try {
          final countriesService = ref.read(countriesServiceProvider);
          final persistedCountry =
              await countriesService.getCountryById(countryId);
          await ref
              .read(selectedCountryProvider.notifier)
              .selectCountry(persistedCountry);
        } catch (_) {
          // Ignore provider sync failures; local labels are still shown.
        }
      }
    }

    // Do not call `selectedCityProvider.selectCity(user.cityId)` here — that was
    // overwriting a valid persisted/browse city with stale cached `user.cityId`.
  }
  
  @override
  Widget build(BuildContext context) {
    // Watch user provider to reload preferences when user data changes
    final user = ref.watch(currentUserProvider);
    
    // Sync currency / language / country when auth user updates.
    // Location is *not* synced here: `user.cityName` is often stale vs server until
    // `_loadUserPreferences` runs `getCurrentUser()`, and syncing it every build
    // reset the subtitle to Kigali after returning to this screen.
    if (user != null) {
      final newCurrency = user.preferences?.currency ?? 'RWF';
      final langCode = user.preferences?.language ?? 'en';
      final newLanguageCode = _normalizeLanguageCode(langCode);
      final newCountry = AppConfig.countrySelectionLockedToRwanda
          ? 'Rwanda'
          : (user.countryName ?? 'Rwanda');

      if (_selectedCurrency != newCurrency ||
          _selectedLanguageCode != newLanguageCode ||
          _selectedCountry != newCountry) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedCurrency = newCurrency;
              _selectedLanguageCode = newLanguageCode;
              _selectedCountry = newCountry;
            });
          }
        });
      }
    }
    
    return _buildProfileContent();
  }
  
  String _normalizeLanguageCode(String code) {
    switch (code.toLowerCase()) {
      case 'fr':
        return 'fr';
      case 'sw':
        return 'sw';
      case 'en':
      case 'rw':
      case 'kin':
      default:
        return 'en';
    }
  }

  String _languageSubtitle(AppLocalizations l10n) {
    switch (_selectedLanguageCode) {
      case 'fr':
        return l10n.languageOptionFrench;
      case 'sw':
        return l10n.languageOptionSwahili;
      default:
        return l10n.languageOptionEnglish;
    }
  }
  
  Widget _buildProfileContent() {
    final l10n = AppLocalizations.of(context)!;
    final packageInfo = ref.watch(packageInfoProvider);
    final aboutSubtitle = packageInfo.maybeWhen(
      data: (p) => l10n.profileAboutSubtitle(p.version, p.buildNumber),
      orElse: () => l10n.profileAppInformation,
    );

    return Scaffold(
      backgroundColor: context.grey50,
      appBar: AppBar(
        title: Text(
          l10n.profileTitle,
          style: context.titleLarge,
        ),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: const [
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),
            
            // Quick Stats
            _buildQuickStats(l10n),
            const SizedBox(height: 32),
            
            // Menu Sections
            _buildMenuSection(
              title: l10n.profileSectionAccount,
              items: [
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: l10n.profileNotificationsTitle,
                  subtitle: l10n.profileNotificationsSubtitle,
                  onTap: () {
                    context.push('/notifications');
                  },
                  showBadge: true, // Show unread badge
                ),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: l10n.profileEditTitle,
                  subtitle: l10n.profileEditSubtitle,
                  onTap: () {
                    context.go('/profile/edit');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  title: l10n.profilePrivacyTitle,
                  subtitle: l10n.profilePrivacySubtitle,
                  onTap: () {
                    context.go('/profile/privacy-security');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: l10n.profileSectionPreferences,
              items: [
                _buildMenuItem(
                  icon: Icons.attach_money_outlined,
                  title: l10n.profileCurrencyTitle,
                  subtitle: _selectedCurrency,
                  onTap: () {
                    _showCurrencyBottomSheet(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.public_outlined,
                  title: l10n.profileCountryTitle,
                  subtitle: AppConfig.countrySelectionLockedToRwanda
                      ? l10n.profileCountryRwanda
                      : _selectedCountry,
                  onTap: AppConfig.countrySelectionLockedToRwanda
                      ? null
                      : () {
                          _showCountryBottomSheet(context);
                        },
                  showTrailingChevron:
                      !AppConfig.countrySelectionLockedToRwanda,
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: l10n.profileLocationTitle,
                  subtitle: _selectedLocation,
                  onTap: () {
                    _showLocationBottomSheet(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: l10n.profileLanguageTitle,
                  subtitle: _languageSubtitle(l10n),
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: l10n.profileSectionAppearance,
              items: [
                _buildThemeSwitcher(l10n),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: l10n.profileSectionTravel,
              items: [
                _buildMenuItem(
                  icon: Icons.history,
                  title: l10n.profileMyBookingsTitle,
                  subtitle: l10n.profileMyBookingsSubtitle,
                  onTap: () {
                    context.go('/profile/my-bookings');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_outline,
                  title: l10n.profileFavoritesTitle,
                  subtitle: l10n.profileFavoritesSubtitle,
                  onTap: () {
                    context.go('/profile/favorites');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.reviews_outlined,
                  title: l10n.profileReviewsTitle,
                  subtitle: l10n.profileReviewsSubtitle,
                  onTap: () {
                    context.go('/profile/reviews-written');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: l10n.profileSectionSupport,
              items: [
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: l10n.profileHelpTitle,
                  subtitle: l10n.profileHelpSubtitle,
                  onTap: () {
                    context.go('/profile/help-center');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: l10n.profileAboutMenuTitle,
                  subtitle: aboutSubtitle,
                  onTap: () {
                    context.go('/profile/about');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: l10n.profileSignOutTitle,
                  subtitle: l10n.profileSignOutSubtitle,
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final user = ref.watch(currentUserProvider);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  context.primaryColorTheme,
                  context.primaryColorTheme.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: user?.profileImage != null
                ? ClipOval(
                    child: Image.network(
                      user!.profileImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            user.initials,
                            style: TextStyle(
                              color: context.primaryTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      user?.initials ?? 'U',
                      style: TextStyle(
                        color: context.primaryTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'User',
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: context.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                if (user?.isVerified == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.primaryColorTheme.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.profileVerifiedTraveler,
                      style: context.labelSmall.copyWith(
                        color: context.primaryColorTheme,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Edit Button
          IconButton(
            onPressed: () {
              context.go('/profile/edit');
            },
            icon: const Icon(Icons.edit_outlined),
            style: IconButton.styleFrom(
              backgroundColor: context.dividerColor,
              foregroundColor: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  int _coerceStatInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return 0;
  }

  Widget _buildQuickStats(AppLocalizations l10n) {
    final userStats = ref.watch(userStatsProvider);
    
    return userStats.when(
      data: (stats) {
        final eventsCount = _coerceStatInt(
          stats['eventsAttended'] ??
              stats['eventBookings'] ??
              stats['events'],
        );
        final visitedPlacesCount = _coerceStatInt(stats['visitedPlaces']);

        return Row(
          children: [
          Expanded(
            child: GestureDetector(
              onTap: eventsCount > 0
                  ? () => context.go('/profile/events-attended')
                  : null,
              behavior: HitTestBehavior.opaque,
              child: _buildStatCard(
                icon: Icons.event,
                title: l10n.profileStatEvents,
                value: '$eventsCount',
                subtitle: l10n.profileStatAttended,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: visitedPlacesCount > 0
                  ? () => context.go('/profile/visited-places')
                  : null,
              behavior: HitTestBehavior.opaque,
              child: _buildStatCard(
                icon: Icons.place,
                title: l10n.profileStatPlaces,
                value: '$visitedPlacesCount',
                subtitle: l10n.profileStatVisited,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/profile/reviews-written'),
              child: _buildStatCard(
                icon: Icons.star,
                title: l10n.profileStatReviews,
                value: '${stats['reviews'] ?? 0}',
                subtitle: l10n.profileStatWritten,
              ),
            ),
          ),
          ],
        );
      },
      loading: () => Row(
        children: [
          Expanded(child: _buildStatCard(icon: Icons.event, title: l10n.profileStatEvents, value: '...', subtitle: l10n.profileStatAttended)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.place, title: l10n.profileStatPlaces, value: '...', subtitle: l10n.profileStatVisited)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.star, title: l10n.profileStatReviews, value: '...', subtitle: l10n.profileStatWritten)),
        ],
      ),
      error: (_, __) => Row(
        children: [
          Expanded(child: _buildStatCard(icon: Icons.event, title: l10n.profileStatEvents, value: '0', subtitle: l10n.profileStatAttended)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.place, title: l10n.profileStatPlaces, value: '0', subtitle: l10n.profileStatVisited)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.star, title: l10n.profileStatReviews, value: '0', subtitle: l10n.profileStatWritten)),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: context.primaryColorTheme,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: context.bodySmall.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: context.labelSmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }


  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showBadge = false,
    bool showTrailingChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColorTheme.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: context.primaryColorTheme,
                    size: 20,
                  ),
                ),
                // Show badge if enabled
                if (showBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.bodySmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (showTrailingChevron)
              Icon(
                Icons.chevron_right,
                color: context.secondaryTextColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher(AppLocalizations l10n) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColorTheme.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: context.primaryColorTheme,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileThemeLabel,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      themeMode == ThemeMode.dark 
                          ? l10n.profileThemeDark
                          : themeMode == ThemeMode.light 
                              ? l10n.profileThemeLight
                              : l10n.profileThemeSystem,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Theme Mode Segmented Control
          Container(
            decoration: BoxDecoration(
              color: context.grey100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildThemeOption(
                  themeMode: ThemeMode.light,
                  currentMode: themeMode,
                  icon: Icons.light_mode,
                  label: l10n.appearanceLight,
                  onTap: () => themeNotifier.setTheme(ThemeMode.light),
                ),
                _buildThemeOption(
                  themeMode: ThemeMode.dark,
                  currentMode: themeMode,
                  icon: Icons.dark_mode,
                  label: l10n.appearanceDark,
                  onTap: () => themeNotifier.setTheme(ThemeMode.dark),
                ),
                _buildThemeOption(
                  themeMode: ThemeMode.system,
                  currentMode: themeMode,
                  icon: Icons.brightness_auto,
                  label: l10n.appearanceSystem,
                  onTap: () => themeNotifier.setTheme(ThemeMode.system),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required ThemeMode themeMode,
    required ThemeMode currentMode,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = currentMode == themeMode;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? context.primaryColorTheme 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? context.isDarkMode 
                        ? context.primaryTextColor
                        : Colors.white
                    : context.secondaryTextColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.bodySmall.copyWith(
                  color: isSelected 
                      ? context.isDarkMode 
                          ? context.primaryTextColor
                          : Colors.white
                      : context.secondaryTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final rootL10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          rootL10n.signOutDialogTitle,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          rootL10n.signOutDialogMessage,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              rootL10n.authCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Sign out using auth service
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
              // Navigate to login screen
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text(
              rootL10n.signOutDialogConfirm,
              style: context.bodyMedium.copyWith(
                color: context.errorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.grey50,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Select Currency',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Currency options
            _buildCurrencyOption('USD', 'United States Dollar', _selectedCurrency == 'USD'),
            _buildCurrencyOption('RWF', 'Rwandan Franc', _selectedCurrency == 'RWF'),
            _buildCurrencyOption('EUR', 'Euro', _selectedCurrency == 'EUR'),
            _buildCurrencyOption('GBP', 'British Pound', _selectedCurrency == 'GBP'),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showCountryBottomSheet(BuildContext context) {
    if (AppConfig.countrySelectionLockedToRwanda) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.grey50,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
        return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              l10n.profileSelectCountrySheetTitle,
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            FutureBuilder(
              future: ref.read(countriesServiceProvider).getActiveCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      l10n.profileCountriesLoadError,
                      style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                    ),
                  );
                }

                final countries = snapshot.data ?? const [];
                if (countries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      l10n.profileCountriesEmpty,
                      style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                    ),
                  );
                }

                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: SingleChildScrollView(
                    child: Column(
                      children: countries.map((country) {
                        final code = country.code2.toUpperCase();
                        return _buildCountryOption(
                          country.name,
                          _flagFromCountryCode(code),
                          _selectedCountry == country.name,
                          countryCode: code,
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
    );
      },
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    final selectedCountry = ref.read(selectedCountryProvider).valueOrNull;
    final countryId = selectedCountry?.id;
    final countryName = selectedCountry?.name ?? _selectedCountry;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.grey50,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
        return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              l10n.profileSelectLocationSheetTitle,
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),

            if (countryId == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  l10n.profileSelectCountryFirstForLocations,
                  style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                ),
              )
            else
              FutureBuilder<List<Map<String, dynamic>>>(
                future: ref.read(countriesServiceProvider).getCountryCities(countryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        l10n.profileLocationsLoadError,
                        style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                      ),
                    );
                  }

                  final cities = (snapshot.data ?? [])
                      .where((c) => (c['name']?.toString().trim().isNotEmpty ?? false))
                      .toList()
                    ..sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));

                  if (cities.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        l10n.profileLocationsEmptyForCountry(countryName),
                        style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                      ),
                    );
                  }

                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: SingleChildScrollView(
                      child: Column(
                        children: cities.map((city) {
                          final cityName = city['name'].toString();
                          final desc = city['description']?.toString();
                          return _buildLocationOption(
                            cityName,
                            (desc != null && desc.isNotEmpty)
                                ? desc
                                : l10n.profileCityInCountryDescription(countryName),
                            _selectedLocation == cityName,
                            cityId: city['id']?.toString(),
                            countryId: countryId,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
    );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.grey50,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              l10n.profileSelectLanguage,
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildLanguageOption('en', l10n, _selectedLanguageCode == 'en'),
            _buildLanguageOption('fr', l10n, _selectedLanguageCode == 'fr'),
            _buildLanguageOption('sw', l10n, _selectedLanguageCode == 'sw'),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String code, String name, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.primaryColorTheme.withValues(alpha: 0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.primaryColorTheme : context.grey200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          code,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          name,
          style: context.bodySmall.copyWith(
            color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
          ),
        ),
        trailing: isSelected ? Icon(
          Icons.check_circle,
          color: context.primaryColorTheme,
          size: 20,
        ) : null,
        onTap: () async {
          Navigator.pop(context);
          setState(() {
            _selectedCurrency = code;
          });
          
          // Update preferences in API
          try {
            final userService = ref.read(userServiceProvider);
            await userService.updatePreferences(currency: code);
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              _showFeedbackSnackBar(l10n.profileCurrencyChanged(code), isSuccess: true);
            }
          } catch (e) {
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              _showFeedbackSnackBar(
                l10n.profileCurrencyUpdateFailed(
                  e.toString().replaceFirst('Exception: ', ''),
                ),
                isError: true,
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildCountryOption(
    String name,
    String flag,
    bool isSelected, {
    String? countryCode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.primaryColorTheme.withValues(alpha: 0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.primaryColorTheme : context.grey200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          name,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
          ),
        ),
        trailing: isSelected ? Icon(
          Icons.check_circle,
          color: context.primaryColorTheme,
          size: 20,
        ) : null,
        onTap: () async {
          // Use provided country code for dynamic options; fallback to name mapping.
          final code = countryCode ?? _getCountryCode(name);
          
          try {
            // Get country from API by code
            final countriesService = ref.read(countriesServiceProvider);
            final country = await countriesService.getCountryByCode(code);
            
            if (country != null) {
              // Save country selection
              await ref.read(selectedCountryProvider.notifier).selectCountry(country);
              await ref.read(selectedCityProvider.notifier).clearCity();
              final userService = ref.read(userServiceProvider);
              await userService.updateProfile(countryId: country.id);
              try {
                await ref.read(authServiceProvider).getCurrentUser();
              } catch (_) {}

              setState(() {
                _selectedCountry = name;
                _selectedLocation = AppLocalizations.of(context)!.profileSelectCity;
                _locationManuallyChanged = true;
              });
              
              if (mounted) {
                Navigator.pop(context);
                final l10n = AppLocalizations.of(context)!;
                _showFeedbackSnackBar(
                  l10n.profileCountryChanged(name),
                  isSuccess: true,
                );
              }
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context);
              final l10n = AppLocalizations.of(context)!;
              _showFeedbackSnackBar(
                l10n.profileCountryChangeFailed,
                isError: true,
              );
            }
          }
        },
      ),
    );
  }

  /// Map country name to ISO 2-letter code
  String _getCountryCode(String name) {
    switch (name) {
      case 'Rwanda':
        return 'RW';
      case 'Kenya':
        return 'KE';
      case 'Uganda':
        return 'UG';
      case 'South Africa':
        return 'ZA';
      case 'Nigeria':
        return 'NG';
      default:
        return 'RW'; // Default to Rwanda
    }
  }

  String _flagFromCountryCode(String code) {
    const codeToFlag = {
      'RW': '🇷🇼',
      'KE': '🇰🇪',
      'UG': '🇺🇬',
      'ZA': '🇿🇦',
      'NG': '🇳🇬',
    };
    return codeToFlag[code] ?? '🌍';
  }

  void _showFeedbackSnackBar(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isError
        ? colorScheme.errorContainer
        : isSuccess
            ? colorScheme.primaryContainer
            : colorScheme.inverseSurface;
    final textColor = isError
        ? colorScheme.onErrorContainer
        : isSuccess
            ? colorScheme.onPrimaryContainer
            : colorScheme.onInverseSurface;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            style: context.bodyMedium.copyWith(color: textColor),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  Widget _buildLocationOption(
    String name,
    String description,
    bool isSelected, {
    String? cityId,
    String? countryId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.primaryColorTheme.withValues(alpha: 0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.primaryColorTheme : context.grey200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
        ),
        title: Text(
          name,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          description,
          style: context.bodySmall.copyWith(
            color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
          ),
        ),
        trailing: isSelected ? Icon(
          Icons.check_circle,
          color: context.primaryColorTheme,
          size: 20,
        ) : null,
        onTap: () async {
          setState(() {
            _selectedLocation = name;
            _locationManuallyChanged = true;
          });
          Navigator.pop(context);

          if (cityId == null || countryId == null) {
            final l10n = AppLocalizations.of(context)!;
            _showFeedbackSnackBar(l10n.profileLocationChanged(name), isSuccess: true);
            return;
          }

          try {
            final userService = ref.read(userServiceProvider);
            await userService.updateProfile(countryId: countryId, cityId: cityId);
            await ref.read(selectedCityProvider.notifier).selectCity(cityId);
            try {
              await ref.read(authServiceProvider).getCurrentUser();
            } catch (_) {}
            if (!mounted) return;
            final l10nOk = AppLocalizations.of(context)!;
            _showFeedbackSnackBar(l10nOk.profileLocationChanged(name), isSuccess: true);
          } catch (e) {
            if (!mounted) return;
            final l10nErr = AppLocalizations.of(context)!;
            _showFeedbackSnackBar(
              l10nErr.profileLocationSaveFailed(
                e.toString().replaceFirst('Exception: ', ''),
              ),
              isError: true,
            );
          }
        },
      ),
    );
  }

  Widget _buildLanguageOption(String code, AppLocalizations l10n, bool isSelected) {
    final title = switch (code) {
      'fr' => l10n.languageOptionFrench,
      'sw' => l10n.languageOptionSwahili,
      _ => l10n.languageOptionEnglish,
    };
    final native = switch (code) {
      'fr' => l10n.languageNativeNameFrench,
      'sw' => l10n.languageNativeNameSwahili,
      _ => l10n.languageNativeNameEnglish,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.primaryColorTheme.withValues(alpha: 0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.primaryColorTheme : context.grey200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          native,
          style: context.bodySmall.copyWith(
            color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
          ),
        ),
        trailing: isSelected ? Icon(
          Icons.check_circle,
          color: context.primaryColorTheme,
          size: 20,
        ) : null,
        onTap: () async {
          Navigator.pop(context);
          await ref.read(localeProvider.notifier).setLanguageCode(code);
          if (!mounted) return;
          setState(() {
            _selectedLanguageCode = code;
          });

          final loggedIn = ref.read(isLoggedInProvider);
          final l10nMsg = AppLocalizations.of(context)!;
          final label = switch (code) {
            'fr' => l10nMsg.languageOptionFrench,
            'sw' => l10nMsg.languageOptionSwahili,
            _ => l10nMsg.languageOptionEnglish,
          };

          if (loggedIn) {
            try {
              final userService = ref.read(userServiceProvider);
              await userService.updatePreferences(language: code);
              if (mounted) {
                _showFeedbackSnackBar(
                  l10nMsg.profileLanguageChanged(label),
                  isSuccess: true,
                );
              }
            } catch (e) {
              if (mounted) {
                _showFeedbackSnackBar(
                  l10nMsg.profileLanguageUpdateFailed(
                    e.toString().replaceFirst('Exception: ', ''),
                  ),
                  isError: true,
                );
              }
            }
          } else {
            _showFeedbackSnackBar(
              l10nMsg.profileLanguageChanged(label),
              isSuccess: true,
            );
          }
        },
      ),
    );
  }
}
