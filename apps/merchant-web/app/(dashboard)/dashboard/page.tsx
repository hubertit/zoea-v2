import type { Metadata } from "next";
import { DashboardPageClient } from "@/components/merchant/DashboardPageClient";

export const metadata: Metadata = {
  title: "Dashboard",
};

export default function DashboardPage() {
  return <DashboardPageClient />;
}
