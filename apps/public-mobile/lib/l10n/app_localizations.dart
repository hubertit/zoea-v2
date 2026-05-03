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

  /// No description provided for @commonViewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get commonViewMore;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @exploreLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get exploreLoading;

  /// No description provided for @exploreDefaultCity.
  ///
  /// In en, this message translates to:
  /// **'Kigali'**
  String get exploreDefaultCity;

  /// No description provided for @exploreCurrencyPair.
  ///
  /// In en, this message translates to:
  /// **'USD / RWF'**
  String get exploreCurrencyPair;

  /// No description provided for @exploreQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get exploreQuickActions;

  /// No description provided for @exploreUnablePhoneCall.
  ///
  /// In en, this message translates to:
  /// **'Unable to make phone call'**
  String get exploreUnablePhoneCall;

  /// No description provided for @exploreEmergencyTollFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Toll Free Numbers'**
  String get exploreEmergencyTollFreeTitle;

  /// No description provided for @exploreEmergencyEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get exploreEmergencyEmergency;

  /// No description provided for @exploreEmergencyTrafficAccidents.
  ///
  /// In en, this message translates to:
  /// **'Traffic Accidents'**
  String get exploreEmergencyTrafficAccidents;

  /// No description provided for @exploreEmergencyAbusePolice.
  ///
  /// In en, this message translates to:
  /// **'Abuse by Police Officer'**
  String get exploreEmergencyAbusePolice;

  /// No description provided for @exploreEmergencyAntiCorruption.
  ///
  /// In en, this message translates to:
  /// **'Anti Corruption'**
  String get exploreEmergencyAntiCorruption;

  /// No description provided for @exploreEmergencyMaritime.
  ///
  /// In en, this message translates to:
  /// **'Maritime Problems'**
  String get exploreEmergencyMaritime;

  /// No description provided for @exploreEmergencyDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License Queries'**
  String get exploreEmergencyDrivingLicense;

  /// No description provided for @exploreEmergencyFireRescue.
  ///
  /// In en, this message translates to:
  /// **'Fire and Rescue'**
  String get exploreEmergencyFireRescue;

  /// No description provided for @exploreCallNumber.
  ///
  /// In en, this message translates to:
  /// **'Call: {number}'**
  String exploreCallNumber(String number);

  /// No description provided for @exploreActionEmergencySos.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get exploreActionEmergencySos;

  /// No description provided for @exploreActionCallTaxi.
  ///
  /// In en, this message translates to:
  /// **'Call Taxi'**
  String get exploreActionCallTaxi;

  /// No description provided for @exploreActionBookTour.
  ///
  /// In en, this message translates to:
  /// **'Book Tour'**
  String get exploreActionBookTour;

  /// No description provided for @exploreActionEsim.
  ///
  /// In en, this message translates to:
  /// **'eSim'**
  String get exploreActionEsim;

  /// No description provided for @exploreActionPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get exploreActionPharmacy;

  /// No description provided for @exploreActionRoadsideAssistance.
  ///
  /// In en, this message translates to:
  /// **'Roadside Assistance'**
  String get exploreActionRoadsideAssistance;

  /// No description provided for @exploreActionFlightInfo.
  ///
  /// In en, this message translates to:
  /// **'Flight Info'**
  String get exploreActionFlightInfo;

  /// No description provided for @exploreActionIrembo.
  ///
  /// In en, this message translates to:
  /// **'Irembo'**
  String get exploreActionIrembo;

  /// No description provided for @exploreActionVisitRwanda.
  ///
  /// In en, this message translates to:
  /// **'Visit Rwanda'**
  String get exploreActionVisitRwanda;

  /// No description provided for @exploreWebviewTitleEsim.
  ///
  /// In en, this message translates to:
  /// **'eSim'**
  String get exploreWebviewTitleEsim;

  /// No description provided for @exploreWebviewTitleRwandAir.
  ///
  /// In en, this message translates to:
  /// **'RwandAir'**
  String get exploreWebviewTitleRwandAir;

  /// No description provided for @exploreWebviewTitleIrembo.
  ///
  /// In en, this message translates to:
  /// **'Irembo'**
  String get exploreWebviewTitleIrembo;

  /// No description provided for @exploreWebviewTitleVisitRwanda.
  ///
  /// In en, this message translates to:
  /// **'Visit Rwanda'**
  String get exploreWebviewTitleVisitRwanda;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get exploreCategories;

  /// No description provided for @exploreHappening.
  ///
  /// In en, this message translates to:
  /// **'Happening'**
  String get exploreHappening;

  /// No description provided for @exploreFailedLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load events'**
  String get exploreFailedLoadEvents;

  /// No description provided for @exploreNoEventsToday.
  ///
  /// In en, this message translates to:
  /// **'No events today'**
  String get exploreNoEventsToday;

  /// No description provided for @exploreAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get exploreAllCategories;

  /// No description provided for @exploreNoCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get exploreNoCategoriesAvailable;

  /// No description provided for @exploreFailedLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get exploreFailedLoadCategories;

  /// No description provided for @exploreRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get exploreRecommended;

  /// No description provided for @exploreNoFeaturedListings.
  ///
  /// In en, this message translates to:
  /// **'No featured listings available'**
  String get exploreNoFeaturedListings;

  /// No description provided for @exploreFailedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recommendations'**
  String get exploreFailedRecommendations;

  /// No description provided for @exploreNearMe.
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get exploreNearMe;

  /// No description provided for @exploreNoListings.
  ///
  /// In en, this message translates to:
  /// **'No listings available'**
  String get exploreNoListings;

  /// No description provided for @exploreFailedListings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listings'**
  String get exploreFailedListings;

  /// No description provided for @exploreTourPackages.
  ///
  /// In en, this message translates to:
  /// **'Tour Packages'**
  String get exploreTourPackages;

  /// No description provided for @exploreFailedTours.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tours'**
  String get exploreFailedTours;

  /// No description provided for @exploreNoTours.
  ///
  /// In en, this message translates to:
  /// **'No tour packages available'**
  String get exploreNoTours;

  /// No description provided for @exploreUntitledTour.
  ///
  /// In en, this message translates to:
  /// **'Untitled Tour'**
  String get exploreUntitledTour;

  /// No description provided for @exploreTourBadgeTour.
  ///
  /// In en, this message translates to:
  /// **'TOUR'**
  String get exploreTourBadgeTour;

  /// No description provided for @exploreTourBadgeFeatured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get exploreTourBadgeFeatured;

  /// No description provided for @exploreTourPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String exploreTourPriceFrom(String price);

  /// No description provided for @exploreTourPriceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'From RWF ---'**
  String get exploreTourPriceUnavailable;

  /// No description provided for @exploreTourDurationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String exploreTourDurationDays(int count);

  /// No description provided for @exploreTourDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String exploreTourDurationHours(int count);

  /// No description provided for @exploreFavoriteSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Save Favorites'**
  String get exploreFavoriteSignInTitle;

  /// No description provided for @exploreFavoriteSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to save your favorite places and access them anytime.'**
  String get exploreFavoriteSignInMessage;

  /// No description provided for @exploreFavoriteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Save Favorites'**
  String get exploreFavoriteSessionTitle;

  /// No description provided for @exploreFavoriteSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again to save favorites.'**
  String get exploreFavoriteSessionMessage;

  /// No description provided for @exploreFavoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite: {error}'**
  String exploreFavoriteUpdateFailed(String error);

  /// No description provided for @exploreGiftReferTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get exploreGiftReferTitle;

  /// No description provided for @exploreGiftReferSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and earn rewards'**
  String get exploreGiftReferSubtitle;

  /// No description provided for @exploreGiftItineraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Planning'**
  String get exploreGiftItineraryTitle;

  /// No description provided for @exploreGiftItinerarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan and share your trip'**
  String get exploreGiftItinerarySubtitle;

  /// No description provided for @exploreEventTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String exploreEventTimeToday(String time);

  /// No description provided for @exploreCategoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exploreCategoryFallback;

  /// No description provided for @exploreListingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get exploreListingUnknown;

  /// No description provided for @exploreListingPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get exploreListingPlace;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get commonClearAll;

  /// No description provided for @commonFavoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites!'**
  String get commonFavoriteAdded;

  /// No description provided for @commonFavoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites!'**
  String get commonFavoriteRemoved;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @eventsTabTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get eventsTabTrending;

  /// No description provided for @eventsTabNearMe.
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get eventsTabNearMe;

  /// No description provided for @eventsTabThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get eventsTabThisWeek;

  /// No description provided for @eventsTabMice.
  ///
  /// In en, this message translates to:
  /// **'MICE'**
  String get eventsTabMice;

  /// No description provided for @eventsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading events'**
  String get eventsErrorLoading;

  /// No description provided for @eventsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get eventsEmptyTitle;

  /// No description provided for @eventsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new events'**
  String get eventsEmptySubtitle;

  /// No description provided for @eventsSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Events'**
  String get eventsSearchTitle;

  /// No description provided for @eventsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for events...'**
  String get eventsSearchHint;

  /// No description provided for @eventsTicketPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {amount} {currency}'**
  String eventsTicketPriceFrom(String amount, String currency);

  /// No description provided for @eventsFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Events'**
  String get eventsFilterTitle;

  /// No description provided for @eventsFilterSearchSection.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get eventsFilterSearchSection;

  /// No description provided for @eventsFilterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get eventsFilterSearchHint;

  /// No description provided for @eventsFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get eventsFilterCategory;

  /// No description provided for @eventsFilterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get eventsFilterDateRange;

  /// No description provided for @eventsFilterStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get eventsFilterStartDate;

  /// No description provided for @eventsFilterEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get eventsFilterEndDate;

  /// No description provided for @eventsFilterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get eventsFilterPriceRange;

  /// No description provided for @eventsFilterLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventsFilterLocation;

  /// No description provided for @eventsFilterLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location...'**
  String get eventsFilterLocationHint;

  /// No description provided for @eventsFilterOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get eventsFilterOptions;

  /// No description provided for @eventsFilterFreeEvents.
  ///
  /// In en, this message translates to:
  /// **'Free Events'**
  String get eventsFilterFreeEvents;

  /// No description provided for @eventsFilterVerifiedOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified Only'**
  String get eventsFilterVerifiedOnly;

  /// No description provided for @eventsCategoryMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get eventsCategoryMusic;

  /// No description provided for @eventsCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports & Wellness'**
  String get eventsCategorySports;

  /// No description provided for @eventsCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks'**
  String get eventsCategoryFood;

  /// No description provided for @eventsCategoryArts.
  ///
  /// In en, this message translates to:
  /// **'Arts & Culture'**
  String get eventsCategoryArts;

  /// No description provided for @eventsCategoryConferences.
  ///
  /// In en, this message translates to:
  /// **'Conferences'**
  String get eventsCategoryConferences;

  /// No description provided for @eventsCategoryPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get eventsCategoryPerformance;

  /// No description provided for @eventsPriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get eventsPriceFree;

  /// No description provided for @eventsPriceUnder5k.
  ///
  /// In en, this message translates to:
  /// **'Under 5K RWF'**
  String get eventsPriceUnder5k;

  /// No description provided for @eventsPrice5kTo15k.
  ///
  /// In en, this message translates to:
  /// **'5K - 15K RWF'**
  String get eventsPrice5kTo15k;

  /// No description provided for @eventsPrice15kTo50k.
  ///
  /// In en, this message translates to:
  /// **'15K - 50K RWF'**
  String get eventsPrice15kTo50k;

  /// No description provided for @eventsPrice50kTo100k.
  ///
  /// In en, this message translates to:
  /// **'50K - 100K RWF'**
  String get eventsPrice50kTo100k;

  /// No description provided for @eventsPrice100kPlus.
  ///
  /// In en, this message translates to:
  /// **'100K+ RWF'**
  String get eventsPrice100kPlus;

  /// No description provided for @eventsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Calendar'**
  String get eventsCalendarTitle;

  /// No description provided for @eventsCalendarOnDate.
  ///
  /// In en, this message translates to:
  /// **'Events on {date}'**
  String eventsCalendarOnDate(String date);

  /// No description provided for @eventsFavoriteSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Save Favorites'**
  String get eventsFavoriteSignInTitle;

  /// No description provided for @eventsFavoriteSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to save your favorite events and access them anytime.'**
  String get eventsFavoriteSignInMessage;

  /// No description provided for @eventsFavoriteSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again to save favorites.'**
  String get eventsFavoriteSessionMessage;

  /// No description provided for @eventsOrganizedBy.
  ///
  /// In en, this message translates to:
  /// **'Organized by'**
  String get eventsOrganizedBy;

  /// No description provided for @eventsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About this event'**
  String get eventsAboutTitle;

  /// No description provided for @eventsSectionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get eventsSectionCategory;

  /// No description provided for @eventsLabelAttending.
  ///
  /// In en, this message translates to:
  /// **'Attending'**
  String get eventsLabelAttending;

  /// No description provided for @eventsLabelCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get eventsLabelCapacity;

  /// No description provided for @eventsLabelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get eventsLabelStatus;

  /// No description provided for @eventsStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get eventsStatusOngoing;

  /// No description provided for @eventsStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventsStatusUpcoming;

  /// No description provided for @eventsTicketsSection.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get eventsTicketsSection;

  /// No description provided for @eventsTicketSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get eventsTicketSoldOut;

  /// No description provided for @eventsTicketBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get eventsTicketBuy;

  /// No description provided for @eventsBottomPerPerson.
  ///
  /// In en, this message translates to:
  /// **'per person'**
  String get eventsBottomPerPerson;

  /// No description provided for @eventsBottomSelectTickets.
  ///
  /// In en, this message translates to:
  /// **'Select Tickets'**
  String get eventsBottomSelectTickets;

  /// No description provided for @eventsBottomJoinEvent.
  ///
  /// In en, this message translates to:
  /// **'Join Event'**
  String get eventsBottomJoinEvent;

  /// No description provided for @eventsBottomPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {amount} {currency}'**
  String eventsBottomPriceFrom(String amount, String currency);

  /// No description provided for @eventsSincRedirectTitle.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to Sinc'**
  String get eventsSincRedirectTitle;

  /// No description provided for @eventsSincRedirectMessage.
  ///
  /// In en, this message translates to:
  /// **'You are about to be redirected to our partner platform \"Sinc\" to purchase tickets for this event. Sinc is our trusted ticketing partner that handles secure event bookings and payments.'**
  String get eventsSincRedirectMessage;

  /// No description provided for @eventsSincDontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get eventsSincDontShowAgain;

  /// No description provided for @eventsShareWithLocation.
  ///
  /// In en, this message translates to:
  /// **'Check out \"{name}\" in {location} on {date}!'**
  String eventsShareWithLocation(String name, String location, String date);

  /// No description provided for @eventsShareNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Check out \"{name}\" on {date}!'**
  String eventsShareNoLocation(String name, String date);

  /// No description provided for @assistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rwanda guide'**
  String get assistantSubtitle;

  /// No description provided for @assistantTooltipNewChat.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get assistantTooltipNewChat;

  /// No description provided for @assistantTooltipHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get assistantTooltipHistory;

  /// No description provided for @assistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about Rwanda...'**
  String get assistantInputHint;

  /// No description provided for @assistantEmptyGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Zoea 👋'**
  String get assistantEmptyGreeting;

  /// No description provided for @assistantEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your friendly guide to Rwanda. Ask me about places to visit, restaurants, tours, or anything else!'**
  String get assistantEmptyBody;

  /// No description provided for @assistantEmptyTryAsking.
  ///
  /// In en, this message translates to:
  /// **'Try asking:'**
  String get assistantEmptyTryAsking;

  /// No description provided for @assistantErrorSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message: {error}'**
  String assistantErrorSend(String error);

  /// No description provided for @assistantHistorySignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In to View History'**
  String get assistantHistorySignInTitle;

  /// No description provided for @assistantHistorySignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to view your conversation history with Zoea.'**
  String get assistantHistorySignInMessage;

  /// No description provided for @assistantHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Conversations'**
  String get assistantHistoryTitle;

  /// No description provided for @assistantHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get assistantHistoryEmpty;

  /// No description provided for @assistantHistoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversations'**
  String get assistantHistoryLoadFailed;

  /// No description provided for @assistantErrorLoadConversation.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversation: {error}'**
  String assistantErrorLoadConversation(String error);

  /// No description provided for @assistantRelativeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get assistantRelativeToday;

  /// No description provided for @assistantRelativeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get assistantRelativeYesterday;

  /// No description provided for @assistantRelativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String assistantRelativeDaysAgo(int count);

  /// No description provided for @assistantSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Italian dinner in Kigali'**
  String get assistantSuggestion1;

  /// No description provided for @assistantSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Gorilla or safari tours'**
  String get assistantSuggestion2;

  /// No description provided for @assistantSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy or ATM nearby'**
  String get assistantSuggestion3;

  /// No description provided for @assistantSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'Show me popular places'**
  String get assistantSuggestion4;

  /// No description provided for @assistantSuggestion5.
  ///
  /// In en, this message translates to:
  /// **'Find restaurants in Kigali'**
  String get assistantSuggestion5;

  /// No description provided for @assistantSuggestion6.
  ///
  /// In en, this message translates to:
  /// **'What tours are available?'**
  String get assistantSuggestion6;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNotApplicable;

  /// No description provided for @bookingsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookingsTabAll;

  /// No description provided for @bookingsTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bookingsTabUpcoming;

  /// No description provided for @bookingsTabPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get bookingsTabPast;

  /// No description provided for @bookingsTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingsTabCancelled;

  /// No description provided for @bookingsErrorOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get bookingsErrorOrders;

  /// No description provided for @bookingsErrorBookings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get bookingsErrorBookings;

  /// No description provided for @bookingsEmptyUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings or orders'**
  String get bookingsEmptyUpcomingTitle;

  /// No description provided for @bookingsEmptyUpcomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any upcoming reservations or orders'**
  String get bookingsEmptyUpcomingSubtitle;

  /// No description provided for @bookingsEmptyPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No past bookings or orders'**
  String get bookingsEmptyPastTitle;

  /// No description provided for @bookingsEmptyPastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking and order history will appear here'**
  String get bookingsEmptyPastSubtitle;

  /// No description provided for @bookingsEmptyCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'No cancelled bookings or orders'**
  String get bookingsEmptyCancelledTitle;

  /// No description provided for @bookingsEmptyCancelledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cancelled bookings and orders will appear here'**
  String get bookingsEmptyCancelledSubtitle;

  /// No description provided for @bookingsEmptyDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookings or orders yet'**
  String get bookingsEmptyDefaultTitle;

  /// No description provided for @bookingsEmptyDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and make your first booking or order!'**
  String get bookingsEmptyDefaultSubtitle;

  /// No description provided for @bookingsExploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore now'**
  String get bookingsExploreNow;

  /// No description provided for @bookingsSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search bookings'**
  String get bookingsSearchTitle;

  /// No description provided for @bookingsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, location, booking or order number…'**
  String get bookingsSearchHint;

  /// No description provided for @bookingsLocationNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Location not specified'**
  String get bookingsLocationNotSpecified;

  /// No description provided for @bookingsTourLocation.
  ///
  /// In en, this message translates to:
  /// **'Tour location'**
  String get bookingsTourLocation;

  /// No description provided for @stayTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to stay'**
  String get stayTitle;

  /// No description provided for @staySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your perfect accommodation'**
  String get staySubtitle;

  /// No description provided for @stayTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get stayTabAll;

  /// No description provided for @stayTabHotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get stayTabHotels;

  /// No description provided for @stayTabBnbs.
  ///
  /// In en, this message translates to:
  /// **'B&Bs'**
  String get stayTabBnbs;

  /// No description provided for @stayTabApartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get stayTabApartments;

  /// No description provided for @stayTabVillas.
  ///
  /// In en, this message translates to:
  /// **'Villas'**
  String get stayTabVillas;

  /// No description provided for @stayAnyDates.
  ///
  /// In en, this message translates to:
  /// **'Any dates'**
  String get stayAnyDates;

  /// No description provided for @staySelectCheckout.
  ///
  /// In en, this message translates to:
  /// **'Select checkout'**
  String get staySelectCheckout;

  /// No description provided for @stayGuestCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 guest} other{{count} guests}}'**
  String stayGuestCount(int count);

  /// No description provided for @stayFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load accommodations'**
  String get stayFailedLoad;

  /// No description provided for @stayEmptyNoMatchesForCategory.
  ///
  /// In en, this message translates to:
  /// **'No {category} found'**
  String stayEmptyNoMatchesForCategory(String category);

  /// No description provided for @stayEmptyAdjust.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get stayEmptyAdjust;

  /// No description provided for @stayFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get stayFiltersTitle;

  /// No description provided for @stayPriceRangeRwf.
  ///
  /// In en, this message translates to:
  /// **'Price range (RWF)'**
  String get stayPriceRangeRwf;

  /// No description provided for @stayPriceMinSample.
  ///
  /// In en, this message translates to:
  /// **'Min: 10,000'**
  String get stayPriceMinSample;

  /// No description provided for @stayPriceMaxSample.
  ///
  /// In en, this message translates to:
  /// **'Max: 200,000'**
  String get stayPriceMaxSample;

  /// No description provided for @stayMinimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get stayMinimumRating;

  /// No description provided for @stayRatingAtLeastPlus.
  ///
  /// In en, this message translates to:
  /// **'{min}+'**
  String stayRatingAtLeastPlus(int min);

  /// No description provided for @stayAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get stayAmenities;

  /// No description provided for @stayAmenityWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get stayAmenityWifi;

  /// No description provided for @stayAmenityPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get stayAmenityPool;

  /// No description provided for @stayAmenitySpa.
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get stayAmenitySpa;

  /// No description provided for @stayAmenityGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get stayAmenityGym;

  /// No description provided for @stayAmenityRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get stayAmenityRestaurant;

  /// No description provided for @stayAmenityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get stayAmenityParking;

  /// No description provided for @stayAmenityAirConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get stayAmenityAirConditioning;

  /// No description provided for @stayAmenityBusinessCenter.
  ///
  /// In en, this message translates to:
  /// **'Business center'**
  String get stayAmenityBusinessCenter;

  /// No description provided for @stayAmenityKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get stayAmenityKitchen;

  /// No description provided for @stayAmenityGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get stayAmenityGarden;

  /// No description provided for @stayAmenityRoomService.
  ///
  /// In en, this message translates to:
  /// **'Room service'**
  String get stayAmenityRoomService;

  /// No description provided for @stayPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get stayPropertyType;

  /// No description provided for @stayDistanceFromCenter.
  ///
  /// In en, this message translates to:
  /// **'Distance from city center'**
  String get stayDistanceFromCenter;

  /// No description provided for @stayDistanceAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get stayDistanceAny;

  /// No description provided for @stayDistanceUnder5km.
  ///
  /// In en, this message translates to:
  /// **'Under 5 km'**
  String get stayDistanceUnder5km;

  /// No description provided for @stayDistance5to10km.
  ///
  /// In en, this message translates to:
  /// **'5–10 km'**
  String get stayDistance5to10km;

  /// No description provided for @stayDistance10to20km.
  ///
  /// In en, this message translates to:
  /// **'10–20 km'**
  String get stayDistance10to20km;

  /// No description provided for @stayDistanceOver20km.
  ///
  /// In en, this message translates to:
  /// **'Over 20 km'**
  String get stayDistanceOver20km;

  /// No description provided for @stayApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get stayApplyFilters;

  /// No description provided for @stayMapComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Map view coming soon!'**
  String get stayMapComingSoon;

  /// No description provided for @staySearchOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search options'**
  String get staySearchOptionsTitle;

  /// No description provided for @stayWhereLabel.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get stayWhereLabel;

  /// No description provided for @stayCheckInOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in & check-out'**
  String get stayCheckInOutLabel;

  /// No description provided for @stayGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get stayGuestsLabel;

  /// No description provided for @staySearchAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Search accommodations'**
  String get staySearchAccommodations;

  /// No description provided for @staySelectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get staySelectLocationTitle;

  /// No description provided for @staySelectDatesTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Select dates & times'**
  String get staySelectDatesTimesTitle;

  /// No description provided for @stayCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get stayCheckIn;

  /// No description provided for @stayCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get stayCheckOut;

  /// No description provided for @staySelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get staySelectDate;

  /// No description provided for @staySelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get staySelectTime;

  /// No description provided for @stayNumberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get stayNumberOfGuests;

  /// No description provided for @stayGuestsSheetGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get stayGuestsSheetGuests;

  /// No description provided for @staySortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get staySortBy;

  /// No description provided for @staySortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get staySortRecommended;

  /// No description provided for @staySortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get staySortPriceLowHigh;

  /// No description provided for @staySortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get staySortPriceHighLow;

  /// No description provided for @staySortRatingHighLow.
  ///
  /// In en, this message translates to:
  /// **'Rating: high to low'**
  String get staySortRatingHighLow;

  /// No description provided for @staySortRatingLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Rating: low to high'**
  String get staySortRatingLowHigh;

  /// No description provided for @staySortDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get staySortDistance;

  /// No description provided for @staySortPopularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get staySortPopularity;

  /// No description provided for @stayListingFallback.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get stayListingFallback;

  /// No description provided for @stayLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get stayLocationUnavailable;

  /// No description provided for @stayBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get stayBreakfast;

  /// No description provided for @stayRoomTypesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 room type} other{{count} room types}}'**
  String stayRoomTypesCount(int count);

  /// No description provided for @bookingsBookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get bookingsBookAgain;

  /// No description provided for @bookingsViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get bookingsViewDetails;

  /// No description provided for @bookingsBookedOn.
  ///
  /// In en, this message translates to:
  /// **'Booked on {date}'**
  String bookingsBookedOn(String date);

  /// No description provided for @bookingsOrderedOn.
  ///
  /// In en, this message translates to:
  /// **'Ordered on {date}'**
  String bookingsOrderedOn(String date);

  /// No description provided for @bookingsOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get bookingsOrderLabel;

  /// No description provided for @bookingsDateNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Date not specified'**
  String get bookingsDateNotSpecified;

  /// No description provided for @bookingsOrderPreviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Order details for {number}'**
  String bookingsOrderPreviewMessage(String number);

  /// No description provided for @bookingsCancelOrderSoon.
  ///
  /// In en, this message translates to:
  /// **'Cancel order coming soon'**
  String get bookingsCancelOrderSoon;

  /// No description provided for @bookingsLineItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String bookingsLineItemCount(int count);

  /// No description provided for @commonNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get commonNotSpecified;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll Be Right Back!'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Our systems are currently undergoing maintenance to serve you better. We\'ll be back online shortly.'**
  String get maintenanceMessage;

  /// No description provided for @maintenanceTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get maintenanceTryAgain;

  /// No description provided for @maintenanceSupport.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact us at {email}'**
  String maintenanceSupport(String email);

  /// No description provided for @maintenanceStillUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service is still unavailable. Please try again in a moment.'**
  String get maintenanceStillUnavailable;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search help articles…'**
  String get helpSearchHint;

  /// No description provided for @helpQuickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get helpQuickHelp;

  /// No description provided for @helpPopularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get helpPopularTopics;

  /// No description provided for @helpContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get helpContactSupport;

  /// No description provided for @helpFaqCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqCategoriesTitle;

  /// No description provided for @helpLinkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link. Try again later.'**
  String get helpLinkOpenFailed;

  /// No description provided for @helpContactButton.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get helpContactButton;

  /// No description provided for @helpFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} is coming soon!'**
  String helpFeatureComingSoon(String feature);

  /// No description provided for @helpLiveChatBody.
  ///
  /// In en, this message translates to:
  /// **'Start a live chat session with our support team.'**
  String get helpLiveChatBody;

  /// No description provided for @helpQuickAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Issues'**
  String get helpQuickAccountTitle;

  /// No description provided for @helpQuickAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login, registration, and profile problems'**
  String get helpQuickAccountSubtitle;

  /// No description provided for @helpQuickPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment & Billing'**
  String get helpQuickPaymentTitle;

  /// No description provided for @helpQuickPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Booking payments and refunds'**
  String get helpQuickPaymentSubtitle;

  /// No description provided for @helpQuickEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events & Bookings'**
  String get helpQuickEventsTitle;

  /// No description provided for @helpQuickEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Event tickets and booking management'**
  String get helpQuickEventsSubtitle;

  /// No description provided for @helpQuickPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Places & Locations'**
  String get helpQuickPlacesTitle;

  /// No description provided for @helpQuickPlacesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Finding and visiting places'**
  String get helpQuickPlacesSubtitle;

  /// No description provided for @helpTopicBookEvents.
  ///
  /// In en, this message translates to:
  /// **'How to book events'**
  String get helpTopicBookEvents;

  /// No description provided for @helpTopicPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get helpTopicPaymentMethods;

  /// No description provided for @helpTopicCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get helpTopicCancelBooking;

  /// No description provided for @helpTopicUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get helpTopicUpdateProfile;

  /// No description provided for @helpTopicContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get helpTopicContactSupport;

  /// No description provided for @helpTopicAppFeatures.
  ///
  /// In en, this message translates to:
  /// **'App features'**
  String get helpTopicAppFeatures;

  /// No description provided for @helpLiveChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get helpLiveChatTitle;

  /// No description provided for @helpLiveChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant help from our support team'**
  String get helpLiveChatSubtitle;

  /// No description provided for @helpEmailSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get helpEmailSupportTitle;

  /// No description provided for @helpPhoneSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get helpPhoneSupportTitle;

  /// No description provided for @helpPhoneSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'+250 796 889 900'**
  String get helpPhoneSupportSubtitle;

  /// No description provided for @helpFaqGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpFaqGettingStarted;

  /// No description provided for @helpFaqAccountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get helpFaqAccountProfile;

  /// No description provided for @helpFaqBookingsEvents.
  ///
  /// In en, this message translates to:
  /// **'Bookings & Events'**
  String get helpFaqBookingsEvents;

  /// No description provided for @helpFaqPaymentRefunds.
  ///
  /// In en, this message translates to:
  /// **'Payment & Refunds'**
  String get helpFaqPaymentRefunds;

  /// No description provided for @helpFaqTechnicalIssues.
  ///
  /// In en, this message translates to:
  /// **'Technical Issues'**
  String get helpFaqTechnicalIssues;

  /// No description provided for @helpAppVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get helpAppVersionLabel;

  /// No description provided for @helpBuildNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get helpBuildNumberLabel;

  /// No description provided for @helpLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get helpLastUpdatedLabel;

  /// No description provided for @helpPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get helpPlatformLabel;

  /// No description provided for @helpPackageInfoError.
  ///
  /// In en, this message translates to:
  /// **'Could not load package info.'**
  String get helpPackageInfoError;

  /// No description provided for @helpArticleAccount.
  ///
  /// In en, this message translates to:
  /// **'Common account issues and solutions:\n\n• Forgot Password: Use the \"Forgot Password\" link on the login screen\n• Account Verification: Check your email for verification links\n• Profile Updates: Go to Profile > Edit Profile to update your information\n• Account Security: Enable two-factor authentication in Privacy & Security settings\n• Data Privacy: Review your privacy settings in the app settings'**
  String get helpArticleAccount;

  /// No description provided for @helpArticlePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment and billing assistance:\n\n• Payment Methods: Add credit cards, mobile money, or bank accounts\n• Refund Requests: Contact support for booking cancellations and refunds\n• Payment History: View all transactions in your profile\n• Failed Payments: Check your payment method and try again\n• Currency: All payments are processed in Rwandan Francs (RWF)'**
  String get helpArticlePayment;

  /// No description provided for @helpArticleBooking.
  ///
  /// In en, this message translates to:
  /// **'Event booking and management:\n\n• Booking Events: Browse events and tap \"Book Now\" to reserve your spot\n• Booking Confirmation: You\'ll receive email and app notifications\n• Cancel Bookings: Go to My Bookings to cancel upcoming events\n• Event Updates: Check the Events tab for latest information\n• Group Bookings: Contact support for group reservations'**
  String get helpArticleBooking;

  /// No description provided for @helpArticlePlaces.
  ///
  /// In en, this message translates to:
  /// **'Places and location information:\n\n• Finding Places: Use the search bar or browse categories\n• Place Details: Tap on any place to see photos, reviews, and information\n• Directions: Get directions using your preferred maps app\n• Reviews: Share your experiences by writing reviews\n• Favorites: Save places you want to visit later'**
  String get helpArticlePlaces;

  /// No description provided for @helpFaqGs1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I create an account?'**
  String get helpFaqGs1Q;

  /// No description provided for @helpFaqGs1A.
  ///
  /// In en, this message translates to:
  /// **'Download the app and tap \"Sign Up\" to create your account with email or phone number.'**
  String get helpFaqGs1A;

  /// No description provided for @helpFaqGs2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I book my first event?'**
  String get helpFaqGs2Q;

  /// No description provided for @helpFaqGs2A.
  ///
  /// In en, this message translates to:
  /// **'Browse events in the Events tab, select an event, and tap \"Book Now\" to reserve your spot.'**
  String get helpFaqGs2A;

  /// No description provided for @helpFaqGs3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update my profile?'**
  String get helpFaqGs3Q;

  /// No description provided for @helpFaqGs3A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Profile to update your personal information.'**
  String get helpFaqGs3A;

  /// No description provided for @helpFaqGs4Q.
  ///
  /// In en, this message translates to:
  /// **'How do I find places to visit?'**
  String get helpFaqGs4Q;

  /// No description provided for @helpFaqGs4A.
  ///
  /// In en, this message translates to:
  /// **'Use the Explore tab to discover places, or search for specific locations.'**
  String get helpFaqGs4A;

  /// No description provided for @helpFaqGs5Q.
  ///
  /// In en, this message translates to:
  /// **'How do I get help?'**
  String get helpFaqGs5Q;

  /// No description provided for @helpFaqGs5A.
  ///
  /// In en, this message translates to:
  /// **'Use this Help Center, contact support, or check our FAQ section.'**
  String get helpFaqGs5A;

  /// No description provided for @helpFaqAc1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I change my password?'**
  String get helpFaqAc1Q;

  /// No description provided for @helpFaqAc1A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Privacy & Security > Change Password to update your password.'**
  String get helpFaqAc1A;

  /// No description provided for @helpFaqAc2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update my email?'**
  String get helpFaqAc2Q;

  /// No description provided for @helpFaqAc2A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Profile to update your email address.'**
  String get helpFaqAc2A;

  /// No description provided for @helpFaqAc3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get helpFaqAc3Q;

  /// No description provided for @helpFaqAc3A.
  ///
  /// In en, this message translates to:
  /// **'Contact support to request account deletion. This action cannot be undone.'**
  String get helpFaqAc3A;

  /// No description provided for @helpFaqAc4Q.
  ///
  /// In en, this message translates to:
  /// **'How do I enable two-factor authentication?'**
  String get helpFaqAc4Q;

  /// No description provided for @helpFaqAc4A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Privacy & Security to enable 2FA for added security.'**
  String get helpFaqAc4A;

  /// No description provided for @helpFaqAc5Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update my profile picture?'**
  String get helpFaqAc5Q;

  /// No description provided for @helpFaqAc5A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Profile and tap on your profile picture to change it.'**
  String get helpFaqAc5A;

  /// No description provided for @helpFaqAc6Q.
  ///
  /// In en, this message translates to:
  /// **'How do I change my phone number?'**
  String get helpFaqAc6Q;

  /// No description provided for @helpFaqAc6A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Profile to update your phone number.'**
  String get helpFaqAc6A;

  /// No description provided for @helpFaqAc7Q.
  ///
  /// In en, this message translates to:
  /// **'How do I verify my account?'**
  String get helpFaqAc7Q;

  /// No description provided for @helpFaqAc7A.
  ///
  /// In en, this message translates to:
  /// **'Check your email for verification links and follow the instructions.'**
  String get helpFaqAc7A;

  /// No description provided for @helpFaqAc8Q.
  ///
  /// In en, this message translates to:
  /// **'How do I download my data?'**
  String get helpFaqAc8Q;

  /// No description provided for @helpFaqAc8A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Privacy & Security > Download Data to request your data.'**
  String get helpFaqAc8A;

  /// No description provided for @helpFaqBk1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I book an event?'**
  String get helpFaqBk1Q;

  /// No description provided for @helpFaqBk1A.
  ///
  /// In en, this message translates to:
  /// **'Browse events, select one, and tap \"Book Now\" to complete your booking.'**
  String get helpFaqBk1A;

  /// No description provided for @helpFaqBk2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel a booking?'**
  String get helpFaqBk2Q;

  /// No description provided for @helpFaqBk2A.
  ///
  /// In en, this message translates to:
  /// **'Go to My Bookings, find your booking, and tap \"Cancel Booking\".'**
  String get helpFaqBk2A;

  /// No description provided for @helpFaqBk3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I get my event tickets?'**
  String get helpFaqBk3Q;

  /// No description provided for @helpFaqBk3A.
  ///
  /// In en, this message translates to:
  /// **'Your tickets will be sent via email and available in the app.'**
  String get helpFaqBk3A;

  /// No description provided for @helpFaqBk4Q.
  ///
  /// In en, this message translates to:
  /// **'Can I book for multiple people?'**
  String get helpFaqBk4Q;

  /// No description provided for @helpFaqBk4A.
  ///
  /// In en, this message translates to:
  /// **'Yes, select the number of people when booking an event.'**
  String get helpFaqBk4A;

  /// No description provided for @helpFaqBk5Q.
  ///
  /// In en, this message translates to:
  /// **'How do I get a refund?'**
  String get helpFaqBk5Q;

  /// No description provided for @helpFaqBk5A.
  ///
  /// In en, this message translates to:
  /// **'Contact support for refund requests. Refund policy varies by event.'**
  String get helpFaqBk5A;

  /// No description provided for @helpFaqBk6Q.
  ///
  /// In en, this message translates to:
  /// **'How do I reschedule a booking?'**
  String get helpFaqBk6Q;

  /// No description provided for @helpFaqBk6A.
  ///
  /// In en, this message translates to:
  /// **'Cancel your current booking and book a new time slot.'**
  String get helpFaqBk6A;

  /// No description provided for @helpFaqBk7Q.
  ///
  /// In en, this message translates to:
  /// **'How do I check my booking status?'**
  String get helpFaqBk7Q;

  /// No description provided for @helpFaqBk7A.
  ///
  /// In en, this message translates to:
  /// **'Go to My Bookings to see all your reservations and their status.'**
  String get helpFaqBk7A;

  /// No description provided for @helpFaqBk8Q.
  ///
  /// In en, this message translates to:
  /// **'What if an event is cancelled?'**
  String get helpFaqBk8Q;

  /// No description provided for @helpFaqBk8A.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified and can request a full refund or transfer to another event.'**
  String get helpFaqBk8A;

  /// No description provided for @helpFaqBk9Q.
  ///
  /// In en, this message translates to:
  /// **'How do I book a hotel?'**
  String get helpFaqBk9Q;

  /// No description provided for @helpFaqBk9A.
  ///
  /// In en, this message translates to:
  /// **'Browse hotels in the Explore tab and follow the booking process.'**
  String get helpFaqBk9A;

  /// No description provided for @helpFaqBk10Q.
  ///
  /// In en, this message translates to:
  /// **'How do I book a tour?'**
  String get helpFaqBk10Q;

  /// No description provided for @helpFaqBk10A.
  ///
  /// In en, this message translates to:
  /// **'Find tours in the Explore tab and book them like events.'**
  String get helpFaqBk10A;

  /// No description provided for @helpFaqBk11Q.
  ///
  /// In en, this message translates to:
  /// **'How do I get directions to an event?'**
  String get helpFaqBk11Q;

  /// No description provided for @helpFaqBk11A.
  ///
  /// In en, this message translates to:
  /// **'Tap on the event location to open it in your maps app.'**
  String get helpFaqBk11A;

  /// No description provided for @helpFaqBk12Q.
  ///
  /// In en, this message translates to:
  /// **'How do I share an event?'**
  String get helpFaqBk12Q;

  /// No description provided for @helpFaqBk12A.
  ///
  /// In en, this message translates to:
  /// **'Tap the share button on any event to share it with friends.'**
  String get helpFaqBk12A;

  /// No description provided for @helpFaqPy1Q.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are accepted?'**
  String get helpFaqPy1Q;

  /// No description provided for @helpFaqPy1A.
  ///
  /// In en, this message translates to:
  /// **'We accept credit cards, mobile money, and bank transfers.'**
  String get helpFaqPy1A;

  /// No description provided for @helpFaqPy2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I add a payment method?'**
  String get helpFaqPy2Q;

  /// No description provided for @helpFaqPy2A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Payment Methods to add your preferred payment option.'**
  String get helpFaqPy2A;

  /// No description provided for @helpFaqPy3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I get a refund?'**
  String get helpFaqPy3Q;

  /// No description provided for @helpFaqPy3A.
  ///
  /// In en, this message translates to:
  /// **'Contact support with your booking details to request a refund.'**
  String get helpFaqPy3A;

  /// No description provided for @helpFaqPy4Q.
  ///
  /// In en, this message translates to:
  /// **'How long do refunds take?'**
  String get helpFaqPy4Q;

  /// No description provided for @helpFaqPy4A.
  ///
  /// In en, this message translates to:
  /// **'Refunds typically take 3-5 business days to process.'**
  String get helpFaqPy4A;

  /// No description provided for @helpFaqPy5Q.
  ///
  /// In en, this message translates to:
  /// **'Is my payment information secure?'**
  String get helpFaqPy5Q;

  /// No description provided for @helpFaqPy5A.
  ///
  /// In en, this message translates to:
  /// **'Yes, we use industry-standard encryption to protect your data.'**
  String get helpFaqPy5A;

  /// No description provided for @helpFaqPy6Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update my payment method?'**
  String get helpFaqPy6Q;

  /// No description provided for @helpFaqPy6A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Payment Methods to update your payment information.'**
  String get helpFaqPy6A;

  /// No description provided for @helpFaqTx1Q.
  ///
  /// In en, this message translates to:
  /// **'The app is not loading properly'**
  String get helpFaqTx1Q;

  /// No description provided for @helpFaqTx1A.
  ///
  /// In en, this message translates to:
  /// **'Try closing and reopening the app, or restart your device.'**
  String get helpFaqTx1A;

  /// No description provided for @helpFaqTx2Q.
  ///
  /// In en, this message translates to:
  /// **'I can\'t log in to my account'**
  String get helpFaqTx2Q;

  /// No description provided for @helpFaqTx2A.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and verify your login credentials.'**
  String get helpFaqTx2A;

  /// No description provided for @helpFaqTx3Q.
  ///
  /// In en, this message translates to:
  /// **'The app crashes frequently'**
  String get helpFaqTx3Q;

  /// No description provided for @helpFaqTx3A.
  ///
  /// In en, this message translates to:
  /// **'Update to the latest version of the app from your app store.'**
  String get helpFaqTx3A;

  /// No description provided for @helpFaqTx4Q.
  ///
  /// In en, this message translates to:
  /// **'I\'m not receiving notifications'**
  String get helpFaqTx4Q;

  /// No description provided for @helpFaqTx4A.
  ///
  /// In en, this message translates to:
  /// **'Check your notification settings in your device settings and app settings.'**
  String get helpFaqTx4A;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the Zoea Africa community'**
  String get registerSubtitle;

  /// No description provided for @registerInviteBanner.
  ///
  /// In en, this message translates to:
  /// **'You opened an invite link — we added the code below. You can change or paste a different code from a text or chat.'**
  String get registerInviteBanner;

  /// No description provided for @registerFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get registerFullNameHint;

  /// No description provided for @registerFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get registerFieldRequired;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get registerEmailHint;

  /// No description provided for @registerInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get registerInviteCodeLabel;

  /// No description provided for @registerInviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Paste if you have one'**
  String get registerInviteCodeHint;

  /// No description provided for @registerCodeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Code is too long'**
  String get registerCodeTooLong;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get registerConfirmPasswordRequired;

  /// No description provided for @registerPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordsMismatch;

  /// No description provided for @registerAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get registerAgreePrefix;

  /// No description provided for @registerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get registerTerms;

  /// No description provided for @registerAndConjunction.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get registerAndConjunction;

  /// No description provided for @registerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacy;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerAgreeTermsMessage.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Conditions'**
  String get registerAgreeTermsMessage;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsCurrentTheme.
  ///
  /// In en, this message translates to:
  /// **'Current Theme'**
  String get settingsCurrentTheme;

  /// No description provided for @commonViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get commonViewDetails;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get commonLoadMore;

  /// No description provided for @mapScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapScreenTitle;

  /// No description provided for @transactionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get transactionHistoryTitle;

  /// No description provided for @itineraryAddFromFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Add from favorites'**
  String get itineraryAddFromFavoritesTitle;

  /// No description provided for @shopSearchProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get shopSearchProductsTitle;

  /// No description provided for @shopClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get shopClearFilters;

  /// No description provided for @webviewOpenInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get webviewOpenInBrowser;

  /// No description provided for @commonViewEvent.
  ///
  /// In en, this message translates to:
  /// **'View event'**
  String get commonViewEvent;

  /// No description provided for @commonViewPlace.
  ///
  /// In en, this message translates to:
  /// **'View place'**
  String get commonViewPlace;

  /// No description provided for @mapScreenHeadline.
  ///
  /// In en, this message translates to:
  /// **'Map view'**
  String get mapScreenHeadline;

  /// No description provided for @mapScreenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Interactive map with listings will be implemented here'**
  String get mapScreenPlaceholder;

  /// No description provided for @transactionHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your payment and transaction history'**
  String get transactionHistorySubtitle;

  /// No description provided for @itineraryAddWithCount.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String itineraryAddWithCount(int count);

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any favorites yet'**
  String get favoritesEmptySubtitle;

  /// No description provided for @favoritesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorites'**
  String get favoritesLoadError;

  /// No description provided for @splashHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Discover Rwanda'**
  String get splashHeadline1;

  /// No description provided for @splashHeadline2.
  ///
  /// In en, this message translates to:
  /// **'Like Never Before'**
  String get splashHeadline2;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Explore stunning destinations, authentic experiences, and hidden gems across the Land of a Thousand Hills.'**
  String get splashTagline;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Rwanda'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the land of a thousand hills with verified experiences'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Book seamlessly'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve hotels, restaurants, and tours with your Zoea Card'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Connect & share'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the community and share your Rwandan adventures'**
  String get onboardingPage3Subtitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSkipGuest.
  ///
  /// In en, this message translates to:
  /// **'Skip — browse as guest'**
  String get onboardingSkipGuest;

  /// No description provided for @onboardingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get onboardingSignInPrompt;

  /// No description provided for @countryPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search'**
  String get countryPickerSearchHint;

  /// No description provided for @authResetPasswordAppBar.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordAppBar;

  /// No description provided for @authChooseResetMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to reset your password'**
  String get authChooseResetMethod;

  /// No description provided for @authResetCodeSentDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset code sent successfully'**
  String get authResetCodeSentDefault;

  /// No description provided for @authSendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get authSendResetCode;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authBackToLogin;

  /// No description provided for @authVerifyCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get authVerifyCodeTitle;

  /// No description provided for @authEnterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter reset code'**
  String get authEnterResetCode;

  /// No description provided for @authResetCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a {digits}-digit code to {identifier}'**
  String authResetCodeSentTo(int digits, String identifier);

  /// No description provided for @authVerifyCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get authVerifyCodeButton;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authResendSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get authResendSending;

  /// No description provided for @authResendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String authResendCodeIn(String time);

  /// No description provided for @authNewPasswordAppBar.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordAppBar;

  /// No description provided for @authCreateNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get authCreateNewPasswordTitle;

  /// No description provided for @authCreateNewPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password. Make sure it\'s strong and secure.'**
  String get authCreateNewPasswordBody;

  /// No description provided for @authNewPasswordFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordFieldLabel;

  /// No description provided for @authNewPasswordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get authNewPasswordFieldHint;

  /// No description provided for @authConfirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get authConfirmNewPasswordHint;

  /// No description provided for @authEnterNewPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get authEnterNewPasswordError;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get authPasswordResetSuccess;

  /// No description provided for @authSaveNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get authSaveNewPassword;

  /// No description provided for @authNewCodeRequested.
  ///
  /// In en, this message translates to:
  /// **'A new code has been requested.'**
  String get authNewCodeRequested;

  /// No description provided for @authPhoneNumberExample.
  ///
  /// In en, this message translates to:
  /// **'780 123 456'**
  String get authPhoneNumberExample;

  /// No description provided for @shopScreenTitleShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopScreenTitleShop;

  /// No description provided for @shopScreenTitleProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get shopScreenTitleProducts;

  /// No description provided for @shopProductCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String shopProductCount(int count);

  /// No description provided for @shopSortLine.
  ///
  /// In en, this message translates to:
  /// **'Sort: {label}'**
  String shopSortLine(String label);

  /// No description provided for @shopEmptyNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get shopEmptyNoProducts;

  /// No description provided for @shopEmptyAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search'**
  String get shopEmptyAdjustFilters;

  /// No description provided for @shopErrorLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get shopErrorLoadProducts;

  /// No description provided for @shopOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get shopOutOfStock;

  /// No description provided for @shopFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter products'**
  String get shopFilterTitle;

  /// No description provided for @shopStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get shopStatusSection;

  /// No description provided for @shopFeaturedSection.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get shopFeaturedSection;

  /// No description provided for @shopFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get shopFilterActive;

  /// No description provided for @shopFilterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get shopFilterInactive;

  /// No description provided for @shopFeaturedOnly.
  ///
  /// In en, this message translates to:
  /// **'Featured only'**
  String get shopFeaturedOnly;

  /// No description provided for @shopFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get shopFilterReset;

  /// No description provided for @shopSearchProductNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product name…'**
  String get shopSearchProductNameHint;

  /// No description provided for @shopSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get shopSortPopular;

  /// No description provided for @shopSortNameAz.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get shopSortNameAz;

  /// No description provided for @shopSortNameZa.
  ///
  /// In en, this message translates to:
  /// **'Name (Z–A)'**
  String get shopSortNameZa;

  /// No description provided for @shopSortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price (low to high)'**
  String get shopSortPriceLowHigh;

  /// No description provided for @shopSortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price (high to low)'**
  String get shopSortPriceHighLow;

  /// No description provided for @shopSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get shopSortNewest;

  /// No description provided for @favoritesEmptyAllTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyAllTitle;

  /// No description provided for @favoritesEmptyAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save your favorite events and places'**
  String get favoritesEmptyAllSubtitle;

  /// No description provided for @favoritesEmptyExploreCta.
  ///
  /// In en, this message translates to:
  /// **'Explore now'**
  String get favoritesEmptyExploreCta;

  /// No description provided for @favoritesEmptyEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorite events'**
  String get favoritesEmptyEventsTitle;

  /// No description provided for @favoritesEmptyEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save events you\'re interested in to see them here'**
  String get favoritesEmptyEventsSubtitle;

  /// No description provided for @favoritesEmptyEventsCta.
  ///
  /// In en, this message translates to:
  /// **'Browse events'**
  String get favoritesEmptyEventsCta;

  /// No description provided for @favoritesEmptyPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorite places'**
  String get favoritesEmptyPlacesTitle;

  /// No description provided for @favoritesEmptyPlacesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save places you want to visit to see them here'**
  String get favoritesEmptyPlacesSubtitle;

  /// No description provided for @favoritesEmptyPlacesCta.
  ///
  /// In en, this message translates to:
  /// **'Explore places'**
  String get favoritesEmptyPlacesCta;

  /// No description provided for @favoritesRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoritesRemoveTitle;

  /// No description provided for @favoritesRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\" from your favorites?'**
  String favoritesRemoveMessage(String name);

  /// No description provided for @favoritesRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove favorite: {error}'**
  String favoritesRemoveFailed(String error);

  /// No description provided for @favoritesTypeEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get favoritesTypeEvent;

  /// No description provided for @favoritesTypePlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get favoritesTypePlace;

  /// No description provided for @favoritesDateTba.
  ///
  /// In en, this message translates to:
  /// **'Date TBA'**
  String get favoritesDateTba;

  /// No description provided for @categoryTitleDining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get categoryTitleDining;

  /// No description provided for @categoryTitleNightlife.
  ///
  /// In en, this message translates to:
  /// **'Nightlife'**
  String get categoryTitleNightlife;

  /// No description provided for @categoryTitleExperiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get categoryTitleExperiences;

  /// No description provided for @categoryTitlePlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get categoryTitlePlaces;

  /// No description provided for @categorySearchAppBar.
  ///
  /// In en, this message translates to:
  /// **'Search {categoryName}'**
  String categorySearchAppBar(String categoryName);

  /// No description provided for @categorySearchHintDining.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants, cafés…'**
  String get categorySearchHintDining;

  /// No description provided for @categorySearchHintNightlife.
  ///
  /// In en, this message translates to:
  /// **'Search bars, clubs, lounges…'**
  String get categorySearchHintNightlife;

  /// No description provided for @categorySearchHintExperiences.
  ///
  /// In en, this message translates to:
  /// **'Search tours, adventures, experiences…'**
  String get categorySearchHintExperiences;

  /// No description provided for @categorySearchHintDefault.
  ///
  /// In en, this message translates to:
  /// **'Search places…'**
  String get categorySearchHintDefault;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get categoryNotFound;

  /// No description provided for @categoryErrorListings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listings'**
  String get categoryErrorListings;

  /// No description provided for @categoryErrorCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load category'**
  String get categoryErrorCategory;

  /// No description provided for @categoryEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for {categoryName}'**
  String categoryEmptyPrompt(String categoryName);

  /// No description provided for @categoryEmptyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get categoryEmptyNoResults;

  /// No description provided for @categoryEmptyTryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or categories'**
  String get categoryEmptyTryDifferentKeywords;

  /// No description provided for @categorySearchSuggestionsDining.
  ///
  /// In en, this message translates to:
  /// **'Try searching for \"pizza\", \"coffee\", or \"sushi\"'**
  String get categorySearchSuggestionsDining;

  /// No description provided for @categorySearchSuggestionsNightlife.
  ///
  /// In en, this message translates to:
  /// **'Try searching for \"bar\", \"club\", or \"lounge\"'**
  String get categorySearchSuggestionsNightlife;

  /// No description provided for @categorySearchSuggestionsExperiences.
  ///
  /// In en, this message translates to:
  /// **'Try searching for \"gorilla\", \"hiking\", or \"cultural\"'**
  String get categorySearchSuggestionsExperiences;

  /// No description provided for @categorySearchSuggestionsDefault.
  ///
  /// In en, this message translates to:
  /// **'Try searching for specific places or locations'**
  String get categorySearchSuggestionsDefault;

  /// No description provided for @categoryFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter {categoryName}'**
  String categoryFilterSheetTitle(String categoryName);

  /// No description provided for @categorySortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort {categoryName}'**
  String categorySortSheetTitle(String categoryName);

  /// No description provided for @categorySectionPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get categorySectionPriceRange;

  /// No description provided for @categorySectionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get categorySectionFeatures;

  /// No description provided for @categoryRatingStars40.
  ///
  /// In en, this message translates to:
  /// **'4.0+ stars'**
  String get categoryRatingStars40;

  /// No description provided for @categoryRatingStars45.
  ///
  /// In en, this message translates to:
  /// **'4.5+ stars'**
  String get categoryRatingStars45;

  /// No description provided for @categoryRatingStars50.
  ///
  /// In en, this message translates to:
  /// **'5.0 stars'**
  String get categoryRatingStars50;

  /// No description provided for @catTourOperatorBadge.
  ///
  /// In en, this message translates to:
  /// **'Tour operator'**
  String get catTourOperatorBadge;

  /// No description provided for @listingReviewsCountParen.
  ///
  /// In en, this message translates to:
  /// **'({count, plural, =1{1 review} other{{count} reviews}})'**
  String listingReviewsCountParen(int count);

  /// No description provided for @catSubDiningRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get catSubDiningRestaurants;

  /// No description provided for @catSubDiningCafes.
  ///
  /// In en, this message translates to:
  /// **'Cafés'**
  String get catSubDiningCafes;

  /// No description provided for @catSubDiningFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get catSubDiningFastFood;

  /// No description provided for @catSubNightBars.
  ///
  /// In en, this message translates to:
  /// **'Bars'**
  String get catSubNightBars;

  /// No description provided for @catSubNightClubs.
  ///
  /// In en, this message translates to:
  /// **'Clubs'**
  String get catSubNightClubs;

  /// No description provided for @catSubNightLounges.
  ///
  /// In en, this message translates to:
  /// **'Lounges'**
  String get catSubNightLounges;

  /// No description provided for @catSubExpTours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get catSubExpTours;

  /// No description provided for @catSubExpAdventures.
  ///
  /// In en, this message translates to:
  /// **'Adventures'**
  String get catSubExpAdventures;

  /// No description provided for @catSubExpCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get catSubExpCultural;

  /// No description provided for @catSubExpOperators.
  ///
  /// In en, this message translates to:
  /// **'Operators'**
  String get catSubExpOperators;

  /// No description provided for @catPriceDiningU5k.
  ///
  /// In en, this message translates to:
  /// **'Under RWF 5,000'**
  String get catPriceDiningU5k;

  /// No description provided for @catPriceDining5to15k.
  ///
  /// In en, this message translates to:
  /// **'RWF 5,000 – 15,000'**
  String get catPriceDining5to15k;

  /// No description provided for @catPriceDining15to30k.
  ///
  /// In en, this message translates to:
  /// **'RWF 15,000 – 30,000'**
  String get catPriceDining15to30k;

  /// No description provided for @catPriceDiningOver30k.
  ///
  /// In en, this message translates to:
  /// **'Above RWF 30,000'**
  String get catPriceDiningOver30k;

  /// No description provided for @catPriceNightU10k.
  ///
  /// In en, this message translates to:
  /// **'Under RWF 10,000'**
  String get catPriceNightU10k;

  /// No description provided for @catPriceNight10to20k.
  ///
  /// In en, this message translates to:
  /// **'RWF 10,000 – 20,000'**
  String get catPriceNight10to20k;

  /// No description provided for @catPriceNight20to30k.
  ///
  /// In en, this message translates to:
  /// **'RWF 20,000 – 30,000'**
  String get catPriceNight20to30k;

  /// No description provided for @catPriceNightOver30k.
  ///
  /// In en, this message translates to:
  /// **'Above RWF 30,000'**
  String get catPriceNightOver30k;

  /// No description provided for @catPriceExpU50k.
  ///
  /// In en, this message translates to:
  /// **'Under RWF 50,000'**
  String get catPriceExpU50k;

  /// No description provided for @catPriceExp50to100k.
  ///
  /// In en, this message translates to:
  /// **'RWF 50,000 – 100,000'**
  String get catPriceExp50to100k;

  /// No description provided for @catPriceExp100to200k.
  ///
  /// In en, this message translates to:
  /// **'RWF 100,000 – 200,000'**
  String get catPriceExp100to200k;

  /// No description provided for @catPriceExpOver200k.
  ///
  /// In en, this message translates to:
  /// **'Above RWF 200,000'**
  String get catPriceExpOver200k;

  /// No description provided for @catPriceDefU10k.
  ///
  /// In en, this message translates to:
  /// **'Under RWF 10,000'**
  String get catPriceDefU10k;

  /// No description provided for @catPriceDef10to30k.
  ///
  /// In en, this message translates to:
  /// **'RWF 10,000 – 30,000'**
  String get catPriceDef10to30k;

  /// No description provided for @catPriceDefOver30k.
  ///
  /// In en, this message translates to:
  /// **'Above RWF 30,000'**
  String get catPriceDefOver30k;

  /// No description provided for @catFeatDiningWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get catFeatDiningWifi;

  /// No description provided for @catFeatDiningParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get catFeatDiningParking;

  /// No description provided for @catFeatDiningOutdoorSeating.
  ///
  /// In en, this message translates to:
  /// **'Outdoor seating'**
  String get catFeatDiningOutdoorSeating;

  /// No description provided for @catFeatDiningDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get catFeatDiningDelivery;

  /// No description provided for @catFeatDiningTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get catFeatDiningTakeaway;

  /// No description provided for @catFeatDiningVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian options'**
  String get catFeatDiningVegetarian;

  /// No description provided for @catFeatNightLiveMusic.
  ///
  /// In en, this message translates to:
  /// **'Live music'**
  String get catFeatNightLiveMusic;

  /// No description provided for @catFeatNightDanceFloor.
  ///
  /// In en, this message translates to:
  /// **'Dance floor'**
  String get catFeatNightDanceFloor;

  /// No description provided for @catFeatNightOutdoorSeating.
  ///
  /// In en, this message translates to:
  /// **'Outdoor seating'**
  String get catFeatNightOutdoorSeating;

  /// No description provided for @catFeatNightVip.
  ///
  /// In en, this message translates to:
  /// **'VIP section'**
  String get catFeatNightVip;

  /// No description provided for @catFeatNightParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get catFeatNightParking;

  /// No description provided for @catFeatNightWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get catFeatNightWifi;

  /// No description provided for @catFeatExpGuidedTours.
  ///
  /// In en, this message translates to:
  /// **'Guided tours'**
  String get catFeatExpGuidedTours;

  /// No description provided for @catFeatExpTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport included'**
  String get catFeatExpTransport;

  /// No description provided for @catFeatExpMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals included'**
  String get catFeatExpMeals;

  /// No description provided for @catFeatExpEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment provided'**
  String get catFeatExpEquipment;

  /// No description provided for @catFeatExpGroup.
  ///
  /// In en, this message translates to:
  /// **'Group tours'**
  String get catFeatExpGroup;

  /// No description provided for @catFeatExpPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private tours'**
  String get catFeatExpPrivate;

  /// No description provided for @catFeatDefWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get catFeatDefWifi;

  /// No description provided for @catFeatDefParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get catFeatDefParking;

  /// No description provided for @catFeatDefAccessible.
  ///
  /// In en, this message translates to:
  /// **'Accessible'**
  String get catFeatDefAccessible;

  /// No description provided for @exploreApplySort.
  ///
  /// In en, this message translates to:
  /// **'Apply sort'**
  String get exploreApplySort;

  /// No description provided for @exploreCategoryNotFoundShort.
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get exploreCategoryNotFoundShort;

  /// No description provided for @commonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get commonSignIn;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get commonMaybeLater;

  /// No description provided for @commonGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get commonGoBack;

  /// No description provided for @commonStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get commonStartShopping;

  /// No description provided for @commonContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get commonContinueShopping;

  /// No description provided for @commonFavoriteVerb.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get commonFavoriteVerb;

  /// No description provided for @commonBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get commonBookNow;

  /// No description provided for @commonOrderNow.
  ///
  /// In en, this message translates to:
  /// **'Order now'**
  String get commonOrderNow;

  /// No description provided for @commonContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get commonContact;

  /// No description provided for @commonReserveTable.
  ///
  /// In en, this message translates to:
  /// **'Reserve table'**
  String get commonReserveTable;

  /// No description provided for @commonWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write review'**
  String get commonWriteReview;

  /// No description provided for @commonViewAllProducts.
  ///
  /// In en, this message translates to:
  /// **'View all products'**
  String get commonViewAllProducts;

  /// No description provided for @commonViewAllServices.
  ///
  /// In en, this message translates to:
  /// **'View all services'**
  String get commonViewAllServices;

  /// No description provided for @commonViewMenu.
  ///
  /// In en, this message translates to:
  /// **'View menu'**
  String get commonViewMenu;

  /// No description provided for @commonViewMenus.
  ///
  /// In en, this message translates to:
  /// **'View menus'**
  String get commonViewMenus;

  /// No description provided for @commonSelectVariant.
  ///
  /// In en, this message translates to:
  /// **'Select a variant'**
  String get commonSelectVariant;

  /// No description provided for @commonShareReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Share referral code'**
  String get commonShareReferralCode;

  /// No description provided for @commonCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete profile'**
  String get commonCompleteProfile;

  /// No description provided for @commonLinkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link. Try again later.'**
  String get commonLinkOpenFailed;

  /// No description provided for @commonCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully!'**
  String get commonCouponApplied;

  /// No description provided for @commonCouponInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code'**
  String get commonCouponInvalid;

  /// No description provided for @commonBookingNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Booking is not available for this listing type'**
  String get commonBookingNotAvailable;

  /// No description provided for @commonFailedLoadListing.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listing: {error}'**
  String commonFailedLoadListing(String error);

  /// No description provided for @commonFailedCreateBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking: {error}'**
  String commonFailedCreateBooking(String error);

  /// No description provided for @commonFailedBookTour.
  ///
  /// In en, this message translates to:
  /// **'Failed to book tour: {error}'**
  String commonFailedBookTour(String error);

  /// No description provided for @commonFailedBookService.
  ///
  /// In en, this message translates to:
  /// **'Failed to book service: {error}'**
  String commonFailedBookService(String error);

  /// No description provided for @commonFailedAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add to cart: {error}'**
  String commonFailedAddToCart(String error);

  /// No description provided for @commonFailedUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String commonFailedUpdate(String error);

  /// No description provided for @commonFailedRemove.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove: {error}'**
  String commonFailedRemove(String error);

  /// No description provided for @commonFailedClearCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cart: {error}'**
  String commonFailedClearCart(String error);

  /// No description provided for @commonFailedPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order: {error}'**
  String commonFailedPlaceOrder(String error);

  /// No description provided for @commonFailedShare.
  ///
  /// In en, this message translates to:
  /// **'Failed to share: {error}'**
  String commonFailedShare(String error);

  /// No description provided for @commonProductAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart'**
  String get commonProductAddedToCart;

  /// No description provided for @commonItemAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Item added to cart'**
  String get commonItemAddedToCart;

  /// No description provided for @commonPleaseSelectTourSchedule.
  ///
  /// In en, this message translates to:
  /// **'Please select a tour and schedule'**
  String get commonPleaseSelectTourSchedule;

  /// No description provided for @commonPleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get commonPleaseFillRequiredFields;

  /// No description provided for @commonBookingMissingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Booking created, but confirmation ID is missing.'**
  String get commonBookingMissingConfirmation;

  /// No description provided for @commonPleaseSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get commonPleaseSelectDateTime;

  /// No description provided for @commonServiceBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service booked successfully!'**
  String get commonServiceBookedSuccess;

  /// No description provided for @commonPleaseWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Please write a review before submitting'**
  String get commonPleaseWriteReview;

  /// No description provided for @commonPleaseWriteReviewUpdate.
  ///
  /// In en, this message translates to:
  /// **'Please write a review before updating'**
  String get commonPleaseWriteReviewUpdate;

  /// No description provided for @commonReviewSubmitMissingContext.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit review. Missing listing, event, or tour information.'**
  String get commonReviewSubmitMissingContext;

  /// No description provided for @commonThankYouReview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get commonThankYouReview;

  /// No description provided for @commonReviewUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review updated successfully!'**
  String get commonReviewUpdatedSuccess;

  /// No description provided for @commonCheckInOutRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select check-in and check-out dates'**
  String get commonCheckInOutRequired;

  /// No description provided for @commonCheckOutAfterCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-out date must be after check-in date'**
  String get commonCheckOutAfterCheckIn;

  /// No description provided for @commonSelectRoomType.
  ///
  /// In en, this message translates to:
  /// **'Please select a room type to continue'**
  String get commonSelectRoomType;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get cartTitle;

  /// No description provided for @cartClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from your cart?'**
  String get cartClearConfirm;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyMessage;

  /// No description provided for @checkoutFulfillmentPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get checkoutFulfillmentPickup;

  /// No description provided for @checkoutFulfillmentPickupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Collect from store'**
  String get checkoutFulfillmentPickupSubtitle;

  /// No description provided for @checkoutFulfillmentDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get checkoutFulfillmentDelivery;

  /// No description provided for @checkoutFulfillmentDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delivered to your address'**
  String get checkoutFulfillmentDeliverySubtitle;

  /// No description provided for @checkoutFulfillmentDineIn.
  ///
  /// In en, this message translates to:
  /// **'Dine in'**
  String get checkoutFulfillmentDineIn;

  /// No description provided for @checkoutFulfillmentDineInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Eat at the restaurant'**
  String get checkoutFulfillmentDineInSubtitle;

  /// No description provided for @checkoutUnableListing.
  ///
  /// In en, this message translates to:
  /// **'Unable to determine listing'**
  String get checkoutUnableListing;

  /// No description provided for @shopSearchServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Search services'**
  String get shopSearchServicesTitle;

  /// No description provided for @shopServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get shopServicesTitle;

  /// No description provided for @referralScreenShareCta.
  ///
  /// In en, this message translates to:
  /// **'Share referral code'**
  String get referralScreenShareCta;

  /// No description provided for @zoeaCardScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Zoea Card'**
  String get zoeaCardScreenTitle;

  /// No description provided for @itinerariesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Itineraries'**
  String get itinerariesScreenTitle;

  /// No description provided for @itinerariesMyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My itineraries'**
  String get itinerariesMyScreenTitle;

  /// No description provided for @itineraryCreateFab.
  ///
  /// In en, this message translates to:
  /// **'Create itinerary'**
  String get itineraryCreateFab;

  /// No description provided for @itineraryDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get itineraryDetailTitle;

  /// No description provided for @itineraryViewCta.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get itineraryViewCta;

  /// No description provided for @itineraryMakePublicTitle.
  ///
  /// In en, this message translates to:
  /// **'Make public'**
  String get itineraryMakePublicTitle;

  /// No description provided for @itineraryMakePublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow others to view this itinerary'**
  String get itineraryMakePublicSubtitle;

  /// No description provided for @itineraryAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itineraryAddItem;

  /// No description provided for @itineraryFromFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'From favorites'**
  String get itineraryFromFavoritesTitle;

  /// No description provided for @itineraryFromFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add from your saved favorites'**
  String get itineraryFromFavoritesSubtitle;

  /// No description provided for @itineraryFromRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'From recommendations'**
  String get itineraryFromRecommendationsTitle;

  /// No description provided for @itineraryFromRecommendationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add from recommended places'**
  String get itineraryFromRecommendationsSubtitle;

  /// No description provided for @itineraryCustomItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom item'**
  String get itineraryCustomItemTitle;

  /// No description provided for @itineraryCustomItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a custom location or activity'**
  String get itineraryCustomItemSubtitle;

  /// No description provided for @itineraryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete itinerary'**
  String get itineraryDeleteTitle;

  /// No description provided for @itineraryDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this itinerary? This action cannot be undone.'**
  String get itineraryDeleteMessage;

  /// No description provided for @itineraryDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary deleted successfully'**
  String get itineraryDeletedSuccess;

  /// No description provided for @itineraryAddCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Add custom item'**
  String get itineraryAddCustomTitle;

  /// No description provided for @itineraryCustomNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get itineraryCustomNameRequired;

  /// No description provided for @itineraryAddFromRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add from recommendations'**
  String get itineraryAddFromRecommendationsTitle;

  /// No description provided for @reviewsEventComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Event detail page coming soon'**
  String get reviewsEventComingSoon;

  /// No description provided for @reviewsTourComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Tour detail page coming soon'**
  String get reviewsTourComingSoon;

  /// No description provided for @tourDetailGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get tourDetailGoBack;

  /// No description provided for @eventsAttendedViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get eventsAttendedViewDetails;

  /// No description provided for @visitedPlacesViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get visitedPlacesViewDetails;

  /// No description provided for @appUpdateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get appUpdateRequiredTitle;

  /// No description provided for @appUpdateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update the app to continue using Zoea.'**
  String get appUpdateRequiredMessage;

  /// No description provided for @appUpdateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get appUpdateAvailableTitle;

  /// No description provided for @appUpdateAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of Zoea is ready with improvements and fixes.'**
  String get appUpdateAvailableMessage;

  /// No description provided for @appUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get appUpdateNow;

  /// No description provided for @appUpdateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get appUpdateLater;

  /// No description provided for @appUpdateStoreOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the store link'**
  String get appUpdateStoreOpenFailed;

  /// No description provided for @privacySectionPrivacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings'**
  String get privacySectionPrivacySettings;

  /// No description provided for @privacyLocationServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Location services'**
  String get privacyLocationServicesTitle;

  /// No description provided for @privacyLocationServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow the app to use your location for better recommendations'**
  String get privacyLocationServicesSubtitle;

  /// No description provided for @privacyPushNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get privacyPushNotificationsTitle;

  /// No description provided for @privacyPushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about events and updates'**
  String get privacyPushNotificationsSubtitle;

  /// No description provided for @privacyDataSharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data sharing'**
  String get privacyDataSharingTitle;

  /// No description provided for @privacyDataSharingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous data to improve the app experience'**
  String get privacyDataSharingSubtitle;

  /// No description provided for @privacyAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get privacyAnalyticsTitle;

  /// No description provided for @privacyAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app with usage analytics'**
  String get privacyAnalyticsSubtitle;

  /// No description provided for @privacyAnalyticsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics enabled'**
  String get privacyAnalyticsEnabled;

  /// No description provided for @privacyAnalyticsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics disabled'**
  String get privacyAnalyticsDisabled;

  /// No description provided for @privacyAnalyticsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update analytics settings'**
  String get privacyAnalyticsUpdateFailed;

  /// No description provided for @privacyAnalyticsLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get privacyAnalyticsLoadingSubtitle;

  /// No description provided for @privacySectionDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & privacy'**
  String get privacySectionDataPrivacy;

  /// No description provided for @privacyWhatDataTitle.
  ///
  /// In en, this message translates to:
  /// **'What data we collect'**
  String get privacyWhatDataTitle;

  /// No description provided for @privacyWhatDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See what information is collected and why'**
  String get privacyWhatDataSubtitle;

  /// No description provided for @privacyClearAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear analytics data'**
  String get privacyClearAnalyticsTitle;

  /// No description provided for @privacyClearAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all stored analytics data'**
  String get privacyClearAnalyticsSubtitle;

  /// No description provided for @privacySectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security settings'**
  String get privacySectionSecurity;

  /// No description provided for @privacyBiometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get privacyBiometricTitle;

  /// No description provided for @privacyBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face recognition to unlock'**
  String get privacyBiometricSubtitle;

  /// No description provided for @privacyTwoFactorTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get privacyTwoFactorTitle;

  /// No description provided for @privacyTwoFactorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security to your account'**
  String get privacyTwoFactorSubtitle;

  /// No description provided for @privacyChangePasswordTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get privacyChangePasswordTileTitle;

  /// No description provided for @privacyChangePasswordTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get privacyChangePasswordTileSubtitle;

  /// No description provided for @privacyEmailVerificationTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get privacyEmailVerificationTileTitle;

  /// No description provided for @privacyEmailVerificationTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address'**
  String get privacyEmailVerificationTileSubtitle;

  /// No description provided for @privacyPhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone verified'**
  String get privacyPhoneVerified;

  /// No description provided for @privacyPhoneAddVerify.
  ///
  /// In en, this message translates to:
  /// **'Add and verify your phone number'**
  String get privacyPhoneAddVerify;

  /// No description provided for @privacyPhoneVerificationTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone verification'**
  String get privacyPhoneVerificationTileTitle;

  /// No description provided for @privacySectionAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account management'**
  String get privacySectionAccountManagement;

  /// No description provided for @privacyDownloadDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get privacyDownloadDataTitle;

  /// No description provided for @privacyDownloadDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a copy of your personal data'**
  String get privacyDownloadDataSubtitle;

  /// No description provided for @privacyDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get privacyDeleteAccountTitle;

  /// No description provided for @privacyDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get privacyDeleteAccountSubtitle;

  /// No description provided for @privacySectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get privacySectionLegal;

  /// No description provided for @privacyPolicyTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyTileTitle;

  /// No description provided for @privacyPolicyTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacyPolicyTileSubtitle;

  /// No description provided for @privacyTermsTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get privacyTermsTileTitle;

  /// No description provided for @privacyTermsTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get privacyTermsTileSubtitle;

  /// No description provided for @privacyChangePasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get privacyChangePasswordDialogTitle;

  /// No description provided for @privacyCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get privacyCurrentPasswordLabel;

  /// No description provided for @privacyCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get privacyCurrentPasswordHint;

  /// No description provided for @privacyCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get privacyCurrentPasswordRequired;

  /// No description provided for @privacyNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get privacyNewPasswordLabel;

  /// No description provided for @privacyNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get privacyNewPasswordHint;

  /// No description provided for @privacyNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get privacyNewPasswordRequired;

  /// No description provided for @privacyPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get privacyPasswordMinLength;

  /// No description provided for @privacyConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get privacyConfirmPasswordLabel;

  /// No description provided for @privacyConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get privacyConfirmPasswordHint;

  /// No description provided for @privacyConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get privacyConfirmPasswordRequired;

  /// No description provided for @privacyPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get privacyPasswordsMismatch;

  /// No description provided for @privacyPasswordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get privacyPasswordChangedSuccess;

  /// No description provided for @privacyPasswordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Please try again.'**
  String get privacyPasswordChangeFailed;

  /// No description provided for @privacyEmailVerificationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get privacyEmailVerificationDialogTitle;

  /// No description provided for @privacyEmailVerificationDialogBody.
  ///
  /// In en, this message translates to:
  /// **'A verification email will be sent to your registered email address.'**
  String get privacyEmailVerificationDialogBody;

  /// No description provided for @privacyVerificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent!'**
  String get privacyVerificationEmailSent;

  /// No description provided for @privacySendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get privacySendEmail;

  /// No description provided for @privacyPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get privacyPhoneInvalid;

  /// No description provided for @privacyPhoneCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code by SMS.'**
  String get privacyPhoneCodeSent;

  /// No description provided for @privacyPhoneEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get privacyPhoneEnterCode;

  /// No description provided for @privacyPhoneVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified'**
  String get privacyPhoneVerifiedSuccess;

  /// No description provided for @privacyPhoneVerificationIntro.
  ///
  /// In en, this message translates to:
  /// **'We will send a code to confirm this number.'**
  String get privacyPhoneVerificationIntro;

  /// No description provided for @myBookingsKeepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get myBookingsKeepBooking;

  /// No description provided for @myBookingsCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get myBookingsCancelBooking;

  /// No description provided for @editProfileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get editProfileConfirm;

  /// No description provided for @privacyPhoneMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get privacyPhoneMobileLabel;

  /// No description provided for @privacySendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get privacySendCode;

  /// No description provided for @privacyVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get privacyVerify;

  /// No description provided for @privacyDownloadDataDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get privacyDownloadDataDialogTitle;

  /// No description provided for @privacyDownloadDataDialogBody.
  ///
  /// In en, this message translates to:
  /// **'We will prepare your data and send it to your email address within 24 hours.'**
  String get privacyDownloadDataDialogBody;

  /// No description provided for @privacyDownloadDataSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Data download request submitted!'**
  String get privacyDownloadDataSubmitted;

  /// No description provided for @privacyRequestData.
  ///
  /// In en, this message translates to:
  /// **'Request data'**
  String get privacyRequestData;

  /// No description provided for @privacyDeleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get privacyDeleteAccountDialogTitle;

  /// No description provided for @privacyDeleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get privacyDeleteAccountDialogBody;

  /// No description provided for @privacyDeleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get privacyDeleteForever;

  /// No description provided for @privacyAccountDeletionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Account deletion feature coming soon!'**
  String get privacyAccountDeletionComingSoon;

  /// No description provided for @privacyFinalConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Final confirmation'**
  String get privacyFinalConfirmationTitle;

  /// No description provided for @privacyFinalConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure? This will permanently delete your account and all associated data.'**
  String get privacyFinalConfirmationBody;

  /// No description provided for @privacyWhatDataCollectSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'What data we collect'**
  String get privacyWhatDataCollectSheetTitle;

  /// No description provided for @privacyDataProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile information'**
  String get privacyDataProfileTitle;

  /// No description provided for @privacyDataProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Country, language, age range, gender, interests, travel preferences'**
  String get privacyDataProfileDescription;

  /// No description provided for @privacyDataProfilePurpose.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience and recommendations'**
  String get privacyDataProfilePurpose;

  /// No description provided for @privacyDataSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search queries'**
  String get privacyDataSearchTitle;

  /// No description provided for @privacyDataSearchDescription.
  ///
  /// In en, this message translates to:
  /// **'What you search for in the app'**
  String get privacyDataSearchDescription;

  /// No description provided for @privacyDataSearchPurpose.
  ///
  /// In en, this message translates to:
  /// **'Improve search results and suggest relevant content'**
  String get privacyDataSearchPurpose;

  /// No description provided for @privacyDataViewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Content views'**
  String get privacyDataViewsTitle;

  /// No description provided for @privacyDataViewsDescription.
  ///
  /// In en, this message translates to:
  /// **'Places and events you view'**
  String get privacyDataViewsDescription;

  /// No description provided for @privacyDataViewsPurpose.
  ///
  /// In en, this message translates to:
  /// **'Understand your interests and improve recommendations'**
  String get privacyDataViewsPurpose;

  /// No description provided for @privacyDataUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'App usage'**
  String get privacyDataUsageTitle;

  /// No description provided for @privacyDataUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'How you use the app, session duration, features used'**
  String get privacyDataUsageDescription;

  /// No description provided for @privacyDataUsagePurpose.
  ///
  /// In en, this message translates to:
  /// **'Improve app performance and user experience'**
  String get privacyDataUsagePurpose;

  /// No description provided for @privacyDataAnonymizedFootnote.
  ///
  /// In en, this message translates to:
  /// **'All data is anonymized and used only to improve your experience. You can disable analytics or clear your data anytime.'**
  String get privacyDataAnonymizedFootnote;

  /// No description provided for @privacyGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get privacyGotIt;

  /// No description provided for @privacyPurposeLine.
  ///
  /// In en, this message translates to:
  /// **'Purpose: {purpose}'**
  String privacyPurposeLine(String purpose);

  /// No description provided for @privacyClearAnalyticsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear analytics data'**
  String get privacyClearAnalyticsDialogTitle;

  /// No description provided for @privacyClearAnalyticsDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will delete all stored analytics data from your device. This action cannot be undone.'**
  String get privacyClearAnalyticsDialogBody;

  /// No description provided for @privacyClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear data'**
  String get privacyClearData;

  /// No description provided for @privacyClearAnalyticsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Analytics data cleared successfully'**
  String get privacyClearAnalyticsSuccess;

  /// No description provided for @privacyClearAnalyticsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear analytics data'**
  String get privacyClearAnalyticsFailed;

  /// No description provided for @privacyPhoneSixDigitCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get privacyPhoneSixDigitCodeLabel;

  /// No description provided for @zoeaCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your digital wallet for seamless payments'**
  String get zoeaCardSubtitle;

  /// No description provided for @shopCartScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping cart'**
  String get shopCartScreenTitle;

  /// No description provided for @shopCartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items to your cart to get started'**
  String get shopCartEmptySubtitle;

  /// No description provided for @shopCartLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart'**
  String get shopCartLoadFailed;

  /// No description provided for @shopCheckoutSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to checkout'**
  String get shopCheckoutSignInTitle;

  /// No description provided for @shopCheckoutSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to complete your purchase. Your cart will be saved.'**
  String get shopCheckoutSignInMessage;

  /// No description provided for @shopCartItemTypeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get shopCartItemTypeProduct;

  /// No description provided for @shopCartItemTypeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get shopCartItemTypeService;

  /// No description provided for @shopCartItemTypeMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Menu item'**
  String get shopCartItemTypeMenuItem;

  /// No description provided for @shopCartClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get shopCartClearTooltip;

  /// No description provided for @shopCartTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get shopCartTotalLabel;

  /// No description provided for @shopProceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to checkout'**
  String get shopProceedToCheckout;

  /// No description provided for @checkoutScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutScreenTitle;

  /// No description provided for @checkoutOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get checkoutOrderSummary;

  /// No description provided for @checkoutDeliveryMethod.
  ///
  /// In en, this message translates to:
  /// **'Delivery method'**
  String get checkoutDeliveryMethod;

  /// No description provided for @checkoutDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get checkoutDeliveryAddress;

  /// No description provided for @checkoutStreetAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get checkoutStreetAddressLabel;

  /// No description provided for @checkoutStreetAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your street address'**
  String get checkoutStreetAddressHint;

  /// No description provided for @checkoutStreetAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your delivery address'**
  String get checkoutStreetAddressRequired;

  /// No description provided for @checkoutCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutCityLabel;

  /// No description provided for @checkoutCityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get checkoutCityHint;

  /// No description provided for @checkoutCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city'**
  String get checkoutCityRequired;

  /// No description provided for @checkoutContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get checkoutContactInformation;

  /// No description provided for @checkoutFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get checkoutFullNameLabel;

  /// No description provided for @checkoutFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get checkoutFullNameHint;

  /// No description provided for @checkoutFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get checkoutFullNameRequired;

  /// No description provided for @checkoutEmailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get checkoutEmailOptionalLabel;

  /// No description provided for @checkoutEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get checkoutEmailHint;

  /// No description provided for @checkoutPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get checkoutPhoneLabel;

  /// No description provided for @checkoutPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get checkoutPhoneHint;

  /// No description provided for @checkoutPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get checkoutPhoneRequired;

  /// No description provided for @checkoutSpecialInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Special instructions (optional)'**
  String get checkoutSpecialInstructionsTitle;

  /// No description provided for @checkoutSpecialInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special instructions for your order…'**
  String get checkoutSpecialInstructionsHint;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutStorePickup.
  ///
  /// In en, this message translates to:
  /// **'Store pickup'**
  String get checkoutStorePickup;

  /// No description provided for @checkoutSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get checkoutSubtotalLabel;

  /// No description provided for @checkoutTaxVatLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax (18%)'**
  String get checkoutTaxVatLabel;

  /// No description provided for @checkoutShippingLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkoutShippingLabel;

  /// No description provided for @checkoutQtyLine.
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String checkoutQtyLine(int quantity);

  /// No description provided for @shopServiceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service} other{{count} services}}'**
  String shopServiceCount(int count);

  /// No description provided for @shopEmptyNoServices.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get shopEmptyNoServices;

  /// No description provided for @shopErrorLoadServices.
  ///
  /// In en, this message translates to:
  /// **'Failed to load services'**
  String get shopErrorLoadServices;

  /// No description provided for @shopFilterServicesSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter services'**
  String get shopFilterServicesSheetTitle;

  /// No description provided for @shopServiceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter service name…'**
  String get shopServiceSearchHint;

  /// No description provided for @shopPricePerHour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get shopPricePerHour;

  /// No description provided for @shopPricePerSession.
  ///
  /// In en, this message translates to:
  /// **'session'**
  String get shopPricePerSession;

  /// No description provided for @shopPricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'person'**
  String get shopPricePerPerson;

  /// No description provided for @shopServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get shopServiceUnavailable;

  /// No description provided for @shopServiceDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String shopServiceDurationMinutes(int minutes);

  /// No description provided for @shopErrorLoadMenu.
  ///
  /// In en, this message translates to:
  /// **'Failed to load menu'**
  String get shopErrorLoadMenu;

  /// No description provided for @shopErrorLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get shopErrorLoadProduct;

  /// No description provided for @shopMenuCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items in this category'**
  String get shopMenuCategoryEmpty;

  /// No description provided for @shopErrorLoadService.
  ///
  /// In en, this message translates to:
  /// **'Failed to load service'**
  String get shopErrorLoadService;

  /// No description provided for @shopViewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get shopViewCart;

  /// No description provided for @shopAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get shopAddToCart;

  /// No description provided for @shopBookService.
  ///
  /// In en, this message translates to:
  /// **'Book service'**
  String get shopBookService;

  /// No description provided for @shopProductDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get shopProductDescription;

  /// No description provided for @shopProductTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get shopProductTags;

  /// No description provided for @shopProductVariantHeading.
  ///
  /// In en, this message translates to:
  /// **'Select variant'**
  String get shopProductVariantHeading;

  /// No description provided for @shopMenuChefSpecial.
  ///
  /// In en, this message translates to:
  /// **'Chef\'s special'**
  String get shopMenuChefSpecial;

  /// No description provided for @shopMenuDietaryInformation.
  ///
  /// In en, this message translates to:
  /// **'Dietary information'**
  String get shopMenuDietaryInformation;

  /// No description provided for @shopMenuAllergensTitle.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get shopMenuAllergensTitle;

  /// No description provided for @shopServiceUnavailableBanner.
  ///
  /// In en, this message translates to:
  /// **'Service is currently unavailable'**
  String get shopServiceUnavailableBanner;

  /// No description provided for @listingShareOnZoea.
  ///
  /// In en, this message translates to:
  /// **'Check out {name} on Zoea!'**
  String listingShareOnZoea(String name);

  /// No description provided for @shopServiceDurationLine.
  ///
  /// In en, this message translates to:
  /// **'Duration: {minutes} minutes'**
  String shopServiceDurationLine(int minutes);

  /// No description provided for @shopBookingFullNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get shopBookingFullNameRequiredLabel;

  /// No description provided for @shopBookingPhoneRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number *'**
  String get shopBookingPhoneRequiredLabel;

  /// No description provided for @shopBookingEmailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get shopBookingEmailOptionalLabel;

  /// No description provided for @shopBookingSelectDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Select date *'**
  String get shopBookingSelectDateRequired;

  /// No description provided for @shopBookingSelectTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Select time *'**
  String get shopBookingSelectTimeRequired;

  /// No description provided for @shopBookingSpecialRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Special requests (optional)'**
  String get shopBookingSpecialRequestsLabel;

  /// No description provided for @shopMenuScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get shopMenuScreenTitle;

  /// No description provided for @shopMenusEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No menu available'**
  String get shopMenusEmptyTitle;

  /// No description provided for @shopMenusEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This restaurant hasn\'t added a menu yet'**
  String get shopMenusEmptySubtitle;

  /// No description provided for @shopOrderPlacedSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get shopOrderPlacedSuccessTitle;

  /// No description provided for @shopOrderPlacedSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order has been received and is being processed'**
  String get shopOrderPlacedSuccessSubtitle;

  /// No description provided for @shopOrderDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get shopOrderDetailsSection;

  /// No description provided for @shopOrderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get shopOrderNumberLabel;

  /// No description provided for @shopOrderMerchantLabel.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get shopOrderMerchantLabel;

  /// No description provided for @shopOrderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get shopOrderStatusLabel;

  /// No description provided for @shopOrderTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get shopOrderTotalAmountLabel;

  /// No description provided for @shopOrderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get shopOrderDateLabel;

  /// No description provided for @shopOrderViewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View my orders'**
  String get shopOrderViewMyOrders;

  /// No description provided for @shopOrderDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details'**
  String get shopOrderDetailsLoadFailed;

  /// No description provided for @referralInviteHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends & earn rewards'**
  String get referralInviteHeroTitle;

  /// No description provided for @referralInviteHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your referral code and earn points when friends join Zoea'**
  String get referralInviteHeroSubtitle;

  /// No description provided for @referralYourCodeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get referralYourCodeSectionTitle;

  /// No description provided for @referralSignInForCodeBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your personal code and track points.'**
  String get referralSignInForCodeBody;

  /// No description provided for @referralErrorLoadCode.
  ///
  /// In en, this message translates to:
  /// **'Could not load your referral code. Pull to retry or sign in again.'**
  String get referralErrorLoadCode;

  /// No description provided for @referralShareCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Share this code with your friends'**
  String get referralShareCodeHint;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get referralCodeCopied;

  /// No description provided for @referralShareInviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on Zoea Africa and discover amazing places in Rwanda!'**
  String get referralShareInviteMessage;

  /// No description provided for @referralHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get referralHowItWorksTitle;

  /// No description provided for @referralStepShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your code'**
  String get referralStepShareTitle;

  /// No description provided for @referralStepShareBody.
  ///
  /// In en, this message translates to:
  /// **'Send your referral code to friends via social media, email, or text'**
  String get referralStepShareBody;

  /// No description provided for @referralStepFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend signs up'**
  String get referralStepFriendTitle;

  /// No description provided for @referralStepFriendBody.
  ///
  /// In en, this message translates to:
  /// **'Your friend creates their Zoea account using your code'**
  String get referralStepFriendBody;

  /// No description provided for @referralStepEarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Earn points'**
  String get referralStepEarnTitle;

  /// No description provided for @referralStepEarnBody.
  ///
  /// In en, this message translates to:
  /// **'You both get points when they sign up (shown as pending until credited)'**
  String get referralStepEarnBody;

  /// No description provided for @referralRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get referralRewardsTitle;

  /// No description provided for @referralRewardForYouTitle.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get referralRewardForYouTitle;

  /// No description provided for @referralRewardForYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When friend joins'**
  String get referralRewardForYouSubtitle;

  /// No description provided for @referralRewardForFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'For friend'**
  String get referralRewardForFriendTitle;

  /// No description provided for @referralRewardForFriendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome bonus'**
  String get referralRewardForFriendSubtitle;

  /// No description provided for @referralRewardsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load reward amounts.'**
  String get referralRewardsLoadError;

  /// No description provided for @referralStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your referrals'**
  String get referralStatsTitle;

  /// No description provided for @referralStatTotalReferrals.
  ///
  /// In en, this message translates to:
  /// **'Total referrals'**
  String get referralStatTotalReferrals;

  /// No description provided for @referralStatPointsEarned.
  ///
  /// In en, this message translates to:
  /// **'Points earned'**
  String get referralStatPointsEarned;

  /// No description provided for @referralStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referralStatPending;

  /// No description provided for @referralPointsValue.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String referralPointsValue(String points);

  /// No description provided for @onboardingGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingGenderMale;

  /// No description provided for @onboardingGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingGenderFemale;

  /// No description provided for @onboardingGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingGenderOther;

  /// No description provided for @onboardingGenderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get onboardingGenderPreferNot;

  /// No description provided for @onboardingVisitLeisureTitle.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get onboardingVisitLeisureTitle;

  /// No description provided for @onboardingVisitLeisureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exploring and enjoying Rwanda'**
  String get onboardingVisitLeisureSubtitle;

  /// No description provided for @onboardingVisitBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get onboardingVisitBusinessTitle;

  /// No description provided for @onboardingVisitBusinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Work and professional travel'**
  String get onboardingVisitBusinessSubtitle;

  /// No description provided for @onboardingVisitMiceTitle.
  ///
  /// In en, this message translates to:
  /// **'MICE'**
  String get onboardingVisitMiceTitle;

  /// No description provided for @onboardingVisitMiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Meetings, incentives, conferences, exhibitions'**
  String get onboardingVisitMiceSubtitle;

  /// No description provided for @diningBookingLabelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get diningBookingLabelDate;

  /// No description provided for @diningBookingLabelTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get diningBookingLabelTime;

  /// No description provided for @diningBookingLabelGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get diningBookingLabelGuests;

  /// No description provided for @diningBookingLabelRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get diningBookingLabelRestaurant;

  /// No description provided for @diningBookingLabelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get diningBookingLabelLocation;

  /// No description provided for @diningBookingLabelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get diningBookingLabelName;

  /// No description provided for @diningBookingLabelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get diningBookingLabelPhone;

  /// No description provided for @diningBookingLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get diningBookingLabelEmail;

  /// No description provided for @diningBookingDetailLine.
  ///
  /// In en, this message translates to:
  /// **'{label}: '**
  String diningBookingDetailLine(String label);

  /// No description provided for @exploreFilterBudgetHintNoLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get exploreFilterBudgetHintNoLimit;

  /// No description provided for @stayBookingSpecialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special requests or preferences…'**
  String get stayBookingSpecialRequestsHint;

  /// No description provided for @stayCouponCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get stayCouponCodeHint;

  /// No description provided for @stayBookingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Book your stay'**
  String get stayBookingScreenTitle;

  /// No description provided for @stayBookingSelectDatesHeading.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get stayBookingSelectDatesHeading;

  /// No description provided for @stayBookingRoomsHeading.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get stayBookingRoomsHeading;

  /// No description provided for @stayBookingRoomCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 room} other{{count} rooms}}'**
  String stayBookingRoomCount(int count);

  /// No description provided for @stayBookingNightlyLine.
  ///
  /// In en, this message translates to:
  /// **'{price} × {roomCount, plural, =1{1 room} other{{roomCount} rooms}}'**
  String stayBookingNightlyLine(String price, int roomCount);

  /// No description provided for @stayBookingContinueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get stayBookingContinueToPayment;

  /// No description provided for @stayBookingSelectedRoomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected rooms'**
  String get stayBookingSelectedRoomsTitle;

  /// No description provided for @stayBookingQtyShort.
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String stayBookingQtyShort(int quantity);

  /// No description provided for @stayBookingDemoHotelName.
  ///
  /// In en, this message translates to:
  /// **'Kigali Marriott Hotel'**
  String get stayBookingDemoHotelName;

  /// No description provided for @stayBookingDemoHotelAddress.
  ///
  /// In en, this message translates to:
  /// **'Kacyiru, Kigali'**
  String get stayBookingDemoHotelAddress;

  /// No description provided for @stayBookingDemoRatingReviews.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({reviewCount, plural, =1{1 review} other{{reviewCount} reviews}})'**
  String stayBookingDemoRatingReviews(String rating, int reviewCount);

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet'**
  String get notificationsEmptyBody;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationsLoadFailed;

  /// No description provided for @notificationsAllMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notificationsAllMarkedRead;

  /// No description provided for @notificationsDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationsDefaultTitle;

  /// No description provided for @notificationsActionViewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get notificationsActionViewBooking;

  /// No description provided for @notificationsActionViewEvent.
  ///
  /// In en, this message translates to:
  /// **'View event'**
  String get notificationsActionViewEvent;

  /// No description provided for @notificationsActionViewListing.
  ///
  /// In en, this message translates to:
  /// **'View listing'**
  String get notificationsActionViewListing;

  /// No description provided for @notificationsMarkReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark notification as read: {error}'**
  String notificationsMarkReadFailed(String error);

  /// No description provided for @notificationsMarkAllReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark all as read: {error}'**
  String notificationsMarkAllReadFailed(String error);

  /// No description provided for @notificationsTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationsTimeJustNow;

  /// No description provided for @notificationsTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String notificationsTimeMinutesAgo(int count);

  /// No description provided for @notificationsTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String notificationsTimeHoursAgo(int count);

  /// No description provided for @notificationsTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String notificationsTimeDaysAgo(int count);

  /// No description provided for @notificationsTimeRecently.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get notificationsTimeRecently;

  /// No description provided for @notificationsOpeningUrl.
  ///
  /// In en, this message translates to:
  /// **'Opening: {url}'**
  String notificationsOpeningUrl(String url);

  /// No description provided for @diningBookingConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation'**
  String get diningBookingConfirmationTitle;

  /// No description provided for @diningBookingReservationConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservation confirmed!'**
  String get diningBookingReservationConfirmedTitle;

  /// No description provided for @diningBookingReservationConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your table has been reserved successfully'**
  String get diningBookingReservationConfirmedSubtitle;

  /// No description provided for @diningBookingNumberLine.
  ///
  /// In en, this message translates to:
  /// **'Booking #{number}'**
  String diningBookingNumberLine(String number);

  /// No description provided for @diningBookingReservationDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Reservation details'**
  String get diningBookingReservationDetailsSection;

  /// No description provided for @diningBookingNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get diningBookingNotSpecified;

  /// No description provided for @diningBookingRestaurantInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Restaurant information'**
  String get diningBookingRestaurantInfoSection;

  /// No description provided for @diningBookingGuestInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Guest information'**
  String get diningBookingGuestInfoSection;

  /// No description provided for @diningBookingSpecialRequestsSection.
  ///
  /// In en, this message translates to:
  /// **'Special requests'**
  String get diningBookingSpecialRequestsSection;

  /// No description provided for @diningBookingImportantInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get diningBookingImportantInfoTitle;

  /// No description provided for @diningBookingImportantInfoBody.
  ///
  /// In en, this message translates to:
  /// **'• Please arrive 5–10 minutes before your reservation time\n• To cancel or change your reservation, contact the restaurant directly\n• Late arrivals may result in losing the table\n• A dress code may apply—check with the restaurant'**
  String get diningBookingImportantInfoBody;

  /// No description provided for @diningBookingBrowseMore.
  ///
  /// In en, this message translates to:
  /// **'Browse more'**
  String get diningBookingBrowseMore;

  /// No description provided for @diningBookingViewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View my bookings'**
  String get diningBookingViewMyBookings;

  /// No description provided for @listingScreenDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get listingScreenDefaultTitle;

  /// No description provided for @tourDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tour details'**
  String get tourDetailLoadError;

  /// No description provided for @listingDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listing'**
  String get listingDetailLoadFailed;

  /// No description provided for @bookingConfirmationHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmationHeaderTitle;

  /// No description provided for @bookingConfirmationHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been confirmed successfully'**
  String get bookingConfirmationHeaderSubtitle;

  /// No description provided for @bookingConfirmationSectionBookingInfo.
  ///
  /// In en, this message translates to:
  /// **'Booking information'**
  String get bookingConfirmationSectionBookingInfo;

  /// No description provided for @bookingConfirmationLabelBookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking number'**
  String get bookingConfirmationLabelBookingNumber;

  /// No description provided for @bookingConfirmationLabelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bookingConfirmationLabelType;

  /// No description provided for @bookingConfirmationSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingConfirmationSectionDetails;

  /// No description provided for @bookingConfirmationLabelPartySize.
  ///
  /// In en, this message translates to:
  /// **'Party size'**
  String get bookingConfirmationLabelPartySize;

  /// No description provided for @bookingConfirmationLabelSpecialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special requests'**
  String get bookingConfirmationLabelSpecialRequests;

  /// No description provided for @bookingConfirmationTourDetailsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tour confirmation details will appear here once available.'**
  String get bookingConfirmationTourDetailsPlaceholder;

  /// No description provided for @bookingConfirmationSectionPriceSummary.
  ///
  /// In en, this message translates to:
  /// **'Price summary'**
  String get bookingConfirmationSectionPriceSummary;

  /// No description provided for @bookingConfirmationLabelTaxesFees.
  ///
  /// In en, this message translates to:
  /// **'Taxes & fees'**
  String get bookingConfirmationLabelTaxesFees;

  /// No description provided for @bookingConfirmationLabelDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get bookingConfirmationLabelDiscount;

  /// No description provided for @bookingConfirmationLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load booking'**
  String get bookingConfirmationLoadFailed;

  /// No description provided for @webviewPageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load page'**
  String get webviewPageLoadFailed;

  /// No description provided for @webviewInvalidUrlLine.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL: {url}'**
  String webviewInvalidUrlLine(String url);

  /// No description provided for @webviewLoadTimeoutBody.
  ///
  /// In en, this message translates to:
  /// **'This page is taking too long to load. Please check your internet connection.'**
  String get webviewLoadTimeoutBody;

  /// No description provided for @webviewTooltipReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get webviewTooltipReload;

  /// No description provided for @webviewTooltipForward.
  ///
  /// In en, this message translates to:
  /// **'Go forward'**
  String get webviewTooltipForward;

  /// No description provided for @listingDetailReviewSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to write a review'**
  String get listingDetailReviewSignInTitle;

  /// No description provided for @listingDetailReviewSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to share your experience and help other travelers.'**
  String get listingDetailReviewSignInMessage;

  /// No description provided for @itineraryDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load itinerary'**
  String get itineraryDetailLoadFailed;

  /// No description provided for @myBookingsCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your booking for \"{name}\"? This action cannot be undone.'**
  String myBookingsCancelConfirmBody(String name);

  /// No description provided for @myBookingsBookAgainPrompt.
  ///
  /// In en, this message translates to:
  /// **'Would you like to book \"{name}\" again?'**
  String myBookingsBookAgainPrompt(String name);

  /// No description provided for @diningFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter dining'**
  String get diningFilterSheetTitle;

  /// No description provided for @diningSortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort dining'**
  String get diningSortSheetTitle;

  /// No description provided for @listingFeaturedOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured only'**
  String get listingFeaturedOnlyTitle;

  /// No description provided for @listingFeaturedOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show only featured listings'**
  String get listingFeaturedOnlySubtitle;

  /// No description provided for @listingSortOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get listingSortOldestFirst;

  /// No description provided for @diningFlowBookTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Book table'**
  String get diningFlowBookTableTitle;

  /// No description provided for @diningFlowReservationDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Reservation details'**
  String get diningFlowReservationDetailsSection;

  /// No description provided for @diningFlowSelectDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get diningFlowSelectDatePlaceholder;

  /// No description provided for @diningFlowAvailableTimes.
  ///
  /// In en, this message translates to:
  /// **'Available times'**
  String get diningFlowAvailableTimes;

  /// No description provided for @diningFlowNumberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get diningFlowNumberOfGuests;

  /// No description provided for @diningFlowGuestInformation.
  ///
  /// In en, this message translates to:
  /// **'Guest information'**
  String get diningFlowGuestInformation;

  /// No description provided for @diningFlowFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get diningFlowFullNameHint;

  /// No description provided for @diningFlowPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+250 796 889 900'**
  String get diningFlowPhoneHint;

  /// No description provided for @diningFlowSpecialRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Special requests'**
  String get diningFlowSpecialRequestsTitle;

  /// No description provided for @diningFlowSpecialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special dietary requirements, seating preferences, etc.'**
  String get diningFlowSpecialRequestsHint;

  /// No description provided for @diningFlowCouponCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get diningFlowCouponCodeTitle;

  /// No description provided for @diningFlowCouponAppliedTitle.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied!'**
  String get diningFlowCouponAppliedTitle;

  /// No description provided for @diningFlowCouponSavedBody.
  ///
  /// In en, this message translates to:
  /// **'You saved {amount}'**
  String diningFlowCouponSavedBody(String amount);

  /// No description provided for @diningBookingTimeNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get diningBookingTimeNotSelected;

  /// No description provided for @diningFlowConfirmSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get diningFlowConfirmSheetTitle;

  /// No description provided for @diningFlowConfirmBookingCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get diningFlowConfirmBookingCta;

  /// No description provided for @stayFavoriteSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to save your favorite accommodations and access them anytime.'**
  String get stayFavoriteSignInMessage;

  /// No description provided for @tourFavoriteSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to save your favorite tours and access them anytime.'**
  String get tourFavoriteSignInMessage;

  /// No description provided for @diningReserveSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to reserve'**
  String get diningReserveSignInTitle;

  /// No description provided for @diningReserveSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to reserve a table and manage your dining reservations.'**
  String get diningReserveSignInMessage;

  /// No description provided for @stayBookSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book'**
  String get stayBookSignInTitle;

  /// No description provided for @stayBookSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to complete your booking and manage your reservations.'**
  String get stayBookSignInMessage;

  /// No description provided for @tourBookSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book'**
  String get tourBookSignInTitle;

  /// No description provided for @tourBookSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to complete your tour booking and manage your reservations.'**
  String get tourBookSignInMessage;

  /// No description provided for @commonFavoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite: {detail}'**
  String commonFavoriteUpdateFailed(String detail);

  /// No description provided for @listingShareOnZoeaInLocation.
  ///
  /// In en, this message translates to:
  /// **'Check out {name} in {location} on Zoea!'**
  String listingShareOnZoeaInLocation(String name, String location);

  /// No description provided for @listingDetailCouldNotOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Could not open website: {website}'**
  String listingDetailCouldNotOpenWebsite(String website);

  /// No description provided for @listingDetailCouldNotCallPhone.
  ///
  /// In en, this message translates to:
  /// **'Could not make phone call to {phone}'**
  String listingDetailCouldNotCallPhone(String phone);

  /// No description provided for @searchScreenGlobalHint.
  ///
  /// In en, this message translates to:
  /// **'Search events, places, experiences…'**
  String get searchScreenGlobalHint;

  /// No description provided for @searchClearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear search history'**
  String get searchClearHistoryTitle;

  /// No description provided for @searchClearHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all your search history?'**
  String get searchClearHistoryBody;

  /// No description provided for @listingReviewComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts about this place…'**
  String get listingReviewComposerHint;

  /// No description provided for @exploreFilterBudgetHintMin.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get exploreFilterBudgetHintMin;

  /// No description provided for @tourBookingPickupHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup location or leave blank for default'**
  String get tourBookingPickupHint;

  /// No description provided for @tourBookingSpecialRequirementsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special requirements, dietary preferences, etc.'**
  String get tourBookingSpecialRequirementsHint;

  /// No description provided for @itineraryCreateNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Rwanda Adventure'**
  String get itineraryCreateNameHint;

  /// No description provided for @itineraryCreateDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your trip…'**
  String get itineraryCreateDescriptionHint;

  /// No description provided for @itineraryCreateStartLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Kigali, Rwanda'**
  String get itineraryCreateStartLocationHint;

  /// No description provided for @itineraryStopTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Coffee Break'**
  String get itineraryStopTitleHint;

  /// No description provided for @itineraryStopDurationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 60'**
  String get itineraryStopDurationHint;

  /// No description provided for @itinerariesFabCreateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create itinerary'**
  String get itinerariesFabCreateTooltip;

  /// No description provided for @itineraryCreateDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete itinerary'**
  String get itineraryCreateDeleteTooltip;

  /// No description provided for @itineraryDetailEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get itineraryDetailEditTooltip;

  /// No description provided for @itineraryDetailShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get itineraryDetailShareTooltip;

  /// No description provided for @udcTravelPartySolo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get udcTravelPartySolo;

  /// No description provided for @udcTravelPartyCouple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get udcTravelPartyCouple;

  /// No description provided for @udcTravelPartyFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get udcTravelPartyFamily;

  /// No description provided for @udcTravelPartyGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get udcTravelPartyGroup;

  /// No description provided for @udcFieldAgeRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get udcFieldAgeRangeTitle;

  /// No description provided for @udcFieldAgeRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize content for you'**
  String get udcFieldAgeRangeSubtitle;

  /// No description provided for @udcFieldGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get udcFieldGenderTitle;

  /// No description provided for @udcFieldGenderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — helps with personalization'**
  String get udcFieldGenderSubtitle;

  /// No description provided for @udcFieldLengthOfStayTitle.
  ///
  /// In en, this message translates to:
  /// **'Length of stay'**
  String get udcFieldLengthOfStayTitle;

  /// No description provided for @udcFieldLengthOfStaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How long are you staying in Rwanda?'**
  String get udcFieldLengthOfStaySubtitle;

  /// No description provided for @udcFieldInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get udcFieldInterestsTitle;

  /// No description provided for @udcFieldInterestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get udcFieldInterestsSubtitle;

  /// No description provided for @udcFieldTravelPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel party'**
  String get udcFieldTravelPartyTitle;

  /// No description provided for @udcFieldTravelPartySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you traveling with?'**
  String get udcFieldTravelPartySubtitle;

  /// No description provided for @onboardingAudienceResidentTitle.
  ///
  /// In en, this message translates to:
  /// **'Resident'**
  String get onboardingAudienceResidentTitle;

  /// No description provided for @onboardingAudienceResidentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I live in Rwanda'**
  String get onboardingAudienceResidentSubtitle;

  /// No description provided for @onboardingAudienceVisitorTitle.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get onboardingAudienceVisitorTitle;

  /// No description provided for @onboardingAudienceVisitorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m visiting Rwanda'**
  String get onboardingAudienceVisitorSubtitle;

  /// No description provided for @commonProfileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get commonProfileUpdatedSuccess;

  /// No description provided for @commonSaveFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get commonSaveFailedTryAgain;

  /// No description provided for @commonFailedSaveDataTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to save data. Please try again.'**
  String get commonFailedSaveDataTryAgain;

  /// No description provided for @progressivePromptThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for helping us personalize your experience!'**
  String get progressivePromptThanks;

  /// No description provided for @profileEditPasswordRequiredForEmail.
  ///
  /// In en, this message translates to:
  /// **'Password is required to update email address.'**
  String get profileEditPasswordRequiredForEmail;

  /// No description provided for @profileEditPleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get profileEditPleaseEnterPassword;

  /// No description provided for @reviewsWrittenSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search reviews…'**
  String get reviewsWrittenSearchHint;

  /// No description provided for @aboutAppInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get aboutAppInfoSectionTitle;

  /// No description provided for @aboutAppVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get aboutAppVersionLabel;

  /// No description provided for @aboutBuildNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get aboutBuildNumberLabel;

  /// No description provided for @aboutLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get aboutLastUpdatedLabel;

  /// No description provided for @aboutPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get aboutPlatformLabel;

  /// No description provided for @aboutLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get aboutLanguageLabel;

  /// No description provided for @aboutLegalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get aboutLegalSectionTitle;

  /// No description provided for @aboutPrivacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicyTitle;

  /// No description provided for @aboutPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get aboutPrivacyPolicySubtitle;

  /// No description provided for @aboutTermsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTermsOfServiceTitle;

  /// No description provided for @aboutTermsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get aboutTermsOfServiceSubtitle;

  /// No description provided for @aboutCopyrightTitle.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get aboutCopyrightTitle;

  /// No description provided for @aboutCopyrightCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'© {year} Zoea Africa. All rights reserved.'**
  String aboutCopyrightCardSubtitle(int year);

  /// No description provided for @aboutConnectSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with us'**
  String get aboutConnectSectionTitle;

  /// No description provided for @aboutContactEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutContactEmailTitle;

  /// No description provided for @aboutContactPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get aboutContactPhoneTitle;

  /// No description provided for @aboutContactWebsiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutContactWebsiteTitle;

  /// No description provided for @aboutContactPhoneDisplay.
  ///
  /// In en, this message translates to:
  /// **'+250 796 889 900'**
  String get aboutContactPhoneDisplay;

  /// No description provided for @aboutContactWebsiteDisplay.
  ///
  /// In en, this message translates to:
  /// **'www.zoea.africa'**
  String get aboutContactWebsiteDisplay;

  /// No description provided for @aboutCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get aboutCloseButton;

  /// No description provided for @aboutVersionLine.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersionLine(String version);

  /// No description provided for @aboutVersionLoading.
  ///
  /// In en, this message translates to:
  /// **'Version …'**
  String get aboutVersionLoading;

  /// No description provided for @aboutBrandTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover Rwanda\'s beauty'**
  String get aboutBrandTagline;

  /// No description provided for @aboutWebsiteWebviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Zoea Africa'**
  String get aboutWebsiteWebviewTitle;

  /// No description provided for @stayDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load accommodation'**
  String get stayDetailLoadFailed;

  /// No description provided for @stayDetailTabAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get stayDetailTabAmenities;

  /// No description provided for @stayDetailAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About this place'**
  String get stayDetailAboutTitle;

  /// No description provided for @stayDetailCheckInOutSection.
  ///
  /// In en, this message translates to:
  /// **'Check-in & check-out'**
  String get stayDetailCheckInOutSection;

  /// No description provided for @stayDetailCheckOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get stayDetailCheckOutLabel;

  /// No description provided for @stayDetailBookingPoliciesSection.
  ///
  /// In en, this message translates to:
  /// **'Booking policies'**
  String get stayDetailBookingPoliciesSection;

  /// No description provided for @stayDetailAvailableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available rooms'**
  String get stayDetailAvailableRooms;

  /// No description provided for @stayDetailNoRoomTypes.
  ///
  /// In en, this message translates to:
  /// **'No room types available'**
  String get stayDetailNoRoomTypes;

  /// No description provided for @stayDetailAmenitiesSection.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get stayDetailAmenitiesSection;

  /// No description provided for @stayDetailNoAmenitiesListed.
  ///
  /// In en, this message translates to:
  /// **'No amenities listed'**
  String get stayDetailNoAmenitiesListed;

  /// No description provided for @stayDetailNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get stayDetailNoReviewsYet;

  /// No description provided for @stayDetailBeFirstToReview.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this place!'**
  String get stayDetailBeFirstToReview;

  /// No description provided for @stayDetailReviewsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews: {error}'**
  String stayDetailReviewsLoadFailed(String error);

  /// No description provided for @stayPolicyCancellationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get stayPolicyCancellationTitle;

  /// No description provided for @stayPolicyCancellationBody.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation until 24 hours before check-in.'**
  String get stayPolicyCancellationBody;

  /// No description provided for @stayPolicyRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get stayPolicyRefundTitle;

  /// No description provided for @stayPolicyRefundBody.
  ///
  /// In en, this message translates to:
  /// **'Full refund if cancelled 24+ hours before check-in.'**
  String get stayPolicyRefundBody;

  /// No description provided for @stayPolicyPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet policy'**
  String get stayPolicyPetTitle;

  /// No description provided for @stayPolicyPetBody.
  ///
  /// In en, this message translates to:
  /// **'Pets allowed with an additional fee of RWF 15,000 per night.'**
  String get stayPolicyPetBody;

  /// No description provided for @stayPolicySmokingTitle.
  ///
  /// In en, this message translates to:
  /// **'Smoking policy'**
  String get stayPolicySmokingTitle;

  /// No description provided for @stayPolicySmokingBody.
  ///
  /// In en, this message translates to:
  /// **'Non-smoking property. Smoking allowed in designated areas only.'**
  String get stayPolicySmokingBody;

  /// No description provided for @stayPolicyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children policy'**
  String get stayPolicyChildrenTitle;

  /// No description provided for @stayPolicyChildrenBody.
  ///
  /// In en, this message translates to:
  /// **'Children of all ages welcome. Extra beds available on request.'**
  String get stayPolicyChildrenBody;

  /// No description provided for @stayPolicyPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment policy'**
  String get stayPolicyPaymentTitle;

  /// No description provided for @stayPolicyPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'Credit card required for booking. Payment due at check-in.'**
  String get stayPolicyPaymentBody;

  /// No description provided for @itineraryCreateScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Create itinerary'**
  String get itineraryCreateScreenTitle;

  /// No description provided for @itineraryEditScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit itinerary'**
  String get itineraryEditScreenTitle;

  /// No description provided for @itineraryFieldTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get itineraryFieldTitleLabel;

  /// No description provided for @itineraryFieldDescriptionOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get itineraryFieldDescriptionOptionalLabel;

  /// No description provided for @itineraryFieldLocationOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get itineraryFieldLocationOptionalLabel;

  /// No description provided for @itineraryFieldStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get itineraryFieldStartDateLabel;

  /// No description provided for @itineraryFieldEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get itineraryFieldEndDateLabel;

  /// No description provided for @itineraryFieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get itineraryFieldNameLabel;

  /// No description provided for @itineraryFieldTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get itineraryFieldTimeLabel;

  /// No description provided for @itineraryFieldDurationOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes, optional)'**
  String get itineraryFieldDurationOptionalLabel;

  /// No description provided for @itineraryValidationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get itineraryValidationTitleRequired;

  /// No description provided for @profileEnterPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get profileEnterPasswordDialogTitle;

  /// No description provided for @profileEnterPasswordDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password to update your email address.'**
  String get profileEnterPasswordDialogBody;

  /// No description provided for @profileUpdateFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again.'**
  String get profileUpdateFailedGeneric;

  /// No description provided for @stayDetailReviewsCountLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String stayDetailReviewsCountLine(int count);

  /// No description provided for @stayDetailTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get stayDetailTabOverview;

  /// No description provided for @stayDetailTabRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get stayDetailTabRooms;

  /// No description provided for @stayDetailTabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get stayDetailTabReviews;

  /// No description provided for @stayDetailTabPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get stayDetailTabPhotos;

  /// No description provided for @onboardingUserTypeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Are you a resident or visitor?'**
  String get onboardingUserTypeHeadline;

  /// No description provided for @onboardingUserTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us show you relevant content'**
  String get onboardingUserTypeSubtitle;

  /// No description provided for @commonComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get commonComplete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @phoneValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneValidationRequired;

  /// No description provided for @phoneValidationInternationalInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneValidationInternationalInvalid;

  /// No description provided for @phoneValidationRwandanInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Rwandan phone number (07xxxxxxxx or 08xxxxxxxx)'**
  String get phoneValidationRwandanInvalid;

  /// No description provided for @exploreFilterLabelMinPrice.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get exploreFilterLabelMinPrice;

  /// No description provided for @exploreFilterLabelMaxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get exploreFilterLabelMaxPrice;

  /// No description provided for @profileEditInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get profileEditInterestsTitle;

  /// No description provided for @profileEditInterestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get profileEditInterestsSubtitle;

  /// No description provided for @profileEditUnsavedChangesBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get profileEditUnsavedChangesBody;

  /// No description provided for @profileEditDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get profileEditDiscard;

  /// No description provided for @profileEditPersonalInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get profileEditPersonalInfoSectionTitle;

  /// No description provided for @profileEditHintFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get profileEditHintFullName;

  /// No description provided for @profileEditValidationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get profileEditValidationFullNameRequired;

  /// No description provided for @profileEditHintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get profileEditHintEmail;

  /// No description provided for @profileEditValidationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get profileEditValidationEmailRequired;

  /// No description provided for @profileEditHintPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get profileEditHintPhone;

  /// No description provided for @profileEditValidationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get profileEditValidationPhoneRequired;

  /// No description provided for @profileEditTabBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get profileEditTabBasicInfo;

  /// No description provided for @profileEditTabPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileEditTabPreferences;

  /// No description provided for @profileVisitedPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Places visited'**
  String get profileVisitedPlacesTitle;

  /// No description provided for @profileVisitedTabAllPlaces.
  ///
  /// In en, this message translates to:
  /// **'All places'**
  String get profileVisitedTabAllPlaces;

  /// No description provided for @profileVisitedTabThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get profileVisitedTabThisYear;

  /// No description provided for @profileVisitedTabListingsOnly.
  ///
  /// In en, this message translates to:
  /// **'Listings only'**
  String get profileVisitedTabListingsOnly;

  /// No description provided for @profileVisitedStatusViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get profileVisitedStatusViewed;

  /// No description provided for @profileVisitedDateLine.
  ///
  /// In en, this message translates to:
  /// **'Viewed on {date}'**
  String profileVisitedDateLine(String date);

  /// No description provided for @profileVisitedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No places visited yet'**
  String get profileVisitedEmptyTitle;

  /// No description provided for @profileVisitedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring Rwanda to build your visited places collection.'**
  String get profileVisitedEmptySubtitle;

  /// No description provided for @profileVisitedExploreButton.
  ///
  /// In en, this message translates to:
  /// **'Explore places'**
  String get profileVisitedExploreButton;

  /// No description provided for @profileUnknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get profileUnknownLocation;

  /// No description provided for @profileEventsAttendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Events attended'**
  String get profileEventsAttendedTitle;

  /// No description provided for @eventsAttendedTabAll.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get eventsAttendedTabAll;

  /// No description provided for @eventsAttendedTabThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get eventsAttendedTabThisYear;

  /// No description provided for @eventsAttendedTabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get eventsAttendedTabFavorites;

  /// No description provided for @eventsAttendedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No events attended yet'**
  String get eventsAttendedEmptyTitle;

  /// No description provided for @eventsAttendedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring events to build your attendance history.'**
  String get eventsAttendedEmptySubtitle;

  /// No description provided for @eventsAttendedExploreButton.
  ///
  /// In en, this message translates to:
  /// **'Explore events'**
  String get eventsAttendedExploreButton;

  /// No description provided for @eventsAttendedBadge.
  ///
  /// In en, this message translates to:
  /// **'Attended'**
  String get eventsAttendedBadge;

  /// No description provided for @exploreHomeCategoryEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get exploreHomeCategoryEvents;

  /// No description provided for @exploreHomeCategoryDining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get exploreHomeCategoryDining;

  /// No description provided for @exploreHomeCategoryExperiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get exploreHomeCategoryExperiences;

  /// No description provided for @exploreHomeCategoryNightlife.
  ///
  /// In en, this message translates to:
  /// **'Nightlife'**
  String get exploreHomeCategoryNightlife;

  /// No description provided for @exploreHomeCategoryAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get exploreHomeCategoryAccommodation;

  /// No description provided for @exploreHomeCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get exploreHomeCategoryShopping;

  /// No description provided for @exploreHomeCategoryAttractions.
  ///
  /// In en, this message translates to:
  /// **'Attractions'**
  String get exploreHomeCategoryAttractions;

  /// No description provided for @exploreHomeCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get exploreHomeCategorySports;

  /// No description provided for @exploreHomeCategoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get exploreHomeCategoryTransport;

  /// No description provided for @exploreHomeCategoryServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get exploreHomeCategoryServices;

  /// No description provided for @exploreHomeCategoryKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get exploreHomeCategoryKids;

  /// No description provided for @exploreHomeCategoryRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get exploreHomeCategoryRealEstate;

  /// No description provided for @exploreHomeCategoryHiking.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get exploreHomeCategoryHiking;

  /// No description provided for @exploreHomeCategoryNationalParks.
  ///
  /// In en, this message translates to:
  /// **'National Parks'**
  String get exploreHomeCategoryNationalParks;

  /// No description provided for @exploreHomeCategoryMuseums.
  ///
  /// In en, this message translates to:
  /// **'Museums'**
  String get exploreHomeCategoryMuseums;

  /// No description provided for @placeDetailOpeningHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get placeDetailOpeningHoursTitle;

  /// No description provided for @placeDetailAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get placeDetailAboutTitle;

  /// No description provided for @placeDetailFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get placeDetailFeaturesTitle;

  /// No description provided for @placeDetailNoPhotosExtended.
  ///
  /// In en, this message translates to:
  /// **'No photos available for this place'**
  String get placeDetailNoPhotosExtended;

  /// No description provided for @placeDetailNoMenuForPlace.
  ///
  /// In en, this message translates to:
  /// **'No menu available for this place'**
  String get placeDetailNoMenuForPlace;

  /// No description provided for @listingNoPhotosShort.
  ///
  /// In en, this message translates to:
  /// **'No photos available'**
  String get listingNoPhotosShort;

  /// No description provided for @listingHoursClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get listingHoursClosed;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @itineraryDaysCountLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String itineraryDaysCountLine(int count);

  /// No description provided for @itineraryItemsCountLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itineraryItemsCountLine(int count);

  /// No description provided for @reviewHelpfulCountLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person found this helpful} other{{count} people found this helpful}}'**
  String reviewHelpfulCountLine(int count);

  /// No description provided for @reviewTimeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String reviewTimeWeeksAgo(int count);

  /// No description provided for @reviewTimeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String reviewTimeMonthsAgo(int count);

  /// No description provided for @reviewTimeYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String reviewTimeYearsAgo(int count);

  /// No description provided for @listingReviewExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get listingReviewExperienceTitle;

  /// No description provided for @listingReviewExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience'**
  String get listingReviewExperienceSubtitle;

  /// No description provided for @listingAnonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get listingAnonymousUser;

  /// No description provided for @stayDefaultRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get stayDefaultRoomLabel;

  /// No description provided for @stayDefaultAmenityLabel.
  ///
  /// In en, this message translates to:
  /// **'Amenity'**
  String get stayDefaultAmenityLabel;

  /// No description provided for @contentTypeEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get contentTypeEventLabel;

  /// No description provided for @contentTypePlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get contentTypePlaceLabel;

  /// No description provided for @contentTypeTourLabel.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get contentTypeTourLabel;

  /// No description provided for @itineraryFallbackItemPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get itineraryFallbackItemPlace;

  /// No description provided for @itineraryFallbackItemEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get itineraryFallbackItemEvent;

  /// No description provided for @itineraryFallbackItemTour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get itineraryFallbackItemTour;

  /// No description provided for @itineraryFallbackItemCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom item'**
  String get itineraryFallbackItemCustom;

  /// No description provided for @onboardingCountryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Where are you from?'**
  String get onboardingCountryHeadline;

  /// No description provided for @onboardingCountrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience'**
  String get onboardingCountrySubtitle;

  /// No description provided for @onboardingVisitRwandaHeadline.
  ///
  /// In en, this message translates to:
  /// **'What brings you to Rwanda?'**
  String get onboardingVisitRwandaHeadline;

  /// No description provided for @onboardingVisitRwandaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your primary purpose'**
  String get onboardingVisitRwandaSubtitle;

  /// No description provided for @onboardingLanguageHeadline.
  ///
  /// In en, this message translates to:
  /// **'What language do you prefer?'**
  String get onboardingLanguageHeadline;

  /// No description provided for @onboardingLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in settings'**
  String get onboardingLanguageSubtitle;

  /// No description provided for @onboardingConsentHeadline.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get onboardingConsentHeadline;

  /// No description provided for @onboardingConsentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow analytics to help us personalize your experience'**
  String get onboardingConsentSubtitle;

  /// No description provided for @onboardingConsentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I agree to share analytics data to improve recommendations'**
  String get onboardingConsentCheckboxLabel;

  /// No description provided for @onboardingSettingsFootnote.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in settings'**
  String get onboardingSettingsFootnote;

  /// No description provided for @progressivePromptTitleWithDuration.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize Zoea (10 sec)'**
  String get progressivePromptTitleWithDuration;

  /// No description provided for @progressivePromptTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize Zoea'**
  String get progressivePromptTitleDefault;

  /// No description provided for @progressiveQuestionAgeRange.
  ///
  /// In en, this message translates to:
  /// **'What\'s your age range?'**
  String get progressiveQuestionAgeRange;

  /// No description provided for @progressiveQuestionGender.
  ///
  /// In en, this message translates to:
  /// **'What\'s your gender?'**
  String get progressiveQuestionGender;

  /// No description provided for @progressiveQuestionLengthOfStay.
  ///
  /// In en, this message translates to:
  /// **'How long are you staying?'**
  String get progressiveQuestionLengthOfStay;

  /// No description provided for @progressiveQuestionInterests.
  ///
  /// In en, this message translates to:
  /// **'What are you interested in?'**
  String get progressiveQuestionInterests;

  /// No description provided for @progressiveQuestionTravelParty.
  ///
  /// In en, this message translates to:
  /// **'Who are you traveling with?'**
  String get progressiveQuestionTravelParty;

  /// No description provided for @profileSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveChangesButton;

  /// No description provided for @profileCompletionPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your data is used only to personalize your experience. You can update or remove it anytime.'**
  String get profileCompletionPrivacyNote;

  /// No description provided for @profileCompletionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile completion'**
  String get profileCompletionSectionTitle;

  /// No description provided for @profileCompletionSubtitleRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to get better recommendations'**
  String get profileCompletionSubtitleRecommendations;

  /// No description provided for @tourBookingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Book tour'**
  String get tourBookingScreenTitle;

  /// No description provided for @tourBookingPerPersonSuffix.
  ///
  /// In en, this message translates to:
  /// **'/person'**
  String get tourBookingPerPersonSuffix;

  /// No description provided for @tourBookingSelectTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Select tour'**
  String get tourBookingSelectTourTitle;

  /// No description provided for @tourBookingSelectDateTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get tourBookingSelectDateTimeTitle;

  /// No description provided for @tourBookingNoSchedules.
  ///
  /// In en, this message translates to:
  /// **'No available schedules'**
  String get tourBookingNoSchedules;

  /// No description provided for @tourBookingScheduleSubtitleWithTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {time} · Spots: {spots} available'**
  String tourBookingScheduleSubtitleWithTime(String time, int spots);

  /// No description provided for @tourBookingScheduleSubtitleSpotsOnly.
  ///
  /// In en, this message translates to:
  /// **'Spots: {spots} available'**
  String tourBookingScheduleSubtitleSpotsOnly(int spots);

  /// No description provided for @tourBookingNumberOfGuestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get tourBookingNumberOfGuestsTitle;

  /// No description provided for @tourBookingGuestAdults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get tourBookingGuestAdults;

  /// No description provided for @tourBookingGuestChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get tourBookingGuestChildren;

  /// No description provided for @tourBookingGuestInfants.
  ///
  /// In en, this message translates to:
  /// **'Infants'**
  String get tourBookingGuestInfants;

  /// No description provided for @tourBookingContactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get tourBookingContactSectionTitle;

  /// No description provided for @tourBookingPickupLocationOptionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup location (optional)'**
  String get tourBookingPickupLocationOptionalTitle;

  /// No description provided for @tourBookingSpecialRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Special requests'**
  String get tourBookingSpecialRequestsTitle;

  /// No description provided for @tourBookingPriceBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Price breakdown'**
  String get tourBookingPriceBreakdownTitle;

  /// No description provided for @tourBookingPriceLineAdults.
  ///
  /// In en, this message translates to:
  /// **'Adults ({count}×)'**
  String tourBookingPriceLineAdults(int count);

  /// No description provided for @tourBookingPriceLineChildren.
  ///
  /// In en, this message translates to:
  /// **'Children ({count}×)'**
  String tourBookingPriceLineChildren(int count);

  /// No description provided for @tourBookingPriceLineInfants.
  ///
  /// In en, this message translates to:
  /// **'Infants ({count}×)'**
  String tourBookingPriceLineInfants(int count);

  /// No description provided for @tourBookingPriceLineFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get tourBookingPriceLineFree;

  /// No description provided for @tourBookingPriceLineTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get tourBookingPriceLineTotal;

  /// No description provided for @tourBookingLocationDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get tourBookingLocationDefaultLabel;

  /// No description provided for @experiencesTabTours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get experiencesTabTours;

  /// No description provided for @experiencesTabAdventures.
  ///
  /// In en, this message translates to:
  /// **'Adventures'**
  String get experiencesTabAdventures;

  /// No description provided for @experiencesTabCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get experiencesTabCultural;

  /// No description provided for @experiencesTabOperators.
  ///
  /// In en, this message translates to:
  /// **'Operators'**
  String get experiencesTabOperators;

  /// No description provided for @experiencesFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load experiences'**
  String get experiencesFailedLoad;

  /// No description provided for @experiencesOperatorsFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load operators'**
  String get experiencesOperatorsFailedLoad;

  /// No description provided for @experiencesEmptyAll.
  ///
  /// In en, this message translates to:
  /// **'No experiences found'**
  String get experiencesEmptyAll;

  /// No description provided for @experiencesEmptyTours.
  ///
  /// In en, this message translates to:
  /// **'No tours found'**
  String get experiencesEmptyTours;

  /// No description provided for @experiencesEmptyAdventures.
  ///
  /// In en, this message translates to:
  /// **'No adventures found'**
  String get experiencesEmptyAdventures;

  /// No description provided for @experiencesEmptyCultural.
  ///
  /// In en, this message translates to:
  /// **'No cultural experiences found'**
  String get experiencesEmptyCultural;

  /// No description provided for @experiencesEmptyOperators.
  ///
  /// In en, this message translates to:
  /// **'No operators found'**
  String get experiencesEmptyOperators;

  /// No description provided for @experiencesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new experiences'**
  String get experiencesEmptySubtitle;

  /// No description provided for @experiencesFilterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get experiencesFilterBy;

  /// No description provided for @experiencesSortRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get experiencesSortRating;

  /// No description provided for @experiencesSortPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get experiencesSortPrice;

  /// No description provided for @tourListingFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get tourListingFallbackName;

  /// No description provided for @tourOperatorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown operator'**
  String get tourOperatorUnknown;

  /// No description provided for @tourCardStartingFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get tourCardStartingFromLabel;

  /// No description provided for @tourCardStartingFromPrice.
  ///
  /// In en, this message translates to:
  /// **'Starting from {price}'**
  String tourCardStartingFromPrice(String price);

  /// No description provided for @tourOperatorReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'({count, plural, =1{1 review} other{{count} reviews}})'**
  String tourOperatorReviewsCount(int count);

  /// No description provided for @tourPackagesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tour packages'**
  String get tourPackagesLoadFailed;

  /// No description provided for @tourPackagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tour packages available'**
  String get tourPackagesEmpty;

  /// No description provided for @tourPackagesBadgePackage.
  ///
  /// In en, this message translates to:
  /// **'TOUR PACKAGE'**
  String get tourPackagesBadgePackage;

  /// No description provided for @tourPackagesBadgeFeatured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get tourPackagesBadgeFeatured;

  /// No description provided for @tourPackagesPriceOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Price on request'**
  String get tourPackagesPriceOnRequest;

  /// No description provided for @tourPackagesPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String tourPackagesPriceFrom(String price);

  /// No description provided for @tourDurationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String tourDurationDays(int count);

  /// No description provided for @tourDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String tourDurationHours(int count);

  /// No description provided for @tourPackagesUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled tour'**
  String get tourPackagesUntitled;

  /// No description provided for @tourPackagesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tour packages'**
  String get tourPackagesScreenTitle;

  /// No description provided for @reviewsViewPlaceAction.
  ///
  /// In en, this message translates to:
  /// **'View place'**
  String get reviewsViewPlaceAction;

  /// No description provided for @placeDetailMapViewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get placeDetailMapViewAction;

  /// No description provided for @itineraryFormButtonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create itinerary'**
  String get itineraryFormButtonCreate;

  /// No description provided for @itineraryFormButtonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update itinerary'**
  String get itineraryFormButtonUpdate;

  /// No description provided for @itineraryUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary updated successfully'**
  String get itineraryUpdatedSuccess;

  /// No description provided for @itineraryCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary created successfully'**
  String get itineraryCreatedSuccess;

  /// No description provided for @itineraryAddItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Add places, events, or tours to your itinerary'**
  String get itineraryAddItemsHint;

  /// No description provided for @itinerarySharedBadge.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get itinerarySharedBadge;

  /// No description provided for @shopCartUnknownItem.
  ///
  /// In en, this message translates to:
  /// **'Unknown item'**
  String get shopCartUnknownItem;

  /// No description provided for @listingDetailHoursClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get listingDetailHoursClosed;

  /// No description provided for @diningCategoryFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get diningCategoryFallbackName;

  /// No description provided for @bookingFallbackRestaurantName.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get bookingFallbackRestaurantName;

  /// No description provided for @aboutLegalCopyrightBody.
  ///
  /// In en, this message translates to:
  /// **'Copyright Notice\n\n© {year} Zoea Africa. All rights reserved.\n\nThis app and its contents are protected by copyright and other intellectual property laws.\n\nYou may not:\n- Copy, modify, or distribute the app without permission\n- Reverse engineer or attempt to extract source code\n- Use the app for commercial purposes without authorization\n\nFor licensing inquiries, contact us at legal@zoea.africa.'**
  String aboutLegalCopyrightBody(int year);

  /// No description provided for @aboutLegalPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy\n\nLast updated: December 2024\n\n1. Information We Collect\nWe collect information you provide directly to us, such as when you create an account, make a booking, or contact us for support.\n\n2. How We Use Your Information\nWe use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.\n\n3. Information Sharing\nWe do not sell, trade, or otherwise transfer your personal information to third parties without your consent.\n\n4. Data Security\nWe implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.\n\n5. Your Rights\nYou have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.\n\n6. Contact Us\nIf you have any questions about this Privacy Policy, please contact us at privacy@zoea.africa.'**
  String get aboutLegalPrivacyBody;

  /// No description provided for @aboutLegalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service\n\nLast updated: December 2024\n\n1. Acceptance of Terms\nBy using our app, you agree to be bound by these Terms of Service.\n\n2. Use of the App\nYou may use our app for lawful purposes only. You agree not to use the app in any way that could damage, disable, or impair the app.\n\n3. User Accounts\nYou are responsible for maintaining the confidentiality of your account and password.\n\n4. Bookings and Payments\nAll bookings are subject to availability. Payment terms are as specified at the time of booking.\n\n5. Cancellation Policy\nCancellation policies vary by event and are specified at the time of booking.\n\n6. Limitation of Liability\nTo the maximum extent permitted by law, we shall not be liable for any indirect, incidental, or consequential damages.\n\n7. Changes to Terms\nWe reserve the right to modify these terms at any time. We will notify users of any material changes.\n\n8. Contact Information\nFor questions about these Terms of Service, contact us at legal@zoea.africa.'**
  String get aboutLegalTermsBody;
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
