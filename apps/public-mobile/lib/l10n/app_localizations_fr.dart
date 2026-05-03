// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Zoea';

  @override
  String get shellTabExplore => 'Explorer';

  @override
  String get shellTabEvents => 'Événements';

  @override
  String get shellTabAskZoea => 'Demander à Zoea';

  @override
  String get shellTabStay => 'Séjour';

  @override
  String get shellTabBookings => 'Réservations';

  @override
  String get shellNoInternetTitle => 'Pas de connexion Internet';

  @override
  String get shellNoInternetSubtitle =>
      'Vérifiez le Wi-Fi ou les données mobiles';

  @override
  String get shellRetry => 'Réessayer';

  @override
  String get shellServiceIssueTitle => 'Problème de service';

  @override
  String get shellServiceIssueSubtitle => 'Difficulté à joindre nos serveurs';

  @override
  String get shellSnackNoInternet =>
      'Pas de connexion Internet. Vérifiez vos réglages réseau.';

  @override
  String get shellSnackInternetRestored => 'Connexion Internet rétablie !';

  @override
  String get shellSnackServiceUnavailable =>
      'Service temporairement indisponible. Nouvelle tentative…';

  @override
  String get shellSnackBackOnline =>
      'De nouveau en ligne ! Connexion rétablie.';

  @override
  String get authPromptBookingsTitle => 'Connexion requise';

  @override
  String get authPromptBookingsMessage =>
      'Connectez-vous pour voir vos réservations.';

  @override
  String get authCancel => 'Annuler';

  @override
  String get signIn => 'Se connecter';

  @override
  String get loginWelcomeBack => 'Bon retour';

  @override
  String get loginSignInToContinue => 'Connectez-vous pour continuer';

  @override
  String get loginTabPhone => 'Téléphone';

  @override
  String get loginTabEmail => 'E-mail';

  @override
  String get loginPhoneNumber => 'Numéro de téléphone';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginPasswordHint => 'Saisissez votre mot de passe';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginSignInButton => 'Se connecter';

  @override
  String get loginOr => 'ou';

  @override
  String get loginContinueWithGoogle => 'Continuer avec Google';

  @override
  String get loginBrowseAsGuest => 'Parcourir en invité';

  @override
  String get loginDontHaveAccount => 'Pas encore de compte ?';

  @override
  String get loginSignUp => 'S’inscrire';

  @override
  String get loginFailed => 'Échec de la connexion. Vérifiez vos identifiants.';

  @override
  String get loginErrorGeneric => 'Une erreur s’est produite. Réessayez.';

  @override
  String get loginGoogleFailed => 'Échec de la connexion Google. Réessayez.';

  @override
  String get loginEmailAddress => 'Adresse e-mail';

  @override
  String get loginEmailHint => 'votre.email@exemple.com';

  @override
  String get loginValidationEmailRequired => 'Saisissez votre adresse e-mail';

  @override
  String get loginValidationEmailInvalid => 'Adresse e-mail invalide';

  @override
  String get loginValidationPasswordRequired => 'Saisissez votre mot de passe';

  @override
  String get loginValidationPasswordShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileAppInformation => 'Informations sur l’app';

  @override
  String get profileSectionAccount => 'Compte';

  @override
  String get profileNotificationsTitle => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Gérer vos notifications';

  @override
  String get profileEditTitle => 'Modifier le profil';

  @override
  String get profileEditSubtitle => 'Mettre à jour vos informations';

  @override
  String get profilePrivacyTitle => 'Confidentialité et sécurité';

  @override
  String get profilePrivacySubtitle => 'Mot de passe et confidentialité';

  @override
  String get profileSectionPreferences => 'Préférences';

  @override
  String get profileCurrencyTitle => 'Devise';

  @override
  String get profileCountryTitle => 'Pays';

  @override
  String get profileCountryRwanda => 'Rwanda';

  @override
  String get profileLocationTitle => 'Localisation';

  @override
  String get profileLanguageTitle => 'Langue';

  @override
  String get profileSectionAppearance => 'Apparence';

  @override
  String get profileThemeLabel => 'Thème';

  @override
  String get profileThemeDark => 'Mode sombre';

  @override
  String get profileThemeLight => 'Mode clair';

  @override
  String get profileThemeSystem => 'Paramètres système';

  @override
  String get appearanceLight => 'Clair';

  @override
  String get appearanceDark => 'Sombre';

  @override
  String get appearanceSystem => 'Système';

  @override
  String get profileSectionTravel => 'Voyage et activités';

  @override
  String get profileMyBookingsTitle => 'Mes réservations';

  @override
  String get profileMyBookingsSubtitle => 'Voir vos réservations';

  @override
  String get profileFavoritesTitle => 'Favoris';

  @override
  String get profileFavoritesSubtitle => 'Lieux et événements enregistrés';

  @override
  String get profileReviewsTitle => 'Avis et notes';

  @override
  String get profileReviewsSubtitle => 'Vos avis et retours';

  @override
  String get profileSectionSupport => 'Assistance';

  @override
  String get profileHelpTitle => 'Centre d’aide';

  @override
  String get profileHelpSubtitle => 'Obtenir de l’aide';

  @override
  String get profileAboutMenuTitle => 'À propos';

  @override
  String profileAboutSubtitle(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get profileSignOutTitle => 'Se déconnecter';

  @override
  String get profileSignOutSubtitle => 'Quitter votre compte';

  @override
  String get profileStatEvents => 'Événements';

  @override
  String get profileStatPlaces => 'Lieux';

  @override
  String get profileStatReviews => 'Avis';

  @override
  String get profileStatAttended => 'Assistés';

  @override
  String get profileStatVisited => 'Visités';

  @override
  String get profileStatWritten => 'Rédigés';

  @override
  String get profileVerifiedTraveler => 'Voyageur vérifié';

  @override
  String get profileSelectLanguage => 'Choisir la langue';

  @override
  String get languageOptionEnglish => 'Anglais';

  @override
  String get languageOptionFrench => 'Français';

  @override
  String get languageNativeNameEnglish => 'Anglais';

  @override
  String get languageNativeNameFrench => 'Français';

  @override
  String profileLanguageChanged(String languageName) {
    return 'Langue changée : $languageName';
  }

  @override
  String profileLanguageUpdateFailed(String error) {
    return 'Échec de la mise à jour de la langue : $error';
  }

  @override
  String profileCurrencyChanged(String code) {
    return 'Devise changée : $code';
  }

  @override
  String profileCurrencyUpdateFailed(String error) {
    return 'Échec de la mise à jour de la devise : $error';
  }

  @override
  String profileCountryChanged(String name) {
    return 'Pays changé : $name. Le contenu sera filtré en conséquence.';
  }

  @override
  String get profileCountryChangeFailed =>
      'Impossible de changer de pays. Réessayez.';

  @override
  String profileLocationChanged(String name) {
    return 'Localisation changée : $name';
  }

  @override
  String profileLocationSaveFailed(String error) {
    return 'Impossible d’enregistrer la localisation : $error';
  }

  @override
  String get profileSelectCity => 'Choisir une ville';

  @override
  String get signOutDialogTitle => 'Se déconnecter';

  @override
  String get signOutDialogMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get signOutDialogConfirm => 'Se déconnecter';
}
