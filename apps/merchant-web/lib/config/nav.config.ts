/**
 * Central route paths (same role as `gemura-web` `nav.config`).
 */
export const routes = {
  home: "/",
  login: "/auth/login",
  register: "/auth/register",
  forgotPassword: "/auth/forgot-password",
  dashboard: "/dashboard",
  businesses: "/businesses",
  listings: "/listings",
  bookings: "/bookings",
  events: "/events",
  profile: "/profile",
  analytics: "/analytics",
  wallet: "/wallet",
} as const;
