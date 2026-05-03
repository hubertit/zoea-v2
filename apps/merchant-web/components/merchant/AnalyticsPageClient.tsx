"use client";

import { useMemo } from "react";
import { BarChart3, Building2, CalendarCheck, List, TrendingUp } from "lucide-react";
import { BOOKING_VOLUME_WEEK, DASHBOARD_KPIS, REVENUE_TREND_WEEK } from "@/lib/data/mock-dashboard";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { listingTypeLabel } from "@/lib/merchant/labels";
import { formatMoney } from "@/lib/merchant/format";
import { MiniAreaChart } from "@/components/merchant/charts/MiniAreaChart";
import { MiniBarChart } from "@/components/merchant/charts/MiniBarChart";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";
import type { ListingType } from "@/lib/types/merchant";

const cardBase =
  "rounded border border-[var(--color-border)] bg-white shadow-[0_1px_2px_rgba(15,23,42,0.04)]";
const sectionHeader = "mb-3 flex items-center justify-between gap-2 border-b border-[var(--color-border)] pb-3";

function MetricCard({
  label,
  value,
  icon,
  hint,
}: {
  label: string;
  value: string;
  icon: React.ReactNode;
  hint?: string;
}) {
  return (
    <div className={`${cardBase} p-4`}>
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="text-xs font-semibold uppercase tracking-wide text-muted">{label}</p>
          <p className="mt-1 text-2xl font-bold tracking-tight text-[var(--foreground)] tabular-nums">{value}</p>
          {hint ? <p className="mt-1 text-xs text-muted">{hint}</p> : null}
        </div>
        <span className="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary">
          {icon}
        </span>
      </div>
    </div>
  );
}

export function AnalyticsPageClient() {
  const listings = useMerchantDemoStore((s) => s.listings);
  const bookings = useMerchantDemoStore((s) => s.bookings);
  const businesses = useMerchantDemoStore((s) => s.businesses);

  const listingCounts = useMemo(() => {
    const counts: Record<ListingType, number> = {
      room: 0,
      table: 0,
      tour: 0,
      event: 0,
      activity: 0,
      package: 0,
    };
    for (const l of listings) counts[l.type] += 1;
    return counts;
  }, [listings]);

  const totalBookings = bookings.length;
  const totalRevenue = DASHBOARD_KPIS.totalRevenue;
  const currency = DASHBOARD_KPIS.currency;

  return (
    <div className="flex flex-col gap-4">
      <MerchantPageHeader title="Analytics" />

      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <MetricCard label="Revenue (demo)" value={formatMoney(totalRevenue, currency)} icon={<TrendingUp className="size-5" />} hint="Mock series until API wiring" />
        <MetricCard label="Bookings" value={String(totalBookings)} icon={<CalendarCheck className="size-5" />} hint="From demo store" />
        <MetricCard label="Listings" value={String(listings.length)} icon={<List className="size-5" />} />
        <MetricCard label="Businesses" value={String(businesses.length)} icon={<Building2 className="size-5" />} />
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[2fr_1fr]">
        <div className={`${cardBase} flex flex-col p-4`}>
          <div className={sectionHeader}>
            <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
              <TrendingUp className="size-5 shrink-0 text-primary" />
              Revenue trend
            </h3>
          </div>
          <div className="flex flex-1 flex-col justify-center">
            <MiniAreaChart data={[...REVENUE_TREND_WEEK]} height={200} />
            <p className="mt-2 text-xs text-muted">Last 7 days — illustrative until analytics API is connected.</p>
          </div>
        </div>

        <div className={`${cardBase} flex flex-col p-4`}>
          <div className={sectionHeader}>
            <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
              <BarChart3 className="size-5 shrink-0 text-primary" />
              Booking volume
            </h3>
          </div>
          <MiniBarChart values={[...BOOKING_VOLUME_WEEK]} height={150} barColor="#181e29" />
          <div className="mt-2 flex justify-between text-[10px] font-medium uppercase tracking-wide text-muted">
            {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((d) => (
              <span key={d}>{d}</span>
            ))}
          </div>
        </div>
      </div>

      <div className={`${cardBase} p-4`}>
        <div className={sectionHeader}>
          <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
            <List className="size-5 shrink-0 text-primary" />
            Listings breakdown
          </h3>
        </div>
        <div className="grid grid-cols-1 gap-2 sm:grid-cols-2 lg:grid-cols-3">
          {(Object.keys(listingCounts) as ListingType[]).map((t) => (
            <div key={t} className="flex items-center justify-between rounded-xl border border-[var(--color-border)] bg-gray-50 px-4 py-3">
              <span className="text-sm font-semibold text-[var(--foreground)]">{listingTypeLabel(t)}</span>
              <span className="text-sm font-bold tabular-nums text-primary">{listingCounts[t]}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

