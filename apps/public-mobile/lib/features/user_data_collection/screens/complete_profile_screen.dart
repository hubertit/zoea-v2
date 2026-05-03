import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/models/user.dart';
import '../../../core/providers/user_data_collection_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/age_range_selector.dart';
import '../widgets/gender_selector.dart';
import '../widgets/length_of_stay_selector.dart';
import '../widgets/interests_chips.dart';
import '../widgets/travel_party_selector.dart';
import '../../../l10n/app_localizations.dart';

/// Screen for users to voluntarily complete their profile
/// Shows all optional data fields with progress indicator
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  bool _isLoading = false;
  bool _isSaving = false;

  // State for each field
  AgeRange? _selectedAgeRange;
  Gender? _selectedGender;
  LengthOfStay? _selectedLengthOfStay;
  List<String> _selectedInterests = [];
  TravelParty? _selectedTravelParty;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final user = ref.read(currentUserProvider);
    if (user?.preferences != null) {
      final prefs = user!.preferences!;
      setState(() {
        _selectedAgeRange = prefs.ageRange;
        _selectedGender = prefs.gender;
        _selectedLengthOfStay = prefs.lengthOfStay;
        _selectedInterests = List<String>.from(prefs.interests);
        _selectedTravelParty = prefs.travelParty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final completionPercentage = user?.preferences?.profileCompletionPercentage ?? 0;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.commonCompleteProfile),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: context.primaryColorTheme))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  _buildProgressSection(completionPercentage, l10n),
                  const SizedBox(height: AppTheme.spacing32),

                  // Age Range
                  _buildSection(
                    title: l10n.udcFieldAgeRangeTitle,
                    subtitle: l10n.udcFieldAgeRangeSubtitle,
                    isComplete: _selectedAgeRange != null,
                    child: AgeRangeSelector(
                      selectedRange: _selectedAgeRange,
                      onRangeSelected: (range) {
                        setState(() {
                          _selectedAgeRange = range;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Gender
                  _buildSection(
                    title: l10n.udcFieldGenderTitle,
                    subtitle: l10n.udcFieldGenderSubtitle,
                    isComplete: _selectedGender != null,
                    child: GenderSelector(
                      selectedGender: _selectedGender,
                      onGenderSelected: (gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Length of Stay (only for visitors)
                  if (user?.preferences?.userType == UserType.visitor) ...[
                    _buildSection(
                      title: l10n.udcFieldLengthOfStayTitle,
                      subtitle: l10n.udcFieldLengthOfStaySubtitle,
                      isComplete: _selectedLengthOfStay != null,
                      child: LengthOfStaySelector(
                        selectedLength: _selectedLengthOfStay,
                        onLengthSelected: (length) {
                          setState(() {
                            _selectedLengthOfStay = length;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                  ],

                  // Interests
                  _buildSection(
                    title: l10n.udcFieldInterestsTitle,
                    subtitle: l10n.udcFieldInterestsSubtitle,
                    isComplete: _selectedInterests.isNotEmpty,
                    child: InterestsChips(
                      selectedInterests: _selectedInterests,
                      onInterestsChanged: (interests) {
                        setState(() {
                          _selectedInterests = interests;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Travel Party
                  _buildSection(
                    title: l10n.udcFieldTravelPartyTitle,
                    subtitle: l10n.udcFieldTravelPartySubtitle,
                    isComplete: _selectedTravelParty != null,
                    child: TravelPartySelector(
                      selectedParty: _selectedTravelParty,
                      onPartySelected: (party) {
                        setState(() {
                          _selectedTravelParty = party;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
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
                      child: _isSaving
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
                              l10n.profileSaveChangesButton,
                              style: context.labelLarge.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),

                  // Privacy note
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: context.primaryColorTheme.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: context.primaryColorTheme,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: Text(
                            l10n.profileCompletionPrivacyNote,
                            style: context.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProgressSection(int percentage, AppLocalizations l10n) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: context.primaryColorTheme.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
          border: Border.all(
            color: context.primaryColorTheme.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profileCompletionSectionTitle,
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryColorTheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: context.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(context.primaryColorTheme),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              l10n.profileCompletionSubtitleRecommendations,
              style: context.bodySmall.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required bool isComplete,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: context.headlineSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isComplete) ...[
                        const SizedBox(width: AppTheme.spacing8),
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppTheme.successColor,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    subtitle,
                    style: context.bodySmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        child,
      ],
    );
  }

  Future<void> _handleSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final service = ref.read(userDataCollectionServiceProvider);

      // Save all fields that have been changed
      if (_selectedAgeRange != null) {
        await service.saveProgressiveData(
          ageRange: _selectedAgeRange,
          flagKey: 'ageAsked',
        );
      }

      if (_selectedGender != null) {
        await service.saveProgressiveData(
          gender: _selectedGender,
          flagKey: 'genderAsked',
        );
      }

      // Only save lengthOfStay for visitors
      final currentUser = ref.read(currentUserProvider);
      final userType = currentUser?.preferences?.userType;
      if (userType == UserType.visitor && _selectedLengthOfStay != null) {
        await service.saveProgressiveData(
          lengthOfStay: _selectedLengthOfStay,
          flagKey: 'lengthOfStayAsked',
        );
      } else if (userType == UserType.resident && _selectedLengthOfStay != null) {
        // Clear lengthOfStay if user is a resident (shouldn't have this)
        await service.saveProgressiveData(
          lengthOfStay: null,
          flagKey: 'lengthOfStayAsked',
        );
      }

      if (_selectedInterests.isNotEmpty) {
        await service.saveProgressiveData(
          interests: _selectedInterests,
          flagKey: 'interestsAsked',
        );
      }

      if (_selectedTravelParty != null) {
        await service.saveProgressiveData(
          travelParty: _selectedTravelParty,
          flagKey: 'travelPartyAsked',
        );
      }

      // Refresh user data
      ref.invalidate(currentUserProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(
            message: AppLocalizations.of(context)!.commonProfileUpdatedSuccess,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(
            message: AppLocalizations.of(context)!.commonSaveFailedTryAgain,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

