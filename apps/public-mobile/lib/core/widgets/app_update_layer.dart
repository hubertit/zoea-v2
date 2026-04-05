import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_update_service.dart';

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
        builder: (ctx) {
          return AlertDialog(
            title: Text(result.title.isEmpty ? 'Update available' : result.title),
            content: SingleChildScrollView(
              child: Text(result.message.isEmpty ? 'A new version of the app is available.' : result.message),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _snooze(result);
                },
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await _openStore(result.storeUrl);
                },
                child: const Text('Update'),
              ),
            ],
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
              child: Material(
                color: Colors.black54,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      margin: const EdgeInsets.all(24),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _mandatoryResult!.title.isEmpty
                                  ? 'Update required'
                                  : _mandatoryResult!.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _mandatoryResult!.message.isEmpty
                                  ? 'Please update the app to continue.'
                                  : _mandatoryResult!.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: () => _openStore(_mandatoryResult!.storeUrl),
                              child: const Text('Update now'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
