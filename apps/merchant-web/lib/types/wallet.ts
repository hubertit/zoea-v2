/** Aligned with `merchant-mobile` `lib/core/models/wallet.dart`. */

export type ISODateString = string;

export type TransactionType =
  | "booking"
  | "withdrawal"
  | "deposit"
  | "refund"
  | "refundReceived"
  | "commission"
  | "payout";

export type TransactionStatus = "pending" | "completed" | "failed" | "cancelled";

export interface Wallet {
  id: string;
  merchantId: string;
  balance: number;
  pendingBalance: number;
  currency: string;
  updatedAt: ISODateString;
}

export interface WalletTransaction {
  id: string;
  walletId: string;
  type: TransactionType;
  amount: number;
  currency: string;
  status: TransactionStatus;
  description?: string;
  reference?: string;
  createdAt: ISODateString;
  bookingId?: string;
  customerName?: string;
}

export type PayoutMethodType = "bank" | "momo";

/** Saved payout destination (CRUD in portal demo). */
export interface PayoutMethod {
  id: string;
  type: PayoutMethodType;
  /** Short label shown in lists, e.g. "Bank • 1234" */
  label: string;
  accountName: string;
  /** Last digits or masked identifier for display */
  accountHint: string;
  isDefault: boolean;
  createdAt: ISODateString;
}
