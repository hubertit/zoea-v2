import '../../l10n/app_localizations.dart';

class PhoneValidator {
  /// Cleans a phone number by removing spaces, +, and special characters
  /// Keeps only digits
  static String cleanPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters (spaces, +, -, (, ), etc.)
    return phoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  static String? validateInternationalPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.phoneValidationRequired;
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Check if it's a valid length (7-15 digits)
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return l10n.phoneValidationInternationalInvalid;
    }

    return null;
  }

  static String? validateRwandanPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.phoneValidationRequired;
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Check if it starts with 07 or 08 (Rwandan mobile numbers)
    if (digitsOnly.length == 9 && (digitsOnly.startsWith('07') || digitsOnly.startsWith('08'))) {
      return null;
    }

    return l10n.phoneValidationRwandanInvalid;
  }
}
