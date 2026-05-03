import type { Metadata } from "next";
import { BusinessFormPageClient } from "@/components/merchant/BusinessFormPageClient";

export const metadata: Metadata = { title: "New Business" };

export default function NewBusinessPage() {
  return <BusinessFormPageClient key="new" />;
}
