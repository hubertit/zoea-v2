"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { LogOut, Save, User } from "lucide-react";
import { clearPortalSession, getPortalSession, setPortalSession } from "@/lib/auth/portal-session";
import { routes } from "@/lib/config/nav.config";
import { MerchantPageHeader } from "@/components/merchant/MerchantPageHeader";

const cardBase =
  "rounded border border-[var(--color-border)] bg-white shadow-[0_1px_2px_rgba(15,23,42,0.04)]";

export function ProfilePageClient() {
  const router = useRouter();
  const initial = useMemo(() => getPortalSession(), []);
  const [displayName, setDisplayName] = useState(() => initial?.displayName ?? "");
  const [email, setEmail] = useState(() => initial?.email ?? "");
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  const canSave = useMemo(() => displayName.trim().length > 1 && email.trim().length > 3, [displayName, email]);

  const showToast = (msg: string) => {
    setToast(msg);
    window.setTimeout(() => setToast(null), 2800);
  };

  const handleSave = () => {
    if (!canSave) return;
    setSaving(true);
    queueMicrotask(() => {
      setPortalSession({ displayName: displayName.trim(), email: email.trim() });
      setSaving(false);
      showToast("Profile updated");
    });
  };

  const handleLogout = () => {
    clearPortalSession();
    router.replace(routes.login);
  };

  return (
    <div className="flex flex-col gap-4">
      <MerchantPageHeader title="Profile & settings" />

      <div className={`${cardBase} overflow-hidden`}>
        <div className="flex items-center justify-between gap-3 border-b border-[var(--color-border)] bg-gray-50 px-5 py-4">
          <div className="flex items-center gap-2">
            <span className="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary">
              <User className="size-5" />
            </span>
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">Account</p>
              <p className="text-xs text-muted">This updates the demo portal session (stored in sessionStorage).</p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={handleLogout}
              className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50"
            >
              <LogOut className="size-4" />
              Logout
            </button>
            <button
              type="button"
              disabled={!canSave || saving}
              onClick={handleSave}
              className="inline-flex items-center gap-2 rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-60"
            >
              <Save className="size-4" />
              {saving ? "Saving…" : "Save"}
            </button>
          </div>
        </div>

        <div className="grid gap-5 px-5 py-6 sm:grid-cols-2">
          <label className="block">
            <span className="mb-1 block text-sm font-medium text-muted">Display name</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              placeholder="e.g., Zoea Merchant"
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-sm font-medium text-muted">Email</span>
            <input
              inputMode="email"
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@business.com"
            />
          </label>
        </div>
      </div>

      <div className={`${cardBase} p-5`}>
        <h2 className="text-sm font-bold text-[var(--foreground)]">Preferences</h2>
        <p className="mt-1 text-sm text-muted">More settings will land here once API-backed user profiles are wired.</p>
        <div className="mt-4 grid gap-3 sm:grid-cols-2">
          <div className="rounded-xl border border-[var(--color-border)] bg-gray-50 px-4 py-3">
            <p className="text-xs font-semibold uppercase tracking-wide text-muted">Portal mode</p>
            <p className="mt-1 text-sm font-semibold text-[var(--foreground)]">Demo</p>
          </div>
          <div className="rounded-xl border border-[var(--color-border)] bg-gray-50 px-4 py-3">
            <p className="text-xs font-semibold uppercase tracking-wide text-muted">Theme</p>
            <p className="mt-1 text-sm font-semibold text-[var(--foreground)]">System</p>
          </div>
        </div>
      </div>

      {toast ? (
        <div className="fixed bottom-6 left-1/2 z-[60] max-w-sm -translate-x-1/2 rounded-lg bg-[var(--foreground)] px-4 py-3 text-center text-sm text-white shadow-lg">
          {toast}
        </div>
      ) : null}
    </div>
  );
}

