import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/user_data_collection_provider.dart';
import '../../../core/utils/phone_input_formatter.dart';
import '../../../core/utils/phone_validator.dart';

class PrivacySecurityScreen extends ConsumerStatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  ConsumerState<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends ConsumerState<PrivacySecurityScreen> {
  bool _locationEnabled = true;
  bool _notificationsEnabled = true;
  bool _dataSharingEnabled = false;
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final analyticsConsentAsync = ref.watch(analyticsConsentProvider);
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.profilePrivacyTitle,
          style: context.titleLarge.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.go('/profile'),
          icon: Icon(Icons.chevron_left, size: 32, color: context.primaryTextColor),
          style: IconButton.styleFrom(
            foregroundColor: context.primaryTextColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Privacy Settings Section
          _buildSectionHeader(l10n.privacySectionPrivacySettings),
          const SizedBox(height: 16),
          _buildSwitchTile(
            icon: Icons.location_on,
            title: l10n.privacyLocationServicesTitle,
            subtitle: l10n.privacyLocationServicesSubtitle,
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: l10n.privacyPushNotificationsTitle,
            subtitle: l10n.privacyPushNotificationsSubtitle,
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.share,
            title: l10n.privacyDataSharingTitle,
            subtitle: l10n.privacyDataSharingSubtitle,
            value: _dataSharingEnabled,
            onChanged: (value) {
              setState(() {
                _dataSharingEnabled = value;
              });
            },
          ),
          // Analytics toggle - connected to AnalyticsService
          analyticsConsentAsync.when(
            data: (hasConsent) => _buildSwitchTile(
              icon: Icons.analytics,
              title: l10n.privacyAnalyticsTitle,
              subtitle: l10n.privacyAnalyticsSubtitle,
              value: hasConsent,
              onChanged: (value) async {
                try {
                  final analyticsService = ref.read(analyticsServiceProvider);
                  await analyticsService.setConsent(value);
                  if (mounted) {
                    ref.invalidate(analyticsConsentProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value 
                              ? l10n.privacyAnalyticsEnabled 
                              : l10n.privacyAnalyticsDisabled,
                          style: context.bodyMedium.copyWith(
                            color: context.primaryTextColor,
                          ),
                        ),
                        backgroundColor: value 
                            ? context.successColor 
                            : context.secondaryTextColor,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      AppTheme.errorSnackBar(
                        message: l10n.privacyAnalyticsUpdateFailed,
                      ),
                    );
                  }
                }
              },
            ),
            loading: () => _buildSwitchTile(
              icon: Icons.analytics,
              title: l10n.privacyAnalyticsTitle,
              subtitle: l10n.privacyAnalyticsLoadingSubtitle,
              value: false,
              onChanged: (_) {},
            ),
            error: (_, __) => _buildSwitchTile(
              icon: Icons.analytics,
              title: l10n.privacyAnalyticsTitle,
              subtitle: l10n.privacyAnalyticsSubtitle,
              value: true,
              onChanged: (value) async {
                try {
                  final analyticsService = ref.read(analyticsServiceProvider);
                  await analyticsService.setConsent(value);
                  if (mounted) {
                    ref.invalidate(analyticsConsentProvider);
                  }
                } catch (e) {
                  // Silently fail
                }
              },
            ),
          ),
          const SizedBox(height: 32),

