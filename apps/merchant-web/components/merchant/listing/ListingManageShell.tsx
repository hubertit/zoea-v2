"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { ChevronLeft, ImageIcon, MessageSquareText, NotebookText, Pencil } from "lucide-react";

const cardBase =
  "rounded border border-[var(--color-border)] bg-white shadow-[0_1px_2px_rgba(15,23,42,0.04)]";

function NavLink({
  href,
  label,
  icon,
}: {
  href: string;
  label: string;
  icon: React.ReactNode;
}) {
  const pathname = usePathname();
  const active = pathname === href || pathname?.startsWith(`${href}/`);
  return (
    <Link
      href={href}
      className={`inline-flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-semibold transition ${
        active ? "bg-primary text-white" : "border border-[var(--color-border)] bg-white text-gray-700 hover:bg-gray-50"
      }`}
    >
      {icon}
      {label}
    </Link>
  );
}

export function ListingManageShell({
  listingId,
  title,
  children,
}: {
  listingId: string;
  title: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="flex items-center gap-3">
          <Link
            href={`/listings/${listingId}`}
            className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50"
          >
            <ChevronLeft className="size-4" />
            Back
          </Link>
          <h1 className="text-2xl font-bold text-[var(--foreground)]">{title}</h1>
        </div>

        <Link
          href={`/listings/${listingId}`}
          className="inline-flex items-center gap-2 rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-white hover:opacity-95"
        >
          <Pencil className="size-4" />
          Edit listing
        </Link>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        <NavLink href={`/listings/${listingId}/menu`} label="Menu" icon={<NotebookText className="size-4" />} />
        <NavLink href={`/listings/${listingId}/reviews`} label="Reviews" icon={<MessageSquareText className="size-4" />} />
        <NavLink href={`/listings/${listingId}/gallery`} label="Gallery" icon={<ImageIcon className="size-4" />} />
      </div>

      <div className={`${cardBase} p-5`}>{children}</div>
    </div>
  );
}

