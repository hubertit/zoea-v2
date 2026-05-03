import 'package:flutter/widgets.dart';

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
