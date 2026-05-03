import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/phone_validator.dart';
import '../../../core/utils/phone_input_formatter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isPhoneLogin = true; // Toggle between email and phone login (default to phone)
  
  // Country picker for phone login
  Country _selectedCountry = Country(
    phoneCode: '250',
    countryCode: 'RW',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Rwanda',
    example: '250123456789',
    displayName: 'Rwanda (RW) [+250]',
    displayNameNoCountryCode: 'Rwanda (RW)',
    e164Key: '250-RW-0',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: context.surfaceColor,
        textStyle: context.bodyLarge.copyWith(
          color: context.primaryTextColor,
        ),
        searchTextStyle: context.bodyMedium.copyWith(
          color: context.primaryTextColor,
        ),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: Icon(Icons.search, color: context.secondaryTextColor),
          filled: true,
          fillColor: context.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            borderSide: BorderSide(
              color: context.dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            borderSide: BorderSide(
              color: context.dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            borderSide: BorderSide(
              color: context.primaryColorTheme,
              width: 2,
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String identifier;
      if (_isPhoneLogin) {
        // Clean phone number: remove spaces, +, and special characters
        final phoneNumber = '${_selectedCountry.phoneCode}${_phoneController.text.trim()}';
        identifier = PhoneValidator.cleanPhoneNumber(phoneNumber);
      } else {
        // Use email
        identifier = _emailController.text.trim();
      }
      
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithEmail(
        identifier,
        _passwordController.text,
      );

      if (user != null && mounted) {
        // Use replace to prevent going back to login/splash
        context.go('/explore');
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: l10n.loginFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      if (!mounted) return;
      if (user != null) {
        context.go('/explore');
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : l10n.loginGoogleFailed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Title
                  Icon(
                    Icons.explore,
                    size: 80,
                    color: context.primaryColorTheme,
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  Text(
                    l10n.loginWelcomeBack,
                    style: context.displaySmall.copyWith(
                      color: context.primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    l10n.loginSignInToContinue,
                    style: context.bodyLarge.copyWith(
                      color: context.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing32),
                  
                  // Login Method Toggle
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing4),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      border: Border.all(
                        color: context.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPhoneLogin = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.spacing12,
                                horizontal: AppTheme.spacing16,
                              ),
                              decoration: BoxDecoration(
                                color: _isPhoneLogin 
                                    ? (context.isDarkMode ? context.grey300 : context.grey300)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: _isPhoneLogin 
                                        ? (context.isDarkMode ? Colors.white : context.primaryTextColor)
                                        : context.secondaryTextColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppTheme.spacing8),
                                  Text(
                                    l10n.loginTabPhone,
                                    style: context.bodyMedium.copyWith(
                                      color: _isPhoneLogin 
                                          ? (context.isDarkMode ? Colors.white : context.primaryTextColor)
                                          : context.secondaryTextColor,
                                      fontWeight: _isPhoneLogin 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPhoneLogin = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.spacing12,
                                horizontal: AppTheme.spacing16,
                              ),
                              decoration: BoxDecoration(
                                color: !_isPhoneLogin 
                                    ? (context.isDarkMode ? context.grey300 : context.grey300)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: !_isPhoneLogin 
                                        ? (context.isDarkMode ? Colors.white : context.primaryTextColor)
                                        : context.secondaryTextColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppTheme.spacing8),
                                  Text(
                                    l10n.loginTabEmail,
                                    style: context.bodyMedium.copyWith(
                                      color: !_isPhoneLogin 
                                          ? (context.isDarkMode ? Colors.white : context.primaryTextColor)
                                          : context.secondaryTextColor,
                                      fontWeight: !_isPhoneLogin 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  
                  // Email or Phone Input Field
                  if (!_isPhoneLogin) ...[
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.loginEmailAddress,
                        hintText: l10n.loginEmailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                          borderSide: BorderSide(color: context.borderColor),
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
                        if (!value.contains('@')) {
                          return l10n.loginValidationEmailInvalid;
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    // Phone Field with Country Code
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          // Country Code Picker
                          InkWell(
                            onTap: _showCountryPicker,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            child: Container(
                              height: 56, // Match TextFormField height
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing12,
                              ),
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                border: Border.all(
                                  color: context.borderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedCountry.flagEmoji,
                                    style: context.bodyLarge,
                                  ),
                                  const SizedBox(width: AppTheme.spacing4),
                                  Text(
                                    '+${_selectedCountry.phoneCode}',
                                    style: context.bodyLarge,
                                  ),
                                  const SizedBox(width: AppTheme.spacing4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: context.secondaryTextColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          // Phone Number Input
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                PhoneInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                labelText: l10n.loginPhoneNumber,
                                prefixIcon: const Icon(Icons.phone_outlined),
                                hintText: '780 123 456',
                                hintStyle: context.bodySmall.copyWith(color: context.secondaryTextColor),
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
                              validator: PhoneValidator.validateInternationalPhone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacing16),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: l10n.loginPassword,
                      hintText: l10n.loginPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                  const SizedBox(height: AppTheme.spacing8),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push('/auth/reset-password/request');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColorTheme,
                      ),
                      child: Text(l10n.loginForgotPassword),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  // Login Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                        ),
                        elevation: _isLoading ? 0 : 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(l10n.loginSignInButton),
                    ),
                  ),
                  if (AppConfig.enableSocialLogin) ...[
                    const SizedBox(height: AppTheme.spacing16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: context.dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing12,
                          ),
                          child: Text(
                            l10n.loginOr,
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: context.dividerColor)),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: (_isLoading || _isGoogleLoading)
                            ? null
                            : _handleGoogleSignIn,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.borderColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                          ),
                        ),
                        child: _isGoogleLoading
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.primaryColorTheme,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 24,
                                    child: Center(
                                      child: Text(
                                        'G',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF4285F4),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacing8),
                                  Text(
                                    l10n.loginContinueWithGoogle,
                                    style: context.bodyLarge.copyWith(
                                      color: context.primaryTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacing16),
                  
                  // Browse as Guest Button
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/explore');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.borderColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            color: context.primaryTextColor,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Text(
                            l10n.loginBrowseAsGuest,
                            style: context.bodyLarge.copyWith(
                              color: context.primaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.loginDontHaveAccount,
                        style: context.bodyMedium.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: context.primaryColorTheme,
                        ),
                        child: Text(l10n.loginSignUp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}