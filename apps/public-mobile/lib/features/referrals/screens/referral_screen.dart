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

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  static final _pointsFmt = NumberFormat('#,###');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(referralProgramRuleProvider);
    final summaryAsync = ref.watch(referralSummaryProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Refer & Earn',
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
            _buildHeroSection(context),
            const SizedBox(height: 32),
            ..._referralCodeBlocks(context, summaryAsync),
            _buildHowItWorksSection(context),
            const SizedBox(height: 32),
            _buildRewardsSection(context, programAsync),
            const SizedBox(height: 32),
            _buildReferralStats(context, summaryAsync),
          ],
        ),
      ),
    );
  }

  List<Widget> _referralCodeBlocks(
    BuildContext context,
    AsyncValue<ReferralSummary?> async,
  ) {
    return async.when(
      data: (summary) {
        if (summary == null) {
          return [
            _buildSignInForCodeCard(context),
            const SizedBox(height: 32),
          ];
        }
        return [
          _buildReferralCodeSection(context, summary),
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
            'Could not load your referral code. Pull to retry or sign in again.',
            style: context.bodyMedium.copyWith(color: context.errorColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInForCodeCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referral Code',
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
                'Sign in to see your personal code and track points.',
                style: context.bodyMedium.copyWith(color: context.secondaryTextColor),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push('/login'),
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
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
            'Invite Friends & Earn Rewards',
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Share your referral code and earn points when friends join Zoea',
            style: context.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection(BuildContext context, ReferralSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referral Code',
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
                      'Share this code with your friends',
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
                        'Referral code copied',
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
              const message =
                  'Join me on Zoea Africa and discover amazing places in Rwanda!';
              await SharePlus.instance.share(
                ShareParams(text: '$message\n${summary.shareUrl}'),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Referral Code'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How it Works',
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildStepCard(
          context,
          title: 'Share Your Code',
          description:
              'Send your referral code to friends via social media, email, or text',
          icon: Icons.share,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          context,
          title: 'Friend Signs Up',
          description: 'Your friend creates their Zoea account using your code',
          icon: Icons.person_add,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          context,
          title: 'Earn Points',
          description:
              'You both get points when they sign up (shown as pending until credited)',
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
    AsyncValue<ReferralProgramRule?> programAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rewards',
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
                    title: 'For You',
                    points: you,
                    description: 'When friend joins',
                    color: context.primaryColorTheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRewardCard(
                    context,
                    title: 'For Friend',
                    points: friend,
                    description: 'Welcome bonus',
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
            'Could not load reward amounts.',
            style: context.bodySmall.copyWith(color: context.secondaryTextColor),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(
    BuildContext context, {
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
            points > 0 ? '${_pointsFmt.format(points)} pts' : '—',
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
    AsyncValue<ReferralSummary?> summaryAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referrals',
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
                    label: 'Total Referrals',
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
                    label: 'Points earned',
                    value: '${_pointsFmt.format(s.totalPointsEarned)} pts',
                    icon: Icons.workspace_premium,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: context.grey300,
                  ),
                  _buildStatItem(
                    context,
                    label: 'Pending',
                    value: '${_pointsFmt.format(s.pendingPoints)} pts',
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
