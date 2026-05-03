import type { Metadata } from "next";
import { WalletPageClient } from "@/components/merchant/WalletPageClient";

export const metadata: Metadata = { title: "Wallet" };

export default function WalletPage() {
  return <WalletPageClient />;
}
