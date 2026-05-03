// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zoea';

  @override
  String get shellTabExplore => 'Explore';

  @override
  String get shellTabEvents => 'Events';

  @override
  String get shellTabAskZoea => 'Ask Zoea';

  @override
  String get shellTabStay => 'Stay';

  @override
  String get shellTabBookings => 'Bookings';

  @override
  String get shellNoInternetTitle => 'No Internet Connection';

  @override
  String get shellNoInternetSubtitle =>
      'Check your WiFi or mobile data connection';

  @override
  String get shellRetry => 'Retry';

  @override
  String get shellServiceIssueTitle => 'Service Issue';

  @override
  String get shellServiceIssueSubtitle =>
      'Having trouble connecting to our servers';

  @override
  String get shellSnackNoInternet =>
      'No internet connection. Please check your network settings.';

  @override
  String get shellSnackInternetRestored => 'Internet connection restored!';

  @override
  String get shellSnackServiceUnavailable =>
      'Service temporarily unavailable. Retrying...';

  @override
  String get shellSnackBackOnline => 'Back online! Connection restored.';

  @override
  String get authPromptBookingsTitle => 'Sign In Required';

  @override
  String get authPromptBookingsMessage =>
      'Please sign in to view your bookings and reservations.';

  @override
  String get authCancel => 'Cancel';

  @override
  String get signIn => 'Sign In';

  @override
  String get loginWelcomeBack => 'Welcome Back';

  @override
  String get loginSignInToContinue => 'Sign in to continue';

  @override
  String get loginTabPhone => 'Phone';

  @override
  String get loginTabEmail => 'Email';

  @override
  String get loginPhoneNumber => 'Phone Number';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get loginOr => 'or';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginBrowseAsGuest => 'Browse as Guest';

  @override
  String get loginDontHaveAccount => 'Don\'t have an account?';

  @override
  String get loginSignUp => 'Sign Up';

  @override
  String get loginFailed => 'Login failed. Please check your credentials.';

  @override
  String get loginErrorGeneric => 'An error occurred. Please try again.';

  @override
  String get loginGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get loginEmailAddress => 'Email Address';

  @override
  String get loginEmailHint => 'your.email@example.com';

  @override
  String get loginValidationEmailRequired => 'Please enter your email address';

  @override
  String get loginValidationEmailInvalid =>
      'Please enter a valid email address';

  @override
  String get loginValidationPasswordRequired => 'Please enter your password';

  @override
  String get loginValidationPasswordShort =>
      'Password must be at least 6 characters';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAppInformation => 'App information';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileNotificationsTitle => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Manage your notifications';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileEditSubtitle => 'Update your personal information';

  @override
  String get profilePrivacyTitle => 'Privacy & Security';

  @override
  String get profilePrivacySubtitle => 'Password and privacy settings';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileCurrencyTitle => 'Currency';

  @override
  String get profileCountryTitle => 'Country';

  @override
  String get profileCountryRwanda => 'Rwanda';

  @override
  String get profileLocationTitle => 'Location';

  @override
  String get profileLanguageTitle => 'Language';

  @override
  String get profileSectionAppearance => 'Appearance';

  @override
  String get profileThemeLabel => 'Theme';

  @override
  String get profileThemeDark => 'Dark Mode';

  @override
  String get profileThemeLight => 'Light Mode';

  @override
  String get profileThemeSystem => 'System Default';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceSystem => 'System';

  @override
  String get profileSectionTravel => 'Travel & Activities';

  @override
  String get profileMyBookingsTitle => 'My Bookings';

  @override
  String get profileMyBookingsSubtitle => 'View your reservations';

  @override
  String get profileFavoritesTitle => 'Favorites';

  @override
  String get profileFavoritesSubtitle => 'Your saved places and events';

  @override
  String get profileReviewsTitle => 'Reviews & Ratings';

  @override
  String get profileReviewsSubtitle => 'Your reviews and feedback';

  @override
  String get profileSectionSupport => 'Support';

  @override
  String get profileHelpTitle => 'Help Center';

  @override
  String get profileHelpSubtitle => 'Get help and support';

  @override
  String get profileAboutMenuTitle => 'About';

  @override
  String profileAboutSubtitle(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get profileSignOutTitle => 'Sign Out';

  @override
  String get profileSignOutSubtitle => 'Sign out of your account';

  @override
  String get profileStatEvents => 'Events';

  @override
  String get profileStatPlaces => 'Places';

  @override
  String get profileStatReviews => 'Reviews';

  @override
  String get profileStatAttended => 'Attended';

  @override
  String get profileStatVisited => 'Visited';

  @override
  String get profileStatWritten => 'Written';

  @override
  String get profileVerifiedTraveler => 'Verified Traveler';

  @override
  String get profileSelectLanguage => 'Select Language';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionFrench => 'French';

  @override
  String get languageNativeNameEnglish => 'English';

  @override
  String get languageNativeNameFrench => 'Français';

  @override
  String profileLanguageChanged(String languageName) {
    return 'Language changed to $languageName';
  }

  @override
  String profileLanguageUpdateFailed(String error) {
    return 'Failed to update language: $error';
  }

  @override
  String profileCurrencyChanged(String code) {
    return 'Currency changed to $code';
  }

  @override
  String profileCurrencyUpdateFailed(String error) {
    return 'Failed to update currency: $error';
  }

  @override
  String profileCountryChanged(String name) {
    return 'Country changed to $name. Content will be filtered accordingly.';
  }

  @override
  String get profileCountryChangeFailed =>
      'Failed to change country. Please try again.';

  @override
  String profileLocationChanged(String name) {
    return 'Location changed to $name';
  }

  @override
  String profileLocationSaveFailed(String error) {
    return 'Failed to save location: $error';
  }

  @override
  String get profileSelectCity => 'Select city';

  @override
  String get signOutDialogTitle => 'Sign Out';

  @override
  String get signOutDialogMessage => 'Are you sure you want to sign out?';

  @override
  String get signOutDialogConfirm => 'Sign Out';
}
