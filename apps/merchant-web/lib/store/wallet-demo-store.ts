import { create } from "zustand";
import { getSeedPayoutMethods, getSeedTransactions, getSeedWallet } from "@/lib/data/mock-wallet";
import type { PayoutMethod, Wallet, WalletTransaction } from "@/lib/types/wallet";

function nextRef(prefix: string): string {
  const n = Math.floor(1000 + Math.random() * 9000);
  return `${prefix}-${new Date().getFullYear()}-${n}`;
}

type WalletDemoState = {
  wallet: Wallet;
  transactions: WalletTransaction[];
  payoutMethods: PayoutMethod[];
  addDeposit: (amount: number) => void;
  requestWithdraw: (amount: number, payoutMethodId: string) => void;
  cancelPendingWithdrawal: (transactionId: string) => void;
  addPayoutMethod: (m: {
    type: PayoutMethod["type"];
    label: string;
    accountName: string;
    accountHint: string;
    isDefault: boolean;
    id?: string;
  }) => void;
  updatePayoutMethod: (m: PayoutMethod) => void;
  removePayoutMethod: (id: string) => void;
  setDefaultPayoutMethod: (id: string) => void;
  resetWalletDemo: () => void;
};

export const useWalletDemoStore = create<WalletDemoState>((set, get) => ({
  wallet: getSeedWallet(),
  transactions: getSeedTransactions(),
  payoutMethods: getSeedPayoutMethods(),

  addDeposit: (amount) => {
    if (amount <= 0) return;
    const now = new Date().toISOString();
    const w = get().wallet;
    const tx: WalletTransaction = {
      id: typeof crypto !== "undefined" ? crypto.randomUUID() : `tx-${Date.now()}`,
      walletId: w.id,
      type: "deposit",
      amount,
      currency: w.currency,
      status: "completed",
      description: "Wallet deposit",
      reference: nextRef("DP"),
      createdAt: now,
    };
    set((s) => ({
      wallet: {
        ...s.wallet,
        balance: s.wallet.balance + amount,
        updatedAt: now,
      },
      transactions: [tx, ...s.transactions],
    }));
  },

  requestWithdraw: (amount, payoutMethodId) => {
    if (amount <= 0) return;
    const { wallet, transactions, payoutMethods } = get();
    const method = payoutMethods.find((p) => p.id === payoutMethodId);
    if (!method) return;
    if (amount > wallet.balance) return;
    const now = new Date().toISOString();
    const tx: WalletTransaction = {
      id: typeof crypto !== "undefined" ? crypto.randomUUID() : `tx-${Date.now()}`,
      walletId: wallet.id,
      type: "withdrawal",
      amount,
      currency: wallet.currency,
      status: "pending",
      description: `Withdrawal to ${method.label}`,
      reference: nextRef("WD"),
      createdAt: now,
    };
    set({
      wallet: {
        ...wallet,
        balance: wallet.balance - amount,
        pendingBalance: wallet.pendingBalance + amount,
        updatedAt: now,
      },
      transactions: [tx, ...transactions],
    });
  },

  cancelPendingWithdrawal: (transactionId) => {
    const now = new Date().toISOString();
    set((s) => {
      const tx = s.transactions.find((t) => t.id === transactionId);
      if (!tx || tx.status !== "pending" || (tx.type !== "withdrawal" && tx.type !== "payout")) {
        return s;
      }
      return {
        wallet: {
          ...s.wallet,
          balance: s.wallet.balance + tx.amount,
          pendingBalance: Math.max(0, s.wallet.pendingBalance - tx.amount),
          updatedAt: now,
        },
        transactions: s.transactions.map((t) =>
          t.id === transactionId ? { ...t, status: "cancelled" as const, reference: t.reference } : t,
        ),
      };
    });
  },

  addPayoutMethod: (m) => {
    const now = new Date().toISOString();
    const id = m.id ?? (typeof crypto !== "undefined" ? crypto.randomUUID() : `pm-${Date.now()}`);
    set((s) => {
      let methods = [...s.payoutMethods];
      const isFirst = methods.length === 0;
      const next: PayoutMethod = {
        id,
        type: m.type,
        label: m.label,
        accountName: m.accountName,
        accountHint: m.accountHint,
        isDefault: m.isDefault || isFirst,
        createdAt: now,
      };
      if (next.isDefault) {
        methods = methods.map((p) => ({ ...p, isDefault: false }));
      }
      return { payoutMethods: [...methods, next] };
    });
  },

  updatePayoutMethod: (m) =>
    set((s) => {
      let methods = s.payoutMethods.map((p) => (p.id === m.id ? m : p));
      if (m.isDefault) {
        methods = methods.map((p) => ({ ...p, isDefault: p.id === m.id }));
      } else if (!methods.some((p) => p.isDefault) && methods.length > 0) {
        methods = methods.map((p, i) => ({ ...p, isDefault: i === 0 }));
      }
      return { payoutMethods: methods };
    }),

  removePayoutMethod: (id) =>
    set((s) => {
      const filtered = s.payoutMethods.filter((p) => p.id !== id);
      if (filtered.length === 0) return { payoutMethods: filtered };
      const removed = s.payoutMethods.find((p) => p.id === id);
      if (!removed?.isDefault) return { payoutMethods: filtered };
      return {
        payoutMethods: filtered.map((p, i) => ({ ...p, isDefault: i === 0 })),
      };
    }),

  setDefaultPayoutMethod: (id) =>
    set((s) => ({
      payoutMethods: s.payoutMethods.map((p) => ({ ...p, isDefault: p.id === id })),
    })),

  resetWalletDemo: () =>
    set({
      wallet: getSeedWallet(),
      transactions: getSeedTransactions(),
      payoutMethods: getSeedPayoutMethods(),
    }),
}));