          // Data & Privacy Section
          _buildSectionHeader(l10n.privacySectionDataPrivacy),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.info_outline,
            title: l10n.privacyWhatDataTitle,
            subtitle: l10n.privacyWhatDataSubtitle,
            onTap: () {
              _showDataCollectionInfo();
            },
          ),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: l10n.privacyClearAnalyticsTitle,
            subtitle: l10n.privacyClearAnalyticsSubtitle,
            onTap: () {
              _showClearAnalyticsDialog();
            },
          ),
          const SizedBox(height: 32),

          // Security Settings Section
          _buildSectionHeader(l10n.privacySectionSecurity),
          const SizedBox(height: 16),
          _buildSwitchTile(
            icon: Icons.fingerprint,
            title: l10n.privacyBiometricTitle,
            subtitle: l10n.privacyBiometricSubtitle,
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.security,
            title: l10n.privacyTwoFactorTitle,
            subtitle: l10n.privacyTwoFactorSubtitle,
            value: _twoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.lock,
            title: l10n.privacyChangePasswordTileTitle,
            subtitle: l10n.privacyChangePasswordTileSubtitle,
            onTap: () {
              _showChangePasswordDialog();
            },
          ),
          _buildActionTile(
            icon: Icons.email,
            title: l10n.privacyEmailVerificationTileTitle,
            subtitle: l10n.privacyEmailVerificationTileSubtitle,
            onTap: () {
              _showEmailVerificationDialog();
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final loc = AppLocalizations.of(context)!;
              final profile = ref.watch(currentUserProfileProvider);
              final subtitle = profile.when(
                data: (u) => u.phoneVerifiedAt != null
                    ? loc.privacyPhoneVerified
                    : loc.privacyPhoneAddVerify,
                loading: () => loc.privacyPhoneAddVerify,
                error: (_, __) => loc.privacyPhoneAddVerify,
              );
              return _buildActionTile(
                icon: Icons.phone,
                title: loc.privacyPhoneVerificationTileTitle,
                subtitle: subtitle,
                onTap: () => _showPhoneVerificationDialog(ref),
              );
            },
          ),
          const SizedBox(height: 32),

          // Account Management Section
          _buildSectionHeader(l10n.privacySectionAccountManagement),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.download,
            title: l10n.privacyDownloadDataTitle,
            subtitle: l10n.privacyDownloadDataSubtitle,
            onTap: () {
              _showDownloadDataDialog();
            },
          ),
          _buildActionTile(
            icon: Icons.delete_forever,
            title: l10n.privacyDeleteAccountTitle,
            subtitle: l10n.privacyDeleteAccountSubtitle,
            onTap: () {
              _showDeleteAccountDialog();
            },
            isDestructive: true,
          ),
          const SizedBox(height: 32),

          // Legal Section
          _buildSectionHeader(l10n.privacySectionLegal),
          const SizedBox(height: 16),
          _buildActionTile(
            icon: Icons.description,
            title: l10n.privacyPolicyTileTitle,
            subtitle: l10n.privacyPolicyTileSubtitle,
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          _buildActionTile(
            icon: Icons.gavel,
            title: l10n.privacyTermsTileTitle,
            subtitle: l10n.privacyTermsTileSubtitle,
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
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
        title: Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.bodySmall.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: context.primaryColorTheme,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive 
                ? context.errorColor.withOpacity(0.1)
                : context.primaryColorTheme.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? context.errorColor : context.primaryColorTheme,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: isDestructive ? context.errorColor : context.primaryTextColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.bodySmall.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: context.secondaryTextColor,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Form(
            key: formKey,
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
                  l10n.privacyChangePasswordDialogTitle,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Current Password
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: l10n.privacyCurrentPasswordLabel,
                    hintText: l10n.privacyCurrentPasswordHint,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setModalState(() {
                          obscureCurrentPassword = !obscureCurrentPassword;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.privacyCurrentPasswordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // New Password
                TextFormField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: l10n.privacyNewPasswordLabel,
                    hintText: l10n.privacyNewPasswordHint,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setModalState(() {
                          obscureNewPassword = !obscureNewPassword;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.privacyNewPasswordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.privacyPasswordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: l10n.privacyConfirmPasswordLabel,
                    hintText: l10n.privacyConfirmPasswordHint,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setModalState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.privacyConfirmPasswordRequired;
                    }
                    if (value != newPasswordController.text) {
                      return l10n.privacyPasswordsMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () {
                          Navigator.pop(context);
                          currentPasswordController.dispose();
                          newPasswordController.dispose();
                          confirmPasswordController.dispose();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: context.secondaryTextColor),
                        ),
                        child: Text(
                          l10n.commonCancel,
                          style: context.bodyMedium.copyWith(
                            color: context.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          if (formKey.currentState!.validate()) {
                            setModalState(() {
                              isLoading = true;
                            });

                            try {
                              final userService = ref.read(userServiceProvider);
                              await userService.changePassword(
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.privacyPasswordChangedSuccess,
                                      style: context.bodyMedium.copyWith(
                                        color: context.primaryTextColor,
                                      ),
                                    ),
                                    backgroundColor: context.successColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                final errorMessage = e.toString().replaceFirst('Exception: ', '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      errorMessage.isNotEmpty 
                                          ? errorMessage 
                                          : l10n.privacyPasswordChangeFailed,
                                      style: context.bodyMedium.copyWith(
                                        color: context.primaryTextColor,
                                      ),
                                    ),
                                    backgroundColor: context.errorColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                setModalState(() {
                                  isLoading = false;
                                });
                              }
                              currentPasswordController.dispose();
                              newPasswordController.dispose();
                              confirmPasswordController.dispose();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColorTheme,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: context.primaryTextColor,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                l10n.privacyChangePasswordDialogTitle,
                                style: context.bodyMedium.copyWith(
                                  color: context.primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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

  void _showEmailVerificationDialog() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
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
              l10n.privacyEmailVerificationDialogTitle,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Content
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColorTheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primaryColorTheme.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: context.primaryColorTheme,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.privacyEmailVerificationDialogBody,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: context.secondaryTextColor),
                    ),
                    child: Text(
                      l10n.commonCancel,
                      style: context.bodyMedium.copyWith(
                        color: context.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Send verification email
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.privacyVerificationEmailSent,
                            style: context.bodyMedium.copyWith(
                              color: context.primaryTextColor,
                            ),
                          ),
                          backgroundColor: context.successColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColorTheme,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.privacySendEmail,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Country _rwandaCountry() {
    return Country(
      phoneCode: '250',
      countryCode: 'RW',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Rwanda',
      example: '250123456789',
      displayName: 'Rwanda (RW) [+250]',
      displayNameNoCountryCode: 'Rwanda (RW)',
      e164Key: '250-RW-0',
    );
  }

  String? _localPartFromStoredPhone(String? stored) {
    if (stored == null || stored.isEmpty) return null;
    final d = PhoneValidator.cleanPhoneNumber(stored);
    if (d.length >= 12 && d.startsWith('250')) {
      return d.substring(3);
    }
    if (d.length == 9 && d.startsWith('0')) {
      return d.substring(1);
    }
    if (d.length == 9 && (d.startsWith('7') || d.startsWith('8'))) {
      return d;
    }
    return d;
  }

  void _showPhoneVerificationDialog(WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    final profile = ref.read(currentUserProfileProvider).valueOrNull;
    final local = _localPartFromStoredPhone(profile?.phoneNumber);
    if (local != null) {
      phoneController.text = local;
    }

    var selectedCountry = _rwandaCountry();
    var sending = false;
    var verifying = false;
    var codeSent = false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> sendCode() async {
              final dialogMessenger = ScaffoldMessenger.of(dialogContext);
              final digits = PhoneValidator.cleanPhoneNumber(
                '${selectedCountry.phoneCode}${phoneController.text.trim()}',
              );
              if (digits.length < 9) {
                dialogMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.privacyPhoneInvalid,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    backgroundColor: context.primaryColorTheme,
                  ),
                );
                return;
              }
              setState(() => sending = true);
              try {
                await ref.read(authServiceProvider).requestPhoneVerification(digits);
                if (!dialogContext.mounted) return;
                setState(() {
                  sending = false;
                  codeSent = true;
                });
                dialogMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.privacyPhoneCodeSent,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    backgroundColor: context.successColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                if (dialogContext.mounted) {
                  setState(() => sending = false);
                }
                if (!dialogContext.mounted) return;
                dialogMessenger.showSnackBar(
                  AppTheme.errorSnackBar(
                    message: e.toString().replaceFirst('Exception: ', ''),
                  ),
                );
              }
            }

            Future<void> verifyCode() async {
              final dialogMessenger = ScaffoldMessenger.of(dialogContext);
              final screenMessenger = ScaffoldMessenger.of(this.context);
              final digits = PhoneValidator.cleanPhoneNumber(
                '${selectedCountry.phoneCode}${phoneController.text.trim()}',
              );
              final code = codeController.text.trim();
              if (code.length != 6) {
                dialogMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.privacyPhoneEnterCode,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    backgroundColor: context.primaryColorTheme,
                  ),
                );
                return;
              }
              setState(() => verifying = true);
              try {
                await ref.read(authServiceProvider).verifyPhone(digits, code);
                await ref.read(authServiceProvider).getCurrentUser();
                ref.invalidate(currentUserProfileProvider);
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                screenMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.privacyPhoneVerifiedSuccess,
                      style: this.context.bodyMedium.copyWith(
                        color: this.context.primaryTextColor,
                      ),
                    ),
                    backgroundColor: this.context.successColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                if (dialogContext.mounted) {
                  setState(() => verifying = false);
                }
                if (!dialogContext.mounted) return;
                dialogMessenger.showSnackBar(
                  AppTheme.errorSnackBar(
                    message: e.toString().replaceFirst('Exception: ', ''),
                  ),
                );
              }
            }

            void pickCountry() {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (c) {
                  setState(() => selectedCountry = c);
                },
              );
            }

            return AlertDialog(
              backgroundColor: context.cardColor,
              title: Text(
                l10n.privacyPhoneVerificationTileTitle,
                style: context.titleMedium.copyWith(
                  color: context.primaryTextColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.privacyPhoneVerificationIntro,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        InkWell(
                          onTap: pickCountry,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: context.dividerColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${selectedCountry.phoneCode}',
                              style: context.bodyMedium.copyWith(
                                color: context.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              PhoneInputFormatter(),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: context.bodyMedium.copyWith(
                              color: context.primaryTextColor,
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.privacyPhoneMobileLabel,
                              labelStyle: context.bodySmall.copyWith(
                                color: context.secondaryTextColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (codeSent) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: context.bodyMedium.copyWith(
                          color: context.primaryTextColor,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.privacyPhoneSixDigitCodeLabel,
                          counterText: '',
                          labelStyle: context.bodySmall.copyWith(
                            color: context.secondaryTextColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: sending || verifying
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.commonCancel,
                    style: context.bodyMedium.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ),
                if (!codeSent)
                  TextButton(
                    onPressed: sending ? null : sendCode,
                    child: sending
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.primaryColorTheme,
                            ),
                          )
                        : Text(
                            l10n.privacySendCode,
                            style: context.bodyMedium.copyWith(
                              color: context.primaryColorTheme,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  )
                else
                  TextButton(
                    onPressed: verifying ? null : verifyCode,
                    child: verifying
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.primaryColorTheme,
                            ),
                          )
                        : Text(
                            l10n.privacyVerify,
                            style: context.bodyMedium.copyWith(
                              color: context.primaryColorTheme,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
              ],
            );
          },
        );
      },
    ).then((_) {
      phoneController.dispose();
      codeController.dispose();
    });
  }

  void _showDownloadDataDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          l10n.privacyDownloadDataDialogTitle,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          l10n.privacyDownloadDataDialogBody,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.commonCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Request data download
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.privacyDownloadDataSubmitted,
                    style: context.bodyMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  backgroundColor: context.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              l10n.privacyRequestData,
              style: context.bodyMedium.copyWith(
                color: context.primaryColorTheme,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          l10n.privacyDeleteAccountDialogTitle,
          style: context.titleMedium.copyWith(
            color: context.errorColor,
          ),
        ),
        content: Text(
          l10n.privacyDeleteAccountDialogBody,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.commonCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            child: Text(
              l10n.commonDelete,
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

  void _showDataCollectionInfo() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
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
              l10n.privacyWhatDataCollectSheetTitle,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Data collection info
            _buildDataInfoItem(
              l10n: l10n,
              icon: Icons.person_outline,
              title: l10n.privacyDataProfileTitle,
              description: l10n.privacyDataProfileDescription,
              purpose: l10n.privacyDataProfilePurpose,
            ),
            const SizedBox(height: 16),
            _buildDataInfoItem(
              l10n: l10n,
              icon: Icons.search,
              title: l10n.privacyDataSearchTitle,
              description: l10n.privacyDataSearchDescription,
              purpose: l10n.privacyDataSearchPurpose,
            ),
            const SizedBox(height: 16),
            _buildDataInfoItem(
              l10n: l10n,
              icon: Icons.visibility,
              title: l10n.privacyDataViewsTitle,
              description: l10n.privacyDataViewsDescription,
              purpose: l10n.privacyDataViewsPurpose,
            ),
            const SizedBox(height: 16),
            _buildDataInfoItem(
              l10n: l10n,
              icon: Icons.event,
              title: l10n.privacyDataUsageTitle,
              description: l10n.privacyDataUsageDescription,
              purpose: l10n.privacyDataUsagePurpose,
            ),
            const SizedBox(height: 24),
            
            // Privacy note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColorTheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: context.primaryColorTheme,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.privacyDataAnonymizedFootnote,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColorTheme,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.privacyGotIt,
                  style: context.bodyMedium.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDataInfoItem({
    required AppLocalizations l10n,
    required IconData icon,
    required String title,
    required String description,
    required String purpose,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.dividerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: context.primaryColorTheme,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.bodySmall.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.privacyPurposeLine(purpose),
                  style: context.bodySmall.copyWith(
                    color: context.primaryColorTheme,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAnalyticsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          l10n.privacyClearAnalyticsDialogTitle,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        content: Text(
          l10n.privacyClearAnalyticsDialogBody,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.commonCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final analyticsService = ref.read(analyticsServiceProvider);
                await analyticsService.clearQueue();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.privacyClearAnalyticsSuccess,
                        style: context.bodyMedium.copyWith(
                          color: context.primaryTextColor,
                        ),
                      ),
                      backgroundColor: context.successColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppTheme.errorSnackBar(
                      message: l10n.privacyClearAnalyticsFailed,
                    ),
                  );
                }
              }
            },
            child: Text(
              l10n.privacyClearData,
              style: context.bodyMedium.copyWith(
                color: context.primaryColorTheme,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          l10n.privacyFinalConfirmationTitle,
          style: context.titleMedium.copyWith(
            color: context.errorColor,
          ),
        ),
        content: Text(
          l10n.privacyFinalConfirmationBody,
          style: context.bodyMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.commonCancel,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.privacyAccountDeletionComingSoon,
                    style: context.bodyMedium.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  backgroundColor: context.errorColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              l10n.privacyDeleteForever,
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
}
