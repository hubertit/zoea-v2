import '../../l10n/app_localizations.dart';

/// Maps English weekday labels from static/demo data to the active locale.
String localizeEnglishWeekday(AppLocalizations l10n, String day) {
  switch (day.trim()) {
    case 'Monday':
      return l10n.weekdayMonday;
    case 'Tuesday':
      return l10n.weekdayTuesday;
    case 'Wednesday':
      return l10n.weekdayWednesday;
    case 'Thursday':
      return l10n.weekdayThursday;
    case 'Friday':
      return l10n.weekdayFriday;
    case 'Saturday':
      return l10n.weekdaySaturday;
    case 'Sunday':
      return l10n.weekdaySunday;
    default:
      return day;
  }
}

/// Localizes the word "Closed" inside opening-hours time cells from demo/API text.
String localizeOpeningHoursTime(AppLocalizations l10n, String time) {
  const enClosed = 'Closed';
  if (time.trim() == enClosed) {
    return l10n.listingHoursClosed;
  }
  if (time.contains(enClosed)) {
    return time.replaceAll(enClosed, l10n.listingHoursClosed);
  }
  return time;
}

String homeExploreCategoryTitleForSlug(AppLocalizations l10n, String slug) {
  switch (slug) {
    case 'events':
      return l10n.exploreHomeCategoryEvents;
    case 'dining':
      return l10n.exploreHomeCategoryDining;
    case 'experiences':
      return l10n.exploreHomeCategoryExperiences;
    case 'nightlife':
      return l10n.exploreHomeCategoryNightlife;
    case 'accommodation':
      return l10n.exploreHomeCategoryAccommodation;
    case 'shopping':
      return l10n.exploreHomeCategoryShopping;
    default:
      return l10n.exploreCategoryFallback;
  }
}
