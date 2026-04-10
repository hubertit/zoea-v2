import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_update_service.dart';

/// Latest result from [GET /app/update-check], including [AppUpdateCheckResult.policyUpdatedAt].
final appUpdateCheckProvider = FutureProvider<AppUpdateCheckResult?>((ref) {
  return AppUpdateService().checkForUpdate();
});
