import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/providers/referral_provider.dart';
import '../../../core/services/referral_service.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../l10n/app_localizations.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  static final _pointsFmt = NumberFormat('#,###');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final programAsync = ref.watch(referralProgramRuleProvider);
    final summaryAsync = ref.watch(referralSummaryProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.exploreGiftReferTitle,
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 32, color: context.primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
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
            _buildHeroSection(context, l10n),
            const SizedBox(height: 32),
            ..._referralCodeBlocks(context, l10n, summaryAsync),
            _buildHowItWorksSection(context, l10n),
            const SizedBox(height: 32),
            _buildRewardsSection(context, l10n, programAsync),
            const SizedBox(height: 32),
            _buildReferralStats(context, l10n, summaryAsync),
          ],
        ),
      ),
    );
  }

  List<Widget> _referralCodeBlocks(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<ReferralSummary?> async,
  ) {
    return async.when(
      data: (summary) {
        if (summary == null) {
          return [
            _buildSignInForCodeCard(context, l10n),
            const SizedBox(height: 32),
          ];
        }
        return [
          _buildReferralCodeSection(context, l10n, summary),
          const SizedBox(height: 32),
        ];
      },
      loading: () => [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(height: 32),
      ],
      error: (_, __) => [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            l10n.referralErrorLoadCode,
            style: context.bodyMedium.copyWith(color: context.errorColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInForCodeCard(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralYourCodeSectionTitle,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.referralSignInForCodeBody,
                style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push('/login'),
                child: Text(l10n.commonSignIn),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColorTheme.withOpacity(0.1),
            context.primaryColorTheme.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.primaryColorTheme.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.card_giftcard,
            size: 48,
            color: context.primaryColorTheme,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.referralInviteHeroTitle,
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.referralInviteHeroSubtitle,
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection(
    BuildContext context,
    AppLocalizations l10n,
    ReferralSummary summary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralYourCodeSectionTitle,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.grey200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.code,
                      style: context.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.referralShareCodeHint,
                      style: context.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: summary.code));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.referralCodeCopied,
                        style: context.bodyMedium.copyWith(
                          color: context.primaryTextColor,
                        ),
                      ),
                      backgroundColor: context.cardColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                style: IconButton.styleFrom(
                  backgroundColor: context.primaryFillColor,
                  foregroundColor: context.onPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final message = l10n.referralShareInviteMessage;
              await SharePlus.instance.share(
                ShareParams(text: '$message\n${summary.shareUrl}'),
              );
            },
            icon: const Icon(Icons.share),
            label: Text(l10n.commonShareReferralCode),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralHowItWorksTitle,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildStepCard(
          context,
          title: l10n.referralStepShareTitle,
          description: l10n.referralStepShareBody,
          icon: Icons.share,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          context,
          title: l10n.referralStepFriendTitle,
          description: l10n.referralStepFriendBody,
          icon: Icons.person_add,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          context,
          title: l10n.referralStepEarnTitle,
          description: l10n.referralStepEarnBody,
          icon: Icons.card_giftcard,
        ),
      ],
    );
  }

  Widget _buildStepCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primaryFillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.onPrimaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<ReferralProgramRule?> programAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralRewardsTitle,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        programAsync.when(
          data: (rule) {
            final you = rule?.referrerPoints ?? 0;
            final friend = rule?.refereePoints ?? 0;
            return Row(
              children: [
                Expanded(
                  child: _buildRewardCard(
                    context,
                    l10n,
                    title: l10n.referralRewardForYouTitle,
                    points: you,
                    description: l10n.referralRewardForYouSubtitle,
                    color: context.primaryColorTheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRewardCard(
                    context,
                    l10n,
                    title: l10n.referralRewardForFriendTitle,
                    points: friend,
                    description: l10n.referralRewardForFriendSubtitle,
                    color: context.successColor,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => Text(
            l10n.referralRewardsLoadError,
            style: context.bodySmall.copyWith(color: context.secondaryTextColor),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(
    BuildContext context,
    AppLocalizations l10n, {
    required String title,
    required int points,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            points > 0
                ? l10n.referralPointsValue(_pointsFmt.format(points))
                : '—',
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.bodySmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralStats(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<ReferralSummary?> summaryAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralStatsTitle,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        summaryAsync.when(
          data: (summary) {
            if (summary == null) {
              return const SizedBox.shrink();
            }
            final s = summary.stats;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.grey200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    label: l10n.referralStatTotalReferrals,
                    value: '${s.totalReferrals}',
                    icon: Icons.people,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: context.grey300,
                  ),
                  _buildStatItem(
                    context,
                    label: l10n.referralStatPointsEarned,
                    value: l10n.referralPointsValue(_pointsFmt.format(s.totalPointsEarned)),
                    icon: Icons.workspace_premium,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: context.grey300,
                  ),
                  _buildStatItem(
                    context,
                    label: l10n.referralStatPending,
                    value: l10n.referralPointsValue(_pointsFmt.format(s.pendingPoints)),
                    icon: Icons.schedule,
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: context.primaryColorTheme,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: context.primaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.bodySmall.copyWith(
            color: context.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
