import type { PayoutMethod, Wallet, WalletTransaction } from "@/lib/types/wallet";

function iso(d: Date): string {
  return d.toISOString();
}

export function getSeedWallet(): Wallet {
  const now = new Date();
  /** Includes pending withdrawal `t7` (75k) moved from available → pending. */
  return {
    id: "w1",
    merchantId: "1",
    balance: 2_375_000,
    pendingBalance: 425_000,
    currency: "RWF",
    updatedAt: iso(now),
  };
}

/** Matches and extends `wallet_screen.dart` `_getMockTransactions` (+ explicit payout). */
export function getSeedTransactions(): WalletTransaction[] {
  const now = new Date();
  return [
    {
      id: "t1",
      walletId: "w1",
      type: "booking",
      amount: 150_000,
      currency: "RWF",
      status: "completed",
      description: "Deluxe Room booking",
      customerName: "John Doe",
      createdAt: iso(new Date(now.getTime() - 2 * 3600000)),
    },
    {
      id: "t2",
      walletId: "w1",
      type: "commission",
      amount: 15_000,
      currency: "RWF",
      status: "completed",
      description: "Platform fee (10%)",
      createdAt: iso(new Date(now.getTime() - 2 * 3600000)),
    },
    {
      id: "t3",
      walletId: "w1",
      type: "withdrawal",
      amount: 500_000,
      currency: "RWF",
      status: "completed",
      description: "Bank transfer",
      reference: "WD-2024-001",
      createdAt: iso(new Date(now.getTime() - 1 * 86400000)),
    },
    {
      id: "t3b",
      walletId: "w1",
      type: "payout",
      amount: 120_000,
      currency: "RWF",
      status: "completed",
      description: "Scheduled payout to MoMo",
      reference: "PO-2024-014",
      createdAt: iso(new Date(now.getTime() - 2 * 86400000)),
    },
    {
      id: "t4",
      walletId: "w1",
      type: "booking",
      amount: 80_000,
      currency: "RWF",
      status: "completed",
      description: "Table reservation",
      customerName: "Jane Smith",
      createdAt: iso(new Date(now.getTime() - 1 * 86400000)),
    },
    {
      id: "t5",
      walletId: "w1",
      type: "refund",
      amount: 50_000,
      currency: "RWF",
      status: "completed",
      description: "Booking cancelled",
      customerName: "Mike Johnson",
      createdAt: iso(new Date(now.getTime() - 2 * 86400000)),
    },
    {
      id: "t6",
      walletId: "w1",
      type: "booking",
      amount: 3_000_000,
      currency: "RWF",
      status: "pending",
      description: "Gorilla trekking tour",
      customerName: "Sarah Williams",
      createdAt: iso(new Date(now.getTime() - 3 * 86400000)),
    },
    {
      id: "t7",
      walletId: "w1",
      type: "withdrawal",
      amount: 75_000,
      currency: "RWF",
      status: "pending",
      description: "Withdrawal to Bank • 4521",
      reference: "WD-2026-099",
      createdAt: iso(new Date(now.getTime() - 6 * 3600000)),
    },
  ];
}

export function getSeedPayoutMethods(): PayoutMethod[] {
  const now = new Date();
  return [
    {
      id: "pm1",
      type: "bank",
      label: "Bank • 4521",
      accountName: "Kigali Heights Hotel Ltd",
      accountHint: "****4521",
      isDefault: true,
      createdAt: iso(new Date(now.getTime() - 90 * 86400000)),
    },
    {
      id: "pm2",
      type: "momo",
      label: "MoMo • 0788",
      accountName: "Finance Desk",
      accountHint: "****0788",
      isDefault: false,
      createdAt: iso(new Date(now.getTime() - 30 * 86400000)),
    },
  ];
}
