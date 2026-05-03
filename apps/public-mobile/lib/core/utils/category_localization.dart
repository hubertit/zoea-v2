import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Resolves a category [Map] from the API for the current UI [locale].
///
/// [name] remains the canonical English label from the backend; [nameFr] is optional.
String localizedCategoryName(Map<String, dynamic>? category, Locale locale) {
  if (category == null || category.isEmpty) return '';
  final primary = (category['name'] as String?)?.trim() ?? '';
  final frRaw = category['nameFr'] ?? category['name_fr'];
  final fr = frRaw is String ? frRaw.trim() : '';
  final lang = locale.languageCode.toLowerCase();
  final useFr =
      (lang == 'fr' || lang.startsWith('fr')) && fr.isNotEmpty;
  if (useFr) return fr;
  return primary;
}

/// Curated explore-root titles (ARB); keys match category slugs from the API.
String exploreHomeCategoryTitleForSlug(AppLocalizations l10n, String slug) {
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
    case 'attractions':
      return l10n.exploreHomeCategoryAttractions;
    case 'sports':
      return l10n.exploreHomeCategorySports;
    case 'transport':
      return l10n.exploreHomeCategoryTransport;
    case 'services':
      return l10n.exploreHomeCategoryServices;
    case 'kids':
      return l10n.exploreHomeCategoryKids;
    case 'real-estate':
      return l10n.exploreHomeCategoryRealEstate;
    case 'hiking':
      return l10n.exploreHomeCategoryHiking;
    case 'national-parks':
      return l10n.exploreHomeCategoryNationalParks;
    case 'museums':
      return l10n.exploreHomeCategoryMuseums;
    default:
      return l10n.exploreCategoryFallback;
  }
}

/// Explore parent-category tiles: French uses API `nameFr` when set; otherwise
/// slug-based ARB titles so labels match the shell locale even if the API only sends English `name`.
String localizedExploreParentCategoryName(
  Map<String, dynamic>? category,
  Locale locale,
  AppLocalizations l10n,
) {
  if (category == null || category.isEmpty) {
    return l10n.exploreCategoryFallback;
  }
  final slug = (category['slug'] as String?)?.trim() ?? '';
  final primary = (category['name'] as String?)?.trim() ?? '';
  final frRaw = category['nameFr'] ?? category['name_fr'];
  final fr = frRaw is String ? frRaw.trim() : '';

  final lang = locale.languageCode.toLowerCase();
  final isFr = lang == 'fr' || lang.startsWith('fr');

  if (isFr) {
    if (fr.isNotEmpty) return fr;
    if (slug.isNotEmpty) {
      final titled = exploreHomeCategoryTitleForSlug(l10n, slug);
      if (titled != l10n.exploreCategoryFallback) return titled;
    }
    if (primary.isNotEmpty) return primary;
    return slug.isNotEmpty
        ? exploreHomeCategoryTitleForSlug(l10n, slug)
        : l10n.exploreCategoryFallback;
  }

  if (primary.isNotEmpty) return primary;
  if (slug.isNotEmpty) {
    final titled = exploreHomeCategoryTitleForSlug(l10n, slug);
    if (titled != l10n.exploreCategoryFallback) return titled;
  }
  return l10n.exploreCategoryFallback;
}
