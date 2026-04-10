import '../config/app_config.dart';

class ReferralProgramRule {
  const ReferralProgramRule({
    required this.id,
    required this.name,
    required this.referrerPoints,
    required this.refereePoints,
  });

  final String id;
  final String name;
  final int referrerPoints;
  final int refereePoints;

  static ReferralProgramRule? fromJsonMap(Map<String, dynamic>? json) {
    if (json == null) return null;
    return ReferralProgramRule(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      referrerPoints: (json['referrerPoints'] as num?)?.toInt() ?? 0,
      refereePoints: (json['refereePoints'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReferralStats {
  const ReferralStats({
    required this.totalReferrals,
    required this.successfulReferrals,
    required this.totalPointsEarned,
    required this.pendingPoints,
  });

  final int totalReferrals;
  final int successfulReferrals;
  final int totalPointsEarned;
  final int pendingPoints;

  static ReferralStats fromJson(Map<String, dynamic> json) {
    return ReferralStats(
      totalReferrals: (json['totalReferrals'] as num?)?.toInt() ?? 0,
      successfulReferrals: (json['successfulReferrals'] as num?)?.toInt() ?? 0,
      totalPointsEarned: (json['totalPointsEarned'] as num?)?.toInt() ?? 0,
      pendingPoints: (json['pendingPoints'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReferralSummary {
  const ReferralSummary({
    required this.code,
    required this.shareUrl,
    required this.stats,
    this.program,
  });

  final String code;
  final String shareUrl;
  final ReferralStats stats;
  final ReferralProgramRule? program;

  static ReferralSummary fromJson(Map<String, dynamic> json) {
    return ReferralSummary(
      code: json['code']?.toString() ?? '',
      shareUrl: json['shareUrl']?.toString() ?? '',
      stats: ReferralStats.fromJson(
        Map<String, dynamic>.from(json['stats'] as Map? ?? {}),
      ),
      program: ReferralProgramRule.fromJsonMap(
        json['program'] as Map<String, dynamic>?,
      ),
    );
  }
}

class ReferralService {
  Future<ReferralProgramRule?> fetchActiveProgram() async {
    final dio = AppConfig.dioInstance();
    final response = await dio.get<Map<String, dynamic>>(
      '${AppConfig.referralsEndpoint}/program',
    );
    final data = response.data;
    if (data == null) return null;
    return ReferralProgramRule.fromJsonMap(
      data['rule'] as Map<String, dynamic>?,
    );
  }

  Future<ReferralSummary> fetchMySummary() async {
    final dio = await AppConfig.authenticatedDioInstance();
    final response = await dio.get<Map<String, dynamic>>(
      '${AppConfig.referralsEndpoint}/me',
    );
    final data = response.data;
    if (data == null) {
      throw Exception('Empty referral summary response');
    }
    return ReferralSummary.fromJson(data);
  }
}
