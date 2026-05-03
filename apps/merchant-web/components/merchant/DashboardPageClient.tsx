"use client";

import Link from "next/link";
import { useEffect, useMemo, useState, type ReactNode } from "react";
import {
  Activity,
  ArrowRight,
  BarChart3,
  Building2,
  Calendar,
  Clock,
  LayoutList,
  List,
  Plus,
  QrCode,
  TrendingUp,
  Wallet,
} from "lucide-react";
import { getPortalSession } from "@/lib/auth/portal-session";
import { bookingGuestCount } from "@/lib/merchant/booking-helpers";
import { bookingStatusLabel } from "@/lib/merchant/labels";
import { formatMoney } from "@/lib/merchant/format";
import { formatWalletNumber } from "@/lib/merchant/wallet-utils";
import { BOOKING_VOLUME_WEEK, DASHBOARD_KPIS, REVENUE_TREND_WEEK } from "@/lib/data/mock-dashboard";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { MiniAreaChart } from "@/components/merchant/charts/MiniAreaChart";
import { MiniBarChart } from "@/components/merchant/charts/MiniBarChart";
import type { LucideIcon } from "lucide-react";
import type { Booking } from "@/lib/types/merchant";

const cardBase =
  "rounded border border-[var(--color-border)] bg-white shadow-[0_1px_2px_rgba(15,23,42,0.04)]";
const sectionHeader = "mb-3 flex items-center justify-between gap-2 border-b border-[var(--color-border)] pb-3";

type MetricVariant = "primary" | "info" | "success" | "warning" | "secondary";

const accentBar: Record<MetricVariant, string> = {
  primary: "bg-[var(--foreground)]",
  info: "bg-sky-600",
  success: "bg-emerald-600",
  warning: "bg-amber-500",
  secondary: "bg-gray-500",
};

const iconWrap: Record<MetricVariant, string> = {
  primary: "bg-[var(--foreground)]/10 text-[var(--foreground)]",
  info: "bg-sky-600/10 text-sky-700",
  success: "bg-emerald-600/10 text-emerald-700",
  warning: "bg-amber-500/15 text-amber-800",
  secondary: "bg-gray-500/10 text-gray-600",
};

function MetricTile({
  href,
  variant,
  icon: Icon,
  label,
  value,
  hint,
}: {
  href: string;
  variant: MetricVariant;
  icon: LucideIcon;
  label: string;
  value: string | number;
  hint?: string;
}) {
  return (
    <Link
      href={href}
      className={`group relative block min-h-[5.5rem] overflow-hidden rounded border border-[var(--color-border)] bg-gray-50/90 shadow-[0_1px_2px_rgba(15,23,42,0.04)] transition-colors hover:border-gray-300 hover:bg-white`}
    >
      <span className={`block h-0.5 w-full ${accentBar[variant]}`} aria-hidden />
      <div className="px-3 pb-2.5 pt-2">
        <div className="mb-0.5 flex items-start justify-between gap-2">
          <span className="text-[0.625rem] font-semibold uppercase leading-tight tracking-wide text-muted">{label}</span>
          <span className={`flex size-8 shrink-0 items-center justify-center rounded ${iconWrap[variant]}`}>
            <Icon className="size-4" />
          </span>
        </div>
        <p className="text-[1.375rem] font-bold leading-tight tracking-tight text-[var(--foreground)] tabular-nums">{value}</p>
        {hint ? <p className="mt-0.5 text-[0.6875rem] leading-snug text-muted">{hint}</p> : null}
      </div>
    </Link>
  );
}

function ChartCard({ title, icon: Icon, children, className = "" }: { title: string; icon: LucideIcon; children: ReactNode; className?: string }) {
  return (
    <div className={`${cardBase} flex flex-col p-4 ${className}`}>
      <div className={sectionHeader}>
        <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
          <Icon className="size-5 shrink-0 text-primary" aria-hidden />
          {title}
        </h3>
      </div>
      <div className="flex min-h-0 flex-1 flex-col">{children}</div>
    </div>
  );
}

