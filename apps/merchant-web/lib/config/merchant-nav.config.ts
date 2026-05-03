import type { LucideIcon } from "lucide-react";
import {
  LayoutDashboard,
  Building2,
  List,
  BedDouble,
  CalendarCheck,
  CalendarDays,
  User,
  BarChart3,
  Wallet,
} from "lucide-react";

export type MerchantNavItem = {
  label: string;
  href: string;
  icon: LucideIcon;
};

/** Primary sections aligned with `merchant-mobile` shell routes */
export const MERCHANT_NAV_ITEMS: MerchantNavItem[] = [
  { label: "Dashboard", href: "/dashboard", icon: LayoutDashboard },
  { label: "Businesses", href: "/businesses", icon: Building2 },
  { label: "Listings", href: "/listings", icon: List },
  { label: "Rooms", href: "/rooms", icon: BedDouble },
  { label: "Bookings", href: "/bookings", icon: CalendarCheck },
  { label: "Events", href: "/events", icon: CalendarDays },
  { label: "Analytics", href: "/analytics", icon: BarChart3 },
  { label: "Wallet", href: "/wallet", icon: Wallet },
  { label: "Profile", href: "/profile", icon: User },
];
