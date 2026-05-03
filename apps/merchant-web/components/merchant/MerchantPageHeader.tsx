import Link from "next/link";
import type { ReactNode } from "react";

type Action = { href: string; label: string; icon?: ReactNode };

export function MerchantPageHeader({
  title,
  action,
  secondary,
}: {
  title: string;
  action?: Action;
  secondary?: ReactNode;
}) {
  return (
    <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <h1 className="text-2xl font-bold text-[var(--foreground)]">{title}</h1>
      <div className="flex flex-wrap items-center gap-2">
        {secondary}
        {action ? (
          <Link
            href={action.href}
            className="btn btn-primary inline-flex items-center gap-2 rounded-lg px-4 py-2.5 text-sm font-semibold"
          >
            {action.icon}
            {action.label}
          </Link>
        ) : null}
      </div>
    </div>
  );
}
