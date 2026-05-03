import type { Metadata } from "next";
import { RoomsPageClient } from "@/components/merchant/RoomsPageClient";

export const metadata: Metadata = { title: "Rooms" };

export default function RoomsPage() {
  return <RoomsPageClient />;
}

