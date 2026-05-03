import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/app_update_check_provider.dart';
import '../../../core/providers/package_info_provider.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/utils/app_build_metadata.dart';
import '../../../l10n/app_localizations.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  static const String _contactEmail = 'contact@zoea.africa';
  static const String _contactPhoneTel = '+250796889900'; // tel: URI (no spaces)
  static const String _websiteUrl = 'https://www.zoea.africa';

  Future<void> _tryLaunchUri(Uri uri) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.commonLinkOpenFailed),
            backgroundColor: context.primaryColorTheme,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.commonLinkOpenFailed),
            backgroundColor: context.primaryColorTheme,
          ),
        );
      }
    }
  }

  void _launchEmail() => _tryLaunchUri(Uri.parse('mailto:$_contactEmail'));

  void _launchPhone() => _tryLaunchUri(Uri(scheme: 'tel', path: _contactPhoneTel));

  void _launchWebsite(AppLocalizations l10n) {
    context.push(
      '/webview?url=${Uri.encodeComponent(_websiteUrl)}'
      '&title=${Uri.encodeComponent(l10n.aboutWebsiteWebviewTitle)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = ref.watch(packageInfoProvider);
    final appUpdateCheck = ref.watch(appUpdateCheckProvider);
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final lastUpdated = lastUpdatedDisplayLabel(
      policyUpdatedAtIso: appUpdateCheck.valueOrNull?.policyUpdatedAt,
      fallback: l10n.commonNotSpecified,
      intlLocale: locale.toLanguageTag(),
    );

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.profileAboutMenuTitle,
          style: context.titleLarge.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.chevron_left, size: 32),
          style: IconButton.styleFrom(
            foregroundColor: context.primaryTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Info
            _buildAppHeader(l10n, packageInfo),
            const SizedBox(height: 32),
            
            // App Information
            _buildAppInformation(context, l10n, packageInfo, lastUpdated),
            const SizedBox(height: 24),
            
            // Legal
            _buildLegal(l10n),
            const SizedBox(height: 24),
            
            // Social Links
            _buildSocialLinks(l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(AppLocalizations l10n, AsyncValue<PackageInfo> packageInfo) {
    return Center(
      child: Column(
        children: [
          // App Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: context.primaryColorTheme,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColorTheme.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.explore,
              size: 50,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // App Name
          Text(
            l10n.appTitle,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          
          // Tagline
          Text(
            l10n.aboutBrandTagline,
            style: context.bodyLarge.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Version
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.primaryColorTheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              packageInfo.maybeWhen(
                data: (p) => l10n.aboutVersionLine(p.version),
                orElse: () => l10n.aboutVersionLoading,
              ),
              style: context.bodySmall.copyWith(
                color: context.primaryColorTheme,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInformation(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<PackageInfo> packageInfo,
    String lastUpdated,
  ) {
    final locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aboutAppInfoSectionTitle,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: packageInfo.when(
            data: (p) => Column(
              children: [
                _buildInfoItem(
                  icon: Icons.info_outline,
                  title: l10n.aboutAppVersionLabel,
                  value: p.version,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.build_outlined,
                  title: l10n.aboutBuildNumberLabel,
                  value: p.buildNumber,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.update_outlined,
                  title: l10n.aboutLastUpdatedLabel,
                  value: lastUpdated,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.phone_android_outlined,
                  title: l10n.aboutPlatformLabel,
                  value: describeRuntimePlatform(),
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.language_outlined,
                  title: l10n.aboutLanguageLabel,
                  value: localeDisplayLabel(locale),
                ),
              ],
            ),
            loading: () => Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.primaryColorTheme,
                  ),
                ),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.helpPackageInfoError,
                style: context.bodyMedium.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.primaryColorTheme,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: context.primaryTextColor,
              ),
            ),
          ),
          Text(
            value,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: context.dividerColor,
    );
  }

  Widget _buildLegal(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aboutLegalSectionTitle,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLegalItem(
                icon: Icons.privacy_tip_outlined,
                title: l10n.aboutPrivacyPolicyTitle,
                subtitle: l10n.aboutPrivacyPolicySubtitle,
                onTap: () => _showLegalDialog(l10n.aboutPrivacyPolicyTitle, _getPrivacyPolicy()),
              ),
              _buildDivider(),
              _buildLegalItem(
                icon: Icons.description_outlined,
                title: l10n.aboutTermsOfServiceTitle,
                subtitle: l10n.aboutTermsOfServiceSubtitle,
                onTap: () => _showLegalDialog(l10n.aboutTermsOfServiceTitle, _getTermsOfService()),
              ),
              _buildDivider(),
              _buildLegalItem(
                icon: Icons.copyright_outlined,
                title: l10n.aboutCopyrightTitle,
                subtitle: l10n.aboutCopyrightCardSubtitle(DateTime.now().year),
                onTap: () => _showLegalDialog(l10n.aboutCopyrightTitle, _getCopyright()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
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
                      fontWeight: FontWeight.w500,
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

  Widget _buildSocialLinks(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aboutConnectSectionTitle,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSocialItem(
                icon: Icons.email_outlined,
                title: l10n.aboutContactEmailTitle,
                subtitle: _contactEmail,
                onTap: _launchEmail,
              ),
              _buildDivider(),
              _buildSocialItem(
                icon: Icons.phone_outlined,
                title: l10n.aboutContactPhoneTitle,
                subtitle: l10n.aboutContactPhoneDisplay,
                onTap: _launchPhone,
              ),
              _buildDivider(),
              _buildSocialItem(
                icon: Icons.language_outlined,
                title: l10n.aboutContactWebsiteTitle,
                subtitle: l10n.aboutContactWebsiteDisplay,
                onTap: () => _launchWebsite(l10n),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
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
                      fontWeight: FontWeight.w500,
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

  void _showLegalDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: context.bodyMedium.copyWith(
              color: context.primaryTextColor,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.aboutCloseButton,
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

  String _getPrivacyPolicy() {
    return '''
Privacy Policy

Last updated: December 2024

1. Information We Collect
We collect information you provide directly to us, such as when you create an account, make a booking, or contact us for support.

2. How We Use Your Information
We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.

3. Information Sharing
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.

4. Data Security
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. Your Rights
You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.

6. Contact Us
If you have any questions about this Privacy Policy, please contact us at privacy@zoea.africa.
''';
  }

  String _getTermsOfService() {
    return '''
Terms of Service

Last updated: December 2024

1. Acceptance of Terms
By using our app, you agree to be bound by these Terms of Service.

2. Use of the App
You may use our app for lawful purposes only. You agree not to use the app in any way that could damage, disable, or impair the app.

3. User Accounts
You are responsible for maintaining the confidentiality of your account and password.

4. Bookings and Payments
All bookings are subject to availability. Payment terms are as specified at the time of booking.

5. Cancellation Policy
Cancellation policies vary by event and are specified at the time of booking.

6. Limitation of Liability
To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, or consequential damages.

7. Changes to Terms
We reserve the right to modify these terms at any time. We will notify users of any material changes.

8. Contact Information
For questions about these Terms of Service, contact us at legal@zoea.africa.
''';
  }

  String _getCopyright() {
    final year = DateTime.now().year;
    return '''
Copyright Notice

© $year Zoea Africa. All rights reserved.

This app and its contents are protected by copyright and other intellectual property laws.

You may not:
- Copy, modify, or distribute the app without permission
- Reverse engineer or attempt to extract source code
- Use the app for commercial purposes without authorization

For licensing inquiries, contact us at legal@zoea.africa.
''';
  }
}
