import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Zoea'**
  String get appTitle;

  /// No description provided for @shellTabExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get shellTabExplore;

  /// No description provided for @shellTabEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get shellTabEvents;

  /// No description provided for @shellTabAskZoea.
  ///
  /// In en, this message translates to:
  /// **'Ask Zoea'**
  String get shellTabAskZoea;

  /// No description provided for @shellTabStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get shellTabStay;

  /// No description provided for @shellTabBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get shellTabBookings;

  /// No description provided for @shellNoInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get shellNoInternetTitle;

  /// No description provided for @shellNoInternetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your WiFi or mobile data connection'**
  String get shellNoInternetSubtitle;

  /// No description provided for @shellRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get shellRetry;

  /// No description provided for @shellServiceIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Issue'**
  String get shellServiceIssueTitle;

  /// No description provided for @shellServiceIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Having trouble connecting to our servers'**
  String get shellServiceIssueSubtitle;

  /// No description provided for @shellSnackNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get shellSnackNoInternet;

  /// No description provided for @shellSnackInternetRestored.
  ///
  /// In en, this message translates to:
  /// **'Internet connection restored!'**
  String get shellSnackInternetRestored;

  /// No description provided for @shellSnackServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Retrying...'**
  String get shellSnackServiceUnavailable;

  /// No description provided for @shellSnackBackOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online! Connection restored.'**
  String get shellSnackBackOnline;

  /// No description provided for @authPromptBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In Required'**
  String get authPromptBookingsTitle;

  /// No description provided for @authPromptBookingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your bookings and reservations.'**
  String get authPromptBookingsMessage;

  /// No description provided for @authCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authCancel;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSignInToContinue;

  /// No description provided for @loginTabPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get loginTabPhone;

  /// No description provided for @loginTabEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginTabEmail;

  /// No description provided for @loginPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get loginPhoneNumber;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignInButton;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginBrowseAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Browse as Guest'**
  String get loginBrowseAsGuest;

  /// No description provided for @loginDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginDontHaveAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get loginErrorGeneric;

  /// No description provided for @loginGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get loginGoogleFailed;

  /// No description provided for @loginEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get loginEmailAddress;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginValidationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get loginValidationEmailRequired;

  /// No description provided for @loginValidationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get loginValidationEmailInvalid;

  /// No description provided for @loginValidationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginValidationPasswordRequired;

  /// No description provided for @loginValidationPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginValidationPasswordShort;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileAppInformation.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get profileAppInformation;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotificationsTitle;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your notifications'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get profileEditSubtitle;

  /// No description provided for @profilePrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get profilePrivacyTitle;

  /// No description provided for @profilePrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password and privacy settings'**
  String get profilePrivacySubtitle;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileSectionPreferences;

  /// No description provided for @profileCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get profileCurrencyTitle;

  /// No description provided for @profileCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountryTitle;

  /// No description provided for @profileCountryRwanda.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get profileCountryRwanda;

  /// No description provided for @profileLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileLocationTitle;

  /// No description provided for @profileLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageTitle;

  /// No description provided for @profileSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileSectionAppearance;

  /// No description provided for @profileThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileThemeLabel;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profileThemeDark;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get profileThemeLight;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get profileThemeSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @profileSectionTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel & Activities'**
  String get profileSectionTravel;

  /// No description provided for @profileMyBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get profileMyBookingsTitle;

  /// No description provided for @profileMyBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your reservations'**
  String get profileMyBookingsSubtitle;

  /// No description provided for @profileFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileFavoritesTitle;

  /// No description provided for @profileFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved places and events'**
  String get profileFavoritesSubtitle;

  /// No description provided for @profileReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get profileReviewsTitle;

  /// No description provided for @profileReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your reviews and feedback'**
  String get profileReviewsSubtitle;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSectionSupport;

  /// No description provided for @profileHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profileHelpTitle;

  /// No description provided for @profileHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get profileHelpSubtitle;

  /// No description provided for @profileAboutMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAboutMenuTitle;

  /// No description provided for @profileAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String profileAboutSubtitle(String version, String buildNumber);

  /// No description provided for @profileSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOutTitle;

  /// No description provided for @profileSignOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get profileSignOutSubtitle;

  /// No description provided for @profileStatEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get profileStatEvents;

  /// No description provided for @profileStatPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get profileStatPlaces;

  /// No description provided for @profileStatReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get profileStatReviews;

  /// No description provided for @profileStatAttended.
  ///
  /// In en, this message translates to:
  /// **'Attended'**
  String get profileStatAttended;

  /// No description provided for @profileStatVisited.
  ///
  /// In en, this message translates to:
  /// **'Visited'**
  String get profileStatVisited;

  /// No description provided for @profileStatWritten.
  ///
  /// In en, this message translates to:
  /// **'Written'**
  String get profileStatWritten;

  /// No description provided for @profileVerifiedTraveler.
  ///
  /// In en, this message translates to:
  /// **'Verified Traveler'**
  String get profileVerifiedTraveler;

  /// No description provided for @profileSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get profileSelectLanguage;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageOptionFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageOptionFrench;

  /// No description provided for @languageNativeNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNativeNameEnglish;

  /// No description provided for @languageNativeNameFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageNativeNameFrench;

  /// No description provided for @profileLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {languageName}'**
  String profileLanguageChanged(String languageName);

  /// No description provided for @profileLanguageUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update language: {error}'**
  String profileLanguageUpdateFailed(String error);

  /// No description provided for @profileCurrencyChanged.
  ///
  /// In en, this message translates to:
  /// **'Currency changed to {code}'**
  String profileCurrencyChanged(String code);

  /// No description provided for @profileCurrencyUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update currency: {error}'**
  String profileCurrencyUpdateFailed(String error);

  /// No description provided for @profileCountryChanged.
  ///
  /// In en, this message translates to:
  /// **'Country changed to {name}. Content will be filtered accordingly.'**
  String profileCountryChanged(String name);

  /// No description provided for @profileCountryChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change country. Please try again.'**
  String get profileCountryChangeFailed;

  /// No description provided for @profileLocationChanged.
  ///
  /// In en, this message translates to:
  /// **'Location changed to {name}'**
  String profileLocationChanged(String name);

  /// No description provided for @profileLocationSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save location: {error}'**
  String profileLocationSaveFailed(String error);

  /// No description provided for @profileSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get profileSelectCity;

  /// No description provided for @signOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutDialogTitle;

  /// No description provided for @signOutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutDialogMessage;

  /// No description provided for @signOutDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutDialogConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
