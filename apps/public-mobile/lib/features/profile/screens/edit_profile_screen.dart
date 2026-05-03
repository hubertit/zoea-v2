import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/models/user.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../user_data_collection/widgets/age_range_selector.dart';
import '../../user_data_collection/widgets/gender_selector.dart';
import '../../user_data_collection/widgets/length_of_stay_selector.dart';
import '../../user_data_collection/widgets/interests_chips.dart';
import '../../user_data_collection/widgets/travel_party_selector.dart';
import '../../../l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final int? initialTab; // 0 = Basic Info, 1 = Preferences

  const EditProfileScreen({super.key, this.initialTab});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasLoadedInitialData = false;

  // Preferences state
  AgeRange? _selectedAgeRange;
  Gender? _selectedGender;
  LengthOfStay? _selectedLengthOfStay;
  List<String> _selectedInterests = [];
  TravelParty? _selectedTravelParty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab ?? 0,
    );
    // Add animation listener for smooth tab transitions
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Tab animation completed
      }
    });
    
    // Load user data initially
    _loadUserData();
  }

  void _loadUserData({bool force = false}) {
    // Prevent multiple simultaneous loads
    if (_hasLoadedInitialData && !force) {
      return;
    }
    
    final user = ref.read(currentUserProvider);
    if (user != null) {
      // Only update if controllers are empty or if data has changed
      if (_nameController.text.isEmpty || _nameController.text != user.fullName) {
        _nameController.text = user.fullName;
      }
      if (_emailController.text.isEmpty || _emailController.text != user.email) {
        _emailController.text = user.email;
      }
      if (_phoneController.text.isEmpty || _phoneController.text != (user.phoneNumber ?? '')) {
        _phoneController.text = user.phoneNumber ?? '';
      }
      
      // Load preferences - only if not already loaded or forced
      if (user.preferences != null) {
        final prefs = user.preferences!;
        final newInterests = List<String>.from(prefs.interests);
        
        // Only update state if values actually changed or this is first load
        final needsUpdate = 
            _selectedAgeRange != prefs.ageRange ||
            _selectedGender != prefs.gender ||
            _selectedLengthOfStay != prefs.lengthOfStay ||
            !_listEquals(_selectedInterests, newInterests) ||
            _selectedTravelParty != prefs.travelParty ||
            !_hasLoadedInitialData;
        
        if (needsUpdate) {
          setState(() {
            _selectedAgeRange = prefs.ageRange;
            _selectedGender = prefs.gender;
            _selectedLengthOfStay = prefs.lengthOfStay;
            
            // Load interests - ensure they match the widget's expected format (IDs)
            // The API returns interests as IDs (e.g., 'nature', 'food')
            _selectedInterests = newInterests;
            
            _selectedTravelParty = prefs.travelParty;
            
            _hasLoadedInitialData = true;
          });
        } else {
          _hasLoadedInitialData = true;
        }
      } else {
        _hasLoadedInitialData = true;
      }
    }
  }
  

  /// Check if there are unsaved changes
  bool _checkForUnsavedChanges() {
    final user = ref.read(currentUserProvider);
    if (user == null) return false;

    // Check basic info changes
    final nameChanged = _nameController.text.trim() != user.fullName;
    final emailChanged = _emailController.text.trim() != user.email;
    final phoneChanged = _phoneController.text.trim() != (user.phoneNumber ?? '');
    
    // Check preferences changes
    final prefs = user.preferences;
    final ageChanged = _selectedAgeRange != prefs?.ageRange;
    final genderChanged = _selectedGender != prefs?.gender;
    final lengthOfStayChanged = _selectedLengthOfStay != prefs?.lengthOfStay;
    final interestsChanged = !_listEquals(_selectedInterests, prefs?.interests ?? []);
    final travelPartyChanged = _selectedTravelParty != prefs?.travelParty;

    return nameChanged || emailChanged || phoneChanged || 
           ageChanged || genderChanged || lengthOfStayChanged || 
           interestsChanged || travelPartyChanged;
  }

  /// Helper to compare lists
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Show confirmation dialog before navigating away
  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          'Unsaved Changes',
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.profileEditUnsavedChangesBody,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context)!.commonCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.profileEditDiscard,
              style: context.bodyMedium.copyWith(
                color: context.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only watch for completion percentage, not the entire user object
    // This prevents unnecessary rebuilds when user data changes
    final user = ref.read(currentUserProvider);
    final completionPercentage = user?.preferences?.profileCompletionPercentage ?? 0;
    
    // Load user data once when it becomes available (only if not already loaded)
    if (user != null && !_hasLoadedInitialData) {
      // Use a one-time callback to avoid reloading on every rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasLoadedInitialData) {
          _loadUserData();
        }
      });
    }

    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          loc.profileEditTitle,
          style: context.titleLarge.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            // Check for unsaved changes before navigating away
            if (_checkForUnsavedChanges()) {
              final shouldLeave = await _showUnsavedChangesDialog();
              if (shouldLeave && mounted) {
                context.go('/profile');
              }
            } else {
              context.go('/profile');
            }
          },
          icon: const Icon(Icons.chevron_left, size: 32),
          style: IconButton.styleFrom(
            foregroundColor: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: (_isLoading || _isSaving) ? null : _saveAll,
            child: Text(
              loc.commonSave,
              style: context.bodyMedium.copyWith(
                color: context.primaryColorTheme,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Completion Badge (above tabs)
          _buildCompletionBadge(completionPercentage),
          
          // TabBar (below completion badge)
          TabBar(
            controller: _tabController,
            labelColor: context.primaryColorTheme,
            unselectedLabelColor: context.secondaryTextColor,
            indicatorColor: context.primaryColorTheme,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: context.bodyMedium,
            tabs: [
              Tab(text: loc.profileEditTabBasicInfo),
              Tab(text: loc.profileEditTabPreferences),
            ],
          ),
          
          // Tab Content with animation
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(), // Smooth scrolling animation
              children: [
                _buildBasicInfoTab(loc),
                _buildPreferencesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBadge(int percentage) {
    Color badgeColor;
    if (percentage >= 80) {
      badgeColor = AppTheme.successColor;
    } else if (percentage >= 50) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = context.secondaryTextColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: badgeColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Text(
              'Profile Completion: $percentage%',
              style: context.bodyMedium.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Personal Information
          _buildSectionHeader(l10n.profileEditPersonalInfoSectionTitle),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: l10n.registerFullName,
            hint: l10n.profileEditHintFullName,
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.profileEditValidationFullNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: l10n.loginEmailAddress,
            hint: l10n.profileEditHintEmail,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.profileEditValidationEmailRequired;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return l10n.loginValidationEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: l10n.loginPhoneNumber,
            hint: l10n.profileEditHintPhone,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.profileEditValidationPhoneRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPreferencesTab() {
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Age Range
          _buildPreferencesSection(
            title: l10n.udcFieldAgeRangeTitle,
            subtitle: l10n.udcFieldAgeRangeSubtitle,
            isComplete: _selectedAgeRange != null,
            child: AgeRangeSelector(
              selectedRange: _selectedAgeRange,
              onRangeSelected: (range) {
                setState(() {
                  _selectedAgeRange = range;
                });
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Gender
          _buildPreferencesSection(
            title: l10n.udcFieldGenderTitle,
            subtitle: l10n.udcFieldGenderSubtitle,
            isComplete: _selectedGender != null,
            child: GenderSelector(
              selectedGender: _selectedGender,
              onGenderSelected: (gender) {
                setState(() {
                  _selectedGender = gender;
                });
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Length of Stay (only for visitors)
          if (user?.preferences?.userType == UserType.visitor) ...[
            _buildPreferencesSection(
              title: l10n.udcFieldLengthOfStayTitle,
              subtitle: l10n.udcFieldLengthOfStaySubtitle,
              isComplete: _selectedLengthOfStay != null,
              child: LengthOfStaySelector(
                selectedLength: _selectedLengthOfStay,
                onLengthSelected: (length) {
                  setState(() {
                    _selectedLengthOfStay = length;
                  });
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
          ],

          // Interests
          _buildPreferencesSection(
            title: l10n.profileEditInterestsTitle,
            subtitle: l10n.profileEditInterestsSubtitle,
            isComplete: _selectedInterests.isNotEmpty,
            child: InterestsChips(
              selectedInterests: _selectedInterests,
              onInterestsChanged: (interests) {
                setState(() {
                  _selectedInterests = interests;
                });
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Travel Party
          _buildPreferencesSection(
            title: l10n.udcFieldTravelPartyTitle,
            subtitle: l10n.udcFieldTravelPartySubtitle,
            isComplete: _selectedTravelParty != null,
            child: TravelPartySelector(
              selectedParty: _selectedTravelParty,
              onPartySelected: (party) {
                setState(() {
                  _selectedTravelParty = party;
                });
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacing32),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection({
    required String title,
    required String subtitle,
    required bool isComplete,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    subtitle,
                    style: context.bodySmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isComplete)
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        child,
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: context.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: context.primaryTextColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: context.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            prefixIcon: Icon(
              icon,
              color: context.primaryColorTheme,
              size: 20,
            ),
            filled: true,
            fillColor: context.dividerColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.primaryColorTheme,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.errorColor,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.errorColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAll() async {
    // Validate basic info form
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      // Switch to basic info tab if validation fails
      _tabController.animateTo(0);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      final userService = ref.read(userServiceProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (currentUser == null) {
        throw Exception('User not found. Please login again.');
      }

      // Save basic info
      final nameChanged = _nameController.text.trim() != currentUser.fullName;
      final emailChanged = _emailController.text.trim() != currentUser.email;
      final phoneChanged = _phoneController.text.trim() != (currentUser.phoneNumber ?? '');

      if (nameChanged || phoneChanged) {
        await userService.updateProfile(
          fullName: nameChanged ? _nameController.text.trim() : null,
          phoneNumber: phoneChanged ? _phoneController.text.trim() : null,
        );
      }

      if (emailChanged) {
        // Show password dialog for email update
        final password = await _showPasswordDialog();
        if (password == null) {
          // User cancelled password dialog
          setState(() {
            _isSaving = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              AppTheme.errorSnackBar(
                message: l10n.profileEditPasswordRequiredForEmail,
              ),
            );
          }
          return;
        }
        await userService.updateEmail(_emailController.text.trim(), password: password);
      }

      // Save preferences in a single API call
      final userType = currentUser.preferences?.userType;
      final existingFlags = currentUser.preferences?.dataCollectionFlags ?? {};
      final updatedFlags = <String, bool>{...existingFlags};
      
      // Build flags for fields that are being set
      if (_selectedAgeRange != null) updatedFlags['ageAsked'] = true;
      if (_selectedGender != null) updatedFlags['genderAsked'] = true;
      if (userType == UserType.visitor && _selectedLengthOfStay != null) {
        updatedFlags['lengthOfStayAsked'] = true;
      }
      if (_selectedInterests.isNotEmpty) updatedFlags['interestsAsked'] = true;
      if (_selectedTravelParty != null) updatedFlags['travelPartyAsked'] = true;

      // Prepare preferences data
      final preferencesData = <String, dynamic>{
        'dataCollectionFlags': updatedFlags,
      };
      
      if (_selectedAgeRange != null) {
        preferencesData['ageRange'] = _selectedAgeRange!.apiValue;
      }
      if (_selectedGender != null) {
        preferencesData['gender'] = _selectedGender!.apiValue;
      }
      
      // Handle lengthOfStay based on user type
      if (userType == UserType.visitor) {
        if (_selectedLengthOfStay != null) {
          preferencesData['lengthOfStay'] = _selectedLengthOfStay!.apiValue;
        }
      } else {
        // Clear lengthOfStay for residents
        preferencesData['lengthOfStay'] = null;
      }
      
      if (_selectedInterests.isNotEmpty) {
        preferencesData['interests'] = _selectedInterests;
      }
      if (_selectedTravelParty != null) {
        preferencesData['travelParty'] = _selectedTravelParty!.apiValue;
      }

      // Save all preferences in one API call
      if (preferencesData.isNotEmpty) {
        await userService.updatePreferences(
          ageRange: _selectedAgeRange,
          gender: _selectedGender,
          lengthOfStay: userType == UserType.visitor ? _selectedLengthOfStay : null,
          interests: _selectedInterests.isNotEmpty ? _selectedInterests : null,
          travelParty: _selectedTravelParty,
          dataCollectionFlags: updatedFlags,
        );
      }

      // Refresh user data from API
      final authService = ref.read(authServiceProvider);
      await authService.getCurrentUser();
      
      // Also invalidate providers to ensure UI updates
      ref.invalidate(currentUserProvider);
      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(authProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(
            message: l10n.commonProfileUpdatedSuccess,
          ),
        );
        
        // Small delay to ensure data is refreshed before navigation
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Navigate back to profile
        if (mounted) {
          context.go('/profile');
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: errorMessage.isNotEmpty 
                ? errorMessage 
                : l10n.profileUpdateFailedGeneric,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<String?> _showPasswordDialog() async {
    final passwordController = TextEditingController();
    bool obscurePassword = true;
    bool isLoading = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final dlgL10n = AppLocalizations.of(context)!;
          return AlertDialog(
          backgroundColor: context.backgroundColor,
          title: Text(
            dlgL10n.profileEnterPasswordDialogTitle,
            style: context.titleLarge.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dlgL10n.profileEnterPasswordDialogBody,
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: dlgL10n.loginPassword,
                  hintText: dlgL10n.loginPasswordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: context.dividerColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(
                dlgL10n.authCancel,
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppTheme.errorSnackBar(
                      message: dlgL10n.profileEditPleaseEnterPassword,
                    ),
                  );
                  return;
                }
                
                setDialogState(() {
                  isLoading = true;
                });
                
                // Small delay to show loading state
                await Future.delayed(const Duration(milliseconds: 100));
                
                if (context.mounted) {
                  Navigator.of(context).pop(password);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColorTheme,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(dlgL10n.editProfileConfirm),
            ),
          ],
        );
        },
      ),
    );
  }
}
