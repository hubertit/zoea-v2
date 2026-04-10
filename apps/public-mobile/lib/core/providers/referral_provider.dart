import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/referral_service.dart';
import 'auth_provider.dart';

final referralServiceProvider = Provider<ReferralService>((ref) {
  return ReferralService();
});

final referralProgramRuleProvider = FutureProvider<ReferralProgramRule?>((ref) async {
  final svc = ref.watch(referralServiceProvider);
  return svc.fetchActiveProgram();
});

final referralSummaryProvider = FutureProvider.autoDispose<ReferralSummary?>((ref) async {
  final user = ref.watch(authProvider).valueOrNull;
  if (user == null) return null;
  final svc = ref.read(referralServiceProvider);
  return svc.fetchMySummary();
});
