import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/referral_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _referralPrefilledFromQuery = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _referralCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_referralPrefilledFromQuery) return;
    final fromQuery =
        GoRouterState.of(context).uri.queryParameters['ref']?.trim();
    if (fromQuery != null && fromQuery.isNotEmpty) {
      _referralCodeController.text = fromQuery;
    }
    _referralPrefilledFromQuery = true;
  }

  /// Pasted or typed code wins over query param (user may correct a bad link).
  String? _effectiveReferralCode() {
    final manual = _referralCodeController.text.trim();
    if (manual.isNotEmpty) return manual;
    final fromQuery =
        GoRouterState.of(context).uri.queryParameters['ref']?.trim();
    if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    return null;
  }

  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(
          message: l10n.registerAgreeTermsMessage,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final refCode = _effectiveReferralCode();
      final user = await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        referralCode: refCode,
      );

      if (user != null && mounted) {
        ref.invalidate(referralSummaryProvider);
        context.go('/explore');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: l10n.registerFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: errorMessage.isNotEmpty ? errorMessage : l10n.loginErrorGeneric,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inviteRef =
        GoRouterState.of(context).uri.queryParameters['ref']?.trim();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () => context.pop(),
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
                // Header
                Column(
                  children: [
                    Text(
                      l10n.registerTitle,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      l10n.registerSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (inviteRef != null && inviteRef.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacing12),
                      Text(
                        l10n.registerInviteBanner,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.primaryColorTheme,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacing32),
                
                // Full Name Field
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.registerFullName,
                    hintText: l10n.registerFullNameHint,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.primaryColorTheme, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.registerFieldRequired;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spacing16),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.registerEmailLabel,
                    hintText: l10n.registerEmailHint,
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.primaryColorTheme, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.loginValidationEmailRequired;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return l10n.loginValidationEmailInvalid;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppTheme.spacing16),

                TextFormField(
                  controller: _referralCodeController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: l10n.registerInviteCodeLabel,
                    hintText: l10n.registerInviteCodeHint,
                    prefixIcon: const Icon(Icons.card_giftcard_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.primaryColorTheme, width: 2),
                    ),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return null;
                    if (v.length > 20) {
                      return l10n.registerCodeTooLong;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppTheme.spacing16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.registerPasswordLabel,
                    hintText: l10n.registerPasswordHint,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.primaryColorTheme, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.loginValidationPasswordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.loginValidationPasswordShort;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spacing16),
                
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleRegister(),
                  decoration: InputDecoration(
                    labelText: l10n.registerConfirmPasswordLabel,
                    hintText: l10n.registerConfirmPasswordHint,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      borderSide: BorderSide(color: context.primaryColorTheme, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.registerConfirmPasswordRequired;
                    }
                    if (value != _passwordController.text) {
                      return l10n.registerPasswordsMismatch;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spacing16),
                
                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: context.primaryColorTheme,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(text: l10n.registerAgreePrefix),
                            TextSpan(
                              text: l10n.registerTerms,
                              style: TextStyle(
                                color: context.primaryColorTheme,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: l10n.registerAndConjunction),
                            TextSpan(
                              text: l10n.registerPrivacy,
                              style: TextStyle(
                                color: context.primaryColorTheme,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacing24),
                
                // Register Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(l10n.registerTitle),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacing24),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.registerAlreadyHaveAccount,
                      style: TextStyle(
                        color: context.secondaryTextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColorTheme,
                      ),
                      child: Text(l10n.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
