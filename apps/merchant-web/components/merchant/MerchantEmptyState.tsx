import Link from "next/link";
import type { ReactNode } from "react";

export function MerchantEmptyState({
  icon,
  title,
  description,
  actionHref,
  actionLabel,
}: {
  icon: ReactNode;
  title: string;
  description: string;
  actionHref: string;
  actionLabel: string;
}) {
  return (
    <div className="flex min-h-[320px] flex-col items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white px-8 py-16 text-center shadow-sm">
      <div className="mb-6 flex size-24 items-center justify-center rounded-full bg-primary/10 text-primary">{icon}</div>
      <h2 className="mb-2 text-xl font-bold text-[var(--foreground)]">{title}</h2>
      <p className="mb-8 max-w-md whitespace-pre-line text-sm text-muted">{description}</p>
      <Link href={actionHref} className="btn btn-primary inline-flex items-center gap-2 rounded-lg px-5 py-2.5 text-sm font-semibold">
        {actionLabel}
      </Link>
    </div>
  );
}
