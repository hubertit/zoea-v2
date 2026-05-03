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

  @override
  String get commonViewMore => 'View More';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonRetry => 'Retry';

  @override
  String get exploreLoading => 'Loading...';

  @override
  String get exploreDefaultCity => 'Kigali';

  @override
  String get exploreCurrencyPair => 'USD / RWF';

  @override
  String get exploreQuickActions => 'Quick Actions';

  @override
  String get exploreUnablePhoneCall => 'Unable to make phone call';

  @override
  String get exploreEmergencyTollFreeTitle => 'Emergency Toll Free Numbers';

  @override
  String get exploreEmergencyEmergency => 'Emergency';

  @override
  String get exploreEmergencyTrafficAccidents => 'Traffic Accidents';

  @override
  String get exploreEmergencyAbusePolice => 'Abuse by Police Officer';

  @override
  String get exploreEmergencyAntiCorruption => 'Anti Corruption';

  @override
  String get exploreEmergencyMaritime => 'Maritime Problems';

  @override
  String get exploreEmergencyDrivingLicense => 'Driving License Queries';

  @override
  String get exploreEmergencyFireRescue => 'Fire and Rescue';

  @override
  String exploreCallNumber(String number) {
    return 'Call: $number';
  }

  @override
  String get exploreActionEmergencySos => 'Emergency SOS';

  @override
  String get exploreActionCallTaxi => 'Call Taxi';

  @override
  String get exploreActionBookTour => 'Book Tour';

  @override
  String get exploreActionEsim => 'eSim';

  @override
  String get exploreActionPharmacy => 'Pharmacy';

  @override
  String get exploreActionRoadsideAssistance => 'Roadside Assistance';

  @override
  String get exploreActionFlightInfo => 'Flight Info';

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
  String get exploreCategories => 'Categories';

  @override
  String get exploreHappening => 'Happening';

  @override
  String get exploreFailedLoadEvents => 'Failed to load events';

  @override
  String get exploreNoEventsToday => 'No events today';

  @override
  String get exploreAllCategories => 'All Categories';

  @override
  String get exploreNoCategoriesAvailable => 'No categories available';

  @override
  String get exploreFailedLoadCategories => 'Failed to load categories';

  @override
  String get exploreRecommended => 'Recommended';

  @override
  String get exploreNoFeaturedListings => 'No featured listings available';

  @override
  String get exploreFailedRecommendations => 'Failed to load recommendations';

  @override
  String get exploreNearMe => 'Near Me';

  @override
  String get exploreNoListings => 'No listings available';

  @override
  String get exploreFailedListings => 'Failed to load listings';

  @override
  String get exploreTourPackages => 'Tour Packages';

  @override
  String get exploreFailedTours => 'Failed to load tours';

  @override
  String get exploreNoTours => 'No tour packages available';

  @override
  String get exploreUntitledTour => 'Untitled Tour';

  @override
  String get exploreTourBadgeTour => 'TOUR';

  @override
  String get exploreTourBadgeFeatured => 'FEATURED';

  @override
  String exploreTourPriceFrom(String price) {
    return 'From $price';
  }

  @override
  String get exploreTourPriceUnavailable => 'From RWF ---';

  @override
  String exploreTourDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String exploreTourDurationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get exploreFavoriteSignInTitle => 'Sign In to Save Favorites';

  @override
  String get exploreFavoriteSignInMessage =>
      'Create an account or sign in to save your favorite places and access them anytime.';

  @override
  String get exploreFavoriteSessionTitle => 'Sign In to Save Favorites';

  @override
  String get exploreFavoriteSessionMessage =>
      'Your session has expired. Please sign in again to save favorites.';

  @override
  String exploreFavoriteUpdateFailed(String error) {
    return 'Failed to update favorite: $error';
  }

  @override
  String get exploreGiftReferTitle => 'Refer & Earn';

  @override
  String get exploreGiftReferSubtitle => 'Invite friends and earn rewards';

  @override
  String get exploreGiftItineraryTitle => 'Itinerary Planning';

  @override
  String get exploreGiftItinerarySubtitle => 'Plan and share your trip';

  @override
  String exploreEventTimeToday(String time) {
    return 'Today, $time';
  }

  @override
  String get exploreCategoryFallback => 'Category';

  @override
  String get exploreListingUnknown => 'Unknown';

  @override
  String get exploreListingPlace => 'Place';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClearAll => 'Clear All';

  @override
  String get commonFavoriteAdded => 'Added to favorites!';

  @override
  String get commonFavoriteRemoved => 'Removed from favorites!';

  @override
  String get eventsTitle => 'Events';

  @override
  String get eventsTabTrending => 'Trending';

  @override
  String get eventsTabNearMe => 'Near Me';

  @override
  String get eventsTabThisWeek => 'This Week';

  @override
  String get eventsTabMice => 'MICE';

  @override
  String get eventsErrorLoading => 'Error loading events';

  @override
  String get eventsEmptyTitle => 'No events found';

  @override
  String get eventsEmptySubtitle => 'Check back later for new events';

  @override
  String get eventsSearchTitle => 'Search Events';

  @override
  String get eventsSearchHint => 'Search for events...';

  @override
  String eventsTicketPriceFrom(String amount, String currency) {
    return 'From $amount $currency';
  }

  @override
  String get eventsFilterTitle => 'Filter Events';

  @override
  String get eventsFilterSearchSection => 'Search';

  @override
  String get eventsFilterSearchHint => 'Search events...';

  @override
  String get eventsFilterCategory => 'Category';

  @override
  String get eventsFilterDateRange => 'Date Range';

  @override
  String get eventsFilterStartDate => 'Start Date';

  @override
  String get eventsFilterEndDate => 'End Date';

  @override
  String get eventsFilterPriceRange => 'Price Range';

  @override
  String get eventsFilterLocation => 'Location';

  @override
  String get eventsFilterLocationHint => 'Enter location...';

  @override
  String get eventsFilterOptions => 'Options';

  @override
  String get eventsFilterFreeEvents => 'Free Events';

  @override
  String get eventsFilterVerifiedOnly => 'Verified Only';

  @override
  String get eventsCategoryMusic => 'Music';

  @override
  String get eventsCategorySports => 'Sports & Wellness';

  @override
  String get eventsCategoryFood => 'Food & Drinks';

  @override
  String get eventsCategoryArts => 'Arts & Culture';

  @override
  String get eventsCategoryConferences => 'Conferences';

  @override
  String get eventsCategoryPerformance => 'Performance';

  @override
  String get eventsPriceFree => 'Free';

  @override
  String get eventsPriceUnder5k => 'Under 5K RWF';

  @override
  String get eventsPrice5kTo15k => '5K - 15K RWF';

  @override
  String get eventsPrice15kTo50k => '15K - 50K RWF';

  @override
  String get eventsPrice50kTo100k => '50K - 100K RWF';

  @override
  String get eventsPrice100kPlus => '100K+ RWF';

  @override
  String get eventsCalendarTitle => 'Event Calendar';

  @override
  String eventsCalendarOnDate(String date) {
    return 'Events on $date';
  }

  @override
  String get eventsFavoriteSignInTitle => 'Sign In to Save Favorites';

  @override
  String get eventsFavoriteSignInMessage =>
      'Create an account or sign in to save your favorite events and access them anytime.';

  @override
  String get eventsFavoriteSessionMessage =>
      'Your session has expired. Please sign in again to save favorites.';

  @override
  String get eventsOrganizedBy => 'Organized by';

  @override
  String get eventsAboutTitle => 'About this event';

  @override
  String get eventsSectionCategory => 'Category';

  @override
  String get eventsLabelAttending => 'Attending';

  @override
  String get eventsLabelCapacity => 'Capacity';

  @override
  String get eventsLabelStatus => 'Status';

  @override
  String get eventsStatusOngoing => 'Ongoing';

  @override
  String get eventsStatusUpcoming => 'Upcoming';

  @override
  String get eventsTicketsSection => 'Tickets';

  @override
  String get eventsTicketSoldOut => 'Sold Out';

  @override
  String get eventsTicketBuy => 'Buy Ticket';

  @override
  String get eventsBottomPerPerson => 'per person';

  @override
  String get eventsBottomSelectTickets => 'Select Tickets';

  @override
  String get eventsBottomJoinEvent => 'Join Event';

  @override
  String eventsBottomPriceFrom(String amount, String currency) {
    return 'From $amount $currency';
  }

  @override
  String get eventsSincRedirectTitle => 'Redirecting to Sinc';

  @override
  String get eventsSincRedirectMessage =>
      'You are about to be redirected to our partner platform \"Sinc\" to purchase tickets for this event. Sinc is our trusted ticketing partner that handles secure event bookings and payments.';

  @override
  String get eventsSincDontShowAgain => 'Don\'t show again';

  @override
  String eventsShareWithLocation(String name, String location, String date) {
    return 'Check out \"$name\" in $location on $date!';
  }

  @override
  String eventsShareNoLocation(String name, String date) {
    return 'Check out \"$name\" on $date!';
  }

  @override
  String get assistantSubtitle => 'Your Rwanda guide';

  @override
  String get assistantTooltipNewChat => 'New conversation';

  @override
  String get assistantTooltipHistory => 'History';

  @override
  String get assistantInputHint => 'Ask me anything about Rwanda...';

  @override
  String get assistantEmptyGreeting => 'Hi! I\'m Zoea 👋';

  @override
  String get assistantEmptyBody =>
      'Your friendly guide to Rwanda. Ask me about places to visit, restaurants, tours, or anything else!';

  @override
  String get assistantEmptyTryAsking => 'Try asking:';

  @override
  String assistantErrorSend(String error) {
    return 'Failed to send message: $error';
  }

  @override
  String get assistantHistorySignInTitle => 'Sign In to View History';

  @override
  String get assistantHistorySignInMessage =>
      'Create an account or sign in to view your conversation history with Zoea.';

  @override
  String get assistantHistoryTitle => 'Recent Conversations';

  @override
  String get assistantHistoryEmpty => 'No conversations yet';

  @override
  String get assistantHistoryLoadFailed => 'Failed to load conversations';

  @override
  String assistantErrorLoadConversation(String error) {
    return 'Failed to load conversation: $error';
  }

  @override
  String get assistantRelativeToday => 'Today';

  @override
  String get assistantRelativeYesterday => 'Yesterday';

  @override
  String assistantRelativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get assistantSuggestion1 => 'Italian dinner in Kigali';

  @override
  String get assistantSuggestion2 => 'Gorilla or safari tours';

  @override
  String get assistantSuggestion3 => 'Pharmacy or ATM nearby';

  @override
  String get assistantSuggestion4 => 'Show me popular places';

  @override
  String get assistantSuggestion5 => 'Find restaurants in Kigali';

  @override
  String get assistantSuggestion6 => 'What tours are available?';

  @override
  String get commonDone => 'Done';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonNotApplicable => 'N/A';

  @override
  String get bookingsTabAll => 'All';

  @override
  String get bookingsTabUpcoming => 'Upcoming';

  @override
  String get bookingsTabPast => 'Past';

  @override
  String get bookingsTabCancelled => 'Cancelled';

  @override
  String get bookingsErrorOrders => 'Failed to load orders';

  @override
  String get bookingsErrorBookings => 'Failed to load bookings';

  @override
  String get bookingsEmptyUpcomingTitle => 'No upcoming bookings or orders';

  @override
  String get bookingsEmptyUpcomingSubtitle =>
      'You don\'t have any upcoming reservations or orders';

  @override
  String get bookingsEmptyPastTitle => 'No past bookings or orders';

  @override
  String get bookingsEmptyPastSubtitle =>
      'Your booking and order history will appear here';

  @override
  String get bookingsEmptyCancelledTitle => 'No cancelled bookings or orders';

  @override
  String get bookingsEmptyCancelledSubtitle =>
      'Cancelled bookings and orders will appear here';

  @override
  String get bookingsEmptyDefaultTitle => 'No bookings or orders yet';

  @override
  String get bookingsEmptyDefaultSubtitle =>
      'Start exploring and make your first booking or order!';

  @override
  String get bookingsExploreNow => 'Explore now';

  @override
  String get bookingsSearchTitle => 'Search bookings';

  @override
  String get bookingsSearchHint =>
      'Search by name, location, booking or order number…';

  @override
  String get bookingsLocationNotSpecified => 'Location not specified';

  @override
  String get bookingsTourLocation => 'Tour location';

  @override
  String get stayTitle => 'Where to stay';

  @override
  String get staySubtitle => 'Find your perfect accommodation';

  @override
  String get stayTabAll => 'All';

  @override
  String get stayTabHotels => 'Hotels';

  @override
  String get stayTabBnbs => 'B&Bs';

  @override
  String get stayTabApartments => 'Apartments';

  @override
  String get stayTabVillas => 'Villas';

  @override
  String get stayAnyDates => 'Any dates';

  @override
  String get staySelectCheckout => 'Select checkout';

  @override
  String stayGuestCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guests',
      one: '1 guest',
    );
    return '$_temp0';
  }

  @override
  String get stayFailedLoad => 'Failed to load accommodations';

  @override
  String stayEmptyNoMatchesForCategory(String category) {
    return 'No $category found';
  }

  @override
  String get stayEmptyAdjust => 'Try adjusting your search or filters';

  @override
  String get stayFiltersTitle => 'Filters';

  @override
  String get stayPriceRangeRwf => 'Price range (RWF)';

  @override
  String get stayPriceMinSample => 'Min: 10,000';

  @override
  String get stayPriceMaxSample => 'Max: 200,000';

  @override
  String get stayMinimumRating => 'Minimum rating';

  @override
  String stayRatingAtLeastPlus(int min) {
    return '$min+';
  }

  @override
  String get stayAmenities => 'Amenities';

  @override
  String get stayAmenityWifi => 'Wi‑Fi';

  @override
  String get stayAmenityPool => 'Pool';

  @override
  String get stayAmenitySpa => 'Spa';

  @override
  String get stayAmenityGym => 'Gym';

  @override
  String get stayAmenityRestaurant => 'Restaurant';

  @override
  String get stayAmenityParking => 'Parking';

  @override
  String get stayAmenityAirConditioning => 'Air conditioning';

  @override
  String get stayAmenityBusinessCenter => 'Business center';

  @override
  String get stayAmenityKitchen => 'Kitchen';

  @override
  String get stayAmenityGarden => 'Garden';

  @override
  String get stayAmenityRoomService => 'Room service';

  @override
  String get stayPropertyType => 'Property type';

  @override
  String get stayDistanceFromCenter => 'Distance from city center';

  @override
  String get stayDistanceAny => 'Any';

  @override
  String get stayDistanceUnder5km => 'Under 5 km';

  @override
  String get stayDistance5to10km => '5–10 km';

  @override
  String get stayDistance10to20km => '10–20 km';

  @override
  String get stayDistanceOver20km => 'Over 20 km';

  @override
  String get stayApplyFilters => 'Apply filters';

  @override
  String get stayMapComingSoon => 'Map view coming soon!';

  @override
  String get staySearchOptionsTitle => 'Search options';

  @override
  String get stayWhereLabel => 'Where';

  @override
  String get stayCheckInOutLabel => 'Check-in & check-out';

  @override
  String get stayGuestsLabel => 'Guests';

  @override
  String get staySearchAccommodations => 'Search accommodations';

  @override
  String get staySelectLocationTitle => 'Select location';

  @override
  String get staySelectDatesTimesTitle => 'Select dates & times';

  @override
  String get stayCheckIn => 'Check-in';

  @override
  String get stayCheckOut => 'Check-out';

  @override
  String get staySelectDate => 'Select date';

  @override
  String get staySelectTime => 'Select time';

  @override
  String get stayNumberOfGuests => 'Number of guests';

  @override
  String get stayGuestsSheetGuests => 'Guests';

  @override
  String get staySortBy => 'Sort by';

  @override
  String get staySortRecommended => 'Recommended';

  @override
  String get staySortPriceLowHigh => 'Price: low to high';

  @override
  String get staySortPriceHighLow => 'Price: high to low';

  @override
  String get staySortRatingHighLow => 'Rating: high to low';

  @override
  String get staySortRatingLowHigh => 'Rating: low to high';

  @override
  String get staySortDistance => 'Distance';

  @override
  String get staySortPopularity => 'Popularity';

  @override
  String get stayListingFallback => 'Accommodation';

  @override
  String get stayLocationUnavailable => 'Location not available';

  @override
  String get stayBreakfast => 'Breakfast';

  @override
  String stayRoomTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count room types',
      one: '1 room type',
    );
    return '$_temp0';
  }

  @override
  String get bookingsBookAgain => 'Book again';

  @override
  String get bookingsViewDetails => 'View details';

  @override
  String bookingsBookedOn(String date) {
    return 'Booked on $date';
  }

  @override
  String bookingsOrderedOn(String date) {
    return 'Ordered on $date';
  }

  @override
  String get bookingsOrderLabel => 'ORDER';

  @override
  String get bookingsDateNotSpecified => 'Date not specified';

  @override
  String bookingsOrderPreviewMessage(String number) {
    return 'Order details for $number';
  }

  @override
  String get bookingsCancelOrderSoon => 'Cancel order coming soon';

  @override
  String bookingsLineItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSpecified => 'Not specified';

  @override
  String get maintenanceTitle => 'We\'ll Be Right Back!';

  @override
  String get maintenanceMessage =>
      'Our systems are currently undergoing maintenance to serve you better. We\'ll be back online shortly.';

  @override
  String get maintenanceTryAgain => 'Try Again';

  @override
  String maintenanceSupport(String email) {
    return 'Need help? Contact us at $email';
  }

  @override
  String get maintenanceStillUnavailable =>
      'Service is still unavailable. Please try again in a moment.';

  @override
  String get helpSearchHint => 'Search help articles…';

  @override
  String get helpQuickHelp => 'Quick Help';

  @override
  String get helpPopularTopics => 'Popular Topics';

  @override
  String get helpContactSupport => 'Contact Support';

  @override
  String get helpFaqCategoriesTitle => 'Frequently Asked Questions';

  @override
  String get helpLinkOpenFailed => 'Could not open link. Try again later.';

  @override
  String get helpContactButton => 'Contact';

  @override
  String helpFeatureComingSoon(String feature) {
    return '$feature is coming soon!';
  }

  @override
  String get helpLiveChatBody =>
      'Start a live chat session with our support team.';

  @override
  String get helpQuickAccountTitle => 'Account Issues';

  @override
  String get helpQuickAccountSubtitle =>
      'Login, registration, and profile problems';

  @override
  String get helpQuickPaymentTitle => 'Payment & Billing';

  @override
  String get helpQuickPaymentSubtitle => 'Booking payments and refunds';

  @override
  String get helpQuickEventsTitle => 'Events & Bookings';

  @override
  String get helpQuickEventsSubtitle => 'Event tickets and booking management';

  @override
  String get helpQuickPlacesTitle => 'Places & Locations';

  @override
  String get helpQuickPlacesSubtitle => 'Finding and visiting places';

  @override
  String get helpTopicBookEvents => 'How to book events';

  @override
  String get helpTopicPaymentMethods => 'Payment methods';

  @override
  String get helpTopicCancelBooking => 'Cancel booking';

  @override
  String get helpTopicUpdateProfile => 'Update profile';

  @override
  String get helpTopicContactSupport => 'Contact support';

  @override
  String get helpTopicAppFeatures => 'App features';

  @override
  String get helpLiveChatTitle => 'Live Chat';

  @override
  String get helpLiveChatSubtitle => 'Get instant help from our support team';

  @override
  String get helpEmailSupportTitle => 'Email Support';

  @override
  String get helpPhoneSupportTitle => 'Phone Support';

  @override
  String get helpPhoneSupportSubtitle => '+250 796 889 900';

  @override
  String get helpFaqGettingStarted => 'Getting Started';

  @override
  String get helpFaqAccountProfile => 'Account & Profile';

  @override
  String get helpFaqBookingsEvents => 'Bookings & Events';

  @override
  String get helpFaqPaymentRefunds => 'Payment & Refunds';

  @override
  String get helpFaqTechnicalIssues => 'Technical Issues';

  @override
  String get helpAppVersionLabel => 'App Version';

  @override
  String get helpBuildNumberLabel => 'Build Number';

  @override
  String get helpLastUpdatedLabel => 'Last Updated';

  @override
  String get helpPlatformLabel => 'Platform';

  @override
  String get helpPackageInfoError => 'Could not load package info.';

  @override
  String get helpArticleAccount =>
      'Common account issues and solutions:\n\n• Forgot Password: Use the \"Forgot Password\" link on the login screen\n• Account Verification: Check your email for verification links\n• Profile Updates: Go to Profile > Edit Profile to update your information\n• Account Security: Enable two-factor authentication in Privacy & Security settings\n• Data Privacy: Review your privacy settings in the app settings';

  @override
  String get helpArticlePayment =>
      'Payment and billing assistance:\n\n• Payment Methods: Add credit cards, mobile money, or bank accounts\n• Refund Requests: Contact support for booking cancellations and refunds\n• Payment History: View all transactions in your profile\n• Failed Payments: Check your payment method and try again\n• Currency: All payments are processed in Rwandan Francs (RWF)';

  @override
  String get helpArticleBooking =>
      'Event booking and management:\n\n• Booking Events: Browse events and tap \"Book Now\" to reserve your spot\n• Booking Confirmation: You\'ll receive email and app notifications\n• Cancel Bookings: Go to My Bookings to cancel upcoming events\n• Event Updates: Check the Events tab for latest information\n• Group Bookings: Contact support for group reservations';

  @override
  String get helpArticlePlaces =>
      'Places and location information:\n\n• Finding Places: Use the search bar or browse categories\n• Place Details: Tap on any place to see photos, reviews, and information\n• Directions: Get directions using your preferred maps app\n• Reviews: Share your experiences by writing reviews\n• Favorites: Save places you want to visit later';

  @override
  String get helpFaqGs1Q => 'How do I create an account?';

  @override
  String get helpFaqGs1A =>
      'Download the app and tap \"Sign Up\" to create your account with email or phone number.';

  @override
  String get helpFaqGs2Q => 'How do I book my first event?';

  @override
  String get helpFaqGs2A =>
      'Browse events in the Events tab, select an event, and tap \"Book Now\" to reserve your spot.';

  @override
  String get helpFaqGs3Q => 'How do I update my profile?';

  @override
  String get helpFaqGs3A =>
      'Go to Profile > Edit Profile to update your personal information.';

  @override
  String get helpFaqGs4Q => 'How do I find places to visit?';

  @override
  String get helpFaqGs4A =>
      'Use the Explore tab to discover places, or search for specific locations.';

  @override
  String get helpFaqGs5Q => 'How do I get help?';

  @override
  String get helpFaqGs5A =>
      'Use this Help Center, contact support, or check our FAQ section.';

  @override
  String get helpFaqAc1Q => 'How do I change my password?';

  @override
  String get helpFaqAc1A =>
      'Go to Profile > Privacy & Security > Change Password to update your password.';

  @override
  String get helpFaqAc2Q => 'How do I update my email?';

  @override
  String get helpFaqAc2A =>
      'Go to Profile > Edit Profile to update your email address.';

  @override
  String get helpFaqAc3Q => 'How do I delete my account?';

  @override
  String get helpFaqAc3A =>
      'Contact support to request account deletion. This action cannot be undone.';

  @override
  String get helpFaqAc4Q => 'How do I enable two-factor authentication?';

  @override
  String get helpFaqAc4A =>
      'Go to Profile > Privacy & Security to enable 2FA for added security.';

  @override
  String get helpFaqAc5Q => 'How do I update my profile picture?';

  @override
  String get helpFaqAc5A =>
      'Go to Profile > Edit Profile and tap on your profile picture to change it.';

  @override
  String get helpFaqAc6Q => 'How do I change my phone number?';

  @override
  String get helpFaqAc6A =>
      'Go to Profile > Edit Profile to update your phone number.';

  @override
  String get helpFaqAc7Q => 'How do I verify my account?';

  @override
  String get helpFaqAc7A =>
      'Check your email for verification links and follow the instructions.';

  @override
  String get helpFaqAc8Q => 'How do I download my data?';

  @override
  String get helpFaqAc8A =>
      'Go to Profile > Privacy & Security > Download Data to request your data.';

  @override
  String get helpFaqBk1Q => 'How do I book an event?';

  @override
  String get helpFaqBk1A =>
      'Browse events, select one, and tap \"Book Now\" to complete your booking.';

  @override
  String get helpFaqBk2Q => 'How do I cancel a booking?';

  @override
  String get helpFaqBk2A =>
      'Go to My Bookings, find your booking, and tap \"Cancel Booking\".';

  @override
  String get helpFaqBk3Q => 'How do I get my event tickets?';

  @override
  String get helpFaqBk3A =>
      'Your tickets will be sent via email and available in the app.';

  @override
  String get helpFaqBk4Q => 'Can I book for multiple people?';

  @override
  String get helpFaqBk4A =>
      'Yes, select the number of people when booking an event.';

  @override
  String get helpFaqBk5Q => 'How do I get a refund?';

  @override
  String get helpFaqBk5A =>
      'Contact support for refund requests. Refund policy varies by event.';

  @override
  String get helpFaqBk6Q => 'How do I reschedule a booking?';

  @override
  String get helpFaqBk6A =>
      'Cancel your current booking and book a new time slot.';

  @override
  String get helpFaqBk7Q => 'How do I check my booking status?';

  @override
  String get helpFaqBk7A =>
      'Go to My Bookings to see all your reservations and their status.';

  @override
  String get helpFaqBk8Q => 'What if an event is cancelled?';

  @override
  String get helpFaqBk8A =>
      'You\'ll be notified and can request a full refund or transfer to another event.';

  @override
  String get helpFaqBk9Q => 'How do I book a hotel?';

  @override
  String get helpFaqBk9A =>
      'Browse hotels in the Explore tab and follow the booking process.';

  @override
  String get helpFaqBk10Q => 'How do I book a tour?';

  @override
  String get helpFaqBk10A =>
      'Find tours in the Explore tab and book them like events.';

  @override
  String get helpFaqBk11Q => 'How do I get directions to an event?';

  @override
  String get helpFaqBk11A =>
      'Tap on the event location to open it in your maps app.';

  @override
  String get helpFaqBk12Q => 'How do I share an event?';

  @override
  String get helpFaqBk12A =>
      'Tap the share button on any event to share it with friends.';

  @override
  String get helpFaqPy1Q => 'What payment methods are accepted?';

  @override
  String get helpFaqPy1A =>
      'We accept credit cards, mobile money, and bank transfers.';

  @override
  String get helpFaqPy2Q => 'How do I add a payment method?';

  @override
  String get helpFaqPy2A =>
      'Go to Profile > Payment Methods to add your preferred payment option.';

  @override
  String get helpFaqPy3Q => 'How do I get a refund?';

  @override
  String get helpFaqPy3A =>
      'Contact support with your booking details to request a refund.';

  @override
  String get helpFaqPy4Q => 'How long do refunds take?';

  @override
  String get helpFaqPy4A =>
      'Refunds typically take 3-5 business days to process.';

  @override
  String get helpFaqPy5Q => 'Is my payment information secure?';

  @override
  String get helpFaqPy5A =>
      'Yes, we use industry-standard encryption to protect your data.';

  @override
  String get helpFaqPy6Q => 'How do I update my payment method?';

  @override
  String get helpFaqPy6A =>
      'Go to Profile > Payment Methods to update your payment information.';

  @override
  String get helpFaqTx1Q => 'The app is not loading properly';

  @override
  String get helpFaqTx1A =>
      'Try closing and reopening the app, or restart your device.';

  @override
  String get helpFaqTx2Q => 'I can\'t log in to my account';

  @override
  String get helpFaqTx2A =>
      'Check your internet connection and verify your login credentials.';

  @override
  String get helpFaqTx3Q => 'The app crashes frequently';

  @override
  String get helpFaqTx3A =>
      'Update to the latest version of the app from your app store.';

  @override
  String get helpFaqTx4Q => 'I\'m not receiving notifications';

  @override
  String get helpFaqTx4A =>
      'Check your notification settings in your device settings and app settings.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join the Zoea Africa community';

  @override
  String get registerInviteBanner =>
      'You opened an invite link — we added the code below. You can change or paste a different code from a text or chat.';

  @override
  String get registerFullName => 'Full Name';

  @override
  String get registerFullNameHint => 'Enter your full name';

  @override
  String get registerFieldRequired => 'Required';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'Enter your email address';

  @override
  String get registerInviteCodeLabel => 'Invite code';

  @override
  String get registerInviteCodeHint => 'Paste if you have one';

  @override
  String get registerCodeTooLong => 'Code is too long';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Create a strong password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerConfirmPasswordHint => 'Confirm your password';

  @override
  String get registerConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get registerPasswordsMismatch => 'Passwords do not match';

  @override
  String get registerAgreePrefix => 'I agree to the ';

  @override
  String get registerTerms => 'Terms and Conditions';

  @override
  String get registerAndConjunction => ' and ';

  @override
  String get registerPrivacy => 'Privacy Policy';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerAgreeTermsMessage =>
      'Please agree to the Terms and Conditions';

  @override
  String get registerFailed => 'Registration failed. Please try again.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsCurrentTheme => 'Current Theme';

  @override
  String get commonViewDetails => 'View details';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String get mapScreenTitle => 'Map';

  @override
  String get transactionHistoryTitle => 'Transaction history';

  @override
  String get itineraryAddFromFavoritesTitle => 'Add from favorites';

  @override
  String get shopSearchProductsTitle => 'Search products';

  @override
  String get shopClearFilters => 'Clear filters';

  @override
  String get webviewOpenInBrowser => 'Open in browser';

  @override
  String get commonViewEvent => 'View event';

  @override
  String get commonViewPlace => 'View place';

  @override
  String get mapScreenHeadline => 'Map view';

  @override
  String get mapScreenPlaceholder =>
      'Interactive map with listings will be implemented here';

  @override
  String get transactionHistorySubtitle =>
      'View your payment and transaction history';

  @override
  String itineraryAddWithCount(int count) {
    return 'Add ($count)';
  }

  @override
  String get favoritesEmptyTitle => 'No favorites';

  @override
  String get favoritesEmptySubtitle => 'You don\'t have any favorites yet';

  @override
  String get favoritesLoadError => 'Failed to load favorites';

  @override
  String get splashHeadline1 => 'Discover Rwanda';

  @override
  String get splashHeadline2 => 'Like Never Before';

  @override
  String get splashTagline =>
      'Explore stunning destinations, authentic experiences, and hidden gems across the Land of a Thousand Hills.';

  @override
  String get onboardingPage1Title => 'Discover Rwanda';

  @override
  String get onboardingPage1Subtitle =>
      'Explore the land of a thousand hills with verified experiences';

  @override
  String get onboardingPage2Title => 'Book seamlessly';

  @override
  String get onboardingPage2Subtitle =>
      'Reserve hotels, restaurants, and tours with your Zoea Card';

  @override
  String get onboardingPage3Title => 'Connect & share';

  @override
  String get onboardingPage3Subtitle =>
      'Join the community and share your Rwandan adventures';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSkipGuest => 'Skip — browse as guest';

  @override
  String get onboardingSignInPrompt => 'Already have an account? Sign in';

  @override
  String get countryPickerSearchHint => 'Start typing to search';

  @override
  String get authResetPasswordAppBar => 'Reset password';

  @override
  String get authChooseResetMethod =>
      'Choose how you want to reset your password';

  @override
  String get authResetCodeSentDefault => 'Reset code sent successfully';

  @override
  String get authSendResetCode => 'Send reset code';

  @override
  String get authBackToLogin => 'Back to login';

  @override
  String get authVerifyCodeTitle => 'Verify code';

  @override
  String get authEnterResetCode => 'Enter reset code';

  @override
  String authResetCodeSentTo(int digits, String identifier) {
    return 'We sent a $digits-digit code to $identifier';
  }

  @override
  String get authVerifyCodeButton => 'Verify code';

  @override
  String get authResendCode => 'Resend code';

  @override
  String get authResendSending => 'Sending…';

  @override
  String authResendCodeIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get authNewPasswordAppBar => 'New password';

  @override
  String get authCreateNewPasswordTitle => 'Create new password';

  @override
  String get authCreateNewPasswordBody =>
      'Enter your new password. Make sure it\'s strong and secure.';

  @override
  String get authNewPasswordFieldLabel => 'New password';

  @override
  String get authNewPasswordFieldHint => 'Enter your new password';

  @override
  String get authConfirmNewPasswordHint => 'Confirm your new password';

  @override
  String get authEnterNewPasswordError => 'Please enter a new password';

  @override
  String get authPasswordResetSuccess => 'Password reset successfully!';

  @override
  String get authSaveNewPassword => 'Save password';

  @override
  String get authNewCodeRequested => 'A new code has been requested.';

  @override
  String get authPhoneNumberExample => '780 123 456';

  @override
  String get shopScreenTitleShop => 'Shop';

  @override
  String get shopScreenTitleProducts => 'Products';

  @override
  String shopProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String shopSortLine(String label) {
    return 'Sort: $label';
  }

  @override
  String get shopEmptyNoProducts => 'No products found';

  @override
  String get shopEmptyAdjustFilters => 'Try adjusting your filters or search';

  @override
  String get shopErrorLoadProducts => 'Failed to load products';

  @override
  String get shopOutOfStock => 'Out of stock';

  @override
  String get shopFilterTitle => 'Filter products';

  @override
  String get shopStatusSection => 'Status';

  @override
  String get shopFeaturedSection => 'Featured';

  @override
  String get shopFilterActive => 'Active';

  @override
  String get shopFilterInactive => 'Inactive';

  @override
  String get shopFeaturedOnly => 'Featured only';

  @override
  String get shopFilterReset => 'Reset';

  @override
  String get shopSearchProductNameHint => 'Enter product name…';

  @override
  String get shopSortPopular => 'Popular';

  @override
  String get shopSortNameAz => 'Name (A–Z)';

  @override
  String get shopSortNameZa => 'Name (Z–A)';

  @override
  String get shopSortPriceLowHigh => 'Price (low to high)';

  @override
  String get shopSortPriceHighLow => 'Price (high to low)';

  @override
  String get shopSortNewest => 'Newest first';

  @override
  String get favoritesEmptyAllTitle => 'No favorites yet';

  @override
  String get favoritesEmptyAllSubtitle =>
      'Start exploring and save your favorite events and places';

  @override
  String get favoritesEmptyExploreCta => 'Explore now';

  @override
  String get favoritesEmptyEventsTitle => 'No favorite events';

  @override
  String get favoritesEmptyEventsSubtitle =>
      'Save events you\'re interested in to see them here';

  @override
  String get favoritesEmptyEventsCta => 'Browse events';

  @override
  String get favoritesEmptyPlacesTitle => 'No favorite places';

  @override
  String get favoritesEmptyPlacesSubtitle =>
      'Save places you want to visit to see them here';

  @override
  String get favoritesEmptyPlacesCta => 'Explore places';

  @override
  String get favoritesRemoveTitle => 'Remove from favorites';

  @override
  String favoritesRemoveMessage(String name) {
    return 'Are you sure you want to remove \"$name\" from your favorites?';
  }

  @override
  String favoritesRemoveFailed(String error) {
    return 'Couldn\'t remove favorite: $error';
  }

  @override
  String get favoritesTypeEvent => 'Event';

  @override
  String get favoritesTypePlace => 'Place';

  @override
  String get favoritesDateTba => 'Date TBA';

  @override
  String get categoryTitleDining => 'Dining';

  @override
  String get categoryTitleNightlife => 'Nightlife';

  @override
  String get categoryTitleExperiences => 'Experiences';

  @override
  String get categoryTitlePlaces => 'Places';

  @override
  String categorySearchAppBar(String categoryName) {
    return 'Search $categoryName';
  }

  @override
  String get categorySearchHintDining => 'Search restaurants, cafés…';

  @override
  String get categorySearchHintNightlife => 'Search bars, clubs, lounges…';

  @override
  String get categorySearchHintExperiences =>
      'Search tours, adventures, experiences…';

  @override
  String get categorySearchHintDefault => 'Search places…';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String get categoryErrorListings => 'Failed to load listings';

  @override
  String get categoryErrorCategory => 'Failed to load category';

  @override
  String categoryEmptyPrompt(String categoryName) {
    return 'Search for $categoryName';
  }

  @override
  String get categoryEmptyNoResults => 'No results found';

  @override
  String get categoryEmptyTryDifferentKeywords =>
      'Try different keywords or categories';

  @override
  String get categorySearchSuggestionsDining =>
      'Try searching for \"pizza\", \"coffee\", or \"sushi\"';

  @override
  String get categorySearchSuggestionsNightlife =>
      'Try searching for \"bar\", \"club\", or \"lounge\"';

  @override
  String get categorySearchSuggestionsExperiences =>
      'Try searching for \"gorilla\", \"hiking\", or \"cultural\"';

  @override
  String get categorySearchSuggestionsDefault =>
      'Try searching for specific places or locations';

  @override
  String categoryFilterSheetTitle(String categoryName) {
    return 'Filter $categoryName';
  }

  @override
  String categorySortSheetTitle(String categoryName) {
    return 'Sort $categoryName';
  }

  @override
  String get categorySectionPriceRange => 'Price range';

  @override
  String get categorySectionFeatures => 'Features';

  @override
  String get categoryRatingStars40 => '4.0+ stars';

  @override
  String get categoryRatingStars45 => '4.5+ stars';

  @override
  String get categoryRatingStars50 => '5.0 stars';

  @override
  String get catTourOperatorBadge => 'Tour operator';

  @override
  String listingReviewsCountParen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '($_temp0)';
  }

  @override
  String get catSubDiningRestaurants => 'Restaurants';

  @override
  String get catSubDiningCafes => 'Cafés';

  @override
  String get catSubDiningFastFood => 'Fast food';

  @override
  String get catSubNightBars => 'Bars';

  @override
  String get catSubNightClubs => 'Clubs';

  @override
  String get catSubNightLounges => 'Lounges';

  @override
  String get catSubExpTours => 'Tours';

  @override
  String get catSubExpAdventures => 'Adventures';

  @override
  String get catSubExpCultural => 'Cultural';

  @override
  String get catSubExpOperators => 'Operators';

  @override
  String get catPriceDiningU5k => 'Under RWF 5,000';

  @override
  String get catPriceDining5to15k => 'RWF 5,000 – 15,000';

  @override
  String get catPriceDining15to30k => 'RWF 15,000 – 30,000';

  @override
  String get catPriceDiningOver30k => 'Above RWF 30,000';

  @override
  String get catPriceNightU10k => 'Under RWF 10,000';

  @override
  String get catPriceNight10to20k => 'RWF 10,000 – 20,000';

  @override
  String get catPriceNight20to30k => 'RWF 20,000 – 30,000';

  @override
  String get catPriceNightOver30k => 'Above RWF 30,000';

  @override
  String get catPriceExpU50k => 'Under RWF 50,000';

  @override
  String get catPriceExp50to100k => 'RWF 50,000 – 100,000';

  @override
  String get catPriceExp100to200k => 'RWF 100,000 – 200,000';

  @override
  String get catPriceExpOver200k => 'Above RWF 200,000';

  @override
  String get catPriceDefU10k => 'Under RWF 10,000';

  @override
  String get catPriceDef10to30k => 'RWF 10,000 – 30,000';

  @override
  String get catPriceDefOver30k => 'Above RWF 30,000';

  @override
  String get catFeatDiningWifi => 'Wi‑Fi';

  @override
  String get catFeatDiningParking => 'Parking';

  @override
  String get catFeatDiningOutdoorSeating => 'Outdoor seating';

  @override
  String get catFeatDiningDelivery => 'Delivery';

  @override
  String get catFeatDiningTakeaway => 'Takeaway';

  @override
  String get catFeatDiningVegetarian => 'Vegetarian options';

  @override
  String get catFeatNightLiveMusic => 'Live music';

  @override
  String get catFeatNightDanceFloor => 'Dance floor';

  @override
  String get catFeatNightOutdoorSeating => 'Outdoor seating';

  @override
  String get catFeatNightVip => 'VIP section';

  @override
  String get catFeatNightParking => 'Parking';

  @override
  String get catFeatNightWifi => 'Wi‑Fi';

  @override
  String get catFeatExpGuidedTours => 'Guided tours';

  @override
  String get catFeatExpTransport => 'Transport included';

  @override
  String get catFeatExpMeals => 'Meals included';

  @override
  String get catFeatExpEquipment => 'Equipment provided';

  @override
  String get catFeatExpGroup => 'Group tours';

  @override
  String get catFeatExpPrivate => 'Private tours';

  @override
  String get catFeatDefWifi => 'Wi‑Fi';

  @override
  String get catFeatDefParking => 'Parking';

  @override
  String get catFeatDefAccessible => 'Accessible';

  @override
  String get exploreApplySort => 'Apply sort';

  @override
  String get exploreCategoryNotFoundShort => 'Category not found';

  @override
  String get commonSignIn => 'Sign in';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonMaybeLater => 'Maybe later';

  @override
  String get commonGoBack => 'Go back';

  @override
  String get commonStartShopping => 'Start shopping';

  @override
  String get commonContinueShopping => 'Continue shopping';

  @override
  String get commonFavoriteVerb => 'Favorite';

  @override
  String get commonBookNow => 'Book now';

  @override
  String get commonOrderNow => 'Order now';

  @override
  String get commonContact => 'Contact';

  @override
  String get commonReserveTable => 'Reserve table';

  @override
  String get commonWriteReview => 'Write review';

  @override
  String get commonViewAllProducts => 'View all products';

  @override
  String get commonViewAllServices => 'View all services';

  @override
  String get commonViewMenu => 'View menu';

  @override
  String get commonViewMenus => 'View menus';

  @override
  String get commonSelectVariant => 'Select a variant';

  @override
  String get commonShareReferralCode => 'Share referral code';

  @override
  String get commonCompleteProfile => 'Complete profile';

  @override
  String get commonLinkOpenFailed => 'Could not open link. Try again later.';

  @override
  String get commonCouponApplied => 'Coupon applied successfully!';

  @override
  String get commonCouponInvalid => 'Invalid coupon code';

  @override
  String get commonBookingNotAvailable =>
      'Booking is not available for this listing type';

  @override
  String commonFailedLoadListing(String error) {
    return 'Failed to load listing: $error';
  }

  @override
  String commonFailedCreateBooking(String error) {
    return 'Failed to create booking: $error';
  }

  @override
  String commonFailedBookTour(String error) {
    return 'Failed to book tour: $error';
  }

  @override
  String commonFailedBookService(String error) {
    return 'Failed to book service: $error';
  }

  @override
  String commonFailedAddToCart(String error) {
    return 'Failed to add to cart: $error';
  }

  @override
  String commonFailedUpdate(String error) {
    return 'Failed to update: $error';
  }

  @override
  String commonFailedRemove(String error) {
    return 'Failed to remove: $error';
  }

  @override
  String commonFailedClearCart(String error) {
    return 'Failed to clear cart: $error';
  }

  @override
  String commonFailedPlaceOrder(String error) {
    return 'Failed to place order: $error';
  }

  @override
  String commonFailedShare(String error) {
    return 'Failed to share: $error';
  }

  @override
  String get commonProductAddedToCart => 'Product added to cart';

  @override
  String get commonItemAddedToCart => 'Item added to cart';

  @override
  String get commonPleaseSelectTourSchedule =>
      'Please select a tour and schedule';

  @override
  String get commonPleaseFillRequiredFields =>
      'Please fill in all required fields';

  @override
  String get commonBookingMissingConfirmation =>
      'Booking created, but confirmation ID is missing.';

  @override
  String get commonPleaseSelectDateTime => 'Please select date and time';

  @override
  String get commonServiceBookedSuccess => 'Service booked successfully!';

  @override
  String get commonPleaseWriteReview =>
      'Please write a review before submitting';

  @override
  String get commonPleaseWriteReviewUpdate =>
      'Please write a review before updating';

  @override
  String get commonReviewSubmitMissingContext =>
      'Unable to submit review. Missing listing, event, or tour information.';

  @override
  String get commonThankYouReview => 'Thank you for your review!';

  @override
  String get commonReviewUpdatedSuccess => 'Review updated successfully!';

  @override
  String get commonCheckInOutRequired =>
      'Please select check-in and check-out dates';

  @override
  String get commonCheckOutAfterCheckIn =>
      'Check-out date must be after check-in date';

  @override
  String get commonSelectRoomType => 'Please select a room type to continue';

  @override
  String get cartTitle => 'Clear cart';

  @override
  String get cartClearConfirm =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get cartEmptyMessage => 'Your cart is empty';

  @override
  String get checkoutFulfillmentPickup => 'Pickup';

  @override
  String get checkoutFulfillmentPickupSubtitle => 'Collect from store';

  @override
  String get checkoutFulfillmentDelivery => 'Delivery';

  @override
  String get checkoutFulfillmentDeliverySubtitle => 'Delivered to your address';

  @override
  String get checkoutFulfillmentDineIn => 'Dine in';

  @override
  String get checkoutFulfillmentDineInSubtitle => 'Eat at the restaurant';

  @override
  String get checkoutUnableListing => 'Unable to determine listing';

  @override
  String get shopSearchServicesTitle => 'Search services';

  @override
  String get shopServicesTitle => 'Services';

  @override
  String get referralScreenShareCta => 'Share referral code';

  @override
  String get zoeaCardScreenTitle => 'Zoea Card';

  @override
  String get itinerariesScreenTitle => 'Itineraries';

  @override
  String get itinerariesMyScreenTitle => 'My itineraries';

  @override
  String get itineraryCreateFab => 'Create itinerary';

  @override
  String get itineraryDetailTitle => 'Itinerary';

  @override
  String get itineraryViewCta => 'View';

  @override
  String get itineraryMakePublicTitle => 'Make public';

  @override
  String get itineraryMakePublicSubtitle =>
      'Allow others to view this itinerary';

  @override
  String get itineraryAddItem => 'Add item';

  @override
  String get itineraryFromFavoritesTitle => 'From favorites';

  @override
  String get itineraryFromFavoritesSubtitle => 'Add from your saved favorites';

  @override
  String get itineraryFromRecommendationsTitle => 'From recommendations';

  @override
  String get itineraryFromRecommendationsSubtitle =>
      'Add from recommended places';

  @override
  String get itineraryCustomItemTitle => 'Custom item';

  @override
  String get itineraryCustomItemSubtitle => 'Add a custom location or activity';

  @override
  String get itineraryDeleteTitle => 'Delete itinerary';

  @override
  String get itineraryDeleteMessage =>
      'Are you sure you want to delete this itinerary? This action cannot be undone.';

  @override
  String get itineraryDeletedSuccess => 'Itinerary deleted successfully';

  @override
  String get itineraryAddCustomTitle => 'Add custom item';

  @override
  String get itineraryCustomNameRequired => 'Please enter a name';

  @override
  String get itineraryAddFromRecommendationsTitle => 'Add from recommendations';

  @override
  String get reviewsEventComingSoon => 'Event detail page coming soon';

  @override
  String get reviewsTourComingSoon => 'Tour detail page coming soon';

  @override
  String get tourDetailGoBack => 'Go back';

  @override
  String get eventsAttendedViewDetails => 'View details';

  @override
  String get visitedPlacesViewDetails => 'View details';

  @override
  String get appUpdateRequiredTitle => 'Update required';

  @override
  String get appUpdateRequiredMessage =>
      'Please update the app to continue using Zoea.';

  @override
  String get appUpdateAvailableTitle => 'Update available';

  @override
  String get appUpdateAvailableMessage =>
      'A new version of Zoea is ready with improvements and fixes.';

  @override
  String get appUpdateNow => 'Update now';

  @override
  String get appUpdateLater => 'Later';

  @override
  String get appUpdateStoreOpenFailed => 'Could not open the store link';

  @override
  String get privacySectionPrivacySettings => 'Privacy settings';

  @override
  String get privacyLocationServicesTitle => 'Location services';

  @override
  String get privacyLocationServicesSubtitle =>
      'Allow the app to use your location for better recommendations';

  @override
  String get privacyPushNotificationsTitle => 'Push notifications';

  @override
  String get privacyPushNotificationsSubtitle =>
      'Receive notifications about events and updates';

  @override
  String get privacyDataSharingTitle => 'Data sharing';

  @override
  String get privacyDataSharingSubtitle =>
      'Share anonymous data to improve the app experience';

  @override
  String get privacyAnalyticsTitle => 'Analytics';

  @override
  String get privacyAnalyticsSubtitle =>
      'Help us improve the app with usage analytics';

  @override
  String get privacyAnalyticsEnabled => 'Analytics enabled';

  @override
  String get privacyAnalyticsDisabled => 'Analytics disabled';

  @override
  String get privacyAnalyticsUpdateFailed =>
      'Failed to update analytics settings';

  @override
  String get privacyAnalyticsLoadingSubtitle => 'Loading…';

  @override
  String get privacySectionDataPrivacy => 'Data & privacy';

  @override
  String get privacyWhatDataTitle => 'What data we collect';

  @override
  String get privacyWhatDataSubtitle =>
      'See what information is collected and why';

  @override
  String get privacyClearAnalyticsTitle => 'Clear analytics data';

  @override
  String get privacyClearAnalyticsSubtitle =>
      'Delete all stored analytics data';

  @override
  String get privacySectionSecurity => 'Security settings';

  @override
  String get privacyBiometricTitle => 'Biometric authentication';

  @override
  String get privacyBiometricSubtitle =>
      'Use fingerprint or face recognition to unlock';

  @override
  String get privacyTwoFactorTitle => 'Two-factor authentication';

  @override
  String get privacyTwoFactorSubtitle =>
      'Add an extra layer of security to your account';

  @override
  String get privacyChangePasswordTileTitle => 'Change password';

  @override
  String get privacyChangePasswordTileSubtitle =>
      'Update your account password';

  @override
  String get privacyEmailVerificationTileTitle => 'Email verification';

  @override
  String get privacyEmailVerificationTileSubtitle =>
      'Verify your email address';

  @override
  String get privacyPhoneVerified => 'Phone verified';

  @override
  String get privacyPhoneAddVerify => 'Add and verify your phone number';

  @override
  String get privacyPhoneVerificationTileTitle => 'Phone verification';

  @override
  String get privacySectionAccountManagement => 'Account management';

  @override
  String get privacyDownloadDataTitle => 'Download my data';

  @override
  String get privacyDownloadDataSubtitle => 'Get a copy of your personal data';

  @override
  String get privacyDeleteAccountTitle => 'Delete account';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Permanently delete your account and all data';

  @override
  String get privacySectionLegal => 'Legal';

  @override
  String get privacyPolicyTileTitle => 'Privacy policy';

  @override
  String get privacyPolicyTileSubtitle => 'Read our privacy policy';

  @override
  String get privacyTermsTileTitle => 'Terms of service';

  @override
  String get privacyTermsTileSubtitle => 'Read our terms of service';

  @override
  String get privacyChangePasswordDialogTitle => 'Change password';

  @override
  String get privacyCurrentPasswordLabel => 'Current password';

  @override
  String get privacyCurrentPasswordHint => 'Enter your current password';

  @override
  String get privacyCurrentPasswordRequired =>
      'Please enter your current password';

  @override
  String get privacyNewPasswordLabel => 'New password';

  @override
  String get privacyNewPasswordHint => 'Enter your new password';

  @override
  String get privacyNewPasswordRequired => 'Please enter a new password';

  @override
  String get privacyPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get privacyConfirmPasswordLabel => 'Confirm new password';

  @override
  String get privacyConfirmPasswordHint => 'Confirm your new password';

  @override
  String get privacyConfirmPasswordRequired =>
      'Please confirm your new password';

  @override
  String get privacyPasswordsMismatch => 'Passwords do not match';

  @override
  String get privacyPasswordChangedSuccess => 'Password changed successfully!';

  @override
  String get privacyPasswordChangeFailed =>
      'Failed to change password. Please try again.';

  @override
  String get privacyEmailVerificationDialogTitle => 'Email verification';

  @override
  String get privacyEmailVerificationDialogBody =>
      'A verification email will be sent to your registered email address.';

  @override
  String get privacyVerificationEmailSent => 'Verification email sent!';

  @override
  String get privacySendEmail => 'Send email';

  @override
  String get privacyPhoneInvalid => 'Enter a valid phone number';

  @override
  String get privacyPhoneCodeSent => 'We sent a 6-digit code by SMS.';

  @override
  String get privacyPhoneEnterCode => 'Enter the 6-digit code';

  @override
  String get privacyPhoneVerifiedSuccess => 'Phone number verified';

  @override
  String get privacyPhoneVerificationIntro =>
      'We will send a code to confirm this number.';

  @override
  String get myBookingsKeepBooking => 'Keep booking';

  @override
  String get myBookingsCancelBooking => 'Cancel booking';

  @override
  String get editProfileConfirm => 'Confirm';

  @override
  String get privacyPhoneMobileLabel => 'Mobile number';

  @override
  String get privacySendCode => 'Send code';

  @override
  String get privacyVerify => 'Verify';

  @override
  String get privacyDownloadDataDialogTitle => 'Download my data';

  @override
  String get privacyDownloadDataDialogBody =>
      'We will prepare your data and send it to your email address within 24 hours.';

  @override
  String get privacyDownloadDataSubmitted => 'Data download request submitted!';

  @override
  String get privacyRequestData => 'Request data';

  @override
  String get privacyDeleteAccountDialogTitle => 'Delete account';

  @override
  String get privacyDeleteAccountDialogBody =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get privacyDeleteForever => 'Delete forever';

  @override
  String get privacyAccountDeletionComingSoon =>
      'Account deletion feature coming soon!';

  @override
  String get privacyFinalConfirmationTitle => 'Final confirmation';

  @override
  String get privacyFinalConfirmationBody =>
      'Are you absolutely sure? This will permanently delete your account and all associated data.';

  @override
  String get privacyWhatDataCollectSheetTitle => 'What data we collect';

  @override
  String get privacyDataProfileTitle => 'Profile information';

  @override
  String get privacyDataProfileDescription =>
      'Country, language, age range, gender, interests, travel preferences';

  @override
  String get privacyDataProfilePurpose =>
      'Personalize your experience and recommendations';

  @override
  String get privacyDataSearchTitle => 'Search queries';

  @override
  String get privacyDataSearchDescription => 'What you search for in the app';

  @override
  String get privacyDataSearchPurpose =>
      'Improve search results and suggest relevant content';

  @override
  String get privacyDataViewsTitle => 'Content views';

  @override
  String get privacyDataViewsDescription => 'Places and events you view';

  @override
  String get privacyDataViewsPurpose =>
      'Understand your interests and improve recommendations';

  @override
  String get privacyDataUsageTitle => 'App usage';

  @override
  String get privacyDataUsageDescription =>
      'How you use the app, session duration, features used';

  @override
  String get privacyDataUsagePurpose =>
      'Improve app performance and user experience';

  @override
  String get privacyDataAnonymizedFootnote =>
      'All data is anonymized and used only to improve your experience. You can disable analytics or clear your data anytime.';

  @override
  String get privacyGotIt => 'Got it';

  @override
  String privacyPurposeLine(String purpose) {
    return 'Purpose: $purpose';
  }

  @override
  String get privacyClearAnalyticsDialogTitle => 'Clear analytics data';

  @override
  String get privacyClearAnalyticsDialogBody =>
      'This will delete all stored analytics data from your device. This action cannot be undone.';

  @override
  String get privacyClearData => 'Clear data';

  @override
  String get privacyClearAnalyticsSuccess =>
      'Analytics data cleared successfully';

  @override
  String get privacyClearAnalyticsFailed => 'Failed to clear analytics data';

  @override
  String get privacyPhoneSixDigitCodeLabel => '6-digit code';

  @override
  String get zoeaCardSubtitle => 'Your digital wallet for seamless payments';

  @override
  String get shopCartScreenTitle => 'Shopping cart';

  @override
  String get shopCartEmptySubtitle => 'Add items to your cart to get started';

  @override
  String get shopCartLoadFailed => 'Failed to load cart';

  @override
  String get shopCheckoutSignInTitle => 'Sign in to checkout';

  @override
  String get shopCheckoutSignInMessage =>
      'Create an account or sign in to complete your purchase. Your cart will be saved.';

  @override
  String get shopCartItemTypeProduct => 'Product';

  @override
  String get shopCartItemTypeService => 'Service';

  @override
  String get shopCartItemTypeMenuItem => 'Menu item';

  @override
  String get shopCartClearTooltip => 'Clear cart';

  @override
  String get shopCartTotalLabel => 'Total';

  @override
  String get shopProceedToCheckout => 'Proceed to checkout';

  @override
  String get checkoutScreenTitle => 'Checkout';

  @override
  String get checkoutOrderSummary => 'Order summary';

  @override
  String get checkoutDeliveryMethod => 'Delivery method';

  @override
  String get checkoutDeliveryAddress => 'Delivery address';

  @override
  String get checkoutStreetAddressLabel => 'Street address';

  @override
  String get checkoutStreetAddressHint => 'Enter your street address';

  @override
  String get checkoutStreetAddressRequired =>
      'Please enter your delivery address';

  @override
  String get checkoutCityLabel => 'City';

  @override
  String get checkoutCityHint => 'Enter your city';

  @override
  String get checkoutCityRequired => 'Please enter your city';

  @override
  String get checkoutContactInformation => 'Contact information';

  @override
  String get checkoutFullNameLabel => 'Full name';

  @override
  String get checkoutFullNameHint => 'Enter your full name';

  @override
  String get checkoutFullNameRequired => 'Please enter your name';

  @override
  String get checkoutEmailOptionalLabel => 'Email (optional)';

  @override
  String get checkoutEmailHint => 'Enter your email';

  @override
  String get checkoutPhoneLabel => 'Phone number';

  @override
  String get checkoutPhoneHint => 'Enter your phone number';

  @override
  String get checkoutPhoneRequired => 'Please enter your phone number';

  @override
  String get checkoutSpecialInstructionsTitle =>
      'Special instructions (optional)';

  @override
  String get checkoutSpecialInstructionsHint =>
      'Add any special instructions for your order…';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String get checkoutStorePickup => 'Store pickup';

  @override
  String get checkoutSubtotalLabel => 'Subtotal';

  @override
  String get checkoutTaxVatLabel => 'Tax (18%)';

  @override
  String get checkoutShippingLabel => 'Shipping';

  @override
  String checkoutQtyLine(int quantity) {
    return 'Qty: $quantity';
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
  String get shopEmptyNoServices => 'No services found';

  @override
  String get shopErrorLoadServices => 'Failed to load services';

  @override
  String get shopFilterServicesSheetTitle => 'Filter services';

  @override
  String get shopServiceSearchHint => 'Enter service name…';

  @override
  String get shopPricePerHour => 'hour';

  @override
  String get shopPricePerSession => 'session';

  @override
  String get shopPricePerPerson => 'person';

  @override
  String get shopServiceUnavailable => 'Unavailable';

  @override
  String shopServiceDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get shopErrorLoadMenu => 'Failed to load menu';

  @override
  String get shopErrorLoadProduct => 'Failed to load product';

  @override
  String get shopMenuCategoryEmpty => 'No items in this category';

  @override
  String get shopErrorLoadService => 'Failed to load service';

  @override
  String get shopViewCart => 'View cart';

  @override
  String get shopAddToCart => 'Add to cart';

  @override
  String get shopBookService => 'Book service';

  @override
  String get shopProductDescription => 'Description';

  @override
  String get shopProductTags => 'Tags';

  @override
  String get shopProductVariantHeading => 'Select variant';

  @override
  String get shopMenuChefSpecial => 'Chef\'s special';

  @override
  String get shopMenuDietaryInformation => 'Dietary information';

  @override
  String get shopMenuAllergensTitle => 'Allergens';

  @override
  String get shopServiceUnavailableBanner => 'Service is currently unavailable';

  @override
  String listingShareOnZoea(String name) {
    return 'Check out $name on Zoea!';
  }

  @override
  String shopServiceDurationLine(int minutes) {
    return 'Duration: $minutes minutes';
  }

  @override
  String get shopBookingFullNameRequiredLabel => 'Full name *';

  @override
  String get shopBookingPhoneRequiredLabel => 'Phone number *';

  @override
  String get shopBookingEmailOptionalLabel => 'Email (optional)';

  @override
  String get shopBookingSelectDateRequired => 'Select date *';

  @override
  String get shopBookingSelectTimeRequired => 'Select time *';

  @override
  String get shopBookingSpecialRequestsLabel => 'Special requests (optional)';

  @override
  String get shopMenuScreenTitle => 'Menu';

  @override
  String get shopMenusEmptyTitle => 'No menu available';

  @override
  String get shopMenusEmptySubtitle =>
      'This restaurant hasn\'t added a menu yet';

  @override
  String get shopOrderPlacedSuccessTitle => 'Order placed successfully!';

  @override
  String get shopOrderPlacedSuccessSubtitle =>
      'Your order has been received and is being processed';

  @override
  String get shopOrderDetailsSection => 'Order details';

  @override
  String get shopOrderNumberLabel => 'Order number';

  @override
  String get shopOrderMerchantLabel => 'Merchant';

  @override
  String get shopOrderStatusLabel => 'Status';

  @override
  String get shopOrderTotalAmountLabel => 'Total amount';

  @override
  String get shopOrderDateLabel => 'Order date';

  @override
  String get shopOrderViewMyOrders => 'View my orders';

  @override
  String get shopOrderDetailsLoadFailed => 'Failed to load order details';

  @override
  String get referralInviteHeroTitle => 'Invite friends & earn rewards';

  @override
  String get referralInviteHeroSubtitle =>
      'Share your referral code and earn points when friends join Zoea';

  @override
  String get referralYourCodeSectionTitle => 'Your referral code';

  @override
  String get referralSignInForCodeBody =>
      'Sign in to see your personal code and track points.';

  @override
  String get referralErrorLoadCode =>
      'Could not load your referral code. Pull to retry or sign in again.';

  @override
  String get referralShareCodeHint => 'Share this code with your friends';

  @override
  String get referralCodeCopied => 'Referral code copied';

  @override
  String get referralShareInviteMessage =>
      'Join me on Zoea Africa and discover amazing places in Rwanda!';

  @override
  String get referralHowItWorksTitle => 'How it works';

  @override
  String get referralStepShareTitle => 'Share your code';

  @override
  String get referralStepShareBody =>
      'Send your referral code to friends via social media, email, or text';

  @override
  String get referralStepFriendTitle => 'Friend signs up';

  @override
  String get referralStepFriendBody =>
      'Your friend creates their Zoea account using your code';

  @override
  String get referralStepEarnTitle => 'Earn points';

  @override
  String get referralStepEarnBody =>
      'You both get points when they sign up (shown as pending until credited)';

  @override
  String get referralRewardsTitle => 'Rewards';

  @override
  String get referralRewardForYouTitle => 'For you';

  @override
  String get referralRewardForYouSubtitle => 'When friend joins';

  @override
  String get referralRewardForFriendTitle => 'For friend';

  @override
  String get referralRewardForFriendSubtitle => 'Welcome bonus';

  @override
  String get referralRewardsLoadError => 'Could not load reward amounts.';

  @override
  String get referralStatsTitle => 'Your referrals';

  @override
  String get referralStatTotalReferrals => 'Total referrals';

  @override
  String get referralStatPointsEarned => 'Points earned';

  @override
  String get referralStatPending => 'Pending';

  @override
  String referralPointsValue(String points) {
    return '$points pts';
  }

  @override
  String get onboardingGenderMale => 'Male';

  @override
  String get onboardingGenderFemale => 'Female';

  @override
  String get onboardingGenderOther => 'Other';

  @override
  String get onboardingGenderPreferNot => 'Prefer not to say';

  @override
  String get onboardingVisitLeisureTitle => 'Leisure';

  @override
  String get onboardingVisitLeisureSubtitle => 'Exploring and enjoying Rwanda';

  @override
  String get onboardingVisitBusinessTitle => 'Business';

  @override
  String get onboardingVisitBusinessSubtitle => 'Work and professional travel';

  @override
  String get onboardingVisitMiceTitle => 'MICE';

  @override
  String get onboardingVisitMiceSubtitle =>
      'Meetings, incentives, conferences, exhibitions';

  @override
  String get diningBookingLabelDate => 'Date';

  @override
  String get diningBookingLabelTime => 'Time';

  @override
  String get diningBookingLabelGuests => 'Guests';

  @override
  String get diningBookingLabelRestaurant => 'Restaurant';

  @override
  String get diningBookingLabelLocation => 'Location';

  @override
  String get diningBookingLabelName => 'Name';

  @override
  String get diningBookingLabelPhone => 'Phone';

  @override
  String get diningBookingLabelEmail => 'Email';

  @override
  String diningBookingDetailLine(String label) {
    return '$label: ';
  }

  @override
  String get exploreFilterBudgetHintNoLimit => 'No limit';

  @override
  String get stayBookingSpecialRequestsHint =>
      'Any special requests or preferences…';

  @override
  String get stayCouponCodeHint => 'Enter coupon code';

  @override
  String get stayBookingScreenTitle => 'Book your stay';

  @override
  String get stayBookingSelectDatesHeading => 'Select dates';

  @override
  String get stayBookingRoomsHeading => 'Rooms';

  @override
  String stayBookingRoomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms',
      one: '1 room',
    );
    return '$_temp0';
  }

  @override
  String stayBookingNightlyLine(String price, int roomCount) {
    String _temp0 = intl.Intl.pluralLogic(
      roomCount,
      locale: localeName,
      other: '$roomCount rooms',
      one: '1 room',
    );
    return '$price × $_temp0';
  }

  @override
  String get stayBookingContinueToPayment => 'Continue to payment';

  @override
  String get stayBookingSelectedRoomsTitle => 'Selected rooms';

  @override
  String stayBookingQtyShort(int quantity) {
    return 'Qty: $quantity';
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
      other: '$reviewCount reviews',
      one: '1 review',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyBody => 'You don\'t have any notifications yet';

  @override
  String get notificationsLoadFailed => 'Failed to load notifications';

  @override
  String get notificationsAllMarkedRead => 'All notifications marked as read';

  @override
  String get notificationsDefaultTitle => 'Notification';

  @override
  String get notificationsActionViewBooking => 'View booking';

  @override
  String get notificationsActionViewEvent => 'View event';

  @override
  String get notificationsActionViewListing => 'View listing';

  @override
  String notificationsMarkReadFailed(String error) {
    return 'Failed to mark notification as read: $error';
  }

  @override
  String notificationsMarkAllReadFailed(String error) {
    return 'Failed to mark all as read: $error';
  }

  @override
  String get notificationsTimeJustNow => 'Just now';

  @override
  String notificationsTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String notificationsTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String notificationsTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get notificationsTimeRecently => 'Recently';

  @override
  String notificationsOpeningUrl(String url) {
    return 'Opening: $url';
  }

  @override
  String get diningBookingConfirmationTitle => 'Booking confirmation';

  @override
  String get diningBookingReservationConfirmedTitle => 'Reservation confirmed!';

  @override
  String get diningBookingReservationConfirmedSubtitle =>
      'Your table has been reserved successfully';

  @override
  String diningBookingNumberLine(String number) {
    return 'Booking #$number';
  }

  @override
  String get diningBookingReservationDetailsSection => 'Reservation details';

  @override
  String get diningBookingNotSpecified => 'Not specified';

  @override
  String get diningBookingRestaurantInfoSection => 'Restaurant information';

  @override
  String get diningBookingGuestInfoSection => 'Guest information';

  @override
  String get diningBookingSpecialRequestsSection => 'Special requests';

  @override
  String get diningBookingImportantInfoTitle => 'Important information';

  @override
  String get diningBookingImportantInfoBody =>
      '• Please arrive 5–10 minutes before your reservation time\n• To cancel or change your reservation, contact the restaurant directly\n• Late arrivals may result in losing the table\n• A dress code may apply—check with the restaurant';

  @override
  String get diningBookingBrowseMore => 'Browse more';

  @override
  String get diningBookingViewMyBookings => 'View my bookings';

  @override
  String get listingScreenDefaultTitle => 'Listings';

  @override
  String get tourDetailLoadError => 'Failed to load tour details';

  @override
  String get listingDetailLoadFailed => 'Failed to load listing';

  @override
  String get bookingConfirmationHeaderTitle => 'Booking confirmed!';

  @override
  String get bookingConfirmationHeaderSubtitle =>
      'Your booking has been confirmed successfully';

  @override
  String get bookingConfirmationSectionBookingInfo => 'Booking information';

  @override
  String get bookingConfirmationLabelBookingNumber => 'Booking number';

  @override
  String get bookingConfirmationLabelType => 'Type';

  @override
  String get bookingConfirmationSectionDetails => 'Booking details';

  @override
  String get bookingConfirmationLabelPartySize => 'Party size';

  @override
  String get bookingConfirmationLabelSpecialRequests => 'Special requests';

  @override
  String get bookingConfirmationTourDetailsPlaceholder =>
      'Tour confirmation details will appear here once available.';

  @override
  String get bookingConfirmationSectionPriceSummary => 'Price summary';

  @override
  String get bookingConfirmationLabelTaxesFees => 'Taxes & fees';

  @override
  String get bookingConfirmationLabelDiscount => 'Discount';

  @override
  String get bookingConfirmationLoadFailed => 'Failed to load booking';

  @override
  String get webviewPageLoadFailed => 'Failed to load page';

  @override
  String webviewInvalidUrlLine(String url) {
    return 'Invalid URL: $url';
  }

  @override
  String get webviewLoadTimeoutBody =>
      'This page is taking too long to load. Please check your internet connection.';

  @override
  String get webviewTooltipReload => 'Reload';

  @override
  String get webviewTooltipForward => 'Go forward';

  @override
  String get listingDetailReviewSignInTitle => 'Sign in to write a review';

  @override
  String get listingDetailReviewSignInMessage =>
      'Create an account or sign in to share your experience and help other travelers.';

  @override
  String get itineraryDetailLoadFailed => 'Failed to load itinerary';

  @override
  String myBookingsCancelConfirmBody(String name) {
    return 'Are you sure you want to cancel your booking for \"$name\"? This action cannot be undone.';
  }

  @override
  String myBookingsBookAgainPrompt(String name) {
    return 'Would you like to book \"$name\" again?';
  }

  @override
  String get diningFilterSheetTitle => 'Filter dining';

  @override
  String get diningSortSheetTitle => 'Sort dining';

  @override
  String get listingFeaturedOnlyTitle => 'Featured only';

  @override
  String get listingFeaturedOnlySubtitle => 'Show only featured listings';

  @override
  String get listingSortOldestFirst => 'Oldest first';

  @override
  String get diningFlowBookTableTitle => 'Book table';

  @override
  String get diningFlowReservationDetailsSection => 'Reservation details';

  @override
  String get diningFlowSelectDatePlaceholder => 'Select date';

  @override
  String get diningFlowAvailableTimes => 'Available times';

  @override
  String get diningFlowNumberOfGuests => 'Number of guests';

  @override
  String get diningFlowGuestInformation => 'Guest information';

  @override
  String get diningFlowFullNameHint => 'John Doe';

  @override
  String get diningFlowPhoneHint => '+250 796 889 900';

  @override
  String get diningFlowSpecialRequestsTitle => 'Special requests';

  @override
  String get diningFlowSpecialRequestsHint =>
      'Any special dietary requirements, seating preferences, etc.';

  @override
  String get diningFlowCouponCodeTitle => 'Coupon code';

  @override
  String get diningFlowCouponAppliedTitle => 'Coupon applied!';

  @override
  String diningFlowCouponSavedBody(String amount) {
    return 'You saved $amount';
  }

  @override
  String get diningBookingTimeNotSelected => 'Not selected';

  @override
  String get diningFlowConfirmSheetTitle => 'Confirm booking';

  @override
  String get diningFlowConfirmBookingCta => 'Confirm booking';

  @override
  String get stayFavoriteSignInMessage =>
      'Create an account or sign in to save your favorite accommodations and access them anytime.';

  @override
  String get tourFavoriteSignInMessage =>
      'Create an account or sign in to save your favorite tours and access them anytime.';

  @override
  String get diningReserveSignInTitle => 'Sign in to reserve';

  @override
  String get diningReserveSignInMessage =>
      'Create an account or sign in to reserve a table and manage your dining reservations.';

  @override
  String get stayBookSignInTitle => 'Sign in to book';

  @override
  String get stayBookSignInMessage =>
      'Create an account or sign in to complete your booking and manage your reservations.';

  @override
  String get tourBookSignInTitle => 'Sign in to book';

  @override
  String get tourBookSignInMessage =>
      'Create an account or sign in to complete your tour booking and manage your reservations.';

  @override
  String commonFavoriteUpdateFailed(String detail) {
    return 'Failed to update favorite: $detail';
  }

  @override
  String listingShareOnZoeaInLocation(String name, String location) {
    return 'Check out $name in $location on Zoea!';
  }

  @override
  String listingDetailCouldNotOpenWebsite(String website) {
    return 'Could not open website: $website';
  }

  @override
  String listingDetailCouldNotCallPhone(String phone) {
    return 'Could not make phone call to $phone';
  }

  @override
  String get searchScreenGlobalHint => 'Search events, places, experiences…';

  @override
  String get searchClearHistoryTitle => 'Clear search history';

  @override
  String get searchClearHistoryBody =>
      'Are you sure you want to clear all your search history?';

  @override
  String get listingReviewComposerHint =>
      'Share your thoughts about this place…';

  @override
  String get exploreFilterBudgetHintMin => '0';

  @override
  String get tourBookingPickupHint =>
      'Enter pickup location or leave blank for default';

  @override
  String get tourBookingSpecialRequirementsHint =>
      'Any special requirements, dietary preferences, etc.';

  @override
  String get itineraryCreateNameHint => 'e.g., My Rwanda Adventure';

  @override
  String get itineraryCreateDescriptionHint => 'Tell us about your trip…';

  @override
  String get itineraryCreateStartLocationHint => 'e.g., Kigali, Rwanda';

  @override
  String get itineraryStopTitleHint => 'e.g., Coffee Break';

  @override
  String get itineraryStopDurationHint => 'e.g., 60';

  @override
  String get itinerariesFabCreateTooltip => 'Create itinerary';

  @override
  String get itineraryCreateDeleteTooltip => 'Delete itinerary';

  @override
  String get itineraryDetailEditTooltip => 'Edit';

  @override
  String get itineraryDetailShareTooltip => 'Share';

  @override
  String get udcTravelPartySolo => 'Solo';

  @override
  String get udcTravelPartyCouple => 'Couple';

  @override
  String get udcTravelPartyFamily => 'Family';

  @override
  String get udcTravelPartyGroup => 'Group';

  @override
  String get udcFieldAgeRangeTitle => 'Age range';

  @override
  String get udcFieldAgeRangeSubtitle => 'Help us personalize content for you';

  @override
  String get udcFieldGenderTitle => 'Gender';

  @override
  String get udcFieldGenderSubtitle => 'Optional — helps with personalization';

  @override
  String get udcFieldLengthOfStayTitle => 'Length of stay';

  @override
  String get udcFieldLengthOfStaySubtitle =>
      'How long are you staying in Rwanda?';

  @override
  String get udcFieldInterestsTitle => 'Interests';

  @override
  String get udcFieldInterestsSubtitle => 'Select all that apply';

  @override
  String get udcFieldTravelPartyTitle => 'Travel party';

  @override
  String get udcFieldTravelPartySubtitle => 'Who are you traveling with?';

  @override
  String get onboardingAudienceResidentTitle => 'Resident';

  @override
  String get onboardingAudienceResidentSubtitle => 'I live in Rwanda';

  @override
  String get onboardingAudienceVisitorTitle => 'Visitor';

  @override
  String get onboardingAudienceVisitorSubtitle => 'I\'m visiting Rwanda';

  @override
  String get commonProfileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get commonSaveFailedTryAgain => 'Failed to save. Please try again.';

  @override
  String get commonFailedSaveDataTryAgain =>
      'Failed to save data. Please try again.';

  @override
  String get progressivePromptThanks =>
      'Thanks for helping us personalize your experience!';

  @override
  String get profileEditPasswordRequiredForEmail =>
      'Password is required to update email address.';

  @override
  String get profileEditPleaseEnterPassword => 'Please enter your password';

  @override
  String get reviewsWrittenSearchHint => 'Search reviews…';

  @override
  String get aboutAppInfoSectionTitle => 'App information';

  @override
  String get aboutAppVersionLabel => 'App version';

  @override
  String get aboutBuildNumberLabel => 'Build number';

  @override
  String get aboutLastUpdatedLabel => 'Last updated';

  @override
  String get aboutPlatformLabel => 'Platform';

  @override
  String get aboutLanguageLabel => 'Language';

  @override
  String get aboutLegalSectionTitle => 'Legal';

  @override
  String get aboutPrivacyPolicyTitle => 'Privacy Policy';

  @override
  String get aboutPrivacyPolicySubtitle => 'How we protect your data';

  @override
  String get aboutTermsOfServiceTitle => 'Terms of Service';

  @override
  String get aboutTermsOfServiceSubtitle => 'Terms and conditions';

  @override
  String get aboutCopyrightTitle => 'Copyright';

  @override
  String aboutCopyrightCardSubtitle(int year) {
    return '© $year Zoea Africa. All rights reserved.';
  }

  @override
  String get aboutConnectSectionTitle => 'Connect with us';

  @override
  String get aboutContactEmailTitle => 'Email';

  @override
  String get aboutContactPhoneTitle => 'Phone';

  @override
  String get aboutContactWebsiteTitle => 'Website';

  @override
  String get aboutContactPhoneDisplay => '+250 796 889 900';

  @override
  String get aboutContactWebsiteDisplay => 'www.zoea.africa';

  @override
  String get aboutCloseButton => 'Close';

  @override
  String aboutVersionLine(String version) {
    return 'Version $version';
  }

  @override
  String get aboutVersionLoading => 'Version …';

  @override
  String get aboutBrandTagline => 'Discover Rwanda\'s beauty';

  @override
  String get aboutWebsiteWebviewTitle => 'Zoea Africa';

  @override
  String get stayDetailLoadFailed => 'Failed to load accommodation';

  @override
  String get stayDetailTabAmenities => 'Amenities';

  @override
  String get stayDetailAboutTitle => 'About this place';

  @override
  String get stayDetailCheckInOutSection => 'Check-in & check-out';

  @override
  String get stayDetailCheckOutLabel => 'Check-out';

  @override
  String get stayDetailBookingPoliciesSection => 'Booking policies';

  @override
  String get stayDetailAvailableRooms => 'Available rooms';

  @override
  String get stayDetailNoRoomTypes => 'No room types available';

  @override
  String get stayDetailAmenitiesSection => 'Amenities';

  @override
  String get stayDetailNoAmenitiesListed => 'No amenities listed';

  @override
  String get stayDetailNoReviewsYet => 'No reviews yet';

  @override
  String get stayDetailBeFirstToReview => 'Be the first to review this place!';

  @override
  String stayDetailReviewsLoadFailed(String error) {
    return 'Failed to load reviews: $error';
  }

  @override
  String get stayPolicyCancellationTitle => 'Cancellation';

  @override
  String get stayPolicyCancellationBody =>
      'Free cancellation until 24 hours before check-in.';

  @override
  String get stayPolicyRefundTitle => 'Refund policy';

  @override
  String get stayPolicyRefundBody =>
      'Full refund if cancelled 24+ hours before check-in.';

  @override
  String get stayPolicyPetTitle => 'Pet policy';

  @override
  String get stayPolicyPetBody =>
      'Pets allowed with an additional fee of RWF 15,000 per night.';

  @override
  String get stayPolicySmokingTitle => 'Smoking policy';

  @override
  String get stayPolicySmokingBody =>
      'Non-smoking property. Smoking allowed in designated areas only.';

  @override
  String get stayPolicyChildrenTitle => 'Children policy';

  @override
  String get stayPolicyChildrenBody =>
      'Children of all ages welcome. Extra beds available on request.';

  @override
  String get stayPolicyPaymentTitle => 'Payment policy';

  @override
  String get stayPolicyPaymentBody =>
      'Credit card required for booking. Payment due at check-in.';

  @override
  String get itineraryCreateScreenTitle => 'Create itinerary';

  @override
  String get itineraryEditScreenTitle => 'Edit itinerary';

  @override
  String get itineraryFieldTitleLabel => 'Title';

  @override
  String get itineraryFieldDescriptionOptionalLabel => 'Description (optional)';

  @override
  String get itineraryFieldLocationOptionalLabel => 'Location (optional)';

  @override
  String get itineraryFieldStartDateLabel => 'Start date';

  @override
  String get itineraryFieldEndDateLabel => 'End date';

  @override
  String get itineraryFieldNameLabel => 'Name';

  @override
  String get itineraryFieldTimeLabel => 'Time';

  @override
  String get itineraryFieldDurationOptionalLabel =>
      'Duration (minutes, optional)';

  @override
  String get itineraryValidationTitleRequired => 'Please enter a title';

  @override
  String get profileEnterPasswordDialogTitle => 'Enter password';

  @override
  String get profileEnterPasswordDialogBody =>
      'Please enter your current password to update your email address.';

  @override
  String get profileUpdateFailedGeneric =>
      'Failed to update profile. Please try again.';

  @override
  String stayDetailReviewsCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get stayDetailTabOverview => 'Overview';

  @override
  String get stayDetailTabRooms => 'Rooms';

  @override
  String get stayDetailTabReviews => 'Reviews';

  @override
  String get stayDetailTabPhotos => 'Photos';

  @override
  String get onboardingUserTypeHeadline => 'Are you a resident or visitor?';

  @override
  String get onboardingUserTypeSubtitle =>
      'This helps us show you relevant content';

  @override
  String get commonComplete => 'Complete';

  @override
  String get commonSave => 'Save';

  @override
  String get phoneValidationRequired => 'Please enter your phone number';

  @override
  String get phoneValidationInternationalInvalid =>
      'Please enter a valid phone number';

  @override
  String get phoneValidationRwandanInvalid =>
      'Please enter a valid Rwandan phone number (07xxxxxxxx or 08xxxxxxxx)';

  @override
  String get exploreFilterLabelMinPrice => 'Min price';

  @override
  String get exploreFilterLabelMaxPrice => 'Max price';

  @override
  String get profileEditInterestsTitle => 'Interests';

  @override
  String get profileEditInterestsSubtitle => 'Select all that apply';

  @override
  String get profileEditUnsavedChangesBody =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get profileEditDiscard => 'Discard';

  @override
  String get profileEditPersonalInfoSectionTitle => 'Personal information';

  @override
  String get profileEditHintFullName => 'Enter your full name';

  @override
  String get profileEditValidationFullNameRequired =>
      'Please enter your full name';

  @override
  String get profileEditHintEmail => 'Enter your email address';

  @override
  String get profileEditValidationEmailRequired =>
      'Please enter your email address';

  @override
  String get profileEditHintPhone => 'Enter your phone number';

  @override
  String get profileEditValidationPhoneRequired =>
      'Please enter your phone number';

  @override
  String get profileEditTabBasicInfo => 'Basic info';

  @override
  String get profileEditTabPreferences => 'Preferences';

  @override
  String get profileVisitedPlacesTitle => 'Places visited';

  @override
  String get profileVisitedTabAllPlaces => 'All places';

  @override
  String get profileVisitedTabThisYear => 'This year';

  @override
  String get profileVisitedTabListingsOnly => 'Listings only';

  @override
  String get profileVisitedStatusViewed => 'Viewed';

  @override
  String profileVisitedDateLine(String date) {
    return 'Viewed on $date';
  }

  @override
  String get profileVisitedEmptyTitle => 'No places visited yet';

  @override
  String get profileVisitedEmptySubtitle =>
      'Start exploring Rwanda to build your visited places collection.';

  @override
  String get profileVisitedExploreButton => 'Explore places';

  @override
  String get profileUnknownLocation => 'Unknown location';

  @override
  String get profileEventsAttendedTitle => 'Events attended';

  @override
  String get eventsAttendedTabAll => 'All events';

  @override
  String get eventsAttendedTabThisYear => 'This year';

  @override
  String get eventsAttendedTabFavorites => 'Favorites';

  @override
  String get eventsAttendedEmptyTitle => 'No events attended yet';

  @override
  String get eventsAttendedEmptySubtitle =>
      'Start exploring events to build your attendance history.';

  @override
  String get eventsAttendedExploreButton => 'Explore events';

  @override
  String get eventsAttendedBadge => 'Attended';

  @override
  String get exploreHomeCategoryEvents => 'Events';

  @override
  String get exploreHomeCategoryDining => 'Dining';

  @override
  String get exploreHomeCategoryExperiences => 'Experiences';

  @override
  String get exploreHomeCategoryNightlife => 'Nightlife';

  @override
  String get exploreHomeCategoryAccommodation => 'Accommodation';

  @override
  String get exploreHomeCategoryShopping => 'Shopping';

  @override
  String get placeDetailOpeningHoursTitle => 'Opening hours';

  @override
  String get placeDetailAboutTitle => 'About';

  @override
  String get placeDetailFeaturesTitle => 'Features';

  @override
  String get placeDetailNoPhotosExtended =>
      'No photos available for this place';

  @override
  String get placeDetailNoMenuForPlace => 'No menu available for this place';

  @override
  String get listingNoPhotosShort => 'No photos available';

  @override
  String get listingHoursClosed => 'Closed';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String itineraryDaysCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String itineraryItemsCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String reviewHelpfulCountLine(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people found this helpful',
      one: '1 person found this helpful',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String reviewTimeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String get listingReviewExperienceTitle => 'How was your experience?';

  @override
  String get listingReviewExperienceSubtitle => 'Tell us about your experience';

  @override
  String get listingAnonymousUser => 'Anonymous';

  @override
  String get stayDefaultRoomLabel => 'Room';

  @override
  String get stayDefaultAmenityLabel => 'Amenity';

  @override
  String get contentTypeEventLabel => 'Event';

  @override
  String get contentTypePlaceLabel => 'Place';

  @override
  String get contentTypeTourLabel => 'Tour';

  @override
  String get itineraryFallbackItemPlace => 'Place';

  @override
  String get itineraryFallbackItemEvent => 'Event';

  @override
  String get itineraryFallbackItemTour => 'Tour';

  @override
  String get itineraryFallbackItemCustom => 'Custom item';

  @override
  String get onboardingCountryHeadline => 'Where are you from?';

  @override
  String get onboardingCountrySubtitle => 'Help us personalize your experience';

  @override
  String get onboardingVisitRwandaHeadline => 'What brings you to Rwanda?';

  @override
  String get onboardingVisitRwandaSubtitle => 'Select your primary purpose';

  @override
  String get onboardingLanguageHeadline => 'What language do you prefer?';

  @override
  String get onboardingLanguageSubtitle =>
      'You can change this anytime in settings';

  @override
  String get onboardingConsentHeadline => 'Help us improve';

  @override
  String get onboardingConsentSubtitle =>
      'Allow analytics to help us personalize your experience';

  @override
  String get onboardingConsentCheckboxLabel =>
      'I agree to share analytics data to improve recommendations';

  @override
  String get onboardingSettingsFootnote =>
      'You can change this anytime in settings';

  @override
  String get progressivePromptTitleWithDuration =>
      'Help us personalize Zoea (10 sec)';

  @override
  String get progressivePromptTitleDefault => 'Help us personalize Zoea';

  @override
  String get progressiveQuestionAgeRange => 'What\'s your age range?';

  @override
  String get progressiveQuestionGender => 'What\'s your gender?';

  @override
  String get progressiveQuestionLengthOfStay => 'How long are you staying?';

  @override
  String get progressiveQuestionInterests => 'What are you interested in?';

  @override
  String get progressiveQuestionTravelParty => 'Who are you traveling with?';

  @override
  String get profileSaveChangesButton => 'Save changes';

  @override
  String get profileCompletionPrivacyNote =>
      'Your data is used only to personalize your experience. You can update or remove it anytime.';

  @override
  String get profileCompletionSectionTitle => 'Profile completion';

  @override
  String get profileCompletionSubtitleRecommendations =>
      'Complete your profile to get better recommendations';

  @override
  String get tourBookingScreenTitle => 'Book tour';

  @override
  String get tourBookingPerPersonSuffix => '/person';

  @override
  String get tourBookingSelectTourTitle => 'Select tour';

  @override
  String get tourBookingSelectDateTimeTitle => 'Select date & time';

  @override
  String get tourBookingNoSchedules => 'No available schedules';

  @override
  String tourBookingScheduleSubtitleWithTime(String time, int spots) {
    return 'Time: $time · Spots: $spots available';
  }

  @override
  String tourBookingScheduleSubtitleSpotsOnly(int spots) {
    return 'Spots: $spots available';
  }

  @override
  String get tourBookingNumberOfGuestsTitle => 'Number of guests';

  @override
  String get tourBookingGuestAdults => 'Adults';

  @override
  String get tourBookingGuestChildren => 'Children';

  @override
  String get tourBookingGuestInfants => 'Infants';

  @override
  String get tourBookingContactSectionTitle => 'Contact information';

  @override
  String get tourBookingPickupLocationOptionalTitle =>
      'Pickup location (optional)';

  @override
  String get tourBookingSpecialRequestsTitle => 'Special requests';

  @override
  String get tourBookingPriceBreakdownTitle => 'Price breakdown';

  @override
  String tourBookingPriceLineAdults(int count) {
    return 'Adults ($count×)';
  }

  @override
  String tourBookingPriceLineChildren(int count) {
    return 'Children ($count×)';
  }

  @override
  String tourBookingPriceLineInfants(int count) {
    return 'Infants ($count×)';
  }

  @override
  String get tourBookingPriceLineFree => 'Free';

  @override
  String get tourBookingPriceLineTotal => 'Total';

  @override
  String get tourBookingLocationDefaultLabel => 'Location';

  @override
  String get tourPackagesScreenTitle => 'Tour packages';

  @override
  String get reviewsViewPlaceAction => 'View place';

  @override
  String get placeDetailMapViewAction => 'View';

  @override
  String get itineraryFormButtonCreate => 'Create itinerary';

  @override
  String get itineraryFormButtonUpdate => 'Update itinerary';

  @override
  String get itineraryUpdatedSuccess => 'Itinerary updated successfully';

  @override
  String get itineraryCreatedSuccess => 'Itinerary created successfully';

  @override
  String get itineraryAddItemsHint =>
      'Add places, events, or tours to your itinerary';

  @override
  String get itinerarySharedBadge => 'Shared';

  @override
  String get shopCartUnknownItem => 'Unknown item';

  @override
  String get listingDetailHoursClosed => 'Closed';

  @override
  String get diningCategoryFallbackName => 'Dining';

  @override
  String get bookingFallbackRestaurantName => 'Restaurant';

  @override
  String aboutLegalCopyrightBody(int year) {
    return 'Copyright Notice\n\n© $year Zoea Africa. All rights reserved.\n\nThis app and its contents are protected by copyright and other intellectual property laws.\n\nYou may not:\n- Copy, modify, or distribute the app without permission\n- Reverse engineer or attempt to extract source code\n- Use the app for commercial purposes without authorization\n\nFor licensing inquiries, contact us at legal@zoea.africa.';
  }

  @override
  String get aboutLegalPrivacyBody =>
      'Privacy Policy\n\nLast updated: December 2024\n\n1. Information We Collect\nWe collect information you provide directly to us, such as when you create an account, make a booking, or contact us for support.\n\n2. How We Use Your Information\nWe use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.\n\n3. Information Sharing\nWe do not sell, trade, or otherwise transfer your personal information to third parties without your consent.\n\n4. Data Security\nWe implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.\n\n5. Your Rights\nYou have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.\n\n6. Contact Us\nIf you have any questions about this Privacy Policy, please contact us at privacy@zoea.africa.';

  @override
  String get aboutLegalTermsBody =>
      'Terms of Service\n\nLast updated: December 2024\n\n1. Acceptance of Terms\nBy using our app, you agree to be bound by these Terms of Service.\n\n2. Use of the App\nYou may use our app for lawful purposes only. You agree not to use the app in any way that could damage, disable, or impair the app.\n\n3. User Accounts\nYou are responsible for maintaining the confidentiality of your account and password.\n\n4. Bookings and Payments\nAll bookings are subject to availability. Payment terms are as specified at the time of booking.\n\n5. Cancellation Policy\nCancellation policies vary by event and are specified at the time of booking.\n\n6. Limitation of Liability\nTo the maximum extent permitted by law, we shall not be liable for any indirect, incidental, or consequential damages.\n\n7. Changes to Terms\nWe reserve the right to modify these terms at any time. We will notify users of any material changes.\n\n8. Contact Information\nFor questions about these Terms of Service, contact us at legal@zoea.africa.';
}
