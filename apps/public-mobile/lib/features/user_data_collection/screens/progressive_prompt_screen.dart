import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/models/user.dart';
import '../../../core/providers/user_data_collection_provider.dart';
import '../widgets/age_range_selector.dart';
import '../widgets/gender_selector.dart';
import '../widgets/length_of_stay_selector.dart';
import '../widgets/interests_chips.dart';
import '../widgets/travel_party_selector.dart';
import '../../../l10n/app_localizations.dart';

/// Progressive prompt screen shown as bottom sheet
/// One question at a time, always skippable
class ProgressivePromptScreen extends ConsumerStatefulWidget {
  final String promptType; // 'age', 'gender', 'lengthOfStay', 'interests', 'travelParty'

  const ProgressivePromptScreen({
    super.key,
    required this.promptType,
  });

  @override
  ConsumerState<ProgressivePromptScreen> createState() =>
      _ProgressivePromptScreenState();
}

class _ProgressivePromptScreenState
    extends ConsumerState<ProgressivePromptScreen> {
  bool _isLoading = false;

  // State for each prompt type
  AgeRange? _selectedAgeRange;
  Gender? _selectedGender;
  LengthOfStay? _selectedLengthOfStay;
  List<String> _selectedInterests = [];
  TravelParty? _selectedTravelParty;

  String _title(AppLocalizations l10n) {
    switch (widget.promptType) {
      case 'age':
      case 'gender':
      case 'lengthOfStay':
      case 'interests':
      case 'travelParty':
        return l10n.progressivePromptTitleWithDuration;
      default:
        return l10n.progressivePromptTitleDefault;
    }
  }

  String _question(AppLocalizations l10n) {
    switch (widget.promptType) {
      case 'age':
        return l10n.progressiveQuestionAgeRange;
      case 'gender':
        return l10n.progressiveQuestionGender;
      case 'lengthOfStay':
        return l10n.progressiveQuestionLengthOfStay;
      case 'interests':
        return l10n.progressiveQuestionInterests;
      case 'travelParty':
        return l10n.progressiveQuestionTravelParty;
      default:
        return '';
    }
  }

  bool get _canSave {
    switch (widget.promptType) {
      case 'age':
        return _selectedAgeRange != null;
      case 'gender':
        return _selectedGender != null;
      case 'lengthOfStay':
        return _selectedLengthOfStay != null;
      case 'interests':
        return _selectedInterests.isNotEmpty;
      case 'travelParty':
        return _selectedTravelParty != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadius16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppTheme.spacing24,
          right: AppTheme.spacing24,
          top: AppTheme.spacing16,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),

            // Title
            Text(
              _title(l10n),
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),

            // Question
            Text(
              _question(l10n),
              style: context.bodyMedium.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),

            // Selector widget
            _buildSelector(),
            const SizedBox(height: AppTheme.spacing24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : _handleSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: context.secondaryTextColor,
                    ),
                    child: Text(AppLocalizations.of(context)!.commonMaybeLater),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading || !_canSave ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            l10n.commonSave,
                            style: context.labelLarge.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector() {
    switch (widget.promptType) {
      case 'age':
        return AgeRangeSelector(
          selectedRange: _selectedAgeRange,
          onRangeSelected: (range) {
            setState(() {
              _selectedAgeRange = range;
            });
          },
        );
      case 'gender':
        return GenderSelector(
          selectedGender: _selectedGender,
          onGenderSelected: (gender) {
            setState(() {
              _selectedGender = gender;
            });
          },
        );
      case 'lengthOfStay':
        return LengthOfStaySelector(
          selectedLength: _selectedLengthOfStay,
          onLengthSelected: (length) {
            setState(() {
              _selectedLengthOfStay = length;
            });
          },
        );
      case 'interests':
        return InterestsChips(
          selectedInterests: _selectedInterests,
          onInterestsChanged: (interests) {
            setState(() {
              _selectedInterests = interests;
            });
          },
        );
      case 'travelParty':
        return TravelPartySelector(
          selectedParty: _selectedTravelParty,
          onPartySelected: (party) {
            setState(() {
              _selectedTravelParty = party;
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleSave() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(userDataCollectionServiceProvider);

      switch (widget.promptType) {
        case 'age':
          await service.saveProgressiveData(
            ageRange: _selectedAgeRange,
            flagKey: 'ageAsked',
          );
          break;
        case 'gender':
          await service.saveProgressiveData(
            gender: _selectedGender,
            flagKey: 'genderAsked',
          );
          break;
        case 'lengthOfStay':
          await service.saveProgressiveData(
            lengthOfStay: _selectedLengthOfStay,
            flagKey: 'lengthOfStayAsked',
          );
          break;
        case 'interests':
          await service.saveProgressiveData(
            interests: _selectedInterests,
            flagKey: 'interestsAsked',
          );
          break;
        case 'travelParty':
          await service.saveProgressiveData(
            travelParty: _selectedTravelParty,
            flagKey: 'travelPartyAsked',
          );
          break;
      }

      // Record that prompt was shown
      final timingService = ref.read(promptTimingServiceProvider);
      await timingService.recordPromptShown(widget.promptType);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(
            message: AppLocalizations.of(context)!.progressivePromptThanks,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: AppLocalizations.of(context)!.commonSaveFailedTryAgain,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSkip() async {
    // Record that prompt was shown (but user skipped)
    final timingService = ref.read(promptTimingServiceProvider);
    await timingService.recordPromptShown(widget.promptType);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Helper function to show progressive prompt
Future<void> showProgressivePrompt(
  BuildContext context,
  String promptType,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ProgressivePromptScreen(
      promptType: promptType,
    ),
  );
}

