import 'package:flutter/material.dart';

/// Layout tokens for listing amenity chips (listing detail, etc.).
/// Keeps padding and spacing consistent with the 8px grid used in [AppTheme].
class AmenityChipTokens {
  AmenityChipTokens._();

  /// Compact chip padding (was 16×12).
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );

  static const double borderRadius = 8;

  static const double iconSize = 18;

  static const double iconLabelGap = 6;

  static const double wrapSpacing = 8;

  static const double wrapRunSpacing = 8;

  /// Section spacing below category title before chips.
  static const double categoryChipGap = 10;
}
