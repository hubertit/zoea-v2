import type { Metadata } from "next";
import { ProfilePageClient } from "@/components/merchant/ProfilePageClient";

export const metadata: Metadata = { title: "Profile" };

export default function ProfilePage() {
  return <ProfilePageClient />;
}
