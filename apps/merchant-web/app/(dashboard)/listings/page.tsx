import type { Metadata } from "next";
import { ListingsPageClient } from "@/components/merchant/ListingsPageClient";

export const metadata: Metadata = { title: "My Listings" };

export default function ListingsPage() {
  return <ListingsPageClient />;
}
