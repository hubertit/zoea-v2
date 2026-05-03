import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import '../theme/text_theme_extensions.dart';

class AuthPromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? returnPath;
  final IconData? icon;

  const AuthPromptDialog({
    super.key,
    required this.title,
    required this.message,
    this.returnPath,
    this.icon,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? returnPath,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AuthPromptDialog(
        title: title,
        message: message,
        returnPath: returnPath,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Compute a readable text color for the Sign In button background.
    final primary = context.primaryColorTheme;
    final isPrimaryDark =
        ThemeData.estimateBrightnessForColor(primary) == Brightness.dark;
    final signInTextColor = isPrimaryDark ? Colors.white : Colors.black;

    return Dialog(
      backgroundColor: context.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: context.primaryColorTheme.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: context.primaryColorTheme,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
            ],
            Text(
              title,
              style: context.titleLarge.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              message,
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                    ),
                    child: Text(
                      l10n.authCancel,
                      style: context.bodyMedium.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      if (returnPath != null) {
                        context.push('/login?returnPath=${Uri.encodeComponent(returnPath!)}');
                      } else {
                        context.push('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColorTheme,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      ),
                      // Ensure readable text across light/dark themes.
                      foregroundColor: signInTextColor,
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                    ),
                    child: Text(
                      l10n.signIn,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: signInTextColor, // Avoid inheriting a conflicting text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
