import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/text_theme_extensions.dart';
import '../../../core/models/event_filter.dart';
import '../../../l10n/app_localizations.dart';

class EventFilterSheet extends StatefulWidget {
  final EventFilter currentFilter;
  final Function(EventFilter) onFilterChanged;
  final VoidCallback onClearFilters;

  const EventFilterSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onClearFilters,
  });

  @override
  State<EventFilterSheet> createState() => _EventFilterSheetState();
}

class _EventFilterSheetState extends State<EventFilterSheet> {
  late EventFilter _filter;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _searchController.text = _filter.searchQuery ?? '';
    _locationController.text = _filter.location ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.eventsFilterTitle,
                  style: context.titleLarge.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    if (_filter.hasActiveFilters)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filter = const EventFilter();
                            _searchController.clear();
                            _locationController.clear();
                          });
                          widget.onClearFilters();
                        },
                        child: Text(l10n.commonClearAll),
                      ),
                    TextButton(
                      onPressed: () {
                        widget.onFilterChanged(_filter);
                        Navigator.pop(context);
                      },
                      child: Text(l10n.commonApply),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(l10n),
                  const SizedBox(height: 24),
                  _buildCategorySection(l10n),
                  const SizedBox(height: 24),
                  _buildDateSection(l10n),
                  const SizedBox(height: 24),
                  _buildPriceSection(l10n),
                  const SizedBox(height: 24),
                  _buildLocationSection(l10n),
                  const SizedBox(height: 24),
                  _buildOptionsSection(l10n),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterSearchSection,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.eventsFilterSearchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(searchQuery: value.isEmpty ? null : value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterCategory,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: EventCategory.categories.map((category) {
            final isSelected = _filter.category == category.id;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(category.icon),
                  const SizedBox(width: 8),
                  Text(_categoryLabel(l10n, category)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filter = _filter.copyWith(
                    category: selected ? category.id : null,
                  );
                });
              },
              backgroundColor: category.color.withOpacity(0.1),
              selectedColor: category.color.withOpacity(0.2),
              checkmarkColor: category.color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterDateRange,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: l10n.eventsFilterStartDate,
                date: _filter.startDate,
                onDateSelected: (date) {
                  setState(() {
                    _filter = _filter.copyWith(startDate: date);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                label: l10n.eventsFilterEndDate,
                date: _filter.endDate,
                onDateSelected: (date) {
                  setState(() {
                    _filter = _filter.copyWith(endDate: date);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null
                    ? DateFormat(
                        'MMM dd, yyyy',
                        Localizations.localeOf(context).toString(),
                      ).format(date)
                    : label,
                style: TextStyle(
                  color: date != null ? context.primaryTextColor : context.secondaryTextColor,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () => onDateSelected(null),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterPriceRange,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PriceRange.ranges.map((range) {
            final isSelected = _filter.minPrice == range.min && _filter.maxPrice == range.max;
            return FilterChip(
              label: Text(_priceRangeLabel(l10n, range)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filter = _filter.copyWith(
                    minPrice: selected ? range.min : null,
                    maxPrice: selected ? range.max : null,
                  );
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterLocation,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: l10n.eventsFilterLocationHint,
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(location: value.isEmpty ? null : value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildOptionsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsFilterOptions,
          style: context.titleMedium.copyWith(
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOptionChip(
                label: l10n.eventsFilterFreeEvents,
                icon: Icons.money_off,
                isSelected: _filter.isFree == true,
                onChanged: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(isFree: selected ? true : null);
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionChip(
                label: l10n.eventsFilterVerifiedOnly,
                icon: Icons.verified,
                isSelected: _filter.isVerified == true,
                onChanged: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(isVerified: selected ? true : null);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColorTheme.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? context.primaryColorTheme : context.dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? context.primaryColorTheme : context.secondaryTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? context.primaryColorTheme : context.primaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, EventCategory c) {
    switch (c.id) {
      case 'music':
        return l10n.eventsCategoryMusic;
      case 'sports':
        return l10n.eventsCategorySports;
      case 'food':
        return l10n.eventsCategoryFood;
      case 'arts':
        return l10n.eventsCategoryArts;
      case 'conferences':
        return l10n.eventsCategoryConferences;
      case 'performance':
        return l10n.eventsCategoryPerformance;
      default:
        return c.name;
    }
  }

  String _priceRangeLabel(AppLocalizations l10n, PriceRange r) {
    if (r.min == 0 && r.max == 0) return l10n.eventsPriceFree;
    if (r.min == 0 && r.max == 5000) return l10n.eventsPriceUnder5k;
    if (r.min == 5000 && r.max == 15000) return l10n.eventsPrice5kTo15k;
    if (r.min == 15000 && r.max == 50000) return l10n.eventsPrice15kTo50k;
    if (r.min == 50000 && r.max == 100000) return l10n.eventsPrice50kTo100k;
    if (r.min == 100000 && r.max == 999999) return l10n.eventsPrice100kPlus;
    return r.label;
  }
}
