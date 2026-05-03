import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';

/// Widget for selecting language
/// Auto-detects language and allows user to change
class LanguageSelector extends StatelessWidget {
  final String? selectedLanguage;
  final String? autoDetectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    this.autoDetectedLanguage,
    required this.onLanguageSelected,
  });

  static const List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'sw', 'name': 'Swahili', 'native': 'Kiswahili'},
  ];

  /// Map device / legacy codes to a supported app language (en / fr / sw).
  static String normalizeToSupportedCode(String? code) {
    if (code == null) return 'en';
    switch (code.toLowerCase()) {
      case 'fr':
        return 'fr';
      case 'sw':
        return 'sw';
      case 'en':
      default:
        return 'en';
    }
  }

  String _getLanguageName(String code) {
    final language = _languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': code, 'name': code, 'native': code},
    );
    return language['name'] ?? code;
  }

  String _getLanguageNative(String code) {
    final language = _languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': code, 'name': code, 'native': code},
    );
    return language['native'] ?? code;
  }

  @override
  Widget build(BuildContext context) {
    final normalizedAuto = autoDetectedLanguage != null
        ? normalizeToSupportedCode(autoDetectedLanguage)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (normalizedAuto != null && selectedLanguage == null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
            child: _buildAutoDetectedCard(context, normalizedAuto),
          ),
        Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: _languages.map((lang) {
            final code = lang['code']!;
            final isSelected = selectedLanguage == code;
            final isAutoDetected = normalizedAuto == code;

            return FilterChip(
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getLanguageName(code),
                    style: context.bodyMedium.copyWith(
                      color: isSelected
                          ? context.primaryColorTheme
                          : context.primaryTextColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (_getLanguageNative(code) != _getLanguageName(code))
                    Text(
                      _getLanguageNative(code),
                      style: context.bodySmall.copyWith(
                        color: isSelected
                            ? context.primaryColorTheme.withOpacity(0.8)
                            : context.secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => onLanguageSelected(code),
              selectedColor: context.primaryColorTheme.withOpacity(0.2),
              checkmarkColor: context.primaryColorTheme,
              backgroundColor: isAutoDetected && !isSelected
                  ? context.primaryColorTheme.withOpacity(0.1)
                  : context.backgroundColor,
              side: BorderSide(
                color: isSelected
                    ? context.primaryColorTheme
                    : isAutoDetected
                        ? context.primaryColorTheme.withOpacity(0.3)
                        : context.dividerColor,
                width: isSelected ? 2 : 1,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAutoDetectedCard(BuildContext context, String normalizedCode) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: context.primaryColorTheme.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(
          color: context.primaryColorTheme.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.translate,
            color: context.primaryColorTheme,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Text(
              'We suggest ${_getLanguageName(normalizedCode)}',
              style: context.bodySmall.copyWith(
                color: context.primaryColorTheme,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

