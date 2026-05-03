#!/usr/bin/env python3
"""Generate lib/l10n/app_sw.arb from app_en.arb (EN → Kiswahili).

Uses a small process pool so one stuck HTTP call does not block the whole run.
Run: python3 tool/build_app_sw_arb.py
"""

from __future__ import annotations

import json
import re
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Install: pip install deep-translator", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "lib/l10n/app_en.arb"
OUT_PATH = ROOT / "lib/l10n/app_sw.arb"

# ICU plural messages: keep hand-authored Kiswahili (machine translation breaks ICU).
ICU_OVERRIDES: dict[str, str] = {
    "exploreTourDurationDays": "{count, plural, =1{Siku 1} other{Siku {count}}}",
    "exploreTourDurationHours": "{count, plural, =1{Saa 1} other{Saa {count}}}",
    "assistantRelativeDaysAgo": "{count, plural, =1{Siku 1 iliyopita} other{Siku {count} zilizopita}}",
    "stayGuestCount": "{count, plural, =1{Mgeni 1} other{Wageni {count}}}",
    "stayRoomTypesCount": "{count, plural, =1{Aina 1 ya chumba} other{Aina {count} za vyumba}}",
    "bookingsLineItemCount": "{count, plural, =1{Kipengee 1} other{Vipengee {count}}}",
    "shopProductCount": "{count, plural, =1{Bidhaa 1} other{Bidhaa {count}}}",
    "listingReviewsCountParen": "({count, plural, =1{Ukaguzi 1} other{Ukaguzi {count}}})",
    "shopServiceCount": "{count, plural, =1{Huduma 1} other{Huduma {count}}}",
    "stayBookingRoomCount": "{count, plural, =1{Chumba 1} other{Vyumba {count}}}",
    "stayBookingNightlyLine": "{price} × {roomCount, plural, =1{chumba 1} other{vyumba {roomCount}}}",
    "stayBookingDemoRatingReviews": "{rating} ({reviewCount, plural, =1{ukaguzi 1} other{ukaguzi {reviewCount}}})",
    "notificationsTimeMinutesAgo": "{count, plural, =1{Dakika 1 iliyopita} other{Dakika {count} zilizopita}}",
    "notificationsTimeHoursAgo": "{count, plural, =1{Saa 1 iliyopita} other{Saa {count} zilizopita}}",
    "notificationsTimeDaysAgo": "{count, plural, =1{Siku 1 iliyopita} other{Siku {count} zilizopita}}",
    "stayDetailReviewsCountLine": "{count, plural, =1{Ukaguzi 1} other{Ukaguzi {count}}}",
    "itineraryDaysCountLine": "{count, plural, =1{Siku 1} other{Siku {count}}}",
    "itineraryItemsCountLine": "{count, plural, =1{Kipengee 1} other{Vipengee {count}}}",
    "reviewHelpfulCountLine": "{count, plural, =1{Mtu 1 aliona hii kuwa na msaada} other{Watu {count} waliona hii kuwa na msaada}}",
    "reviewTimeWeeksAgo": "{count, plural, =1{Wiki 1 iliyopita} other{Wiki {count} zilizopita}}",
    "reviewTimeMonthsAgo": "{count, plural, =1{Mwezi 1 uliopita} other{Miezi {count} iliyopita}}",
    "reviewTimeYearsAgo": "{count, plural, =1{Mwaka 1 uliopita} other{Miaka {count} iliyopita}}",
    "tourOperatorReviewsCount": "({count, plural, =1{Ukaguzi 1} other{Ukaguzi {count}}})",
    "tourDurationDays": "{count, plural, =1{Siku 1} other{Siku {count}}}",
    "tourDurationHours": "{count, plural, =1{Saa 1} other{Saa {count}}}",
}

PLACEHOLDER_TOKEN_RE = re.compile(r"(\{[^{}]+\})")


def protect_placeholders(s: str) -> tuple[str, list[str]]:
    holders: list[str] = []

    def repl(m: re.Match[str]) -> str:
        holders.append(m.group(1))
        return f"⟦{len(holders) - 1}⟧"

    return PLACEHOLDER_TOKEN_RE.sub(repl, s), holders


def restore_placeholders(s: str, holders: list[str]) -> str:
    out = s
    for i, h in enumerate(holders):
        out = out.replace(f"⟦{i}⟧", h)
    return out


def _translate_masked(translator: GoogleTranslator, masked: str) -> str:
    if not masked.strip():
        return masked
    try:
        return translator.translate(masked)
    except Exception:
        time.sleep(0.4)
        try:
            return translator.translate(masked)
        except Exception:
            return masked


def _worker_translate_chunk(pairs: list[tuple[str, str]]) -> list[tuple[str, str]]:
    """pairs: (key, english text). Returns (key, sw text)."""
    translator = GoogleTranslator(source="en", target="sw")
    out: list[tuple[str, str]] = []
    for key, english in pairs:
        if key in ICU_OVERRIDES:
            out.append((key, ICU_OVERRIDES[key]))
            continue
        masked, holders = protect_placeholders(english)
        translated = _translate_masked(translator, masked)
        out.append((key, restore_placeholders(translated, holders)))
        time.sleep(0.06)
    return out


def main() -> None:
    data = json.loads(EN_PATH.read_text(encoding="utf-8"))
    out: dict[str, object] = {}
    to_translate: list[tuple[str, str]] = []

    for key, value in data.items():
        if key == "@@locale":
            out[key] = "sw"
            continue
        if key.startswith("@"):
            out[key] = value
            continue
        if not isinstance(value, str):
            out[key] = value
            continue
        if key in ICU_OVERRIDES:
            out[key] = ICU_OVERRIDES[key]
            continue
        to_translate.append((key, value))

    workers = min(4, max(1, len(to_translate) // 120))
    chunk_size = (len(to_translate) + workers - 1) // workers
    chunks = [
        to_translate[i : i + chunk_size] for i in range(0, len(to_translate), chunk_size)
    ]

    print(f"Translating {len(to_translate)} strings with {workers} workers …", flush=True)
    with ProcessPoolExecutor(max_workers=workers) as ex:
        futures = [ex.submit(_worker_translate_chunk, ch) for ch in chunks]
        done_chunks = 0
        for fut in as_completed(futures):
            for key, sw_text in fut.result():
                out[key] = sw_text
            done_chunks += 1
            print(f"  chunks done {done_chunks}/{len(chunks)}", flush=True)

    out["languageOptionEnglish"] = "Kiingereza"
    out["languageOptionFrench"] = "Kifaransa"
    out["languageOptionSwahili"] = "Kiswahili"
    out["languageNativeNameEnglish"] = "English"
    out["languageNativeNameFrench"] = "Français"
    out["languageNativeNameSwahili"] = "Kiswahili"

    OUT_PATH.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_PATH}", flush=True)


if __name__ == "__main__":
    main()
