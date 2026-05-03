import type { Metadata } from "next";
import { EventsPageClient } from "@/components/merchant/EventsPageClient";

export const metadata: Metadata = { title: "Events" };

export default function EventsPage() {
  return <EventsPageClient />;
}
