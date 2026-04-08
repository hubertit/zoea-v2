import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/auth_provider.dart';
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
  String _selectedLanguage = 'English';
  
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
      _selectedLanguage = _mapLanguageCodeToName(langCode);
      _selectedCountry = user.countryName ?? _selectedCountry;
      // Only update location from user if it hasn't been manually changed
      if (!_locationManuallyChanged) {
        _selectedLocation = user.cityName ?? _selectedLocation;
      }
    });

    final countryId = user.countryId;
    if (countryId != null && countryId.isNotEmpty) {
      try {
        final countriesService = ref.read(countriesServiceProvider);
        final persistedCountry = await countriesService.getCountryById(countryId);
        await ref.read(selectedCountryProvider.notifier).selectCountry(persistedCountry);
      } catch (_) {
        // Ignore provider sync failures; local labels are still shown.
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
      final newLanguage = _mapLanguageCodeToName(langCode);
      final newCountry = user.countryName ?? 'Rwanda';

      if (_selectedCurrency != newCurrency ||
          _selectedLanguage != newLanguage ||
          _selectedCountry != newCountry) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedCurrency = newCurrency;
              _selectedLanguage = newLanguage;
              _selectedCountry = newCountry;
            });
          }
        });
      }
    }
    
    return _buildProfileContent();
  }
  
  String _mapLanguageCodeToName(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return 'English';
      case 'rw':
      case 'kin':
        return 'Kinyarwanda';
      case 'fr':
        return 'French';
      case 'sw':
        return 'Swahili';
      default:
        return 'English';
    }
  }
  
  String _mapLanguageNameToCode(String name) {
    switch (name) {
      case 'Kinyarwanda':
        return 'rw';
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'Swahili':
        return 'sw';
      default:
        return 'en';
    }
  }
  
  Widget _buildProfileContent() {

    return Scaffold(
      backgroundColor: context.grey50,
      appBar: AppBar(
        title: Text(
          'Profile',
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
            _buildQuickStats(),
            const SizedBox(height: 32),
            
            // Menu Sections
            _buildMenuSection(
              title: 'Account',
              items: [
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your notifications',
                  onTap: () {
                    context.push('/notifications');
                  },
                  showBadge: true, // Show unread badge
                ),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    context.go('/profile/edit');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.email_outlined,
                  title: 'Email & Phone',
                  subtitle: 'Manage contact information',
                  onTap: () {
                    // TODO: Navigate to contact settings
                  },
                ),
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Password and privacy settings',
                  onTap: () {
                    context.go('/profile/privacy-security');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: 'Preferences',
              items: [
                _buildMenuItem(
                  icon: Icons.attach_money_outlined,
                  title: 'Currency',
                  subtitle: _selectedCurrency,
                  onTap: () {
                    _showCurrencyBottomSheet(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.public_outlined,
                  title: 'Country',
                  subtitle: _selectedCountry,
                  onTap: () {
                    _showCountryBottomSheet(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  subtitle: _selectedLocation,
                  onTap: () {
                    _showLocationBottomSheet(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: 'Appearance',
              items: [
                _buildThemeSwitcher(),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: 'Travel & Activities',
              items: [
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'My Bookings',
                  subtitle: 'View your reservations',
                  onTap: () {
                    context.go('/profile/my-bookings');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_outline,
                  title: 'Favorites',
                  subtitle: 'Your saved places and events',
                  onTap: () {
                    context.go('/profile/favorites');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.reviews_outlined,
                  title: 'Reviews & Ratings',
                  subtitle: 'Your reviews and feedback',
                  onTap: () {
                    context.go('/profile/reviews-ratings');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildMenuSection(
              title: 'Support',
              items: [
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    context.go('/profile/help-center');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    context.go('/profile/about');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
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
            color: context.isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
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
                  context.primaryColorTheme.withOpacity(0.8),
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
                      color: context.primaryColorTheme.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Verified Traveler',
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

  Widget _buildQuickStats() {
    final userStats = ref.watch(userStatsProvider);
    
    return userStats.when(
      data: (stats) => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/profile/events-attended'),
              child: _buildStatCard(
                icon: Icons.event,
                title: 'Events',
                value: '0', // Events not in stats yet
                subtitle: 'Attended',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/profile/visited-places'),
              child: _buildStatCard(
                icon: Icons.place,
                title: 'Places',
                value: '${stats['visitedPlaces'] ?? 0}',
                subtitle: 'Visited',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/profile/reviews-written'),
              child: _buildStatCard(
                icon: Icons.star,
                title: 'Reviews',
                value: '${stats['reviews'] ?? 0}',
                subtitle: 'Written',
              ),
            ),
          ),
        ],
      ),
      loading: () => Row(
        children: [
          Expanded(child: _buildStatCard(icon: Icons.event, title: 'Events', value: '...', subtitle: 'Attended')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.place, title: 'Places', value: '...', subtitle: 'Visited')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.star, title: 'Reviews', value: '...', subtitle: 'Written')),
        ],
      ),
      error: (_, __) => Row(
        children: [
          Expanded(child: _buildStatCard(icon: Icons.event, title: 'Events', value: '0', subtitle: 'Attended')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.place, title: 'Places', value: '0', subtitle: 'Visited')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(icon: Icons.star, title: 'Reviews', value: '0', subtitle: 'Written')),
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
            color: context.isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
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
                color: context.isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
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
    required VoidCallback onTap,
    bool showBadge = false,
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
                    color: context.primaryColorTheme.withOpacity(0.1),
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

  Widget _buildThemeSwitcher() {
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
                  color: context.primaryColorTheme.withOpacity(0.1),
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
                      'Theme',
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      themeMode == ThemeMode.dark 
                          ? 'Dark Mode' 
                          : themeMode == ThemeMode.light 
                              ? 'Light Mode' 
                              : 'System Default',
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
                  label: 'Light',
                  onTap: () => themeNotifier.setTheme(ThemeMode.light),
                ),
                _buildThemeOption(
                  themeMode: ThemeMode.dark,
                  currentMode: themeMode,
                  icon: Icons.dark_mode,
                  label: 'Dark',
                  onTap: () => themeNotifier.setTheme(ThemeMode.dark),
                ),
                _buildThemeOption(
                  themeMode: ThemeMode.system,
                  currentMode: themeMode,
                  icon: Icons.brightness_auto,
                  label: 'System',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          'Sign Out',
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
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
              'Sign Out',
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
              'Select Country',
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
                      'Failed to load countries. Please try again.',
                      style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
                    ),
                  );
                }

                final countries = snapshot.data ?? const [];
                if (countries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'No countries available.',
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
      ),
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
              'Select Location',
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
                  'Select a country first to load locations.',
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
                        'Failed to load locations. Please try again.',
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
                        'No locations available for $countryName.',
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
                            (desc != null && desc.isNotEmpty) ? desc : 'City in $countryName',
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
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
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
              'Select Language',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Language options
            _buildLanguageOption('Kinyarwanda', 'Ikinyarwanda', _selectedLanguage == 'Kinyarwanda'),
            _buildLanguageOption('English', 'English', _selectedLanguage == 'English'),
            _buildLanguageOption('French', 'Français', _selectedLanguage == 'French'),
            _buildLanguageOption('Swahili', 'Kiswahili', _selectedLanguage == 'Swahili'),
            
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
        color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : context.cardColor,
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
              _showFeedbackSnackBar('Currency changed to $code', isSuccess: true);
            }
          } catch (e) {
            if (mounted) {
              _showFeedbackSnackBar(
                'Failed to update currency: ${e.toString().replaceFirst('Exception: ', '')}',
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
        color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : context.cardColor,
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
                _selectedLocation = 'Select city';
                _locationManuallyChanged = true;
              });
              
              if (mounted) {
                Navigator.pop(context);
                _showFeedbackSnackBar(
                  'Country changed to $name. Content will be filtered accordingly.',
                  isSuccess: true,
                );
              }
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context);
              _showFeedbackSnackBar(
                'Failed to change country. Please try again.',
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
        color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : context.cardColor,
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
            _showFeedbackSnackBar('Location changed to $name', isSuccess: true);
            return;
          }

          try {
            final userService = ref.read(userServiceProvider);
            await userService.updateProfile(countryId: countryId, cityId: cityId);
            await ref.read(selectedCityProvider.notifier).selectCity(cityId);
            try {
              await ref.read(authServiceProvider).getCurrentUser();
            } catch (_) {}
            _showFeedbackSnackBar('Location changed to $name', isSuccess: true);
          } catch (e) {
            _showFeedbackSnackBar(
              'Failed to save location: ${e.toString().replaceFirst('Exception: ', '')}',
              isError: true,
            );
          }
        },
      ),
    );
  }

  Widget _buildLanguageOption(String name, String nativeName, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? context.primaryColorTheme : context.grey200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          name,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          nativeName,
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
            _selectedLanguage = name;
          });
          
          // Update preferences in API
          try {
            final userService = ref.read(userServiceProvider);
            final langCode = _mapLanguageNameToCode(name);
            await userService.updatePreferences(language: langCode);
            if (mounted) {
              _showFeedbackSnackBar('Language changed to $name', isSuccess: true);
            }
          } catch (e) {
            if (mounted) {
              _showFeedbackSnackBar(
                'Failed to update language: ${e.toString().replaceFirst('Exception: ', '')}',
                isError: true,
              );
            }
          }
        },
      ),
    );
  }
}
