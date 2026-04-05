import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_update_service.dart';
import '../theme/app_theme.dart';

const _kSnoozeUntilMs = 'zoea_app_update_snooze_until_ms';
const _kSnoozeFingerprint = 'zoea_app_update_snooze_fingerprint';

/// Runs update policy check and shows optional or mandatory UI over [child].
class AppUpdateLayer extends StatefulWidget {
  const AppUpdateLayer({super.key, required this.child});

  final Widget? child;

  @override
  State<AppUpdateLayer> createState() => _AppUpdateLayerState();
}

class _AppUpdateLayerState extends State<AppUpdateLayer> with WidgetsBindingObserver {
  final AppUpdateService _service = AppUpdateService();
  bool _mandatoryVisible = false;
  AppUpdateCheckResult? _mandatoryResult;
  bool _optionalInFlight = false;
  DateTime? _lastCheckAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check(force: true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _check(force: false);
    }
  }

  Future<void> _check({required bool force}) async {
    if (!mounted) return;
    if (_mandatoryVisible) return;

    final now = DateTime.now();
    if (!force && _lastCheckAt != null && now.difference(_lastCheckAt!) < const Duration(hours: 4)) {
      return;
    }
    _lastCheckAt = now;

    final result = await _service.checkForUpdate();
    if (!mounted || result == null) return;

    if (!result.updateRequired) {
      return;
    }

    if (result.mode == 'mandatory') {
      setState(() {
        _mandatoryResult = result;
        _mandatoryVisible = true;
      });
      return;
    }

    if (result.mode == 'optional') {
      await _maybeShowOptional(result);
    }
  }

  Future<bool> _isSnoozed(AppUpdateCheckResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final fp = prefs.getString(_kSnoozeFingerprint);
    final until = prefs.getInt(_kSnoozeUntilMs) ?? 0;
    if (fp == null || fp != result.policyFingerprint) return false;
    return DateTime.now().millisecondsSinceEpoch < until;
  }

  Future<void> _snooze(AppUpdateCheckResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final days = result.dismissForDays.clamp(1, 365);
    final until = DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch;
    await prefs.setInt(_kSnoozeUntilMs, until);
    await prefs.setString(_kSnoozeFingerprint, result.policyFingerprint);
  }

  Future<void> _maybeShowOptional(AppUpdateCheckResult result) async {
    if (_optionalInFlight || !mounted) return;
    if (await _isSnoozed(result)) return;

    _optionalInFlight = true;
    try {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (ctx) {
          return Material(
            type: MaterialType.transparency,
            child: _OptionalUpdateDialog(
              result: result,
              onUpdate: () async {
                Navigator.of(ctx).pop();
                await _openStore(result.storeUrl);
              },
              onLater: () {
                Navigator.of(ctx).pop();
                _snooze(result);
              },
            ),
          );
        },
      );
    } finally {
      _optionalInFlight = false;
    }
  }

  Future<void> _openStore(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('Could not open the store link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.child != null) widget.child!,
        if (_mandatoryVisible && _mandatoryResult != null)
          Positioned.fill(
            child: PopScope(
              canPop: false,
              child: _UpdateScrim(
                child: _UpdatePromptCard(
                  title: _mandatoryResult!.title.isEmpty
                      ? 'Update required'
                      : _mandatoryResult!.title,
                  message: _mandatoryResult!.message.isEmpty
                      ? 'Please update the app to continue using Zoea.'
                      : _mandatoryResult!.message,
                  primaryLabel: 'Update now',
                  onPrimary: () => _openStore(_mandatoryResult!.storeUrl),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Frosted dimmed backdrop + centered card.
class _UpdateScrim extends StatelessWidget {
  const _UpdateScrim({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.38),
                    Colors.black.withValues(alpha: 0.58),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionalUpdateDialog extends StatelessWidget {
  const _OptionalUpdateDialog({
    required this.result,
    required this.onUpdate,
    required this.onLater,
  });

  final AppUpdateCheckResult result;
  final VoidCallback onUpdate;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              behavior: HitTestBehavior.opaque,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _UpdatePromptCard(
                  title: result.title.isEmpty ? 'Update available' : result.title,
                  message: result.message.isEmpty
                      ? 'A new version of Zoea is ready with improvements and fixes.'
                      : result.message,
                  primaryLabel: 'Update now',
                  onPrimary: onUpdate,
                  secondaryLabel: 'Later',
                  onSecondary: onLater,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdatePromptCard extends StatelessWidget {
  const _UpdatePromptCard({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final surface = isDark ? AppTheme.darkCardColor : Colors.white;
    final muted = isDark ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor;
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.45) : AppTheme.primaryColor.withValues(alpha: 0.12);

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 40,
              offset: const Offset(0, 18),
              spreadRadius: -8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary,
                      cs.primary.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
              Container(
                color: surface,
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withValues(alpha: isDark ? 0.18 : 0.08),
                      ),
                      child: Icon(
                        Icons.system_update_rounded,
                        size: 36,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        height: 1.25,
                        color: isDark ? AppTheme.darkPrimaryTextColor : AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.45,
                        color: muted,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: onPrimary,
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          textStyle: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: Text(primaryLabel),
                      ),
                    ),
                    if (secondaryLabel != null && onSecondary != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: onSecondary,
                          style: TextButton.styleFrom(
                            foregroundColor: muted,
                            shape: const StadiumBorder(),
                            textStyle: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text(secondaryLabel!),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
