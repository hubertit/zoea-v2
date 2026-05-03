import type { TransactionType, WalletTransaction } from "@/lib/types/wallet";

/** Same rules as `WalletTransaction.isCredit` in merchant-mobile. */
export function transactionIsCredit(t: WalletTransaction): boolean {
  return t.type === "booking" || t.type === "deposit" || t.type === "refundReceived";
}

export function transactionTypeLabel(type: TransactionType): string {
  switch (type) {
    case "booking":
      return "Booking Payment";
    case "withdrawal":
      return "Withdrawal";
    case "deposit":
      return "Deposit";
    case "refund":
      return "Refund";
    case "refundReceived":
      return "Refund Received";
    case "commission":
      return "Platform Commission";
    case "payout":
      return "Payout";
  }
}

export function transactionTypeIcon(type: TransactionType): string {
  switch (type) {
    case "booking":
      return "💰";
    case "withdrawal":
      return "📤";
    case "deposit":
      return "📥";
    case "refund":
      return "↩️";
    case "refundReceived":
      return "↪️";
    case "commission":
      return "📊";
    case "payout":
      return "🏦";
  }
}

export function transactionStatusLabel(s: import("@/lib/types/wallet").TransactionStatus): string {
  switch (s) {
    case "pending":
      return "Pending";
    case "completed":
      return "Completed";
    case "failed":
      return "Failed";
    case "cancelled":
      return "Cancelled";
  }
}

export function formatWalletNumber(n: number): string {
  return new Intl.NumberFormat("en-US", { maximumFractionDigits: 0 }).format(n);
}

export function formatRelativeListTime(iso: string): string {
  const d = new Date(iso);
  const now = new Date();
  const diffMs = now.getTime() - d.getTime();
  const diffDays = Math.floor(diffMs / 86400000);
  if (diffDays === 0) {
    return d.toLocaleTimeString(undefined, { hour: "2-digit", minute: "2-digit" });
  }
  if (diffDays === 1) return "Yesterday";
  if (diffDays < 7) return d.toLocaleDateString(undefined, { weekday: "long" });
  return d.toLocaleDateString(undefined, { month: "short", day: "numeric" });
}
