import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/providers/auth_provider.dart';

/// Must match backend [AuthService.generateOtpCode] (6-digit numeric).
const int _kResetCodeLength = 6;

/// Cooldown before "Resend" is allowed again (code still valid for ~15 min server-side).
const int _kResendCooldownSeconds = 120;

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  final String identifier;

  const VerifyResetCodeScreen({
    super.key,
    required this.identifier,
  });

  @override
  ConsumerState<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends ConsumerState<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _codeControllers;
  late final List<FocusNode> _focusNodes;
  bool _isLoading = false;
  bool _resendLoading = false;

  Timer? _resendTimer;
  int _secondsUntilResend = _kResendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(_kResetCodeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_kResetCodeLength, (_) => FocusNode());
    _startResendCooldown();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _secondsUntilResend = _kResendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secondsUntilResend <= 1) {
          _secondsUntilResend = 0;
          t.cancel();
        } else {
          _secondsUntilResend--;
        }
      });
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.length > 1) {
      _codeControllers[index].text = value.substring(0, 1);
    }

    if (value.isNotEmpty && index < _kResetCodeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_getCode().length == _kResetCodeLength) {
      _handleVerifyCode();
    }
  }

  String _getCode() {
    return _codeControllers.map((c) => c.text).join();
  }

  Future<void> _handleResend() async {
    if (_secondsUntilResend > 0 || _resendLoading) return;

    setState(() => _resendLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.requestPasswordReset(widget.identifier);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.authNewCodeRequested,
            style: context.bodyMedium.copyWith(color: context.primaryTextColor),
          ),
          backgroundColor: context.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      for (final c in _codeControllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
      _startResendCooldown();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _resendLoading = false);
    }
  }

  Future<void> _handleVerifyCode() async {
    final code = _getCode();
    if (code.length != _kResetCodeLength) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyResetCode(
        widget.identifier,
        code,
      );

      if (mounted) {
        context.push('/auth/reset-password/new-password', extra: {
          'identifier': widget.identifier,
          'code': code,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
        for (final controller in _codeControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _resendLabel(AppLocalizations l10n) {
    if (_resendLoading) return l10n.authResendSending;
    if (_secondsUntilResend > 0) {
      final m = _secondsUntilResend ~/ 60;
      final s = _secondsUntilResend % 60;
      final time = '$m:${s.toString().padLeft(2, '0')}';
      return l10n.authResendCodeIn(time);
    }
    return l10n.authResendCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const boxWidth = 48.0;
    const boxSpacing = 6.0;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: context.primaryTextColor,
            size: 32,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.authVerifyCodeTitle,
          style: context.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacing32),
                Icon(
                  Icons.verified_user,
                  size: 80,
                  color: context.primaryColorTheme,
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  l10n.authEnterResetCode,
                  style: context.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  l10n.authResetCodeSentTo(_kResetCodeLength, widget.identifier),
                  style: context.bodyLarge.copyWith(
                    color: context.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing32),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: boxSpacing,
                  runSpacing: AppTheme.spacing12,
                  children: List.generate(_kResetCodeLength, (index) {
                    return SizedBox(
                      width: boxWidth,
                      height: 52,
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 1,
                        style: context.headlineMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 10,
                          ),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            borderSide: BorderSide(
                              color: context.dividerColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            borderSide: BorderSide(
                              color: context.primaryColorTheme,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: context.backgroundColor,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onCodeChanged(index, value),
                        onTap: () {
                          _codeControllers[index].selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _codeControllers[index].text.length,
                          );
                        },
                        onSubmitted: (_) {
                          if (index < _kResetCodeLength - 1) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _handleVerifyCode();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppTheme.spacing32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    elevation: _isLoading ? 0 : 2,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          l10n.authVerifyCodeButton,
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextButton(
                  onPressed: (_secondsUntilResend > 0 || _resendLoading)
                      ? null
                      : _handleResend,
                  child: Text(
                    _resendLabel(l10n),
                    style: context.bodyMedium.copyWith(
                      color: (_secondsUntilResend > 0 || _resendLoading)
                          ? context.secondaryTextColor
                          : context.primaryColorTheme,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
