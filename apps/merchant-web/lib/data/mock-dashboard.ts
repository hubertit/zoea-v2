/** KPIs aligned with `merchant-mobile` `dashboard_screen.dart` mock fields. */

export const DASHBOARD_KPIS = {
  todayBookings: 12,
  pendingBookings: 5,
  totalRevenue: 2_450_000,
  totalListings: 8,
  totalBusinesses: 1,
  currency: "RWF",
} as const;

/** Normalized 0–1 heights for a 7-day mini bar chart (demo). */
export const BOOKING_VOLUME_WEEK = [0.35, 0.55, 0.42, 0.7, 0.5, 0.85, 0.62];

/** Revenue index series (relative); scaled in chart. */
export const REVENUE_TREND_WEEK = [180, 220, 195, 260, 240, 310, 285];
