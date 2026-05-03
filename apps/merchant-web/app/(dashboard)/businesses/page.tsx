import type { Metadata } from "next";
import { BusinessesPageClient } from "@/components/merchant/BusinessesPageClient";

export const metadata: Metadata = { title: "My Businesses" };

export default function BusinessesPage() {
  return <BusinessesPageClient />;
}
