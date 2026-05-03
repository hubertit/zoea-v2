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

  @override
  String get commonViewMore => 'Voir plus';

  @override
  String get commonViewAll => 'Voir tout';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get exploreLoading => 'Chargement…';

  @override
  String get exploreDefaultCity => 'Kigali';

  @override
  String get exploreCurrencyPair => 'USD / RWF';

  @override
  String get exploreQuickActions => 'Actions rapides';

  @override
  String get exploreUnablePhoneCall => 'Impossible de passer l’appel';

  @override
  String get exploreEmergencyTollFreeTitle => 'Numéros verts d’urgence';

  @override
  String get exploreEmergencyEmergency => 'Urgences';

  @override
  String get exploreEmergencyTrafficAccidents => 'Accidents de la route';

  @override
  String get exploreEmergencyAbusePolice => 'Violences par un policier';

  @override
  String get exploreEmergencyAntiCorruption => 'Anti-corruption';

  @override
  String get exploreEmergencyMaritime => 'Urgences maritimes';

  @override
  String get exploreEmergencyDrivingLicense => 'Permis de conduire';

  @override
  String get exploreEmergencyFireRescue => 'Incendie et secours';

  @override
  String exploreCallNumber(String number) {
    return 'Appeler : $number';
  }

  @override
  String get exploreActionEmergencySos => 'SOS urgence';

  @override
  String get exploreActionCallTaxi => 'Appeler un taxi';

  @override
  String get exploreActionBookTour => 'Réserver une excursion';

  @override
  String get exploreActionEsim => 'eSim';

  @override
  String get exploreActionPharmacy => 'Pharmacie';

  @override
  String get exploreActionRoadsideAssistance => 'Assistance routière';

  @override
  String get exploreActionFlightInfo => 'Infos vols';

  @override
  String get exploreActionIrembo => 'Irembo';

  @override
  String get exploreActionVisitRwanda => 'Visit Rwanda';

  @override
  String get exploreWebviewTitleEsim => 'eSim';

  @override
  String get exploreWebviewTitleRwandAir => 'RwandAir';

  @override
  String get exploreWebviewTitleIrembo => 'Irembo';

  @override
  String get exploreWebviewTitleVisitRwanda => 'Visit Rwanda';

  @override
  String get exploreCategories => 'Catégories';

  @override
  String get exploreHappening => 'À l’affiche';

  @override
  String get exploreFailedLoadEvents => 'Impossible de charger les événements';

  @override
  String get exploreNoEventsToday => 'Aucun événement aujourd’hui';

  @override
  String get exploreAllCategories => 'Toutes les catégories';

  @override
  String get exploreNoCategoriesAvailable => 'Aucune catégorie disponible';

  @override
  String get exploreFailedLoadCategories =>
      'Impossible de charger les catégories';

  @override
  String get exploreRecommended => 'Recommandé';

  @override
  String get exploreNoFeaturedListings => 'Aucune recommandation disponible';

  @override
  String get exploreFailedRecommendations =>
      'Impossible de charger les recommandations';

  @override
  String get exploreNearMe => 'Près de moi';

  @override
  String get exploreNoListings => 'Aucun établissement disponible';

  @override
  String get exploreFailedListings =>
      'Impossible de charger les établissements';

  @override
  String get exploreTourPackages => 'Forfaits d’excursion';

  @override
  String get exploreFailedTours => 'Impossible de charger les excursions';

  @override
  String get exploreNoTours => 'Aucun forfait disponible';

  @override
  String get exploreUntitledTour => 'Excursion sans titre';

  @override
  String get exploreTourBadgeTour => 'EXCURSION';

  @override
  String get exploreTourBadgeFeatured => 'À LA UNE';

  @override
  String exploreTourPriceFrom(String price) {
    return 'À partir de $price';
  }

  @override
  String get exploreTourPriceUnavailable => 'À partir de RWF ---';

  @override
  String exploreTourDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String exploreTourDurationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String get exploreFavoriteSignInTitle => 'Connexion pour les favoris';

  @override
  String get exploreFavoriteSignInMessage =>
      'Créez un compte ou connectez-vous pour enregistrer vos lieux favoris.';

  @override
  String get exploreFavoriteSessionTitle => 'Connexion pour les favoris';

  @override
  String get exploreFavoriteSessionMessage =>
      'Votre session a expiré. Reconnectez-vous pour enregistrer vos favoris.';

  @override
  String exploreFavoriteUpdateFailed(String error) {
    return 'Impossible de mettre à jour le favori : $error';
  }

  @override
  String get exploreGiftReferTitle => 'Parrainer et gagner';

  @override
  String get exploreGiftReferSubtitle =>
      'Invitez des amis et gagnez des récompenses';

  @override
  String get exploreGiftItineraryTitle => 'Itinéraire';

  @override
  String get exploreGiftItinerarySubtitle =>
      'Planifiez et partagez votre voyage';

  @override
  String exploreEventTimeToday(String time) {
    return 'Aujourd’hui, $time';
  }

  @override
  String get exploreCategoryFallback => 'Catégorie';

  @override
  String get exploreListingUnknown => 'Inconnu';

  @override
  String get exploreListingPlace => 'Lieu';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonApply => 'Appliquer';

  @override
  String get commonClearAll => 'Tout effacer';

  @override
  String get commonFavoriteAdded => 'Ajouté aux favoris !';

  @override
  String get commonFavoriteRemoved => 'Retiré des favoris !';

  @override
  String get eventsTitle => 'Événements';

  @override
  String get eventsTabTrending => 'Tendances';

  @override
  String get eventsTabNearMe => 'Près de moi';

  @override
  String get eventsTabThisWeek => 'Cette semaine';

  @override
  String get eventsTabMice => 'MICE';

  @override
  String get eventsErrorLoading => 'Erreur lors du chargement des événements';

  @override
  String get eventsEmptyTitle => 'Aucun événement';

  @override
  String get eventsEmptySubtitle =>
      'Revenez plus tard pour de nouveaux événements';

  @override
  String get eventsSearchTitle => 'Rechercher des événements';

  @override
  String get eventsSearchHint => 'Rechercher des événements…';

  @override
  String eventsTicketPriceFrom(String amount, String currency) {
    return 'À partir de $amount $currency';
  }

  @override
  String get eventsFilterTitle => 'Filtrer les événements';

  @override
  String get eventsFilterSearchSection => 'Recherche';

  @override
  String get eventsFilterSearchHint => 'Rechercher des événements…';

  @override
  String get eventsFilterCategory => 'Catégorie';

  @override
  String get eventsFilterDateRange => 'Période';

  @override
  String get eventsFilterStartDate => 'Date de début';

  @override
  String get eventsFilterEndDate => 'Date de fin';

  @override
  String get eventsFilterPriceRange => 'Fourchette de prix';

  @override
  String get eventsFilterLocation => 'Lieu';

  @override
  String get eventsFilterLocationHint => 'Saisir un lieu…';

  @override
  String get eventsFilterOptions => 'Options';

  @override
  String get eventsFilterFreeEvents => 'Événements gratuits';

  @override
  String get eventsFilterVerifiedOnly => 'Vérifiés uniquement';

  @override
  String get eventsCategoryMusic => 'Musique';

  @override
  String get eventsCategorySports => 'Sport et bien-être';

  @override
  String get eventsCategoryFood => 'Gastronomie';

  @override
  String get eventsCategoryArts => 'Arts et culture';

  @override
  String get eventsCategoryConferences => 'Conférences';

  @override
  String get eventsCategoryPerformance => 'Spectacles';

  @override
  String get eventsPriceFree => 'Gratuit';

  @override
  String get eventsPriceUnder5k => 'Moins de 5K RWF';

  @override
  String get eventsPrice5kTo15k => '5K - 15K RWF';

  @override
  String get eventsPrice15kTo50k => '15K - 50K RWF';

  @override
  String get eventsPrice50kTo100k => '50K - 100K RWF';

  @override
  String get eventsPrice100kPlus => 'Plus de 100K RWF';

  @override
  String get eventsCalendarTitle => 'Calendrier des événements';

  @override
  String eventsCalendarOnDate(String date) {
    return 'Événements du $date';
  }

  @override
  String get eventsFavoriteSignInTitle => 'Connexion pour les favoris';

  @override
  String get eventsFavoriteSignInMessage =>
      'Créez un compte ou connectez-vous pour enregistrer vos événements favoris.';

  @override
  String get eventsFavoriteSessionMessage =>
      'Votre session a expiré. Reconnectez-vous pour enregistrer vos favoris.';

  @override
  String get eventsOrganizedBy => 'Organisé par';

  @override
  String get eventsAboutTitle => 'À propos de cet événement';

  @override
  String get eventsSectionCategory => 'Catégorie';

  @override
  String get eventsLabelAttending => 'Participants';

  @override
  String get eventsLabelCapacity => 'Capacité';

  @override
  String get eventsLabelStatus => 'Statut';

  @override
  String get eventsStatusOngoing => 'En cours';

  @override
  String get eventsStatusUpcoming => 'À venir';

  @override
  String get eventsTicketsSection => 'Billets';

  @override
  String get eventsTicketSoldOut => 'Complet';

  @override
  String get eventsTicketBuy => 'Acheter un billet';

  @override
  String get eventsBottomPerPerson => 'par personne';

  @override
  String get eventsBottomSelectTickets => 'Choisir des billets';

  @override
  String get eventsBottomJoinEvent => 'Rejoindre l’événement';

  @override
  String eventsBottomPriceFrom(String amount, String currency) {
    return 'À partir de $amount $currency';
  }

  @override
  String get eventsSincRedirectTitle => 'Redirection vers Sinc';

  @override
  String get eventsSincRedirectMessage =>
      'Vous allez être redirigé vers notre partenaire « Sinc » pour acheter des billets pour cet événement. Sinc est notre plateforme de billetterie de confiance pour des réservations et paiements sécurisés.';

  @override
  String get eventsSincDontShowAgain => 'Ne plus afficher';

  @override
  String eventsShareWithLocation(String name, String location, String date) {
    return 'Découvrez « $name » à $location le $date !';
  }

  @override
  String eventsShareNoLocation(String name, String date) {
    return 'Découvrez « $name » le $date !';
  }

  @override
  String get assistantSubtitle => 'Votre guide au Rwanda';

  @override
  String get assistantTooltipNewChat => 'Nouvelle conversation';

  @override
  String get assistantTooltipHistory => 'Historique';

  @override
  String get assistantInputHint => 'Posez une question sur le Rwanda…';

  @override
  String get assistantEmptyGreeting => 'Bonjour ! Je suis Zoea 👋';

  @override
  String get assistantEmptyBody =>
      'Votre guide au Rwanda. Lieux à visiter, restaurants, excursions ou tout autre sujet : demandez-moi !';

  @override
  String get assistantEmptyTryAsking => 'Essayez par exemple :';

  @override
  String assistantErrorSend(String error) {
    return 'Impossible d’envoyer le message : $error';
  }

  @override
  String get assistantHistorySignInTitle => 'Connexion pour l’historique';

  @override
  String get assistantHistorySignInMessage =>
      'Créez un compte ou connectez-vous pour voir l’historique de vos conversations avec Zoea.';

  @override
  String get assistantHistoryTitle => 'Conversations récentes';

  @override
  String get assistantHistoryEmpty => 'Aucune conversation';

  @override
  String get assistantHistoryLoadFailed =>
      'Impossible de charger les conversations';

  @override
  String assistantErrorLoadConversation(String error) {
    return 'Impossible de charger la conversation : $error';
  }

  @override
  String get assistantRelativeToday => 'Aujourd’hui';

  @override
  String get assistantRelativeYesterday => 'Hier';

  @override
  String assistantRelativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get assistantSuggestion1 => 'Dîner italien à Kigali';

  @override
  String get assistantSuggestion2 => 'Excursions gorilles ou safari';

  @override
  String get assistantSuggestion3 => 'Pharmacie ou distributeur à proximité';

  @override
  String get assistantSuggestion4 => 'Lieux populaires à voir';

  @override
  String get assistantSuggestion5 => 'Restaurants à Kigali';

  @override
  String get assistantSuggestion6 => 'Quelles excursions sont disponibles ?';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonClear => 'Effacer';

  @override
  String get commonNotApplicable => 'N/D';

  @override
  String get bookingsTabAll => 'Tout';

  @override
  String get bookingsTabUpcoming => 'À venir';

  @override
  String get bookingsTabPast => 'Passés';

  @override
  String get bookingsTabCancelled => 'Annulés';

  @override
  String get bookingsErrorOrders => 'Impossible de charger les commandes';

  @override
  String get bookingsErrorBookings => 'Impossible de charger les réservations';

  @override
  String get bookingsEmptyUpcomingTitle =>
      'Aucune réservation ou commande à venir';

  @override
  String get bookingsEmptyUpcomingSubtitle =>
      'Vous n’avez aucune réservation ou commande à venir';

  @override
  String get bookingsEmptyPastTitle => 'Aucune réservation ou commande passée';

  @override
  String get bookingsEmptyPastSubtitle =>
      'L’historique de vos réservations et commandes apparaîtra ici';

  @override
  String get bookingsEmptyCancelledTitle =>
      'Aucune réservation ou commande annulée';

  @override
  String get bookingsEmptyCancelledSubtitle =>
      'Les réservations et commandes annulées apparaîtront ici';

  @override
  String get bookingsEmptyDefaultTitle => 'Aucune réservation ou commande';

  @override
  String get bookingsEmptyDefaultSubtitle =>
      'Explorez l’app et effectuez votre première réservation ou commande !';

  @override
  String get bookingsExploreNow => 'Explorer';

  @override
  String get bookingsSearchTitle => 'Rechercher des réservations';

  @override
  String get bookingsSearchHint =>
      'Rechercher par nom, lieu, n° de réservation ou de commande…';

  @override
  String get bookingsLocationNotSpecified => 'Lieu non précisé';

  @override
  String get bookingsTourLocation => 'Lieu de l’excursion';

  @override
  String get stayTitle => 'Où loger';

  @override
  String get staySubtitle => 'Trouvez l’hébergement idéal';

  @override
  String get stayTabAll => 'Tout';

  @override
  String get stayTabHotels => 'Hôtels';

  @override
  String get stayTabBnbs => 'Chambres d’hôtes';

  @override
  String get stayTabApartments => 'Appartements';

  @override
  String get stayTabVillas => 'Villas';

  @override
  String get stayAnyDates => 'Toutes les dates';

  @override
  String get staySelectCheckout => 'Choisir le départ';

  @override
  String stayGuestCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invités',
      one: '1 invité',
    );
    return '$_temp0';
  }

  @override
  String get stayFailedLoad => 'Impossible de charger les hébergements';

  @override
  String stayEmptyNoMatchesForCategory(String category) {
    return 'Aucun résultat : $category';
  }

  @override
  String get stayEmptyAdjust => 'Modifiez votre recherche ou vos filtres';

  @override
  String get stayFiltersTitle => 'Filtres';

  @override
  String get stayPriceRangeRwf => 'Fourchette de prix (RWF)';

  @override
  String get stayPriceMinSample => 'Min. : 10 000';

  @override
  String get stayPriceMaxSample => 'Max. : 200 000';

  @override
  String get stayMinimumRating => 'Note minimale';

  @override
  String stayRatingAtLeastPlus(int min) {
    return '$min+';
  }

  @override
  String get stayAmenities => 'Équipements';

  @override
  String get stayAmenityWifi => 'Wi‑Fi';

  @override
  String get stayAmenityPool => 'Piscine';

  @override
  String get stayAmenitySpa => 'Spa';

  @override
  String get stayAmenityGym => 'Salle de sport';

  @override
  String get stayAmenityRestaurant => 'Restaurant';

  @override
  String get stayAmenityParking => 'Parking';

  @override
  String get stayAmenityAirConditioning => 'Climatisation';

  @override
  String get stayAmenityBusinessCenter => 'Centre d’affaires';

  @override
  String get stayAmenityKitchen => 'Cuisine';

  @override
  String get stayAmenityGarden => 'Jardin';

  @override
  String get stayAmenityRoomService => 'Service en chambre';

  @override
  String get stayPropertyType => 'Type de bien';

  @override
  String get stayDistanceFromCenter => 'Distance du centre-ville';

  @override
  String get stayDistanceAny => 'Tout';

  @override
  String get stayDistanceUnder5km => 'Moins de 5 km';

  @override
  String get stayDistance5to10km => '5–10 km';

  @override
  String get stayDistance10to20km => '10–20 km';

  @override
  String get stayDistanceOver20km => 'Plus de 20 km';

  @override
  String get stayApplyFilters => 'Appliquer les filtres';

  @override
  String get stayMapComingSoon => 'Vue carte bientôt disponible !';

  @override
  String get staySearchOptionsTitle => 'Options de recherche';

  @override
  String get stayWhereLabel => 'Où';

  @override
  String get stayCheckInOutLabel => 'Arrivée et départ';

  @override
  String get stayGuestsLabel => 'Invités';

  @override
  String get staySearchAccommodations => 'Rechercher un hébergement';

  @override
  String get staySelectLocationTitle => 'Choisir un lieu';

  @override
  String get staySelectDatesTimesTitle => 'Choisir dates et heures';

  @override
  String get stayCheckIn => 'Arrivée';

  @override
  String get stayCheckOut => 'Départ';

  @override
  String get staySelectDate => 'Choisir la date';

  @override
  String get staySelectTime => 'Choisir l’heure';

  @override
  String get stayNumberOfGuests => 'Nombre d’invités';

  @override
  String get stayGuestsSheetGuests => 'Invités';

  @override
  String get staySortBy => 'Trier par';

  @override
  String get staySortRecommended => 'Recommandé';

  @override
  String get staySortPriceLowHigh => 'Prix : croissant';

  @override
  String get staySortPriceHighLow => 'Prix : décroissant';

  @override
  String get staySortRatingHighLow => 'Note : décroissante';

  @override
  String get staySortRatingLowHigh => 'Note : croissante';

  @override
  String get staySortDistance => 'Distance';

  @override
  String get staySortPopularity => 'Popularité';

  @override
  String get stayListingFallback => 'Hébergement';

  @override
  String get stayLocationUnavailable => 'Lieu non disponible';

  @override
  String get stayBreakfast => 'Petit-déjeuner';

  @override
  String stayRoomTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count types de chambres',
      one: '1 type de chambre',
    );
    return '$_temp0';
  }

  @override
  String get bookingsBookAgain => 'Réserver à nouveau';

  @override
  String get bookingsViewDetails => 'Voir le détail';

  @override
  String bookingsBookedOn(String date) {
    return 'Réservé le $date';
  }

  @override
  String bookingsOrderedOn(String date) {
    return 'Commandé le $date';
  }

  @override
  String get bookingsOrderLabel => 'COMMANDE';

  @override
  String get bookingsDateNotSpecified => 'Date non précisée';

  @override
  String bookingsOrderPreviewMessage(String number) {
    return 'Détails de la commande $number';
  }

  @override
  String get bookingsCancelOrderSoon =>
      'Annulation de commande bientôt disponible';

  @override
  String bookingsLineItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSpecified => 'Non précisé';

  @override
  String get maintenanceTitle => 'Nous revenons tout de suite !';

  @override
  String get maintenanceMessage =>
      'Nos systèmes sont en maintenance pour mieux vous servir. Nous serons de retour en ligne sous peu.';

  @override
  String get maintenanceTryAgain => 'Réessayer';

  @override
  String maintenanceSupport(String email) {
    return 'Besoin d’aide ? Écrivez-nous à $email';
  }

  @override
  String get maintenanceStillUnavailable =>
      'Le service est toujours indisponible. Réessayez dans un instant.';

  @override
  String get helpSearchHint => 'Rechercher dans l’aide…';

  @override
  String get helpQuickHelp => 'Aide rapide';

  @override
  String get helpPopularTopics => 'Sujets populaires';

  @override
  String get helpContactSupport => 'Contacter le support';

  @override
  String get helpFaqCategoriesTitle => 'Questions fréquentes';

  @override
  String get helpLinkOpenFailed =>
      'Impossible d’ouvrir le lien. Réessayez plus tard.';

  @override
  String get helpContactButton => 'Contacter';

  @override
  String helpFeatureComingSoon(String feature) {
    return '$feature : bientôt disponible !';
  }

  @override
  String get helpLiveChatBody =>
      'Démarrez une session de chat en direct avec notre équipe support.';

  @override
  String get helpQuickAccountTitle => 'Problèmes de compte';

  @override
  String get helpQuickAccountSubtitle => 'Connexion, inscription et profil';

  @override
  String get helpQuickPaymentTitle => 'Paiement et facturation';

  @override
  String get helpQuickPaymentSubtitle =>
      'Paiements de réservation et remboursements';

  @override
  String get helpQuickEventsTitle => 'Événements et réservations';

  @override
  String get helpQuickEventsSubtitle => 'Billets et gestion des réservations';

  @override
  String get helpQuickPlacesTitle => 'Lieux et destinations';

  @override
  String get helpQuickPlacesSubtitle => 'Trouver et visiter des lieux';

  @override
  String get helpTopicBookEvents => 'Réserver un événement';

  @override
  String get helpTopicPaymentMethods => 'Moyens de paiement';

  @override
  String get helpTopicCancelBooking => 'Annuler une réservation';

  @override
  String get helpTopicUpdateProfile => 'Mettre à jour le profil';

  @override
  String get helpTopicContactSupport => 'Contacter le support';

  @override
  String get helpTopicAppFeatures => 'Fonctionnalités de l’app';

  @override
  String get helpLiveChatTitle => 'Chat en direct';

  @override
  String get helpLiveChatSubtitle => 'Obtenez de l’aide instantanément';

  @override
  String get helpEmailSupportTitle => 'Assistance par e-mail';

  @override
  String get helpPhoneSupportTitle => 'Assistance téléphonique';

  @override
  String get helpPhoneSupportSubtitle => '+250 796 889 900';

  @override
  String get helpFaqGettingStarted => 'Pour bien commencer';

  @override
  String get helpFaqAccountProfile => 'Compte et profil';

  @override
  String get helpFaqBookingsEvents => 'Réservations et événements';

  @override
  String get helpFaqPaymentRefunds => 'Paiements et remboursements';

  @override
  String get helpFaqTechnicalIssues => 'Problèmes techniques';

  @override
  String get helpAppVersionLabel => 'Version de l’app';

  @override
  String get helpBuildNumberLabel => 'Numéro de build';

  @override
  String get helpLastUpdatedLabel => 'Dernière mise à jour';

  @override
  String get helpPlatformLabel => 'Plateforme';

  @override
  String get helpPackageInfoError =>
      'Impossible de charger les infos de l’application.';

  @override
  String get helpArticleAccount =>
      'Problèmes de compte courants et solutions :\n\n• Mot de passe oublié : utilisez le lien « Mot de passe oublié » sur l’écran de connexion\n• Vérification du compte : consultez vos e-mails pour les liens de vérification\n• Mises à jour du profil : Profil > Modifier le profil\n• Sécurité du compte : activez l’authentification à deux facteurs dans Confidentialité et sécurité\n• Données personnelles : consultez vos paramètres de confidentialité dans l’app';

  @override
  String get helpArticlePayment =>
      'Aide paiement et facturation :\n\n• Moyens de paiement : cartes bancaires, mobile money ou virements\n• Remboursements : contactez le support pour les annulations et remboursements\n• Historique des paiements : consultez vos transactions dans le profil\n• Paiements refusés : vérifiez votre moyen de paiement et réessayez\n• Devise : les paiements sont traités en francs rwandais (RWF)';

  @override
  String get helpArticleBooking =>
      'Réservation et gestion d’événements :\n\n• Réserver : parcourez les événements et appuyez sur « Réserver »\n• Confirmation : vous recevrez des notifications par e-mail et dans l’app\n• Annulation : Mes réservations > annuler les événements à venir\n• Actualités : consultez l’onglet Événements\n• Groupes : contactez le support pour les réservations de groupe';

  @override
  String get helpArticlePlaces =>
      'Lieux et localisation :\n\n• Recherche : barre de recherche ou catégories\n• Détails : appuyez sur un lieu pour photos, avis et infos\n• Itinéraires : ouvrez votre application de cartes préférée\n• Avis : partagez votre expérience\n• Favoris : enregistrez les lieux à visiter plus tard';

  @override
  String get helpFaqGs1Q => 'Comment créer un compte ?';

  @override
  String get helpFaqGs1A =>
      'Téléchargez l’app et appuyez sur « Inscription » pour créer un compte avec e-mail ou téléphone.';

  @override
  String get helpFaqGs2Q => 'Comment réserver mon premier événement ?';

  @override
  String get helpFaqGs2A =>
      'Parcourez l’onglet Événements, choisissez un événement et appuyez sur « Réserver ».';

  @override
  String get helpFaqGs3Q => 'Comment mettre à jour mon profil ?';

  @override
  String get helpFaqGs3A => 'Allez dans Profil > Modifier le profil.';

  @override
  String get helpFaqGs4Q => 'Comment trouver des lieux à visiter ?';

  @override
  String get helpFaqGs4A =>
      'Utilisez l’onglet Explorer ou recherchez un lieu précis.';

  @override
  String get helpFaqGs5Q => 'Comment obtenir de l’aide ?';

  @override
  String get helpFaqGs5A =>
      'Utilisez ce centre d’aide, contactez le support ou consultez la FAQ.';

  @override
  String get helpFaqAc1Q => 'Comment changer mon mot de passe ?';

  @override
  String get helpFaqAc1A =>
      'Profil > Confidentialité et sécurité > Changer le mot de passe.';

  @override
  String get helpFaqAc2Q => 'Comment mettre à jour mon e-mail ?';

  @override
  String get helpFaqAc2A => 'Profil > Modifier le profil.';

  @override
  String get helpFaqAc3Q => 'Comment supprimer mon compte ?';

  @override
  String get helpFaqAc3A =>
      'Contactez le support pour demander la suppression. Action irréversible.';

  @override
  String get helpFaqAc4Q =>
      'Comment activer l’authentification à deux facteurs ?';

  @override
  String get helpFaqAc4A =>
      'Profil > Confidentialité et sécurité pour activer le 2FA.';

  @override
  String get helpFaqAc5Q => 'Comment changer ma photo de profil ?';

  @override
  String get helpFaqAc5A =>
      'Profil > Modifier le profil > appuyez sur la photo.';

  @override
  String get helpFaqAc6Q => 'Comment changer mon numéro de téléphone ?';

  @override
  String get helpFaqAc6A => 'Profil > Modifier le profil.';

  @override
  String get helpFaqAc7Q => 'Comment vérifier mon compte ?';

  @override
  String get helpFaqAc7A =>
      'Consultez vos e-mails pour les liens de vérification.';

  @override
  String get helpFaqAc8Q => 'Comment télécharger mes données ?';

  @override
  String get helpFaqAc8A =>
      'Profil > Confidentialité et sécurité > Télécharger mes données.';

  @override
  String get helpFaqBk1Q => 'Comment réserver un événement ?';

  @override
  String get helpFaqBk1A =>
      'Parcourez les événements, choisissez-en un et appuyez sur « Réserver ».';

  @override
  String get helpFaqBk2Q => 'Comment annuler une réservation ?';

  @override
  String get helpFaqBk2A =>
      'Mes réservations > trouvez la réservation > « Annuler la réservation ».';

  @override
  String get helpFaqBk3Q => 'Comment recevoir mes billets ?';

  @override
  String get helpFaqBk3A => 'Par e-mail et dans l’application.';

  @override
  String get helpFaqBk4Q => 'Puis-je réserver pour plusieurs personnes ?';

  @override
  String get helpFaqBk4A =>
      'Oui, indiquez le nombre de personnes lors de la réservation.';

  @override
  String get helpFaqBk5Q => 'Comment obtenir un remboursement ?';

  @override
  String get helpFaqBk5A =>
      'Contactez le support ; les conditions varient selon l’événement.';

  @override
  String get helpFaqBk6Q => 'Comment décaler une réservation ?';

  @override
  String get helpFaqBk6A =>
      'Annulez la réservation actuelle puis réservez un nouveau créneau.';

  @override
  String get helpFaqBk7Q => 'Comment voir le statut de ma réservation ?';

  @override
  String get helpFaqBk7A => 'Consultez Mes réservations.';

  @override
  String get helpFaqBk8Q => 'Et si un événement est annulé ?';

  @override
  String get helpFaqBk8A =>
      'Vous serez informé ; remboursement intégral ou report possible.';

  @override
  String get helpFaqBk9Q => 'Comment réserver un hôtel ?';

  @override
  String get helpFaqBk9A =>
      'Parcourez les hôtels dans Explorer et suivez le flux de réservation.';

  @override
  String get helpFaqBk10Q => 'Comment réserver une excursion ?';

  @override
  String get helpFaqBk10A =>
      'Trouvez les excursions dans Explorer comme pour les événements.';

  @override
  String get helpFaqBk11Q => 'Comment obtenir l’itinéraire vers un événement ?';

  @override
  String get helpFaqBk11A =>
      'Appuyez sur le lieu de l’événement pour l’ouvrir dans votre appli cartes.';

  @override
  String get helpFaqBk12Q => 'Comment partager un événement ?';

  @override
  String get helpFaqBk12A =>
      'Utilisez le bouton Partager sur la fiche événement.';

  @override
  String get helpFaqPy1Q => 'Quels moyens de paiement sont acceptés ?';

  @override
  String get helpFaqPy1A => 'Cartes bancaires, mobile money et virements.';

  @override
  String get helpFaqPy2Q => 'Comment ajouter un moyen de paiement ?';

  @override
  String get helpFaqPy2A => 'Profil > Moyens de paiement.';

  @override
  String get helpFaqPy3Q => 'Comment obtenir un remboursement ?';

  @override
  String get helpFaqPy3A =>
      'Contactez le support avec les détails de la réservation.';

  @override
  String get helpFaqPy4Q => 'Combien de temps pour un remboursement ?';

  @override
  String get helpFaqPy4A => 'En général 3 à 5 jours ouvrables.';

  @override
  String get helpFaqPy5Q => 'Mes données de paiement sont-elles sécurisées ?';

  @override
  String get helpFaqPy5A =>
      'Oui, nous utilisons un chiffrement conforme aux standards du secteur.';

  @override
  String get helpFaqPy6Q => 'Comment mettre à jour mon moyen de paiement ?';

  @override
  String get helpFaqPy6A => 'Profil > Moyens de paiement.';

  @override
  String get helpFaqTx1Q => 'L’application ne charge pas correctement';

  @override
  String get helpFaqTx1A =>
      'Fermez puis rouvrez l’app, ou redémarrez l’appareil.';

  @override
  String get helpFaqTx2Q => 'Je ne peux pas me connecter';

  @override
  String get helpFaqTx2A =>
      'Vérifiez la connexion Internet et vos identifiants.';

  @override
  String get helpFaqTx3Q => 'L’application plante souvent';

  @override
  String get helpFaqTx3A =>
      'Mettez à jour vers la dernière version depuis le store.';

  @override
  String get helpFaqTx4Q => 'Je ne reçois pas les notifications';

  @override
  String get helpFaqTx4A =>
      'Vérifiez les réglages de notifications du téléphone et de l’app.';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerSubtitle => 'Rejoignez la communauté Zoea Africa';

  @override
  String get registerInviteBanner =>
      'Vous avez ouvert un lien d’invitation — le code a été ajouté ci-dessous. Vous pouvez le modifier ou en coller un autre depuis un message.';

  @override
  String get registerFullName => 'Nom complet';

  @override
  String get registerFullNameHint => 'Saisissez votre nom complet';

  @override
  String get registerFieldRequired => 'Obligatoire';

  @override
  String get registerEmailLabel => 'E-mail';

  @override
  String get registerEmailHint => 'Saisissez votre adresse e-mail';

  @override
  String get registerInviteCodeLabel => 'Code d’invitation';

  @override
  String get registerInviteCodeHint => 'Collez-le si vous en avez un';

  @override
  String get registerCodeTooLong => 'Code trop long';

  @override
  String get registerPasswordLabel => 'Mot de passe';

  @override
  String get registerPasswordHint => 'Créez un mot de passe robuste';

  @override
  String get registerConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get registerConfirmPasswordHint => 'Confirmez votre mot de passe';

  @override
  String get registerConfirmPasswordRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get registerPasswordsMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get registerAgreePrefix => 'J’accepte les ';

  @override
  String get registerTerms => 'Conditions générales';

  @override
  String get registerAndConjunction => ' et la ';

  @override
  String get registerPrivacy => 'Politique de confidentialité';

  @override
  String get registerAlreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get registerAgreeTermsMessage =>
      'Veuillez accepter les conditions générales';

  @override
  String get registerFailed => 'Inscription impossible. Réessayez.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsAppearanceSection => 'Apparence';

  @override
  String get settingsCurrentTheme => 'Thème actuel';

  @override
  String get commonViewDetails => 'Voir le détail';

  @override
  String get commonRemove => 'Retirer';

  @override
  String get commonLoadMore => 'Charger plus';

  @override
  String get mapScreenTitle => 'Carte';

  @override
  String get transactionHistoryTitle => 'Historique des transactions';

  @override
  String get itineraryAddFromFavoritesTitle => 'Ajouter depuis les favoris';

  @override
  String get shopSearchProductsTitle => 'Rechercher des produits';

  @override
  String get shopClearFilters => 'Effacer les filtres';

  @override
  String get webviewOpenInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get commonViewEvent => 'Voir l’événement';

  @override
  String get commonViewPlace => 'Voir le lieu';

  @override
  String get mapScreenHeadline => 'Vue carte';

  @override
  String get mapScreenPlaceholder =>
      'La carte interactive avec les fiches sera disponible ici';

  @override
  String get transactionHistorySubtitle =>
      'Consultez vos paiements et l’historique des transactions';

  @override
  String itineraryAddWithCount(int count) {
    return 'Ajouter ($count)';
  }

  @override
  String get favoritesEmptyTitle => 'Aucun favori';

  @override
  String get favoritesEmptySubtitle => 'Vous n’avez pas encore de favoris';

  @override
  String get favoritesLoadError => 'Impossible de charger les favoris';

  @override
  String get splashHeadline1 => 'Découvrez le Rwanda';

  @override
  String get splashHeadline2 => 'Comme jamais auparavant';

  @override
  String get splashTagline =>
      'Explorez des destinations exceptionnelles, des expériences authentiques et des trésors cachés au pays des mille collines.';

  @override
  String get onboardingPage1Title => 'Découvrez le Rwanda';

  @override
  String get onboardingPage1Subtitle =>
      'Explorez le pays des mille collines avec des expériences vérifiées';

  @override
  String get onboardingPage2Title => 'Réservez en toute simplicité';

  @override
  String get onboardingPage2Subtitle =>
      'Réservez hôtels, restaurants et excursions avec votre carte Zoea';

  @override
  String get onboardingPage3Title => 'Échangez et partagez';

  @override
  String get onboardingPage3Subtitle =>
      'Rejoignez la communauté et partagez vos aventures au Rwanda';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingSkipGuest => 'Passer — parcourir en invité';

  @override
  String get onboardingSignInPrompt =>
      'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get countryPickerSearchHint => 'Tapez pour rechercher';

  @override
  String get authResetPasswordAppBar => 'Réinitialiser le mot de passe';

  @override
  String get authChooseResetMethod =>
      'Choisissez comment réinitialiser votre mot de passe';

  @override
  String get authResetCodeSentDefault => 'Code de réinitialisation envoyé';

  @override
  String get authSendResetCode => 'Envoyer le code';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authVerifyCodeTitle => 'Vérifier le code';

  @override
  String get authEnterResetCode => 'Saisissez le code';

  @override
  String authResetCodeSentTo(int digits, String identifier) {
    return 'Nous avons envoyé un code à $digits chiffres à $identifier';
  }

  @override
  String get authVerifyCodeButton => 'Vérifier le code';

  @override
  String get authResendCode => 'Renvoyer le code';

  @override
  String get authResendSending => 'Envoi…';

  @override
  String authResendCodeIn(String time) {
    return 'Renvoyer le code dans $time';
  }

  @override
  String get authNewPasswordAppBar => 'Nouveau mot de passe';

  @override
  String get authCreateNewPasswordTitle => 'Créer un nouveau mot de passe';

  @override
  String get authCreateNewPasswordBody =>
      'Saisissez votre nouveau mot de passe. Choisissez-en un solide et sécurisé.';

  @override
  String get authNewPasswordFieldLabel => 'Nouveau mot de passe';

  @override
  String get authNewPasswordFieldHint => 'Saisissez votre nouveau mot de passe';

  @override
  String get authConfirmNewPasswordHint =>
      'Confirmez votre nouveau mot de passe';

  @override
  String get authEnterNewPasswordError =>
      'Veuillez saisir un nouveau mot de passe';

  @override
  String get authPasswordResetSuccess => 'Mot de passe réinitialisé !';

  @override
  String get authSaveNewPassword => 'Enregistrer le mot de passe';

  @override
  String get authNewCodeRequested => 'Un nouveau code a été demandé.';

  @override
  String get authPhoneNumberExample => '780 123 456';

  @override
  String get shopScreenTitleShop => 'Boutique';

  @override
  String get shopScreenTitleProducts => 'Produits';

  @override
  String shopProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produits',
      one: '1 produit',
    );
    return '$_temp0';
  }

  @override
  String shopSortLine(String label) {
    return 'Trier : $label';
  }

  @override
  String get shopEmptyNoProducts => 'Aucun produit';

  @override
  String get shopEmptyAdjustFilters =>
      'Essayez d’ajuster vos filtres ou votre recherche';

  @override
  String get shopErrorLoadProducts => 'Impossible de charger les produits';

  @override
  String get shopOutOfStock => 'Rupture de stock';

  @override
  String get shopFilterTitle => 'Filtrer les produits';

  @override
  String get shopStatusSection => 'Statut';

  @override
  String get shopFeaturedSection => 'À la une';

  @override
  String get shopFilterActive => 'Actif';

  @override
  String get shopFilterInactive => 'Inactif';

  @override
  String get shopFeaturedOnly => 'À la une uniquement';

  @override
  String get shopFilterReset => 'Réinitialiser';

  @override
  String get shopSearchProductNameHint => 'Nom du produit…';

  @override
  String get shopSortPopular => 'Populaire';

  @override
  String get shopSortNameAz => 'Nom (A–Z)';

  @override
  String get shopSortNameZa => 'Nom (Z–A)';

  @override
  String get shopSortPriceLowHigh => 'Prix (croissant)';

  @override
  String get shopSortPriceHighLow => 'Prix (décroissant)';

  @override
  String get shopSortNewest => 'Les plus récents';

  @override
  String get favoritesEmptyAllTitle => 'Pas encore de favoris';

  @override
  String get favoritesEmptyAllSubtitle =>
      'Explorez et enregistrez vos événements et lieux préférés';

  @override
  String get favoritesEmptyExploreCta => 'Explorer';

  @override
  String get favoritesEmptyEventsTitle => 'Aucun événement favori';

  @override
  String get favoritesEmptyEventsSubtitle =>
      'Enregistrez les événements qui vous intéressent pour les voir ici';

  @override
  String get favoritesEmptyEventsCta => 'Parcourir les événements';

  @override
  String get favoritesEmptyPlacesTitle => 'Aucun lieu favori';

  @override
  String get favoritesEmptyPlacesSubtitle =>
      'Enregistrez les lieux que vous souhaitez visiter pour les voir ici';

  @override
  String get favoritesEmptyPlacesCta => 'Explorer les lieux';

  @override
  String get favoritesRemoveTitle => 'Retirer des favoris';

  @override
  String favoritesRemoveMessage(String name) {
    return 'Retirer « $name » de vos favoris ?';
  }

  @override
  String favoritesRemoveFailed(String error) {
    return 'Impossible de retirer le favori : $error';
  }

  @override
  String get favoritesTypeEvent => 'Événement';

  @override
  String get favoritesTypePlace => 'Lieu';

  @override
  String get favoritesDateTba => 'Date à confirmer';

  @override
  String get categoryTitleDining => 'Restauration';

  @override
  String get categoryTitleNightlife => 'Vie nocturne';

  @override
  String get categoryTitleExperiences => 'Expériences';

  @override
  String get categoryTitlePlaces => 'Lieux';

  @override
  String categorySearchAppBar(String categoryName) {
    return 'Rechercher · $categoryName';
  }

  @override
  String get categorySearchHintDining => 'Restaurants, cafés…';

  @override
  String get categorySearchHintNightlife => 'Bars, clubs, salons…';

  @override
  String get categorySearchHintExperiences =>
      'Circuits, aventures, expériences…';

  @override
  String get categorySearchHintDefault => 'Lieux…';

  @override
  String get categoryNotFound => 'Catégorie introuvable';

  @override
  String get categoryErrorListings => 'Impossible de charger les annonces';

  @override
  String get categoryErrorCategory => 'Impossible de charger la catégorie';

  @override
  String categoryEmptyPrompt(String categoryName) {
    return 'Rechercher · $categoryName';
  }

  @override
  String get categoryEmptyNoResults => 'Aucun résultat';

  @override
  String get categoryEmptyTryDifferentKeywords =>
      'Essayez d’autres mots-clés ou catégories';

  @override
  String get categorySearchSuggestionsDining =>
      'Essayez « pizza », « café » ou « sushi »';

  @override
  String get categorySearchSuggestionsNightlife =>
      'Essayez « bar », « club » ou « salon »';

  @override
  String get categorySearchSuggestionsExperiences =>
      'Essayez « gorille », « randonnée » ou « culturel »';

  @override
  String get categorySearchSuggestionsDefault =>
      'Recherchez des lieux ou des destinations précises';

  @override
  String categoryFilterSheetTitle(String categoryName) {
    return 'Filtrer · $categoryName';
  }

  @override
  String categorySortSheetTitle(String categoryName) {
    return 'Trier · $categoryName';
  }

  @override
  String get categorySectionPriceRange => 'Fourchette de prix';

  @override
  String get categorySectionFeatures => 'Équipements';

  @override
  String get categoryRatingStars40 => '4,0+ étoiles';

  @override
  String get categoryRatingStars45 => '4,5+ étoiles';

  @override
  String get categoryRatingStars50 => '5,0 étoiles';

  @override
  String get catTourOperatorBadge => 'Tour opérateur';

  @override
  String listingReviewsCountParen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
    );
    return '($_temp0)';
  }

  @override
  String get catSubDiningRestaurants => 'Restaurants';

  @override
  String get catSubDiningCafes => 'Cafés';

  @override
  String get catSubDiningFastFood => 'Restauration rapide';

  @override
  String get catSubNightBars => 'Bars';

  @override
  String get catSubNightClubs => 'Clubs';

  @override
  String get catSubNightLounges => 'Salons';

  @override
  String get catSubExpTours => 'Circuits';

  @override
  String get catSubExpAdventures => 'Aventures';

  @override
  String get catSubExpCultural => 'Culturel';

  @override
  String get catSubExpOperators => 'Opérateurs';

  @override
  String get catPriceDiningU5k => 'Moins de 5 000 RWF';

  @override
  String get catPriceDining5to15k => '5 000 – 15 000 RWF';

  @override
  String get catPriceDining15to30k => '15 000 – 30 000 RWF';

  @override
  String get catPriceDiningOver30k => 'Plus de 30 000 RWF';

  @override
  String get catPriceNightU10k => 'Moins de 10 000 RWF';

  @override
  String get catPriceNight10to20k => '10 000 – 20 000 RWF';

  @override
  String get catPriceNight20to30k => '20 000 – 30 000 RWF';

  @override
  String get catPriceNightOver30k => 'Plus de 30 000 RWF';

  @override
  String get catPriceExpU50k => 'Moins de 50 000 RWF';

  @override
  String get catPriceExp50to100k => '50 000 – 100 000 RWF';

  @override
  String get catPriceExp100to200k => '100 000 – 200 000 RWF';

  @override
  String get catPriceExpOver200k => 'Plus de 200 000 RWF';

  @override
  String get catPriceDefU10k => 'Moins de 10 000 RWF';

  @override
  String get catPriceDef10to30k => '10 000 – 30 000 RWF';

  @override
  String get catPriceDefOver30k => 'Plus de 30 000 RWF';

  @override
  String get catFeatDiningWifi => 'Wi‑Fi';

  @override
  String get catFeatDiningParking => 'Parking';

  @override
  String get catFeatDiningOutdoorSeating => 'Terrasse';

  @override
  String get catFeatDiningDelivery => 'Livraison';

  @override
  String get catFeatDiningTakeaway => 'À emporter';

  @override
  String get catFeatDiningVegetarian => 'Options végétariennes';

  @override
  String get catFeatNightLiveMusic => 'Musique live';

  @override
  String get catFeatNightDanceFloor => 'Piste de danse';

  @override
  String get catFeatNightOutdoorSeating => 'Terrasse';

  @override
  String get catFeatNightVip => 'Section VIP';

  @override
  String get catFeatNightParking => 'Parking';

  @override
  String get catFeatNightWifi => 'Wi‑Fi';

  @override
  String get catFeatExpGuidedTours => 'Visites guidées';

  @override
  String get catFeatExpTransport => 'Transport inclus';

  @override
  String get catFeatExpMeals => 'Repas inclus';

  @override
  String get catFeatExpEquipment => 'Matériel fourni';

  @override
  String get catFeatExpGroup => 'Groupes';

  @override
  String get catFeatExpPrivate => 'Visites privées';

  @override
  String get catFeatDefWifi => 'Wi‑Fi';

  @override
  String get catFeatDefParking => 'Parking';

  @override
  String get catFeatDefAccessible => 'Accessible';

  @override
  String get exploreApplySort => 'Appliquer le tri';

  @override
  String get exploreCategoryNotFoundShort => 'Catégorie introuvable';

  @override
  String get commonSignIn => 'Se connecter';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonMaybeLater => 'Peut-être plus tard';

  @override
  String get commonGoBack => 'Retour';

  @override
  String get commonStartShopping => 'Commencer les achats';

  @override
  String get commonContinueShopping => 'Continuer les achats';

  @override
  String get commonFavoriteVerb => 'Favori';

  @override
  String get commonBookNow => 'Réserver';

  @override
  String get commonOrderNow => 'Commander';

  @override
  String get commonContact => 'Contacter';

  @override
  String get commonReserveTable => 'Réserver une table';

  @override
  String get commonWriteReview => 'Rédiger un avis';

  @override
  String get commonViewAllProducts => 'Voir tous les produits';

  @override
  String get commonViewAllServices => 'Voir tous les services';

  @override
  String get commonViewMenu => 'Voir le menu';

  @override
  String get commonViewMenus => 'Voir les menus';

  @override
  String get commonSelectVariant => 'Choisir une variante';

  @override
  String get commonShareReferralCode => 'Partager le code de parrainage';

  @override
  String get commonCompleteProfile => 'Compléter le profil';

  @override
  String get commonLinkOpenFailed =>
      'Impossible d’ouvrir le lien. Réessayez plus tard.';

  @override
  String get commonCouponApplied => 'Code promo appliqué !';

  @override
  String get commonCouponInvalid => 'Code promo invalide';

  @override
  String get commonBookingNotAvailable =>
      'La réservation n’est pas disponible pour ce type d’annonce';

  @override
  String commonFailedLoadListing(String error) {
    return 'Impossible de charger l’annonce : $error';
  }

  @override
  String commonFailedCreateBooking(String error) {
    return 'Impossible de créer la réservation : $error';
  }

  @override
  String commonFailedBookTour(String error) {
    return 'Impossible de réserver le circuit : $error';
  }

  @override
  String commonFailedBookService(String error) {
    return 'Impossible de réserver le service : $error';
  }

  @override
  String commonFailedAddToCart(String error) {
    return 'Impossible d’ajouter au panier : $error';
  }

  @override
  String commonFailedUpdate(String error) {
    return 'Impossible de mettre à jour : $error';
  }

  @override
  String commonFailedRemove(String error) {
    return 'Impossible de retirer : $error';
  }

  @override
  String commonFailedClearCart(String error) {
    return 'Impossible de vider le panier : $error';
  }

  @override
  String commonFailedPlaceOrder(String error) {
    return 'Impossible de passer la commande : $error';
  }

  @override
  String commonFailedShare(String error) {
    return 'Impossible de partager : $error';
  }

  @override
  String get commonProductAddedToCart => 'Produit ajouté au panier';

  @override
  String get commonItemAddedToCart => 'Article ajouté au panier';

  @override
  String get commonPleaseSelectTourSchedule =>
      'Sélectionnez un circuit et un créneau';

  @override
  String get commonPleaseFillRequiredFields =>
      'Remplissez tous les champs obligatoires';

  @override
  String get commonBookingMissingConfirmation =>
      'Réservation créée, mais l’identifiant de confirmation est manquant.';

  @override
  String get commonPleaseSelectDateTime => 'Sélectionnez une date et une heure';

  @override
  String get commonServiceBookedSuccess => 'Service réservé avec succès !';

  @override
  String get commonPleaseWriteReview => 'Écrivez un avis avant d’envoyer';

  @override
  String get commonPleaseWriteReviewUpdate =>
      'Écrivez un avis avant de mettre à jour';

  @override
  String get commonReviewSubmitMissingContext =>
      'Impossible d’envoyer l’avis. Informations manquantes (annonce, événement ou circuit).';

  @override
  String get commonThankYouReview => 'Merci pour votre avis !';

  @override
  String get commonReviewUpdatedSuccess => 'Avis mis à jour avec succès !';

  @override
  String get commonCheckInOutRequired =>
      'Sélectionnez les dates d’arrivée et de départ';

  @override
  String get commonCheckOutAfterCheckIn =>
      'La date de départ doit être après la date d’arrivée';

  @override
  String get commonSelectRoomType =>
      'Sélectionnez un type de chambre pour continuer';

  @override
  String get cartTitle => 'Vider le panier';

  @override
  String get cartClearConfirm => 'Retirer tous les articles de votre panier ?';

  @override
  String get cartEmptyMessage => 'Votre panier est vide';

  @override
  String get checkoutFulfillmentPickup => 'Retrait';

  @override
  String get checkoutFulfillmentPickupSubtitle => 'Retrait en magasin';

  @override
  String get checkoutFulfillmentDelivery => 'Livraison';

  @override
  String get checkoutFulfillmentDeliverySubtitle => 'Livraison à votre adresse';

  @override
  String get checkoutFulfillmentDineIn => 'Sur place';

  @override
  String get checkoutFulfillmentDineInSubtitle => 'Au restaurant';

  @override
  String get checkoutUnableListing => 'Impossible de déterminer l’annonce';

  @override
  String get shopSearchServicesTitle => 'Rechercher des services';

  @override
  String get shopServicesTitle => 'Services';

  @override
  String get referralScreenShareCta => 'Partager le code de parrainage';

  @override
  String get zoeaCardScreenTitle => 'Carte Zoea';

  @override
  String get itinerariesScreenTitle => 'Itinéraires';

  @override
  String get itinerariesMyScreenTitle => 'Mes itinéraires';

  @override
  String get itineraryCreateFab => 'Créer un itinéraire';

  @override
  String get itineraryDetailTitle => 'Itinéraire';

  @override
  String get itineraryViewCta => 'Voir';

  @override
  String get itineraryMakePublicTitle => 'Rendre public';

  @override
  String get itineraryMakePublicSubtitle =>
      'Permettre aux autres de voir cet itinéraire';

  @override
  String get itineraryAddItem => 'Ajouter un élément';

  @override
  String get itineraryFromFavoritesTitle => 'Depuis les favoris';

  @override
  String get itineraryFromFavoritesSubtitle => 'Ajouter depuis vos favoris';

  @override
  String get itineraryFromRecommendationsTitle => 'Depuis les recommandations';

  @override
  String get itineraryFromRecommendationsSubtitle =>
      'Ajouter depuis les lieux recommandés';

  @override
  String get itineraryCustomItemTitle => 'Élément personnalisé';

  @override
  String get itineraryCustomItemSubtitle =>
      'Ajouter un lieu ou une activité personnalisée';

  @override
  String get itineraryDeleteTitle => 'Supprimer l’itinéraire';

  @override
  String get itineraryDeleteMessage =>
      'Supprimer cet itinéraire ? Cette action est irréversible.';

  @override
  String get itineraryDeletedSuccess => 'Itinéraire supprimé';

  @override
  String get itineraryAddCustomTitle => 'Ajouter un élément personnalisé';

  @override
  String get itineraryCustomNameRequired => 'Veuillez saisir un nom';

  @override
  String get itineraryAddFromRecommendationsTitle =>
      'Ajouter depuis les recommandations';

  @override
  String get reviewsEventComingSoon => 'Page événement bientôt disponible';

  @override
  String get reviewsTourComingSoon => 'Page circuit bientôt disponible';

  @override
  String get tourDetailGoBack => 'Retour';

  @override
  String get eventsAttendedViewDetails => 'Voir les détails';

  @override
  String get visitedPlacesViewDetails => 'Voir les détails';

  @override
  String get appUpdateRequiredTitle => 'Mise à jour obligatoire';

  @override
  String get appUpdateRequiredMessage =>
      'Veuillez mettre à jour l’application pour continuer à utiliser Zoea.';

  @override
  String get appUpdateAvailableTitle => 'Mise à jour disponible';

  @override
  String get appUpdateAvailableMessage =>
      'Une nouvelle version de Zoea est prête, avec des améliorations et des corrections.';

  @override
  String get appUpdateNow => 'Mettre à jour';

  @override
  String get appUpdateLater => 'Plus tard';

  @override
  String get appUpdateStoreOpenFailed => 'Impossible d’ouvrir le lien du store';

  @override
  String get privacySectionPrivacySettings => 'Confidentialité';

  @override
  String get privacyLocationServicesTitle => 'Services de localisation';

  @override
  String get privacyLocationServicesSubtitle =>
      'Autoriser l’app à utiliser votre position pour de meilleures recommandations';

  @override
  String get privacyPushNotificationsTitle => 'Notifications push';

  @override
  String get privacyPushNotificationsSubtitle =>
      'Recevoir des notifications sur les événements et les mises à jour';

  @override
  String get privacyDataSharingTitle => 'Partage de données';

  @override
  String get privacyDataSharingSubtitle =>
      'Partager des données anonymes pour améliorer l’expérience';

  @override
  String get privacyAnalyticsTitle => 'Analytique';

  @override
  String get privacyAnalyticsSubtitle =>
      'Nous aider à améliorer l’app grâce à l’usage';

  @override
  String get privacyAnalyticsEnabled => 'Analytique activée';

  @override
  String get privacyAnalyticsDisabled => 'Analytique désactivée';

  @override
  String get privacyAnalyticsUpdateFailed =>
      'Impossible de mettre à jour les paramètres d’analytique';

  @override
  String get privacyAnalyticsLoadingSubtitle => 'Chargement…';

  @override
  String get privacySectionDataPrivacy => 'Données et confidentialité';

  @override
  String get privacyWhatDataTitle => 'Données collectées';

  @override
  String get privacyWhatDataSubtitle =>
      'Voir quelles informations sont collectées et pourquoi';

  @override
  String get privacyClearAnalyticsTitle => 'Effacer les données d’analytique';

  @override
  String get privacyClearAnalyticsSubtitle =>
      'Supprimer toutes les données d’analytique stockées';

  @override
  String get privacySectionSecurity => 'Sécurité';

  @override
  String get privacyBiometricTitle => 'Authentification biométrique';

  @override
  String get privacyBiometricSubtitle =>
      'Empreinte ou reconnaissance faciale pour déverrouiller';

  @override
  String get privacyTwoFactorTitle => 'Authentification à deux facteurs';

  @override
  String get privacyTwoFactorSubtitle =>
      'Renforcer la sécurité de votre compte';

  @override
  String get privacyChangePasswordTileTitle => 'Changer le mot de passe';

  @override
  String get privacyChangePasswordTileSubtitle =>
      'Mettre à jour le mot de passe du compte';

  @override
  String get privacyEmailVerificationTileTitle => 'Vérification de l’e-mail';

  @override
  String get privacyEmailVerificationTileSubtitle =>
      'Vérifier votre adresse e-mail';

  @override
  String get privacyPhoneVerified => 'Téléphone vérifié';

  @override
  String get privacyPhoneAddVerify => 'Ajouter et vérifier votre numéro';

  @override
  String get privacyPhoneVerificationTileTitle => 'Vérification du téléphone';

  @override
  String get privacySectionAccountManagement => 'Gestion du compte';

  @override
  String get privacyDownloadDataTitle => 'Télécharger mes données';

  @override
  String get privacyDownloadDataSubtitle =>
      'Obtenir une copie de vos données personnelles';

  @override
  String get privacyDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Supprimer définitivement votre compte et toutes les données';

  @override
  String get privacySectionLegal => 'Mentions légales';

  @override
  String get privacyPolicyTileTitle => 'Politique de confidentialité';

  @override
  String get privacyPolicyTileSubtitle =>
      'Lire notre politique de confidentialité';

  @override
  String get privacyTermsTileTitle => 'Conditions d’utilisation';

  @override
  String get privacyTermsTileSubtitle => 'Lire nos conditions d’utilisation';

  @override
  String get privacyChangePasswordDialogTitle => 'Changer le mot de passe';

  @override
  String get privacyCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get privacyCurrentPasswordHint =>
      'Saisissez votre mot de passe actuel';

  @override
  String get privacyCurrentPasswordRequired =>
      'Veuillez saisir votre mot de passe actuel';

  @override
  String get privacyNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get privacyNewPasswordHint => 'Saisissez votre nouveau mot de passe';

  @override
  String get privacyNewPasswordRequired =>
      'Veuillez saisir un nouveau mot de passe';

  @override
  String get privacyPasswordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get privacyConfirmPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get privacyConfirmPasswordHint =>
      'Confirmez votre nouveau mot de passe';

  @override
  String get privacyConfirmPasswordRequired =>
      'Veuillez confirmer votre nouveau mot de passe';

  @override
  String get privacyPasswordsMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get privacyPasswordChangedSuccess => 'Mot de passe modifié !';

  @override
  String get privacyPasswordChangeFailed =>
      'Impossible de modifier le mot de passe. Réessayez.';

  @override
  String get privacyEmailVerificationDialogTitle => 'Vérification de l’e-mail';

  @override
  String get privacyEmailVerificationDialogBody =>
      'Un e-mail de vérification sera envoyé à votre adresse enregistrée.';

  @override
  String get privacyVerificationEmailSent => 'E-mail de vérification envoyé !';

  @override
  String get privacySendEmail => 'Envoyer l’e-mail';

  @override
  String get privacyPhoneInvalid => 'Saisissez un numéro valide';

  @override
  String get privacyPhoneCodeSent =>
      'Nous avons envoyé un code à 6 chiffres par SMS.';

  @override
  String get privacyPhoneEnterCode => 'Saisissez le code à 6 chiffres';

  @override
  String get privacyPhoneVerifiedSuccess => 'Numéro de téléphone vérifié';

  @override
  String get privacyPhoneVerificationIntro =>
      'Nous enverrons un code pour confirmer ce numéro.';

  @override
  String get myBookingsKeepBooking => 'Conserver la réservation';

  @override
  String get myBookingsCancelBooking => 'Annuler la réservation';

  @override
  String get editProfileConfirm => 'Confirmer';

  @override
  String get privacyPhoneMobileLabel => 'Numéro de mobile';

  @override
  String get privacySendCode => 'Envoyer le code';

  @override
  String get privacyVerify => 'Vérifier';

  @override
  String get privacyDownloadDataDialogTitle => 'Télécharger mes données';

  @override
  String get privacyDownloadDataDialogBody =>
      'Nous préparerons vos données et les enverrons à votre adresse e-mail sous 24 heures.';

  @override
  String get privacyDownloadDataSubmitted =>
      'Demande de téléchargement envoyée !';

  @override
  String get privacyRequestData => 'Demander les données';

  @override
  String get privacyDeleteAccountDialogTitle => 'Supprimer le compte';

  @override
  String get privacyDeleteAccountDialogBody =>
      'Cette action est irréversible. Toutes vos données seront supprimées définitivement.';

  @override
  String get privacyDeleteForever => 'Supprimer définitivement';

  @override
  String get privacyAccountDeletionComingSoon =>
      'La suppression de compte arrive bientôt !';

  @override
  String get privacyFinalConfirmationTitle => 'Confirmation finale';

  @override
  String get privacyFinalConfirmationBody =>
      'Voulez-vous vraiment continuer ? Votre compte et toutes les données associées seront supprimés définitivement.';

  @override
  String get privacyWhatDataCollectSheetTitle => 'Données collectées';

  @override
  String get privacyDataProfileTitle => 'Informations de profil';

  @override
  String get privacyDataProfileDescription =>
      'Pays, langue, tranche d’âge, genre, centres d’intérêt, préférences de voyage';

  @override
  String get privacyDataProfilePurpose =>
      'Personnaliser votre expérience et vos recommandations';

  @override
  String get privacyDataSearchTitle => 'Recherches';

  @override
  String get privacyDataSearchDescription =>
      'Ce que vous recherchez dans l’application';

  @override
  String get privacyDataSearchPurpose =>
      'Améliorer les résultats et suggérer du contenu pertinent';

  @override
  String get privacyDataViewsTitle => 'Consultations de contenu';

  @override
  String get privacyDataViewsDescription => 'Lieux et événements consultés';

  @override
  String get privacyDataViewsPurpose =>
      'Mieux comprendre vos intérêts et améliorer les recommandations';

  @override
  String get privacyDataUsageTitle => 'Utilisation de l’app';

  @override
  String get privacyDataUsageDescription =>
      'Fonctionnalités utilisées, durée des sessions';

  @override
  String get privacyDataUsagePurpose =>
      'Améliorer les performances et l’expérience utilisateur';

  @override
  String get privacyDataAnonymizedFootnote =>
      'Les données sont anonymisées et servent uniquement à améliorer votre expérience. Vous pouvez désactiver l’analytique ou effacer vos données à tout moment.';

  @override
  String get privacyGotIt => 'Compris';

  @override
  String privacyPurposeLine(String purpose) {
    return 'Objectif : $purpose';
  }

  @override
  String get privacyClearAnalyticsDialogTitle =>
      'Effacer les données d’analytique';

  @override
  String get privacyClearAnalyticsDialogBody =>
      'Cela supprimera toutes les données d’analytique stockées sur cet appareil. Action irréversible.';

  @override
  String get privacyClearData => 'Effacer les données';

  @override
  String get privacyClearAnalyticsSuccess => 'Données d’analytique effacées';

  @override
  String get privacyClearAnalyticsFailed =>
      'Impossible d’effacer les données d’analytique';

  @override
  String get privacyPhoneSixDigitCodeLabel => 'Code à 6 chiffres';

  @override
  String get zoeaCardSubtitle =>
      'Votre portefeuille numérique pour des paiements fluides';

  @override
  String get shopCartScreenTitle => 'Panier';

  @override
  String get shopCartEmptySubtitle =>
      'Ajoutez des articles à votre panier pour commencer';

  @override
  String get shopCartLoadFailed => 'Impossible de charger le panier';

  @override
  String get shopCheckoutSignInTitle => 'Connectez-vous pour payer';

  @override
  String get shopCheckoutSignInMessage =>
      'Créez un compte ou connectez-vous pour finaliser votre achat. Votre panier sera enregistré.';

  @override
  String get shopCartItemTypeProduct => 'Produit';

  @override
  String get shopCartItemTypeService => 'Service';

  @override
  String get shopCartItemTypeMenuItem => 'Article du menu';

  @override
  String get shopCartClearTooltip => 'Vider le panier';

  @override
  String get shopCartTotalLabel => 'Total';

  @override
  String get shopProceedToCheckout => 'Passer à la caisse';

  @override
  String get checkoutScreenTitle => 'Paiement';

  @override
  String get checkoutOrderSummary => 'Récapitulatif de commande';

  @override
  String get checkoutDeliveryMethod => 'Mode de livraison';

  @override
  String get checkoutDeliveryAddress => 'Adresse de livraison';

  @override
  String get checkoutStreetAddressLabel => 'Adresse';

  @override
  String get checkoutStreetAddressHint => 'Saisissez votre adresse';

  @override
  String get checkoutStreetAddressRequired =>
      'Veuillez saisir votre adresse de livraison';

  @override
  String get checkoutCityLabel => 'Ville';

  @override
  String get checkoutCityHint => 'Saisissez votre ville';

  @override
  String get checkoutCityRequired => 'Veuillez saisir votre ville';

  @override
  String get checkoutContactInformation => 'Coordonnées';

  @override
  String get checkoutFullNameLabel => 'Nom complet';

  @override
  String get checkoutFullNameHint => 'Saisissez votre nom complet';

  @override
  String get checkoutFullNameRequired => 'Veuillez saisir votre nom';

  @override
  String get checkoutEmailOptionalLabel => 'E-mail (facultatif)';

  @override
  String get checkoutEmailHint => 'Saisissez votre e-mail';

  @override
  String get checkoutPhoneLabel => 'Téléphone';

  @override
  String get checkoutPhoneHint => 'Saisissez votre numéro de téléphone';

  @override
  String get checkoutPhoneRequired =>
      'Veuillez saisir votre numéro de téléphone';

  @override
  String get checkoutSpecialInstructionsTitle =>
      'Instructions particulières (facultatif)';

  @override
  String get checkoutSpecialInstructionsHint =>
      'Ajoutez des instructions pour votre commande…';

  @override
  String get checkoutPlaceOrder => 'Passer la commande';

  @override
  String get checkoutStorePickup => 'Retrait en magasin';

  @override
  String get checkoutSubtotalLabel => 'Sous-total';

  @override
  String get checkoutTaxVatLabel => 'TVA (18 %)';

  @override
  String get checkoutShippingLabel => 'Livraison';

  @override
  String checkoutQtyLine(int quantity) {
    return 'Qté : $quantity';
  }

  @override
  String shopServiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '1 service',
    );
    return '$_temp0';
  }

  @override
  String get shopEmptyNoServices => 'Aucun service trouvé';

  @override
  String get shopErrorLoadServices => 'Impossible de charger les services';

  @override
  String get shopFilterServicesSheetTitle => 'Filtrer les services';

  @override
  String get shopServiceSearchHint => 'Nom du service…';

  @override
  String get shopPricePerHour => 'heure';

  @override
  String get shopPricePerSession => 'séance';

  @override
  String get shopPricePerPerson => 'personne';

  @override
  String get shopServiceUnavailable => 'Indisponible';

  @override
  String shopServiceDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get shopErrorLoadMenu => 'Impossible de charger le menu';

  @override
  String get shopErrorLoadProduct => 'Impossible de charger le produit';

  @override
  String get shopMenuCategoryEmpty => 'Aucun article dans cette catégorie';

  @override
  String get shopErrorLoadService => 'Impossible de charger le service';

  @override
  String get shopViewCart => 'Voir le panier';

  @override
  String get shopAddToCart => 'Ajouter au panier';

  @override
  String get shopBookService => 'Réserver le service';

  @override
  String get shopProductDescription => 'Description';

  @override
  String get shopProductTags => 'Étiquettes';

  @override
  String get shopProductVariantHeading => 'Choisir une variante';

  @override
  String get shopMenuChefSpecial => 'Spécialité du chef';

  @override
  String get shopMenuDietaryInformation => 'Informations diététiques';

  @override
  String get shopMenuAllergensTitle => 'Allergènes';

  @override
  String get shopServiceUnavailableBanner =>
      'Ce service est momentanément indisponible';

  @override
  String listingShareOnZoea(String name) {
    return 'Découvrez $name sur Zoea !';
  }

  @override
  String shopServiceDurationLine(int minutes) {
    return 'Durée : $minutes minutes';
  }

  @override
  String get shopBookingFullNameRequiredLabel => 'Nom complet *';

  @override
  String get shopBookingPhoneRequiredLabel => 'Téléphone *';

  @override
  String get shopBookingEmailOptionalLabel => 'E-mail (facultatif)';

  @override
  String get shopBookingSelectDateRequired => 'Choisir une date *';

  @override
  String get shopBookingSelectTimeRequired => 'Choisir une heure *';

  @override
  String get shopBookingSpecialRequestsLabel =>
      'Demandes particulières (facultatif)';

  @override
  String get shopMenuScreenTitle => 'Menu';

  @override
  String get shopMenusEmptyTitle => 'Aucun menu disponible';

  @override
  String get shopMenusEmptySubtitle =>
      'Ce restaurant n’a pas encore ajouté de menu';

  @override
  String get shopOrderPlacedSuccessTitle => 'Commande passée avec succès !';

  @override
  String get shopOrderPlacedSuccessSubtitle =>
      'Votre commande a bien été reçue et est en cours de traitement';

  @override
  String get shopOrderDetailsSection => 'Détails de la commande';

  @override
  String get shopOrderNumberLabel => 'Numéro de commande';

  @override
  String get shopOrderMerchantLabel => 'Commerçant';

  @override
  String get shopOrderStatusLabel => 'Statut';

  @override
  String get shopOrderTotalAmountLabel => 'Montant total';

  @override
  String get shopOrderDateLabel => 'Date de commande';

  @override
  String get shopOrderViewMyOrders => 'Voir mes commandes';

  @override
  String get shopOrderDetailsLoadFailed =>
      'Impossible de charger les détails de la commande';

  @override
  String get referralInviteHeroTitle =>
      'Invitez des amis et gagnez des récompenses';

  @override
  String get referralInviteHeroSubtitle =>
      'Partagez votre code de parrainage et gagnez des points quand vos amis rejoignent Zoea';

  @override
  String get referralYourCodeSectionTitle => 'Votre code de parrainage';

  @override
  String get referralSignInForCodeBody =>
      'Connectez-vous pour voir votre code personnel et suivre vos points.';

  @override
  String get referralErrorLoadCode =>
      'Impossible de charger votre code de parrainage. Tirez pour réessayer ou reconnectez-vous.';

  @override
  String get referralShareCodeHint => 'Partagez ce code avec vos amis';

  @override
  String get referralCodeCopied => 'Code de parrainage copié';

  @override
  String get referralShareInviteMessage =>
      'Rejoignez-moi sur Zoea Africa et découvrez des lieux incroyables au Rwanda !';

  @override
  String get referralHowItWorksTitle => 'Comment ça marche';

  @override
  String get referralStepShareTitle => 'Partagez votre code';

  @override
  String get referralStepShareBody =>
      'Envoyez votre code à vos amis via les réseaux sociaux, l’e-mail ou SMS';

  @override
  String get referralStepFriendTitle => 'Votre ami s’inscrit';

  @override
  String get referralStepFriendBody =>
      'Votre ami crée son compte Zoea avec votre code';

  @override
  String get referralStepEarnTitle => 'Gagnez des points';

  @override
  String get referralStepEarnBody =>
      'Vous gagnez tous les deux des points à l’inscription (affichés en attente jusqu’à validation)';

  @override
  String get referralRewardsTitle => 'Récompenses';

  @override
  String get referralRewardForYouTitle => 'Pour vous';

  @override
  String get referralRewardForYouSubtitle => 'Quand un ami rejoint';

  @override
  String get referralRewardForFriendTitle => 'Pour votre ami';

  @override
  String get referralRewardForFriendSubtitle => 'Bonus de bienvenue';

  @override
  String get referralRewardsLoadError =>
      'Impossible de charger les montants des récompenses.';

  @override
  String get referralStatsTitle => 'Vos parrainages';

  @override
  String get referralStatTotalReferrals => 'Total parrainages';

  @override
  String get referralStatPointsEarned => 'Points gagnés';

  @override
  String get referralStatPending => 'En attente';

  @override
  String referralPointsValue(String points) {
    return '$points pts';
  }

  @override
  String get onboardingGenderMale => 'Homme';

  @override
  String get onboardingGenderFemale => 'Femme';

  @override
  String get onboardingGenderOther => 'Autre';

  @override
  String get onboardingGenderPreferNot => 'Je préfère ne pas répondre';

  @override
  String get onboardingVisitLeisureTitle => 'Loisirs';

  @override
  String get onboardingVisitLeisureSubtitle => 'Explorer et profiter du Rwanda';

  @override
  String get onboardingVisitBusinessTitle => 'Affaires';

  @override
  String get onboardingVisitBusinessSubtitle => 'Voyages professionnels';

  @override
  String get onboardingVisitMiceTitle => 'MICE';

  @override
  String get onboardingVisitMiceSubtitle =>
      'Réunions, incentives, conférences, expositions';

  @override
  String get diningBookingLabelDate => 'Date';

  @override
  String get diningBookingLabelTime => 'Heure';

  @override
  String get diningBookingLabelGuests => 'Convives';

  @override
  String get diningBookingLabelRestaurant => 'Restaurant';

  @override
  String get diningBookingLabelLocation => 'Lieu';

  @override
  String get diningBookingLabelName => 'Nom';

  @override
  String get diningBookingLabelPhone => 'Téléphone';

  @override
  String get diningBookingLabelEmail => 'E-mail';

  @override
  String diningBookingDetailLine(String label) {
    return '$label : ';
  }

  @override
  String get exploreFilterBudgetHintNoLimit => 'Sans limite';

  @override
  String get stayBookingSpecialRequestsHint =>
      'Demandes ou préférences particulières…';

  @override
  String get stayCouponCodeHint => 'Saisir un code promo';

  @override
  String get stayBookingScreenTitle => 'Réserver votre séjour';

  @override
  String get stayBookingSelectDatesHeading => 'Choisir les dates';

  @override
  String get stayBookingRoomsHeading => 'Chambres';

  @override
  String stayBookingRoomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chambres',
      one: '1 chambre',
    );
    return '$_temp0';
  }

  @override
  String stayBookingNightlyLine(String price, int roomCount) {
    String _temp0 = intl.Intl.pluralLogic(
      roomCount,
      locale: localeName,
      other: '$roomCount chambres',
      one: '1 chambre',
    );
    return '$price × $_temp0';
  }

  @override
  String get stayBookingContinueToPayment => 'Continuer vers le paiement';

  @override
  String get stayBookingSelectedRoomsTitle => 'Chambres sélectionnées';

  @override
  String stayBookingQtyShort(int quantity) {
    return 'Qté : $quantity';
  }

  @override
  String get stayBookingDemoHotelName => 'Kigali Marriott Hotel';

  @override
  String get stayBookingDemoHotelAddress => 'Kacyiru, Kigali';

  @override
  String stayBookingDemoRatingReviews(String rating, int reviewCount) {
    String _temp0 = intl.Intl.pluralLogic(
      reviewCount,
      locale: localeName,
      other: '$reviewCount avis',
      one: '1 avis',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get notificationsMarkAllRead => 'Tout marquer lu';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsEmptyBody =>
      'Vous n’avez pas encore de notifications';

  @override
  String get notificationsLoadFailed =>
      'Impossible de charger les notifications';

  @override
  String get notificationsAllMarkedRead =>
      'Toutes les notifications sont marquées comme lues';

  @override
  String get notificationsDefaultTitle => 'Notification';

  @override
  String get notificationsActionViewBooking => 'Voir la réservation';

  @override
  String get notificationsActionViewEvent => 'Voir l’événement';

  @override
  String get notificationsActionViewListing => 'Voir l’annonce';

  @override
  String notificationsMarkReadFailed(String error) {
    return 'Impossible de marquer la notification comme lue : $error';
  }

  @override
  String notificationsMarkAllReadFailed(String error) {
    return 'Impossible de tout marquer comme lu : $error';
  }

  @override
  String get notificationsTimeJustNow => 'À l’instant';

  @override
  String notificationsTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count minutes',
      one: 'Il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String notificationsTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count heures',
      one: 'Il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String notificationsTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get notificationsTimeRecently => 'Récemment';

  @override
  String notificationsOpeningUrl(String url) {
    return 'Ouverture : $url';
  }

  @override
  String get diningBookingConfirmationTitle => 'Confirmation de réservation';

  @override
  String get diningBookingReservationConfirmedTitle =>
      'Réservation confirmée !';

  @override
  String get diningBookingReservationConfirmedSubtitle =>
      'Votre table a bien été réservée';

  @override
  String diningBookingNumberLine(String number) {
    return 'Réservation n°$number';
  }

  @override
  String get diningBookingReservationDetailsSection =>
      'Détails de la réservation';

  @override
  String get diningBookingNotSpecified => 'Non précisé';

  @override
  String get diningBookingRestaurantInfoSection =>
      'Informations sur le restaurant';

  @override
  String get diningBookingGuestInfoSection => 'Informations sur l’invité';

  @override
  String get diningBookingSpecialRequestsSection => 'Demandes particulières';

  @override
  String get diningBookingImportantInfoTitle => 'Informations importantes';

  @override
  String get diningBookingImportantInfoBody =>
      '• Merci d’arriver 5 à 10 minutes avant l’heure de réservation\n• Pour annuler ou modifier, contactez directement le restaurant\n• Un retard important peut entraîner la perte de la table\n• Un code vestimentaire peut s’appliquer—renseignez-vous auprès du restaurant';

  @override
  String get diningBookingBrowseMore => 'Continuer à explorer';

  @override
  String get diningBookingViewMyBookings => 'Voir mes réservations';

  @override
  String get listingScreenDefaultTitle => 'Annonces';

  @override
  String get tourDetailLoadError =>
      'Impossible de charger les détails du circuit';

  @override
  String get listingDetailLoadFailed => 'Impossible de charger l’annonce';

  @override
  String get bookingConfirmationHeaderTitle => 'Réservation confirmée !';

  @override
  String get bookingConfirmationHeaderSubtitle =>
      'Votre réservation a bien été confirmée';

  @override
  String get bookingConfirmationSectionBookingInfo =>
      'Informations sur la réservation';

  @override
  String get bookingConfirmationLabelBookingNumber => 'Numéro de réservation';

  @override
  String get bookingConfirmationLabelType => 'Type';

  @override
  String get bookingConfirmationSectionDetails => 'Détails de la réservation';

  @override
  String get bookingConfirmationLabelPartySize => 'Nombre de convives';

  @override
  String get bookingConfirmationLabelSpecialRequests =>
      'Demandes particulières';

  @override
  String get bookingConfirmationTourDetailsPlaceholder =>
      'Les détails de confirmation du circuit apparaîtront ici dès qu’ils seront disponibles.';

  @override
  String get bookingConfirmationSectionPriceSummary => 'Récapitulatif des prix';

  @override
  String get bookingConfirmationLabelTaxesFees => 'Taxes et frais';

  @override
  String get bookingConfirmationLabelDiscount => 'Réduction';

  @override
  String get bookingConfirmationLoadFailed =>
      'Impossible de charger la réservation';

  @override
  String get webviewPageLoadFailed => 'Impossible de charger la page';

  @override
  String webviewInvalidUrlLine(String url) {
    return 'URL invalide : $url';
  }

  @override
  String get webviewLoadTimeoutBody =>
      'Le chargement prend trop de temps. Vérifiez votre connexion Internet.';

  @override
  String get webviewTooltipReload => 'Actualiser';

  @override
  String get webviewTooltipForward => 'Avancer';

  @override
  String get listingDetailReviewSignInTitle =>
      'Connectez-vous pour rédiger un avis';

  @override
  String get listingDetailReviewSignInMessage =>
      'Créez un compte ou connectez-vous pour partager votre expérience et aider d’autres voyageurs.';

  @override
  String get itineraryDetailLoadFailed => 'Impossible de charger l’itinéraire';

  @override
  String myBookingsCancelConfirmBody(String name) {
    return 'Voulez-vous vraiment annuler votre réservation pour « $name » ? Cette action est irréversible.';
  }

  @override
  String myBookingsBookAgainPrompt(String name) {
    return 'Souhaitez-vous réserver à nouveau « $name » ?';
  }

  @override
  String get diningFilterSheetTitle => 'Filtrer la restauration';

  @override
  String get diningSortSheetTitle => 'Trier la restauration';

  @override
  String get listingFeaturedOnlyTitle => 'En vedette uniquement';

  @override
  String get listingFeaturedOnlySubtitle =>
      'Afficher uniquement les annonces en vedette';

  @override
  String get listingSortOldestFirst => 'Plus anciennes en premier';

  @override
  String get diningFlowBookTableTitle => 'Réserver une table';

  @override
  String get diningFlowReservationDetailsSection => 'Détails de la réservation';

  @override
  String get diningFlowSelectDatePlaceholder => 'Choisir une date';

  @override
  String get diningFlowAvailableTimes => 'Créneaux disponibles';

  @override
  String get diningFlowNumberOfGuests => 'Nombre de convives';

  @override
  String get diningFlowGuestInformation => 'Informations sur l’invité';

  @override
  String get diningFlowFullNameHint => 'Jean Dupont';

  @override
  String get diningFlowPhoneHint => '+250 796 889 900';

  @override
  String get diningFlowSpecialRequestsTitle => 'Demandes particulières';

  @override
  String get diningFlowSpecialRequestsHint =>
      'Régimes alimentaires, préférences de table, etc.';

  @override
  String get diningFlowCouponCodeTitle => 'Code promo';

  @override
  String get diningFlowCouponAppliedTitle => 'Code appliqué !';

  @override
  String diningFlowCouponSavedBody(String amount) {
    return 'Vous économisez $amount';
  }

  @override
  String get diningBookingTimeNotSelected => 'Non sélectionné';

  @override
  String get diningFlowConfirmSheetTitle => 'Confirmer la réservation';

  @override
  String get diningFlowConfirmBookingCta => 'Confirmer la réservation';

  @override
  String get stayFavoriteSignInMessage =>
      'Créez un compte ou connectez-vous pour enregistrer vos hébergements favoris et y accéder à tout moment.';

  @override
  String get tourFavoriteSignInMessage =>
      'Créez un compte ou connectez-vous pour enregistrer vos circuits favoris et y accéder à tout moment.';

  @override
  String get diningReserveSignInTitle => 'Se connecter pour réserver';

  @override
  String get diningReserveSignInMessage =>
      'Créez un compte ou connectez-vous pour réserver une table et gérer vos réservations au restaurant.';

  @override
  String get stayBookSignInTitle => 'Se connecter pour réserver';

  @override
  String get stayBookSignInMessage =>
      'Créez un compte ou connectez-vous pour finaliser votre réservation et la gérer.';

  @override
  String get tourBookSignInTitle => 'Se connecter pour réserver';

  @override
  String get tourBookSignInMessage =>
      'Créez un compte ou connectez-vous pour finaliser votre réservation de circuit et la gérer.';

  @override
  String commonFavoriteUpdateFailed(String detail) {
    return 'Impossible de mettre à jour le favori : $detail';
  }

  @override
  String listingShareOnZoeaInLocation(String name, String location) {
    return 'Découvrez $name à $location sur Zoea !';
  }

  @override
  String listingDetailCouldNotOpenWebsite(String website) {
    return 'Impossible d’ouvrir le site : $website';
  }

  @override
  String listingDetailCouldNotCallPhone(String phone) {
    return 'Impossible d’appeler le numéro : $phone';
  }

  @override
  String get searchScreenGlobalHint =>
      'Rechercher des événements, lieux, expériences…';

  @override
  String get searchClearHistoryTitle => 'Effacer l’historique de recherche';

  @override
  String get searchClearHistoryBody =>
      'Voulez-vous vraiment effacer tout l’historique de recherche ?';

  @override
  String get listingReviewComposerHint => 'Partagez votre avis sur ce lieu…';

  @override
  String get exploreFilterBudgetHintMin => '0';

  @override
  String get tourBookingPickupHint =>
      'Lieu de prise en charge, ou laissez vide pour la valeur par défaut';

  @override
  String get tourBookingSpecialRequirementsHint =>
      'Besoins particuliers, préférences alimentaires, etc.';

  @override
  String get itineraryCreateNameHint => 'ex. : Mon aventure au Rwanda';

  @override
  String get itineraryCreateDescriptionHint => 'Parlez-nous de votre voyage…';

  @override
  String get itineraryCreateStartLocationHint => 'ex. : Kigali, Rwanda';

  @override
  String get itineraryStopTitleHint => 'ex. : Pause café';

  @override
  String get itineraryStopDurationHint => 'ex. : 60';

  @override
  String get itinerariesFabCreateTooltip => 'Créer un itinéraire';

  @override
  String get itineraryCreateDeleteTooltip => 'Supprimer l’itinéraire';

  @override
  String get itineraryDetailEditTooltip => 'Modifier';

  @override
  String get itineraryDetailShareTooltip => 'Partager';

  @override
  String get udcTravelPartySolo => 'Seul(e)';

  @override
  String get udcTravelPartyCouple => 'Couple';

  @override
  String get udcTravelPartyFamily => 'Famille';

  @override
  String get udcTravelPartyGroup => 'Groupe';

  @override
  String get udcFieldAgeRangeTitle => 'Tranche d’âge';

  @override
  String get udcFieldAgeRangeSubtitle => 'Pour personnaliser le contenu';

  @override
  String get udcFieldGenderTitle => 'Genre';

  @override
  String get udcFieldGenderSubtitle =>
      'Facultatif — aide à la personnalisation';

  @override
  String get udcFieldLengthOfStayTitle => 'Durée du séjour';

  @override
  String get udcFieldLengthOfStaySubtitle =>
      'Combien de temps restez-vous au Rwanda ?';

  @override
  String get udcFieldInterestsTitle => 'Centres d’intérêt';

  @override
  String get udcFieldInterestsSubtitle => 'Sélectionnez tout ce qui s’applique';

  @override
  String get udcFieldTravelPartyTitle => 'Composition du voyage';

  @override
  String get udcFieldTravelPartySubtitle => 'Avec qui voyagez-vous ?';

  @override
  String get onboardingAudienceResidentTitle => 'Résident(e)';

  @override
  String get onboardingAudienceResidentSubtitle => 'Je vis au Rwanda';

  @override
  String get onboardingAudienceVisitorTitle => 'Visiteur(se)';

  @override
  String get onboardingAudienceVisitorSubtitle => 'Je visite le Rwanda';

  @override
  String get commonProfileUpdatedSuccess => 'Profil mis à jour avec succès !';

  @override
  String get commonSaveFailedTryAgain =>
      'Enregistrement impossible. Réessayez.';

  @override
  String get commonFailedSaveDataTryAgain =>
      'Impossible d’enregistrer les données. Réessayez.';

  @override
  String get progressivePromptThanks =>
      'Merci de nous aider à personnaliser votre expérience !';

  @override
  String get profileEditPasswordRequiredForEmail =>
      'Le mot de passe est requis pour modifier l’adresse e-mail.';

  @override
  String get profileEditPleaseEnterPassword =>
      'Veuillez saisir votre mot de passe';

  @override
  String get reviewsWrittenSearchHint => 'Rechercher dans les avis…';

  @override
  String get aboutAppInfoSectionTitle => 'Informations sur l’application';

  @override
  String get aboutAppVersionLabel => 'Version de l’app';

  @override
  String get aboutBuildNumberLabel => 'Numéro de build';

  @override
  String get aboutLastUpdatedLabel => 'Dernière mise à jour';

  @override
  String get aboutPlatformLabel => 'Plateforme';

  @override
  String get aboutLanguageLabel => 'Langue';

  @override
  String get aboutLegalSectionTitle => 'Mentions légales';

  @override
  String get aboutPrivacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get aboutPrivacyPolicySubtitle =>
      'Comment nous protégeons vos données';

  @override
  String get aboutTermsOfServiceTitle => 'Conditions d’utilisation';

  @override
  String get aboutTermsOfServiceSubtitle => 'Modalités et conditions';

  @override
  String get aboutCopyrightTitle => 'Droits d’auteur';

  @override
  String aboutCopyrightCardSubtitle(int year) {
    return '© $year Zoea Africa. Tous droits réservés.';
  }

  @override
  String get aboutConnectSectionTitle => 'Nous contacter';

  @override
  String get aboutContactEmailTitle => 'E-mail';

  @override
  String get aboutContactPhoneTitle => 'Téléphone';

  @override
  String get aboutContactWebsiteTitle => 'Site web';

  @override
  String get aboutContactPhoneDisplay => '+250 796 889 900';

  @override
  String get aboutContactWebsiteDisplay => 'www.zoea.africa';

  @override
  String get aboutCloseButton => 'Fermer';

  @override
  String aboutVersionLine(String version) {
    return 'Version $version';
  }

  @override
  String get aboutVersionLoading => 'Version …';

  @override
  String get aboutBrandTagline => 'Découvrez la beauté du Rwanda';

  @override
  String get aboutWebsiteWebviewTitle => 'Zoea Africa';

  @override
  String get stayDetailLoadFailed => 'Impossible de charger l’hébergement';

  @override
  String get stayDetailTabAmenities => 'Équipements';

  @override
  String get stayDetailAboutTitle => 'À propos de ce lieu';

  @override
  String get stayDetailCheckInOutSection => 'Arrivée et départ';

  @override
  String get stayDetailCheckOutLabel => 'Départ';

  @override
  String get stayDetailBookingPoliciesSection => 'Politiques de réservation';

  @override
  String get stayDetailAvailableRooms => 'Chambres disponibles';

  @override
  String get stayDetailNoRoomTypes => 'Aucun type de chambre disponible';

  @override
  String get stayDetailAmenitiesSection => 'Équipements';

  @override
  String get stayDetailNoAmenitiesListed => 'Aucun équipement indiqué';

  @override
  String get stayDetailNoReviewsYet => 'Pas encore d’avis';

  @override
  String get stayDetailBeFirstToReview =>
      'Soyez le premier à laisser un avis !';

  @override
  String stayDetailReviewsLoadFailed(String error) {
    return 'Impossible de charger les avis : $error';
  }

  @override
  String get stayPolicyCancellationTitle => 'Annulation';

  @override
  String get stayPolicyCancellationBody =>
      'Annulation gratuite jusqu’à 24 h avant l’arrivée.';

  @override
  String get stayPolicyRefundTitle => 'Politique de remboursement';

  @override
  String get stayPolicyRefundBody =>
      'Remboursement intégral si annulation plus de 24 h avant l’arrivée.';

  @override
  String get stayPolicyPetTitle => 'Politique animaux';

  @override
  String get stayPolicyPetBody =>
      'Animaux acceptés avec des frais supplémentaires de 15 000 RWF par nuit.';

  @override
  String get stayPolicySmokingTitle => 'Politique tabac';

  @override
  String get stayPolicySmokingBody =>
      'Établissement non-fumeur. Tabac autorisé dans les zones prévues.';

  @override
  String get stayPolicyChildrenTitle => 'Politique enfants';

  @override
  String get stayPolicyChildrenBody =>
      'Tous âges bienvenus. Lits supplémentaires sur demande.';

  @override
  String get stayPolicyPaymentTitle => 'Politique de paiement';

  @override
  String get stayPolicyPaymentBody =>
      'Carte bancaire requise pour la réservation. Paiement à l’arrivée.';

  @override
  String get itineraryCreateScreenTitle => 'Créer un itinéraire';

  @override
  String get itineraryEditScreenTitle => 'Modifier l’itinéraire';

  @override
  String get itineraryFieldTitleLabel => 'Titre';

  @override
  String get itineraryFieldDescriptionOptionalLabel =>
      'Description (facultatif)';

  @override
  String get itineraryFieldLocationOptionalLabel => 'Lieu (facultatif)';

  @override
  String get itineraryFieldStartDateLabel => 'Date de début';

  @override
  String get itineraryFieldEndDateLabel => 'Date de fin';

  @override
  String get itineraryFieldNameLabel => 'Nom';

  @override
  String get itineraryFieldTimeLabel => 'Heure';

  @override
  String get itineraryFieldDurationOptionalLabel =>
      'Durée (minutes, facultatif)';

  @override
  String get itineraryValidationTitleRequired => 'Veuillez saisir un titre';

  @override
  String get profileEnterPasswordDialogTitle => 'Saisir le mot de passe';

  @override
  String get profileEnterPasswordDialogBody =>
      'Saisissez votre mot de passe actuel pour modifier votre adresse e-mail.';

  @override
  String get profileUpdateFailedGeneric =>
      'Impossible de mettre à jour le profil. Réessayez.';

  @override
  String stayDetailReviewsCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
    );
    return '$_temp0';
  }

  @override
  String get stayDetailTabOverview => 'Vue d’ensemble';

  @override
  String get stayDetailTabRooms => 'Chambres';

  @override
  String get stayDetailTabReviews => 'Avis';

  @override
  String get stayDetailTabPhotos => 'Photos';

  @override
  String get onboardingUserTypeHeadline => 'Résident(e) ou visiteur(se) ?';

  @override
  String get onboardingUserTypeSubtitle =>
      'Cela nous aide à vous proposer du contenu adapté';

  @override
  String get commonComplete => 'Terminer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get phoneValidationRequired =>
      'Veuillez saisir votre numéro de téléphone';

  @override
  String get phoneValidationInternationalInvalid =>
      'Veuillez saisir un numéro de téléphone valide';

  @override
  String get phoneValidationRwandanInvalid =>
      'Veuillez saisir un numéro rwandais valide (07xxxxxxxx ou 08xxxxxxxx)';

  @override
  String get exploreFilterLabelMinPrice => 'Prix min';

  @override
  String get exploreFilterLabelMaxPrice => 'Prix max';

  @override
  String get profileEditInterestsTitle => 'Centres d’intérêt';

  @override
  String get profileEditInterestsSubtitle =>
      'Sélectionnez tout ce qui s’applique';

  @override
  String get profileEditUnsavedChangesBody =>
      'Vous avez des modifications non enregistrées. Quitter quand même ?';

  @override
  String get profileEditDiscard => 'Abandonner';

  @override
  String get profileEditPersonalInfoSectionTitle => 'Informations personnelles';

  @override
  String get profileEditHintFullName => 'Saisissez votre nom complet';

  @override
  String get profileEditValidationFullNameRequired =>
      'Veuillez saisir votre nom complet';

  @override
  String get profileEditHintEmail => 'Saisissez votre adresse e-mail';

  @override
  String get profileEditValidationEmailRequired =>
      'Veuillez saisir votre adresse e-mail';

  @override
  String get profileEditHintPhone => 'Saisissez votre numéro de téléphone';

  @override
  String get profileEditValidationPhoneRequired =>
      'Veuillez saisir votre numéro de téléphone';

  @override
  String get profileEditTabBasicInfo => 'Infos de base';

  @override
  String get profileEditTabPreferences => 'Préférences';

  @override
  String get profileVisitedPlacesTitle => 'Lieux visités';

  @override
  String get profileVisitedTabAllPlaces => 'Tous les lieux';

  @override
  String get profileVisitedTabThisYear => 'Cette année';

  @override
  String get profileVisitedTabListingsOnly => 'Annonces uniquement';

  @override
  String get profileVisitedStatusViewed => 'Consulté';

  @override
  String profileVisitedDateLine(String date) {
    return 'Consulté le $date';
  }

  @override
  String get profileVisitedEmptyTitle => 'Aucun lieu visité pour l’instant';

  @override
  String get profileVisitedEmptySubtitle =>
      'Explorez le Rwanda pour constituer votre liste de lieux visités.';

  @override
  String get profileVisitedExploreButton => 'Explorer les lieux';

  @override
  String get profileUnknownLocation => 'Lieu inconnu';

  @override
  String get profileEventsAttendedTitle => 'Événements assistés';

  @override
  String get eventsAttendedTabAll => 'Tous les événements';

  @override
  String get eventsAttendedTabThisYear => 'Cette année';

  @override
  String get eventsAttendedTabFavorites => 'Favoris';

  @override
  String get eventsAttendedEmptyTitle =>
      'Aucun événement assisté pour l’instant';

  @override
  String get eventsAttendedEmptySubtitle =>
      'Explorez des événements pour constituer votre historique.';

  @override
  String get eventsAttendedExploreButton => 'Explorer les événements';

  @override
  String get eventsAttendedBadge => 'Assisté';

  @override
  String get exploreHomeCategoryEvents => 'Événements';

  @override
  String get exploreHomeCategoryDining => 'Restauration';

  @override
  String get exploreHomeCategoryExperiences => 'Expériences';

  @override
  String get exploreHomeCategoryNightlife => 'Vie nocturne';

  @override
  String get exploreHomeCategoryAccommodation => 'Hébergement';

  @override
  String get exploreHomeCategoryShopping => 'Shopping';

  @override
  String get placeDetailOpeningHoursTitle => 'Heures d’ouverture';

  @override
  String get placeDetailAboutTitle => 'À propos';

  @override
  String get placeDetailFeaturesTitle => 'Points forts';

  @override
  String get placeDetailNoPhotosExtended =>
      'Aucune photo disponible pour ce lieu';

  @override
  String get placeDetailNoMenuForPlace => 'Aucun menu disponible pour ce lieu';

  @override
  String get listingNoPhotosShort => 'Aucune photo disponible';

  @override
  String get listingHoursClosed => 'Fermé';

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get weekdayTuesday => 'Mardi';

  @override
  String get weekdayWednesday => 'Mercredi';

  @override
  String get weekdayThursday => 'Jeudi';

  @override
  String get weekdayFriday => 'Vendredi';

  @override
  String get weekdaySaturday => 'Samedi';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String itineraryDaysCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String itineraryItemsCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String reviewHelpfulCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes ont trouvé cela utile',
      one: '1 personne a trouvé cela utile',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count semaines',
      one: 'Il y a 1 semaine',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count mois',
      one: 'Il y a 1 mois',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count ans',
      one: 'Il y a 1 an',
    );
    return '$_temp0';
  }

  @override
  String get listingReviewExperienceTitle =>
      'Comment s’est passée votre expérience ?';

  @override
  String get listingReviewExperienceSubtitle =>
      'Parlez-nous de votre expérience';

  @override
  String get listingAnonymousUser => 'Anonyme';

  @override
  String get stayDefaultRoomLabel => 'Chambre';

  @override
  String get stayDefaultAmenityLabel => 'Équipement';

  @override
  String get contentTypeEventLabel => 'Événement';

  @override
  String get contentTypePlaceLabel => 'Lieu';

  @override
  String get contentTypeTourLabel => 'Circuit';

  @override
  String get itineraryFallbackItemPlace => 'Lieu';

  @override
  String get itineraryFallbackItemEvent => 'Événement';

  @override
  String get itineraryFallbackItemTour => 'Circuit';

  @override
  String get itineraryFallbackItemCustom => 'Élément personnalisé';

  @override
  String get onboardingCountryHeadline => 'D’où venez-vous ?';

  @override
  String get onboardingCountrySubtitle =>
      'Aidez-nous à personnaliser votre expérience';

  @override
  String get onboardingVisitRwandaHeadline =>
      'Qu’est-ce qui vous amène au Rwanda ?';

  @override
  String get onboardingVisitRwandaSubtitle =>
      'Sélectionnez votre objectif principal';

  @override
  String get onboardingLanguageHeadline => 'Quelle langue préférez-vous ?';

  @override
  String get onboardingLanguageSubtitle =>
      'Vous pourrez modifier ce choix à tout moment dans les paramètres';

  @override
  String get onboardingConsentHeadline => 'Aidez-nous à nous améliorer';

  @override
  String get onboardingConsentSubtitle =>
      'Autorisez l’analyse pour nous aider à personnaliser votre expérience';

  @override
  String get onboardingConsentCheckboxLabel =>
      'J’accepte de partager des données d’analyse pour améliorer les recommandations';

  @override
  String get onboardingSettingsFootnote =>
      'Vous pourrez modifier ce choix à tout moment dans les paramètres';

  @override
  String get progressivePromptTitleWithDuration =>
      'Personnalisons Zoea (10 sec)';

  @override
  String get progressivePromptTitleDefault => 'Personnalisons Zoea';

  @override
  String get progressiveQuestionAgeRange => 'Quelle est votre tranche d’âge ?';

  @override
  String get progressiveQuestionGender => 'Quel est votre genre ?';

  @override
  String get progressiveQuestionLengthOfStay =>
      'Combien de temps restez-vous ?';

  @override
  String get progressiveQuestionInterests => 'Qu’est-ce qui vous intéresse ?';

  @override
  String get progressiveQuestionTravelParty => 'Avec qui voyagez-vous ?';

  @override
  String get profileSaveChangesButton => 'Enregistrer les modifications';

  @override
  String get profileCompletionPrivacyNote =>
      'Vos données servent uniquement à personnaliser votre expérience. Vous pouvez les mettre à jour ou les supprimer à tout moment.';

  @override
  String get profileCompletionSectionTitle => 'Complétion du profil';

  @override
  String get profileCompletionSubtitleRecommendations =>
      'Complétez votre profil pour de meilleures recommandations';

  @override
  String get tourBookingScreenTitle => 'Réserver un circuit';

  @override
  String get tourBookingPerPersonSuffix => '/personne';

  @override
  String get tourBookingSelectTourTitle => 'Choisir un circuit';

  @override
  String get tourBookingSelectDateTimeTitle => 'Choisir la date et l’heure';

  @override
  String get tourBookingNoSchedules => 'Aucun créneau disponible';

  @override
  String tourBookingScheduleSubtitleWithTime(String time, int spots) {
    return 'Heure : $time · Places : $spots disponibles';
  }

  @override
  String tourBookingScheduleSubtitleSpotsOnly(int spots) {
    return 'Places : $spots disponibles';
  }

  @override
  String get tourBookingNumberOfGuestsTitle => 'Nombre de voyageurs';

  @override
  String get tourBookingGuestAdults => 'Adultes';

  @override
  String get tourBookingGuestChildren => 'Enfants';

  @override
  String get tourBookingGuestInfants => 'Bébés';

  @override
  String get tourBookingContactSectionTitle => 'Coordonnées';

  @override
  String get tourBookingPickupLocationOptionalTitle =>
      'Lieu de prise en charge (facultatif)';

  @override
  String get tourBookingSpecialRequestsTitle => 'Demandes particulières';

  @override
  String get tourBookingPriceBreakdownTitle => 'Détail du prix';

  @override
  String tourBookingPriceLineAdults(int count) {
    return 'Adultes ($count×)';
  }

  @override
  String tourBookingPriceLineChildren(int count) {
    return 'Enfants ($count×)';
  }

  @override
  String tourBookingPriceLineInfants(int count) {
    return 'Bébés ($count×)';
  }

  @override
  String get tourBookingPriceLineFree => 'Gratuit';

  @override
  String get tourBookingPriceLineTotal => 'Total';

  @override
  String get tourBookingLocationDefaultLabel => 'Lieu';

  @override
  String get tourPackagesScreenTitle => 'Forfaits circuits';

  @override
  String get reviewsViewPlaceAction => 'Voir le lieu';

  @override
  String get placeDetailMapViewAction => 'Voir';

  @override
  String get itineraryFormButtonCreate => 'Créer l’itinéraire';

  @override
  String get itineraryFormButtonUpdate => 'Mettre à jour l’itinéraire';

  @override
  String get itineraryUpdatedSuccess => 'Itinéraire mis à jour';

  @override
  String get itineraryCreatedSuccess => 'Itinéraire créé';

  @override
  String get itineraryAddItemsHint =>
      'Ajoutez des lieux, événements ou circuits à votre itinéraire';

  @override
  String get itinerarySharedBadge => 'Partagé';

  @override
  String get shopCartUnknownItem => 'Article inconnu';

  @override
  String get listingDetailHoursClosed => 'Fermé';

  @override
  String get diningCategoryFallbackName => 'Restauration';

  @override
  String get bookingFallbackRestaurantName => 'Restaurant';

  @override
  String aboutLegalCopyrightBody(int year) {
    return 'Avis sur les droits d\'auteur\n\n© $year Zoea Africa. Tous droits réservés.\n\nL\'application et son contenu sont protégés par le droit d\'auteur et d\'autres lois sur la propriété intellectuelle.\n\nVous ne pouvez pas :\n- copier, modifier ou distribuer l\'application sans autorisation ;\n- procéder à de l\'ingénierie inverse ou tenter d\'extraire le code source ;\n- utiliser l\'application à des fins commerciales sans autorisation.\n\nPour toute question de licence, contactez-nous à legal@zoea.africa.';
  }

  @override
  String get aboutLegalPrivacyBody =>
      'Politique de confidentialité\n\nDernière mise à jour : décembre 2024\n\n1. Informations que nous collectons\nNous collectons les informations que vous nous fournissez directement, par exemple lorsque vous créez un compte, effectuez une réservation ou nous contactez pour une assistance.\n\n2. Utilisation de vos informations\nNous utilisons les informations collectées pour fournir, maintenir et améliorer nos services, traiter les transactions et communiquer avec vous.\n\n3. Partage des informations\nNous ne vendons, n\'échangeons ni ne transférons vos données personnelles à des tiers sans votre consentement.\n\n4. Sécurité des données\nNous mettons en œuvre des mesures de sécurité appropriées pour protéger vos données personnelles contre l\'accès, la modification, la divulgation ou la destruction non autorisés.\n\n5. Vos droits\nVous pouvez accéder à vos données personnelles, les mettre à jour ou les supprimer. Vous pouvez le faire via les paramètres du compte ou en nous contactant.\n\n6. Nous contacter\nPour toute question concernant cette politique, écrivez-nous à privacy@zoea.africa.';

  @override
  String get aboutLegalTermsBody =>
      'Conditions d\'utilisation\n\nDernière mise à jour : décembre 2024\n\n1. Acceptation des conditions\nEn utilisant l\'application, vous acceptez d\'être lié(e) par les présentes conditions d\'utilisation.\n\n2. Utilisation de l\'application\nVous ne pouvez utiliser l\'application qu\'à des fins licites. Vous acceptez de ne pas l\'utiliser d\'une manière susceptible d\'endommager, de désactiver ou d\'altérer l\'application.\n\n3. Comptes utilisateurs\nVous êtes responsable de la confidentialité de votre compte et de votre mot de passe.\n\n4. Réservations et paiements\nToutes les réservations sont soumises à disponibilité. Les conditions de paiement sont celles indiquées au moment de la réservation.\n\n5. Politique d\'annulation\nLes politiques d\'annulation varient selon l\'événement et sont précisées au moment de la réservation.\n\n6. Limitation de responsabilité\nDans la mesure maximale permise par la loi, nous déclinons toute responsabilité pour les dommages indirects, accessoires ou consécutifs.\n\n7. Modifications des conditions\nNous pouvons modifier ces conditions à tout moment. Nous informerons les utilisateurs en cas de changement important.\n\n8. Coordonnées\nPour toute question sur ces conditions, contactez-nous à legal@zoea.africa.';
}