function statusPill(status: Booking["status"]): string {
  switch (status) {
    case "pending":
      return "bg-orange-500/10 text-orange-700";
    case "confirmed":
      return "bg-sky-500/10 text-sky-700";
    case "checkedIn":
      return "bg-emerald-500/10 text-emerald-800";
    case "completed":
      return "bg-gray-500/10 text-gray-700";
    default:
      return "bg-red-500/10 text-red-700";
  }
}

export function DashboardPageClient() {
  const bookings = useMerchantDemoStore((s) => s.bookings);
  const listingsCount = useMerchantDemoStore((s) => s.listings.length);
  const businessesCount = useMerchantDemoStore((s) => s.businesses.length);
  const [greetingName, setGreetingName] = useState<string | null>(null);
  useEffect(() => {
    const id = requestAnimationFrame(() => {
      setGreetingName(getPortalSession()?.displayName ?? null);
    });
    return () => cancelAnimationFrame(id);
  }, []);

  const recent = useMemo(() => {
    return [...bookings]
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
      .slice(0, 4);
  }, [bookings]);

  const k = DASHBOARD_KPIS;

  return (
    <div className="flex flex-col gap-4">
      <header>
        <h1 className="text-2xl font-semibold tracking-tight text-[var(--foreground)]">Dashboard</h1>
        <p className="mt-1 text-sm text-muted">
          {greetingName ? <>Hi {greetingName} — </> : null}
          Bookings, revenue, and shortcuts. Layout inspired by analytics dashboards; numbers mirror the merchant app demo.
        </p>
      </header>

      <Link
        href="/wallet"
        className="block overflow-hidden rounded border border-[var(--color-border)] bg-gradient-to-br from-[#e8e8ed] via-[#d1d1d6] to-[#e4e6f0] p-6 shadow-[0_1px_2px_rgba(15,23,42,0.04)] transition hover:border-gray-300"
      >
        <div className="flex flex-wrap items-start justify-between gap-3">
          <p className="text-sm font-medium text-black/55">Total balance (demo)</p>
          <span className="rounded-full bg-[var(--foreground)]/10 px-2.5 py-1 text-[11px] font-semibold text-[var(--foreground)]">
            This month
          </span>
        </div>
        <p className="mt-3 text-3xl font-bold tracking-tight text-black/90 sm:text-4xl">
          {k.currency} {formatWalletNumber(k.totalRevenue)}
        </p>
        <div className="mt-5 flex flex-wrap items-end justify-between gap-4">
          <div>
            <p className="text-xl font-bold text-black/90">{businessesCount}</p>
            <p className="text-xs text-black/50">Businesses</p>
          </div>
          <div>
            <p className="text-xl font-bold text-black/90">{listingsCount}</p>
            <p className="text-xs text-black/50">Listings</p>
          </div>
          <span className="ml-auto flex size-10 items-center justify-center rounded-lg bg-[var(--foreground)]/10 text-[var(--foreground)]">
            <Wallet className="size-5" />
          </span>
        </div>
      </Link>

      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-5">
        <MetricTile
          href="/bookings"
          variant="primary"
          icon={Calendar}
          label="Today's bookings"
          value={k.todayBookings}
          hint="Open bookings"
        />
        <MetricTile href="/bookings" variant="warning" icon={Clock} label="Pending" value={k.pendingBookings} hint="Needs action" />
        <MetricTile
          href="/listings"
          variant="success"
          icon={List}
          label="Listings"
          value={listingsCount}
          hint="Live in portal"
        />
        <MetricTile
          href="/businesses"
          variant="info"
          icon={Building2}
          label="Businesses"
          value={businessesCount}
          hint="Profiles"
        />
        <MetricTile href="/wallet" variant="secondary" icon={Wallet} label="Revenue (demo)" value={formatCompact(k.totalRevenue)} hint="RWF · mobile seed" />
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[2fr_1fr]">
        <ChartCard title="Revenue trend" icon={TrendingUp} className="min-h-[220px]">
          <div className="flex flex-1 flex-col justify-center">
            <MiniAreaChart data={[...REVENUE_TREND_WEEK]} height={168} />
            <p className="mt-2 text-[0.8125rem] text-muted">Last 7 days — illustrative series until analytics API is connected.</p>
          </div>
        </ChartCard>
        <ChartCard title="Booking volume" icon={BarChart3}>
          <MiniBarChart values={[...BOOKING_VOLUME_WEEK]} height={130} barColor="#181e29" />
          <div className="mt-2 flex justify-between text-[10px] font-medium uppercase tracking-wide text-muted">
            {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((d) => (
              <span key={d}>{d}</span>
            ))}
          </div>
        </ChartCard>
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[2fr_1fr]">
        <div className={`${cardBase} flex flex-col p-4`}>
          <div className={sectionHeader}>
            <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
              <Activity className="size-5 text-primary" />
              Recent bookings
            </h3>
            <Link href="/bookings" className="inline-flex items-center gap-1 text-sm font-medium text-primary hover:opacity-80">
              View all
              <ArrowRight className="size-4" />
            </Link>
          </div>
          {recent.length === 0 ? (
            <div className="flex flex-1 flex-col items-center justify-center gap-2 py-10 text-center text-sm text-muted">
              <Calendar className="size-8 opacity-40" />
              <p>No bookings in the demo store yet.</p>
            </div>
          ) : (
            <ul className="flex flex-col">
              {recent.map((b) => (
                <li key={b.id} className="border-b border-[var(--color-border)] last:border-0">
                  <Link
                    href="/bookings"
                    className="grid grid-cols-[1fr_auto] items-center gap-3 px-1 py-2.5 text-left transition hover:bg-gray-50/80 sm:px-2"
                  >
                    <div className="min-w-0">
                      <p className="truncate text-sm font-medium text-[var(--foreground)]">{b.customerName}</p>
                      <p className="truncate text-xs text-muted">
                        {b.listingName} · {bookingGuestCount(b)} guests
                      </p>
                    </div>
                    <div className="flex flex-col items-end gap-1">
                      <span className={`rounded-full px-2 py-0.5 text-[11px] font-semibold ${statusPill(b.status)}`}>
                        {bookingStatusLabel(b.status)}
                      </span>
                      <span className="text-xs font-semibold tabular-nums text-[var(--foreground)]">
                        {formatMoney(b.totalAmount, b.currency)}
                      </span>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className={`${cardBase} flex flex-col p-4`}>
          <div className={sectionHeader}>
            <h3 className="flex items-center gap-2 text-base font-semibold text-[var(--foreground)]">
              <BarChart3 className="size-5 text-primary" />
              Quick actions
            </h3>
          </div>
          <div className="flex flex-col gap-2">
            <Link
              href="/businesses/new"
              className="flex items-center justify-center gap-2 rounded-sm border border-[var(--foreground)] bg-[var(--foreground)] px-4 py-2.5 text-sm font-medium text-white transition hover:opacity-95"
            >
              <Plus className="size-4" />
              Add business
            </Link>
            <Link
              href="/listings/new"
              className="flex items-center justify-center gap-2 rounded-sm border border-[var(--color-border)] bg-white px-4 py-2.5 text-sm font-medium text-gray-700 transition hover:border-primary hover:text-primary"
            >
              <LayoutList className="size-4" />
              Add listing
            </Link>
            <button
              type="button"
              className="flex cursor-not-allowed items-center justify-center gap-2 rounded-sm border border-[var(--color-border)] bg-white px-4 py-2.5 text-sm font-medium text-gray-400"
              disabled
              title="Coming soon"
            >
              <QrCode className="size-4" />
              Scan QR
            </button>
            <Link
              href="/analytics"
              className="flex items-center justify-center gap-2 rounded-sm border border-[var(--color-border)] bg-white px-4 py-2.5 text-sm font-medium text-gray-700 transition hover:border-primary hover:text-primary"
            >
              <BarChart3 className="size-4" />
              Analytics
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

function formatCompact(n: number): string {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
  if (n >= 1000) return `${Math.round(n / 1000)}K`;
  return String(Math.round(n));
}
