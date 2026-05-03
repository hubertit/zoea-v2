import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/providers/app_update_check_provider.dart';
import '../../../core/providers/package_info_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/utils/app_build_metadata.dart';

class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> {
  static const String _supportEmail = 'support@zoea.africa';
  static const String _supportPhoneTel = '+250796889900';

  final TextEditingController _searchController = TextEditingController();

  Future<void> _tryLaunchUri(Uri uri) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.helpLinkOpenFailed),
            backgroundColor: context.primaryColorTheme,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.helpLinkOpenFailed),
            backgroundColor: context.primaryColorTheme,
          ),
        );
      }
    }
  }

  void _launchSupportEmail() =>
      _tryLaunchUri(Uri.parse('mailto:$_supportEmail'));

  void _launchSupportPhone() =>
      _tryLaunchUri(Uri(scheme: 'tel', path: _supportPhoneTel));

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          l10n.profileHelpTitle,
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
            // Search Bar
            _buildSearchBar(l10n),
            const SizedBox(height: 24),
            
            // Quick Help
            _buildQuickHelp(l10n),
            const SizedBox(height: 24),
            
            // Popular Topics
            _buildPopularTopics(l10n),
            const SizedBox(height: 24),
            
            // Contact Support
            _buildContactSupport(l10n),
            const SizedBox(height: 24),
            
            // FAQ Categories
            _buildFAQCategories(l10n),
            const SizedBox(height: 24),
            
            // App Information
            _buildAppInformation(packageInfo, lastUpdated, l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode ? context.dividerColor.withOpacity(0.3) : context.dividerColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.helpSearchHint,
          hintStyle: context.bodyMedium.copyWith(
            color: context.secondaryTextColor,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.secondaryTextColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.clear,
                    color: context.secondaryTextColor,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: context.dividerColor,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildQuickHelp(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpQuickHelp,
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
                color: context.isDarkMode ? context.dividerColor.withOpacity(0.3) : context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildQuickHelpItem(
                icon: Icons.account_circle_outlined,
                title: l10n.helpQuickAccountTitle,
                subtitle: l10n.helpQuickAccountSubtitle,
                onTap: () => _showHelpDialog(l10n, l10n.helpQuickAccountTitle, l10n.helpArticleAccount),
              ),
              _buildDivider(),
              _buildQuickHelpItem(
                icon: Icons.payment_outlined,
                title: l10n.helpQuickPaymentTitle,
                subtitle: l10n.helpQuickPaymentSubtitle,
                onTap: () => _showHelpDialog(l10n, l10n.helpQuickPaymentTitle, l10n.helpArticlePayment),
              ),
              _buildDivider(),
              _buildQuickHelpItem(
                icon: Icons.event_outlined,
                title: l10n.helpQuickEventsTitle,
                subtitle: l10n.helpQuickEventsSubtitle,
                onTap: () => _showHelpDialog(l10n, l10n.helpQuickEventsTitle, l10n.helpArticleBooking),
              ),
              _buildDivider(),
              _buildQuickHelpItem(
                icon: Icons.place_outlined,
                title: l10n.helpQuickPlacesTitle,
                subtitle: l10n.helpQuickPlacesSubtitle,
                onTap: () => _showHelpDialog(l10n, l10n.helpQuickPlacesTitle, l10n.helpArticlePlaces),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickHelpItem({
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

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: context.dividerColor,
    );
  }

  Widget _buildPopularTopics(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpPopularTopics,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTopicChip(l10n.helpTopicBookEvents),
            _buildTopicChip(l10n.helpTopicPaymentMethods),
            _buildTopicChip(l10n.helpTopicCancelBooking),
            _buildTopicChip(l10n.helpTopicUpdateProfile),
            _buildTopicChip(l10n.helpTopicContactSupport),
            _buildTopicChip(l10n.helpTopicAppFeatures),
          ],
        ),
      ],
    );
  }

  Widget _buildTopicChip(String label) {
    return InkWell(
      onTap: () {
        // TODO: Search for topic
        _searchController.text = label;
        setState(() {});
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.primaryColorTheme.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.primaryColorTheme.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: context.bodySmall.copyWith(
            color: context.primaryColorTheme,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupport(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpContactSupport,
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
                color: context.isDarkMode ? context.dividerColor.withOpacity(0.3) : context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildContactItem(
                icon: Icons.chat_outlined,
                title: l10n.helpLiveChatTitle,
                subtitle: l10n.helpLiveChatSubtitle,
                onTap: () => _showContactDialog(l10n, l10n.helpLiveChatTitle, l10n.helpLiveChatBody),
              ),
              _buildDivider(),
              _buildContactItem(
                icon: Icons.email_outlined,
                title: l10n.helpEmailSupportTitle,
                subtitle: _supportEmail,
                onTap: _launchSupportEmail,
              ),
              _buildDivider(),
              _buildContactItem(
                icon: Icons.phone_outlined,
                title: l10n.helpPhoneSupportTitle,
                subtitle: l10n.helpPhoneSupportSubtitle,
                onTap: _launchSupportPhone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: context.successColor,
                size: 20,
              ),
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

  Widget _buildFAQCategories(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpFaqCategoriesTitle,
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
                color: context.isDarkMode ? context.dividerColor.withOpacity(0.3) : context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFAQItem(
                title: l10n.helpFaqGettingStarted,
                count: 5,
                onTap: () => _showFAQDialog(l10n, l10n.helpFaqGettingStarted, _gettingStartedFaqs(l10n)),
              ),
              _buildDivider(),
              _buildFAQItem(
                title: l10n.helpFaqAccountProfile,
                count: 8,
                onTap: () => _showFAQDialog(l10n, l10n.helpFaqAccountProfile, _accountFaqs(l10n)),
              ),
              _buildDivider(),
              _buildFAQItem(
                title: l10n.helpFaqBookingsEvents,
                count: 12,
                onTap: () => _showFAQDialog(l10n, l10n.helpFaqBookingsEvents, _bookingFaqs(l10n)),
              ),
              _buildDivider(),
              _buildFAQItem(
                title: l10n.helpFaqPaymentRefunds,
                count: 6,
                onTap: () => _showFAQDialog(l10n, l10n.helpFaqPaymentRefunds, _paymentFaqs(l10n)),
              ),
              _buildDivider(),
              _buildFAQItem(
                title: l10n.helpFaqTechnicalIssues,
                count: 4,
                onTap: () => _showFAQDialog(l10n, l10n.helpFaqTechnicalIssues, _technicalFaqs(l10n)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColorTheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: context.primaryColorTheme,
                size: 20,
              ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.primaryColorTheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: context.labelSmall.copyWith(
                  color: context.primaryColorTheme,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
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

  Widget _buildAppInformation(
    AsyncValue<PackageInfo> packageInfo,
    String lastUpdated,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileAppInformation,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode ? context.dividerColor.withOpacity(0.3) : context.dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: packageInfo.when(
            data: (p) => Column(
              children: [
                _buildInfoRow(l10n.helpAppVersionLabel, p.version),
                _buildInfoRow(l10n.helpBuildNumberLabel, p.buildNumber),
                _buildInfoRow(l10n.helpLastUpdatedLabel, lastUpdated),
                _buildInfoRow(l10n.helpPlatformLabel, describeRuntimePlatform()),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => Text(
              l10n.helpPackageInfoError,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          Text(
            value,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(AppLocalizations l10n, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.backgroundColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
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
              title,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: context.bodyMedium.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.commonClose,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(AppLocalizations l10n, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.backgroundColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
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
              title,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Content
            Text(
              content,
              style: context.bodyMedium.copyWith(
                color: context.primaryTextColor,
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
                      l10n.commonClose,
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
                      // TODO: Implement contact action
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.helpFeatureComingSoon(title),
                          style: context.bodyMedium.copyWith(
                            color: context.primaryTextColor,
                          ),
                        ),
                        backgroundColor: context.primaryColorTheme,
                      ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.helpContactButton,
                      style: const TextStyle(
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

  void _showFAQDialog(AppLocalizations l10n, String title, List<Map<String, String>> faqs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.backgroundColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
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
              title,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // FAQ List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.dividerColor),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        faq['question']!,
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.primaryTextColor,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            faq['answer']!,
                            style: context.bodyMedium.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.commonClose,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _gettingStartedFaqs(AppLocalizations l10n) => [
        {'question': l10n.helpFaqGs1Q, 'answer': l10n.helpFaqGs1A},
        {'question': l10n.helpFaqGs2Q, 'answer': l10n.helpFaqGs2A},
        {'question': l10n.helpFaqGs3Q, 'answer': l10n.helpFaqGs3A},
        {'question': l10n.helpFaqGs4Q, 'answer': l10n.helpFaqGs4A},
        {'question': l10n.helpFaqGs5Q, 'answer': l10n.helpFaqGs5A},
      ];

  List<Map<String, String>> _accountFaqs(AppLocalizations l10n) => [
        {'question': l10n.helpFaqAc1Q, 'answer': l10n.helpFaqAc1A},
        {'question': l10n.helpFaqAc2Q, 'answer': l10n.helpFaqAc2A},
        {'question': l10n.helpFaqAc3Q, 'answer': l10n.helpFaqAc3A},
        {'question': l10n.helpFaqAc4Q, 'answer': l10n.helpFaqAc4A},
        {'question': l10n.helpFaqAc5Q, 'answer': l10n.helpFaqAc5A},
        {'question': l10n.helpFaqAc6Q, 'answer': l10n.helpFaqAc6A},
        {'question': l10n.helpFaqAc7Q, 'answer': l10n.helpFaqAc7A},
        {'question': l10n.helpFaqAc8Q, 'answer': l10n.helpFaqAc8A},
      ];

  List<Map<String, String>> _bookingFaqs(AppLocalizations l10n) => [
        {'question': l10n.helpFaqBk1Q, 'answer': l10n.helpFaqBk1A},
        {'question': l10n.helpFaqBk2Q, 'answer': l10n.helpFaqBk2A},
        {'question': l10n.helpFaqBk3Q, 'answer': l10n.helpFaqBk3A},
        {'question': l10n.helpFaqBk4Q, 'answer': l10n.helpFaqBk4A},
        {'question': l10n.helpFaqBk5Q, 'answer': l10n.helpFaqBk5A},
        {'question': l10n.helpFaqBk6Q, 'answer': l10n.helpFaqBk6A},
        {'question': l10n.helpFaqBk7Q, 'answer': l10n.helpFaqBk7A},
        {'question': l10n.helpFaqBk8Q, 'answer': l10n.helpFaqBk8A},
        {'question': l10n.helpFaqBk9Q, 'answer': l10n.helpFaqBk9A},
        {'question': l10n.helpFaqBk10Q, 'answer': l10n.helpFaqBk10A},
        {'question': l10n.helpFaqBk11Q, 'answer': l10n.helpFaqBk11A},
        {'question': l10n.helpFaqBk12Q, 'answer': l10n.helpFaqBk12A},
      ];

  List<Map<String, String>> _paymentFaqs(AppLocalizations l10n) => [
        {'question': l10n.helpFaqPy1Q, 'answer': l10n.helpFaqPy1A},
        {'question': l10n.helpFaqPy2Q, 'answer': l10n.helpFaqPy2A},
        {'question': l10n.helpFaqPy3Q, 'answer': l10n.helpFaqPy3A},
        {'question': l10n.helpFaqPy4Q, 'answer': l10n.helpFaqPy4A},
        {'question': l10n.helpFaqPy5Q, 'answer': l10n.helpFaqPy5A},
        {'question': l10n.helpFaqPy6Q, 'answer': l10n.helpFaqPy6A},
      ];

  List<Map<String, String>> _technicalFaqs(AppLocalizations l10n) => [
        {'question': l10n.helpFaqTx1Q, 'answer': l10n.helpFaqTx1A},
        {'question': l10n.helpFaqTx2Q, 'answer': l10n.helpFaqTx2A},
        {'question': l10n.helpFaqTx3Q, 'answer': l10n.helpFaqTx3A},
        {'question': l10n.helpFaqTx4Q, 'answer': l10n.helpFaqTx4A},
      ];
}
