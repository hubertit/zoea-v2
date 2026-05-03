"use client";

import { useCallback, useMemo, useRef, useState, type ReactNode } from "react";
import {
  ArrowDownLeft,
  ArrowUpRight,
  Building2,
  ChevronRight,
  Download,
  HelpCircle,
  History,
  Landmark,
  Plus,
  Smartphone,
  Trash2,
  X,
} from "lucide-react";
import { useWalletDemoStore } from "@/lib/store/wallet-demo-store";
import {
  formatRelativeListTime,
  formatWalletNumber,
  transactionIsCredit,
  transactionStatusLabel,
  transactionTypeIcon,
  transactionTypeLabel,
} from "@/lib/merchant/wallet-utils";
import type { PayoutMethod, PayoutMethodType, WalletTransaction } from "@/lib/types/wallet";

const QUICK_AMOUNTS = [50_000, 100_000, 250_000, 500_000];

type TabKey = "all" | "in" | "out";

function statusChipClass(status: WalletTransaction["status"]): string {
  switch (status) {
    case "completed":
      return "bg-emerald-500/10 text-emerald-700";
    case "pending":
      return "bg-orange-500/10 text-orange-700";
    case "failed":
    case "cancelled":
      return "bg-red-500/10 text-red-700";
  }
}

export function WalletPageClient() {
  const activityRef = useRef<HTMLDivElement>(null);
  const wallet = useWalletDemoStore((s) => s.wallet);
  const transactions = useWalletDemoStore((s) => s.transactions);
  const payoutMethods = useWalletDemoStore((s) => s.payoutMethods);
  const addDeposit = useWalletDemoStore((s) => s.addDeposit);
  const requestWithdraw = useWalletDemoStore((s) => s.requestWithdraw);
  const cancelPendingWithdrawal = useWalletDemoStore((s) => s.cancelPendingWithdrawal);
  const addPayoutMethod = useWalletDemoStore((s) => s.addPayoutMethod);
  const updatePayoutMethod = useWalletDemoStore((s) => s.updatePayoutMethod);
  const removePayoutMethod = useWalletDemoStore((s) => s.removePayoutMethod);
  const setDefaultPayoutMethod = useWalletDemoStore((s) => s.setDefaultPayoutMethod);
  const resetWalletDemo = useWalletDemoStore((s) => s.resetWalletDemo);

  const [tab, setTab] = useState<TabKey>("all");
  const [toast, setToast] = useState<string | null>(null);
  const [depositOpen, setDepositOpen] = useState(false);
  const [withdrawOpen, setWithdrawOpen] = useState(false);
  const [detailTx, setDetailTx] = useState<WalletTransaction | null>(null);
  const [methodModal, setMethodModal] = useState<{ mode: "add" | "edit"; method?: PayoutMethod } | null>(null);

  const showToast = useCallback((msg: string) => {
    setToast(msg);
    window.setTimeout(() => setToast(null), 2800);
  }, []);

  const filteredTx = useMemo(() => {
    if (tab === "all") return transactions;
    if (tab === "in") return transactions.filter((t) => transactionIsCredit(t));
    return transactions.filter((t) => !transactionIsCredit(t));
  }, [transactions, tab]);

  const defaultMethodId = useMemo(
    () => payoutMethods.find((p) => p.isDefault)?.id ?? payoutMethods[0]?.id ?? "",
    [payoutMethods],
  );

  const scrollToActivity = () => {
    activityRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[var(--foreground)]">Wallet</h1>
          <p className="mt-1 text-sm text-muted">Balances, activity, withdrawals, and payout accounts.</p>
        </div>
        <button
          type="button"
          className="self-start rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-xs font-medium text-muted hover:bg-gray-50"
          onClick={() => {
            resetWalletDemo();
            showToast("Demo data reset");
          }}
        >
          Reset demo data
        </button>
      </div>

      <BalanceCard wallet={wallet} />

      <div className="grid grid-cols-3 gap-3 sm:max-w-xl">
        <ActionTile icon={<Plus className="size-5" />} label="Deposit" onClick={() => setDepositOpen(true)} />
        <ActionTile icon={<ArrowUpRight className="size-5" />} label="Withdraw" onClick={() => setWithdrawOpen(true)} />
        <ActionTile icon={<History className="size-5" />} label="History" onClick={scrollToActivity} />
      </div>

      <section className="rounded-2xl border border-[var(--color-border)] bg-white p-5 shadow-sm">
        <div className="mb-4 flex items-center justify-between gap-2">
          <h2 className="text-lg font-bold">Payout accounts</h2>
          <button
            type="button"
            className="btn btn-primary inline-flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-semibold"
            onClick={() => setMethodModal({ mode: "add" })}
          >
            <Plus className="size-4" />
            Add
          </button>
        </div>
        {payoutMethods.length === 0 ? (
          <p className="text-sm text-muted">Add a bank account or MoMo number to receive withdrawals.</p>
        ) : (
          <ul className="space-y-3">
            {payoutMethods.map((m) => (
              <li
                key={m.id}
                className="flex flex-col gap-3 rounded-xl border border-[var(--color-border)] p-4 sm:flex-row sm:items-center sm:justify-between"
              >
                <div className="flex items-start gap-3">
                  <div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary">
                    {m.type === "bank" ? <Landmark className="size-5" /> : <Smartphone className="size-5" />}
                  </div>
                  <div>
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-semibold">{m.label}</span>
                      {m.isDefault ? (
                        <span className="rounded-md bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase text-primary">
                          Default
                        </span>
                      ) : null}
                    </div>
                    <p className="text-sm text-muted">{m.accountName}</p>
                    <p className="text-xs text-muted">{m.accountHint}</p>
                  </div>
                </div>
                <div className="flex flex-wrap gap-2">
                  {!m.isDefault ? (
                    <button
                      type="button"
                      className="rounded-lg border border-[var(--color-border)] px-3 py-1.5 text-xs font-semibold hover:bg-gray-50"
                      onClick={() => setDefaultPayoutMethod(m.id)}
                    >
                      Set default
                    </button>
                  ) : null}
                  <button
                    type="button"
                    className="rounded-lg border border-[var(--color-border)] px-3 py-1.5 text-xs font-semibold hover:bg-gray-50"
                    onClick={() => setMethodModal({ mode: "edit", method: m })}
                  >
                    Edit
                  </button>
                  <button
                    type="button"
                    className="rounded-lg border border-[var(--color-danger)]/40 px-3 py-1.5 text-xs font-semibold text-[var(--color-danger)] hover:bg-red-50"
                    onClick={() => {
                      if (payoutMethods.length <= 1) {
                        showToast("Keep at least one payout account.");
                        return;
                      }
                      removePayoutMethod(m.id);
                      showToast("Account removed");
                    }}
                  >
                    <Trash2 className="mx-auto size-3.5 sm:mx-0 sm:inline sm:mr-1" />
                    <span className="sr-only sm:not-sr-only">Remove</span>
                  </button>
                </div>
              </li>
            ))}
          </ul>
        )}
      </section>

      <section ref={activityRef} id="wallet-activity" className="scroll-mt-4">
        <h2 className="mb-4 text-lg font-bold">Activity</h2>
        <div className="mb-4 flex rounded-xl border border-[var(--color-border)] bg-gray-100/80 p-1">
          {(
            [
              ["all", "All"],
              ["in", "In"],
              ["out", "Out"],
            ] as const
          ).map(([k, label]) => (
            <button
              key={k}
              type="button"
              onClick={() => setTab(k)}
              className={`flex-1 rounded-lg py-2 text-sm font-semibold transition ${
                tab === k ? "bg-white text-[var(--foreground)] shadow-sm" : "text-muted hover:text-[var(--foreground)]"
              }`}
            >
              {label}
            </button>
          ))}
        </div>

        {filteredTx.length === 0 ? (
          <div className="flex flex-col items-center justify-center rounded-2xl border border-dashed border-[var(--color-border)] bg-white py-16 text-muted">
            <History className="mb-3 size-12 opacity-30" />
            <p>No transactions</p>
          </div>
        ) : (
          <ul className="space-y-3">
            {filteredTx.map((t) => (
              <li key={t.id}>
                <button
                  type="button"
                  onClick={() => setDetailTx(t)}
                  className="flex w-full items-center gap-3 rounded-xl border border-[var(--color-border)] bg-white p-4 text-left shadow-sm transition hover:border-primary/25"
                >
                  <div
                    className={`flex size-11 shrink-0 items-center justify-center rounded-xl ${
                      transactionIsCredit(t) ? "bg-emerald-500/10 text-emerald-700" : "bg-red-500/10 text-red-600"
                    }`}
                  >
                    {transactionIsCredit(t) ? <ArrowDownLeft className="size-5" /> : <ArrowUpRight className="size-5" />}
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="font-semibold text-[var(--foreground)]">
                      <span className="mr-1.5">{transactionTypeIcon(t.type)}</span>
                      {transactionTypeLabel(t.type)}
                    </p>
                    <p className="truncate text-sm text-muted">{t.description ?? ""}</p>
                  </div>
                  <div className="flex shrink-0 items-center gap-1">
                    <div className="text-right">
                      <p
                        className={`text-sm font-bold ${
                          transactionIsCredit(t) ? "text-emerald-600" : "text-red-600"
                        }`}
                      >
                        {transactionIsCredit(t) ? "+" : "-"} {formatWalletNumber(t.amount)}
                      </p>
                      <p className="text-xs text-muted">{formatRelativeListTime(t.createdAt)}</p>
                    </div>
                    <ChevronRight className="size-4 text-muted opacity-50" />
                  </div>
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>

      {depositOpen ? (
        <AmountSheet
          title="Deposit funds"
          submitLabel="Deposit"
          currency={wallet.currency}
          onClose={() => setDepositOpen(false)}
          onSubmit={(amount) => {
            addDeposit(amount);
            setDepositOpen(false);
            showToast("Deposit initiated");
          }}
        />
      ) : null}

      {withdrawOpen ? (
        <WithdrawSheet
          currency={wallet.currency}
          balance={wallet.balance}
          payoutMethods={payoutMethods}
          defaultMethodId={defaultMethodId}
          onClose={() => setWithdrawOpen(false)}
          onSubmit={(amount, methodId) => {
            if (amount > wallet.balance) {
              showToast("Amount exceeds available balance");
              return;
            }
            requestWithdraw(amount, methodId);
            setWithdrawOpen(false);
            showToast("Withdrawal initiated");
          }}
        />
      ) : null}

      {detailTx ? (
        <TransactionDetailModal
          tx={detailTx}
          currency={wallet.currency}
          onClose={() => setDetailTx(null)}
          onCancelPending={() => {
            cancelPendingWithdrawal(detailTx.id);
            setDetailTx(null);
            showToast("Withdrawal cancelled");
          }}
          onReceipt={() => showToast("Receipt downloaded")}
          onSupport={() => showToast("Support ticket created")}
        />
      ) : null}

      {methodModal ? (
        <PayoutMethodModal
          mode={methodModal.mode}
          initial={methodModal.method}
          onClose={() => setMethodModal(null)}
          onSave={(payload) => {
            if (methodModal.mode === "add") {
              addPayoutMethod(payload);
              showToast("Account added");
            } else if (methodModal.method) {
              updatePayoutMethod({ ...payload, id: methodModal.method.id, createdAt: methodModal.method.createdAt });
              showToast("Account updated");
            }
            setMethodModal(null);
          }}
        />
      ) : null}

      {toast ? (
        <div className="fixed bottom-6 left-1/2 z-[70] max-w-sm -translate-x-1/2 rounded-lg bg-[var(--foreground)] px-4 py-3 text-center text-sm text-white shadow-lg">
          {toast}
        </div>
      ) : null}
    </div>
  );
}

function BalanceCard({ wallet }: { wallet: { balance: number; pendingBalance: number; currency: string } }) {
  return (
    <div
      className="overflow-hidden rounded-3xl border border-[var(--color-border)] p-6 shadow-md"
      style={{
        background: "linear-gradient(135deg, #e8e8ed 0%, #d1d1d6 50%, #e4e6f0 100%)",
      }}
    >
      <p className="text-center text-sm text-black/55">Available balance</p>
      <p className="mt-2 text-center text-3xl font-bold tracking-tight text-black/90 sm:text-4xl">
        {wallet.currency} {formatWalletNumber(wallet.balance)}
      </p>
      <div className="mt-4 flex justify-center">
        <div className="inline-flex items-center gap-2 rounded-full bg-black/10 px-4 py-2 text-sm text-black/80">
          <Building2 className="size-4 shrink-0 opacity-60" />
          <span>
            Pending: {wallet.currency} {formatWalletNumber(wallet.pendingBalance)}
          </span>
        </div>
      </div>
    </div>
  );
}

function ActionTile({ icon, label, onClick }: { icon: ReactNode; label: string; onClick: () => void }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="flex flex-col items-center gap-2 rounded-xl border border-[var(--color-border)] bg-white py-4 shadow-sm transition hover:border-primary/30 hover:bg-gray-50/80"
    >
      <span className="flex size-10 items-center justify-center rounded-full bg-primary/10 text-primary">{icon}</span>
      <span className="text-xs font-semibold text-[var(--foreground)]">{label}</span>
    </button>
  );
}

function AmountSheet({
  title,
  submitLabel,
  currency,
  onClose,
  onSubmit,
}: {
  title: string;
  submitLabel: string;
  currency: string;
  onClose: () => void;
  onSubmit: (amount: number) => void;
}) {
  const [raw, setRaw] = useState("");
  const amount = Number(raw.replace(/,/g, "")) || 0;

  return (
    <ModalBackdrop onClose={onClose}>
      <div className="relative z-10 w-full max-w-md rounded-t-2xl bg-gray-50 p-6 shadow-xl sm:rounded-2xl">
        <div className="mx-auto mb-4 h-1 w-10 rounded-full bg-[var(--color-border)] sm:hidden" />
        <div className="mb-4 flex items-center justify-between">
          <h3 className="text-lg font-bold">{title}</h3>
          <button type="button" className="rounded-lg p-2 text-muted hover:bg-gray-200/80" aria-label="Close" onClick={onClose}>
            <X className="size-5" />
          </button>
        </div>
        <label className="mb-3 block text-sm font-medium text-muted">Amount ({currency})</label>
        <input
          inputMode="numeric"
          className="mb-4 w-full rounded-xl border border-[var(--color-border)] bg-white px-4 py-3 text-2xl font-bold outline-none focus:border-primary"
          placeholder="0"
          value={raw}
          onChange={(e) => setRaw(e.target.value.replace(/[^\d]/g, ""))}
        />
        <div className="mb-6 flex flex-wrap gap-2">
          {QUICK_AMOUNTS.map((a) => (
            <button
              key={a}
              type="button"
              className="rounded-full bg-primary/10 px-4 py-2 text-sm font-semibold text-primary hover:bg-primary/15"
              onClick={() => setRaw(String(a))}
            >
              {formatWalletNumber(a)}
            </button>
          ))}
        </div>
        <button
          type="button"
          className="btn btn-primary w-full rounded-lg py-3 text-sm font-semibold"
          disabled={amount <= 0}
          onClick={() => onSubmit(amount)}
        >
          {submitLabel}
        </button>
      </div>
    </ModalBackdrop>
  );
}

function WithdrawSheet({
  currency,
  balance,
  payoutMethods,
  defaultMethodId,
  onClose,
  onSubmit,
}: {
  currency: string;
  balance: number;
  payoutMethods: PayoutMethod[];
  defaultMethodId: string;
  onClose: () => void;
  onSubmit: (amount: number, methodId: string) => void;
}) {
  const [raw, setRaw] = useState("");
  const [methodId, setMethodId] = useState(defaultMethodId);
  const amount = Number(raw.replace(/,/g, "")) || 0;

  return (
    <ModalBackdrop onClose={onClose}>
      <div className="relative z-10 w-full max-w-md rounded-t-2xl bg-gray-50 p-6 shadow-xl sm:rounded-2xl">
        <div className="mx-auto mb-4 h-1 w-10 rounded-full bg-[var(--color-border)] sm:hidden" />
        <div className="mb-4 flex items-center justify-between">
          <h3 className="text-lg font-bold">Withdraw funds</h3>
          <button type="button" className="rounded-lg p-2 text-muted hover:bg-gray-200/80" aria-label="Close" onClick={onClose}>
            <X className="size-5" />
          </button>
        </div>
        <p className="mb-4 text-sm text-muted">
          Available: {currency} {formatWalletNumber(balance)}
        </p>
        {payoutMethods.length === 0 ? (
          <p className="mb-4 text-sm text-red-600">Add a payout account before withdrawing.</p>
        ) : (
          <label className="mb-4 block">
            <span className="mb-1 block text-sm font-medium text-muted">Payout account</span>
            <select
              className="w-full rounded-xl border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={methodId}
              onChange={(e) => setMethodId(e.target.value)}
            >
              {payoutMethods.map((m) => (
                <option key={m.id} value={m.id}>
                  {m.label} {m.isDefault ? "(default)" : ""}
                </option>
              ))}
            </select>
          </label>
        )}
        <label className="mb-3 block text-sm font-medium text-muted">Amount ({currency})</label>
        <input
          inputMode="numeric"
          className="mb-4 w-full rounded-xl border border-[var(--color-border)] bg-white px-4 py-3 text-2xl font-bold outline-none focus:border-primary"
          placeholder="0"
          value={raw}
          onChange={(e) => setRaw(e.target.value.replace(/[^\d]/g, ""))}
        />
        <div className="mb-6 flex flex-wrap gap-2">
          {QUICK_AMOUNTS.map((a) => (
            <button
              key={a}
              type="button"
              className="rounded-full bg-primary/10 px-4 py-2 text-sm font-semibold text-primary hover:bg-primary/15"
              onClick={() => setRaw(String(a))}
            >
              {formatWalletNumber(a)}
            </button>
          ))}
        </div>
        <button
          type="button"
          className="btn btn-primary w-full rounded-lg py-3 text-sm font-semibold"
          disabled={amount <= 0 || !methodId || payoutMethods.length === 0}
          onClick={() => onSubmit(amount, methodId)}
        >
          Withdraw
        </button>
      </div>
    </ModalBackdrop>
  );
}

function ModalBackdrop({ children, onClose }: { children: ReactNode; onClose: () => void }) {
  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/45 p-0 sm:items-center sm:p-4">
      <button type="button" className="absolute inset-0 cursor-default" aria-label="Close" onClick={onClose} />
      {children}
    </div>
  );
}

function TransactionDetailModal({
  tx,
  currency,
  onClose,
  onCancelPending,
  onReceipt,
  onSupport,
}: {
  tx: WalletTransaction;
  currency: string;
  onClose: () => void;
  onCancelPending: () => void;
  onReceipt: () => void;
  onSupport: () => void;
}) {
  const credit = transactionIsCredit(tx);
  const d = new Date(tx.createdAt);
  const canCancel = tx.status === "pending" && (tx.type === "withdrawal" || tx.type === "payout");

  return (
    <ModalBackdrop onClose={onClose}>
      <div className="relative z-10 max-h-[90vh] w-full max-w-lg overflow-y-auto rounded-t-2xl bg-gray-50 p-6 shadow-xl sm:rounded-2xl">
        <div className="mx-auto mb-4 h-1 w-10 rounded-full bg-[var(--color-border)] sm:hidden" />
        <div className="mb-6 flex items-start gap-3">
          <div
            className={`flex size-12 shrink-0 items-center justify-center rounded-2xl ${
              credit ? "bg-emerald-500/10 text-emerald-700" : "bg-red-500/10 text-red-600"
            }`}
          >
            {credit ? <ArrowDownLeft className="size-6" /> : <ArrowUpRight className="size-6" />}
          </div>
          <div className="min-w-0 flex-1">
            <p className="text-lg font-bold">
              {transactionTypeIcon(tx.type)} {transactionTypeLabel(tx.type)}
            </p>
            <p className="text-sm text-muted">{tx.description}</p>
          </div>
          <span className={`shrink-0 rounded-full px-3 py-1 text-xs font-semibold ${statusChipClass(tx.status)}`}>
            {transactionStatusLabel(tx.status)}
          </span>
        </div>

        <div
          className={`mb-6 rounded-2xl border p-5 text-center ${
            credit ? "border-emerald-200/80 bg-emerald-500/5" : "border-red-200/80 bg-red-500/5"
          }`}
        >
          <p className="text-xs font-medium text-muted">{credit ? "Amount received" : "Amount sent"}</p>
          <p className={`mt-1 text-3xl font-bold ${credit ? "text-emerald-600" : "text-red-600"}`}>
            {credit ? "+" : "-"} {currency} {formatWalletNumber(tx.amount)}
          </p>
        </div>

        <div className="mb-4">
          <h4 className="mb-2 text-sm font-bold">Transaction details</h4>
          <div className="rounded-xl border border-[var(--color-border)] bg-white p-4 text-sm">
            {tx.customerName ? <DetailRow label="Customer" value={tx.customerName} /> : null}
            <DetailRow label="Date" value={d.toLocaleDateString(undefined, { weekday: "long", month: "short", day: "numeric", year: "numeric" })} />
            <DetailRow label="Time" value={d.toLocaleTimeString(undefined, { hour: "2-digit", minute: "2-digit" })} />
            {tx.reference ? <DetailRow label="Reference" value={tx.reference} /> : null}
          </div>
        </div>

        <div className="mb-6">
          <h4 className="mb-2 text-sm font-bold">Transaction ID</h4>
          <div className="rounded-xl border border-[var(--color-border)] bg-white p-3 font-mono text-xs text-muted">{tx.id}</div>
        </div>

        {canCancel ? (
          <button
            type="button"
            className="mb-4 w-full rounded-lg border border-[var(--color-danger)] py-2.5 text-sm font-semibold text-[var(--color-danger)] hover:bg-red-50"
            onClick={onCancelPending}
          >
            Cancel withdrawal
          </button>
        ) : null}

        <div className="flex gap-3">
          <button
            type="button"
            className="btn flex flex-1 items-center justify-center gap-2 rounded-lg border border-[var(--color-border)] bg-white py-2.5 text-sm font-semibold hover:bg-gray-50"
            onClick={() => {
              onReceipt();
              onClose();
            }}
          >
            <Download className="size-4" />
            Receipt
          </button>
          <button
            type="button"
            className="btn flex flex-1 items-center justify-center gap-2 rounded-lg border border-[var(--color-border)] bg-white py-2.5 text-sm font-semibold hover:bg-gray-50"
            onClick={() => {
              onSupport();
              onClose();
            }}
          >
            <HelpCircle className="size-4" />
            Support
          </button>
        </div>
      </div>
    </ModalBackdrop>
  );
}

function DetailRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4 border-b border-[var(--color-border)] py-2 last:border-0">
      <span className="text-muted">{label}</span>
      <span className="max-w-[60%] text-right font-medium">{value}</span>
    </div>
  );
}

function PayoutMethodModal({
  mode,
  initial,
  onClose,
  onSave,
}: {
  mode: "add" | "edit";
  initial?: PayoutMethod;
  onClose: () => void;
  onSave: (p: Omit<PayoutMethod, "id" | "createdAt"> & { id?: string }) => void;
}) {
  const [type, setType] = useState<PayoutMethodType>(initial?.type ?? "bank");
  const [accountName, setAccountName] = useState(initial?.accountName ?? "");
  const [accountHint, setAccountHint] = useState(initial?.accountHint ?? "");
  const [isDefault, setIsDefault] = useState(initial?.isDefault ?? false);

  const buildLabel = () => {
    const tail = accountHint.replace(/\D/g, "").slice(-4) || "????";
    return type === "bank" ? `Bank • ${tail}` : `MoMo • ${tail}`;
  };

  return (
    <ModalBackdrop onClose={onClose}>
      <div className="relative z-10 w-full max-w-md rounded-t-2xl bg-gray-50 p-6 shadow-xl sm:rounded-2xl">
        <div className="mb-4 flex items-center justify-between">
          <h3 className="text-lg font-bold">{mode === "add" ? "Add payout account" : "Edit payout account"}</h3>
          <button type="button" className="rounded-lg p-2 text-muted hover:bg-gray-200/80" aria-label="Close" onClick={onClose}>
            <X className="size-5" />
          </button>
        </div>
        <div className="space-y-4">
          <label className="block">
            <span className="mb-1 block text-sm text-muted">Type</span>
            <select
              className="w-full rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm"
              value={type}
              onChange={(e) => setType(e.target.value as PayoutMethodType)}
            >
              <option value="bank">Bank transfer</option>
              <option value="momo">Mobile money</option>
            </select>
          </label>
          <label className="block">
            <span className="mb-1 block text-sm text-muted">Account name</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm"
              value={accountName}
              onChange={(e) => setAccountName(e.target.value)}
              placeholder="Name on account"
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-sm text-muted">Last digits / reference</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] bg-white px-3 py-2.5 text-sm"
              value={accountHint}
              onChange={(e) => setAccountHint(e.target.value)}
              placeholder="e.g. ****4521 or 0788…"
            />
          </label>
          <p className="text-xs text-muted">
            Display label: <span className="font-semibold text-[var(--foreground)]">{buildLabel()}</span>
          </p>
          <label className="flex cursor-pointer items-center gap-2 text-sm">
            <input type="checkbox" checked={isDefault} onChange={(e) => setIsDefault(e.target.checked)} className="size-4 rounded" />
            Set as default payout account
          </label>
        </div>
        <button
          type="button"
          className="btn btn-primary mt-6 w-full rounded-lg py-3 text-sm font-semibold"
          disabled={!accountName.trim() || !accountHint.trim()}
          onClick={() =>
            onSave({
              type,
              label: buildLabel(),
              accountName: accountName.trim(),
              accountHint: accountHint.trim(),
              isDefault,
            })
          }
        >
          Save
        </button>
      </div>
    </ModalBackdrop>
  );
}
