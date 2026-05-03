import type { Metadata } from "next";
import { BusinessFormPageClient } from "@/components/merchant/BusinessFormPageClient";

export const metadata: Metadata = { title: "Edit Business" };

export default async function EditBusinessPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <BusinessFormPageClient key={id} businessId={id} />;
}
