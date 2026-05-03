# Public mobile (EN / FR) translation coverage

## What this pass did

- **ARB (`app_en.arb` / `app_fr.arb`)**: Large batch of keys for onboarding, progressive prompts, profile edit/visited/events, phone validation, explore home category fallbacks, filters (min/max price), itinerary UI (days/items counts, shared badge, save messages, item fallbacks), tour booking flow, search clear-history dialog, legal bodies (privacy, terms, copyright with `{year}`), weekdays helpers (for future use with demo hours), reviews/helpful and relative-time strings, listing/stay fallbacks, and more.
- **`flutter gen-l10n`**: Regenerated `app_localizations*.dart`.
- **Code**: Wired `AppLocalizations` through the screens and utilities above; added `lib/core/utils/weekday_localization.dart` for English weekday labels and “Closed” in hours strings; **home explore fallback** names now resolve from slug when the API does not supply a name (`home_explore_categories.dart` + `explore_screen.dart`).

## Legal / long-form copy

- About screen dialogs now use **`aboutLegalPrivacyBody`**, **`aboutLegalTermsBody`**, and **`aboutLegalCopyrightBody(year)`** from ARB (EN + FR).

## Known remaining English (non-exhaustive)

These are mostly **demo JSON**, **debug/sample content**, or **low-priority UI** not wired in this pass:

- **`place_detail_screen.dart`**: Overview section titles, opening-hour **row labels/times** (English weekday + “Closed” mapping), empty menu/photos copy, and review snackbar action are localized; **embedded mock lists** (feature chips, menu categories, long descriptions) may still be English.
- **Large mock maps** in `accommodation_detail_screen.dart`, `listing_detail_screen.dart`, and similar (fake hotel copy, amenity strings). Display can be localized later by mapping keys or moving mock data to locale-aware assets.
- **Some filter/rating chips** (e.g. “4.5+ Stars”) and **operator/listing demo names** in explore experiences and related screens.
- **`help_center_screen.dart`** (and any other) **long help articles** if they remain hardcoded in English.
- **Date/time formatting** still uses `DateFormat` patterns; consider `intl` with the active locale for full locale-aware dates.

Re-run a quick audit anytime:

```bash
rg "'[A-Z]" apps/public-mobile/lib/features --glob '*.dart' | head -50
```

Then add keys and replace with `AppLocalizations.of(context)!`.
