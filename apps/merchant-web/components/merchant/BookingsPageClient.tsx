"use client";

import { useCallback, useMemo, useState } from "react";
import { CalendarDays, Filter, Footprints, Hotel, Ticket, Users } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { bookingCardGuestLine, bookingGuestIconType, bookingPrimaryDateIso } from "@/lib/merchant/booking-helpers";
import {
  bookingStatusLabel,
  bookingTypeFilterIcon,
  bookingTypeIcon,
  bookingTypeLabel,
  paymentMethodLabel,
  paymentStatusLabel,
} from "@/lib/merchant/labels";
import { formatMoney, formatShortDate } from "@/lib/merchant/format";
import type { Booking, BookingStatus, BookingType } from "@/lib/types/merchant";

const TABS: { key: "all" | BookingStatus; label: (n: number) => string }[] = [
  { key: "all", label: (n) => `All (${n})` },
  { key: "pending", label: (n) => `Pending (${n})` },
  { key: "confirmed", label: (n) => `Confirmed (${n})` },
  { key: "completed", label: (n) => `Completed (${n})` },
];

function statusChipClasses(status: BookingStatus): string {
  switch (status) {
    case "pending":
      return "bg-orange-500/10 text-orange-600";
    case "confirmed":
      return "bg-blue-500/10 text-blue-600";
    case "checkedIn":
      return "bg-emerald-500/10 text-emerald-700";
    case "completed":
      return "bg-gray-500/10 text-gray-600";
    case "cancelled":
    case "noShow":
      return "bg-red-500/10 text-red-600";
  }
}

function GuestIcon({ type }: { type: BookingType }) {
  const k = bookingGuestIconType(type);
  const cls = "size-3.5 shrink-0 text-muted";
  if (k === "hotel") return <Hotel className={cls} />;
  if (k === "people") return <Users className={cls} />;
  if (k === "hiking") return <Footprints className={cls} />;
  return <Ticket className={cls} />;
}

function BookingCard({ booking, onOpen }: { booking: Booking; onOpen: (b: Booking) => void }) {
  return (
    <button
      type="button"
      onClick={() => onOpen(booking)}
      className="w-full rounded-xl border border-[var(--color-border)] bg-white p-4 text-left shadow-sm transition hover:border-primary/30 hover:shadow-md"
    >
      <div className="flex gap-3">
        <div className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-lg">{bookingTypeIcon(booking.type)}</div>
        <div className="min-w-0 flex-1">
          <div className="flex items-start justify-between gap-2">
            <div className="min-w-0">
              <p className="font-semibold text-[var(--foreground)]">{booking.customerName}</p>
              <p className="truncate text-xs text-muted">{booking.listingName ?? "Unknown Listing"}</p>
            </div>
            <span className={`shrink-0 rounded-full px-2.5 py-1 text-[11px] font-semibold ${statusChipClasses(booking.status)}`}>
              {bookingStatusLabel(booking.status)}
            </span>
          </div>
          <div className="mt-3 flex flex-wrap items-center gap-x-4 gap-y-1 border-t border-[var(--color-border)] pt-3 text-xs text-muted">
            <span className="inline-flex items-center gap-1">
              <CalendarDays className="size-3.5 shrink-0" />
              {formatShortDate(bookingPrimaryDateIso(booking))}
            </span>
            <span className="inline-flex items-center gap-1">
              <GuestIcon type={booking.type} />
              {bookingCardGuestLine(booking)}
            </span>
            <span className="ml-auto font-bold text-primary">{formatMoney(booking.totalAmount, booking.currency)}</span>
          </div>
        </div>
      </div>
    </button>
  );
}

function BookingDetailSheet({
  booking,
  onClose,
  onConfirm,
  onDecline,
  onCheckIn,
}: {
  booking: Booking;
  onClose: () => void;
  onConfirm: () => void;
  onDecline: () => void;
  onCheckIn: () => void;
}) {
  const infoRows = useMemo(() => {
    const rows: { label: string; value: string }[] = [
      { label: "Listing", value: booking.listingName ?? "N/A" },
      { label: "Business", value: booking.businessName ?? "N/A" },
    ];
    switch (booking.type) {
      case "accommodation": {
        const d = booking.accommodationDetails;
        if (d) {
          rows.push(
            { label: "Check-in", value: formatShortDate(d.checkInDate) },
            { label: "Check-out", value: formatShortDate(d.checkOutDate) },
            { label: "Nights", value: String(d.nights) },
            { label: "Rooms", value: String(d.roomCount) },
            { label: "Guests", value: String(d.guestCount) },
          );
        }
        break;
      }
      case "dining": {
        const d = booking.diningDetails;
        if (d) {
          rows.push(
            { label: "Date", value: formatShortDate(d.reservationDate) },
            { label: "Time", value: d.timeSlot },
            { label: "Party Size", value: String(d.partySize) },
          );
          if (d.tablePreference) rows.push({ label: "Table", value: d.tablePreference });
        }
        break;
      }
      case "tour": {
        const d = booking.tourDetails;
        if (d) {
          rows.push(
            { label: "Tour Date", value: formatShortDate(d.tourDate) },
            { label: "Participants", value: String(d.participants) },
          );
          if (d.pickupLocation) rows.push({ label: "Pickup", value: d.pickupLocation });
        }
        break;
      }
      case "event": {
        const d = booking.eventDetails;
        if (d) {
          rows.push(
            { label: "Event Date", value: formatShortDate(d.eventDate) },
            { label: "Ticket Type", value: d.ticketType },
            { label: "Tickets", value: String(d.ticketCount) },
          );
        }
        break;
      }
    }
    return rows;
  }, [booking]);

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/40 p-0 sm:items-center sm:p-4" role="dialog" aria-modal>
      <button type="button" className="absolute inset-0 cursor-default" aria-label="Close" onClick={onClose} />
      <div className="relative z-10 max-h-[90vh] w-full max-w-lg overflow-y-auto rounded-t-2xl border border-[var(--color-border)] bg-gray-50 shadow-xl sm:rounded-2xl">
        <div className="sticky top-0 z-10 flex justify-center bg-gray-50 pb-2 pt-3">
          <div className="h-1 w-10 rounded-full bg-[var(--color-border)]" />
        </div>
        <div className="space-y-5 px-5 pb-8 pt-2">
          <div className="flex flex-wrap items-start justify-between gap-2">
            <h2 className="text-lg font-bold">
              {bookingTypeIcon(booking.type)} {bookingTypeLabel(booking.type)} Booking
            </h2>
            <span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${statusChipClasses(booking.status)}`}>
              {bookingStatusLabel(booking.status)}
            </span>
          </div>

          <section>
            <h3 className="mb-2 text-sm font-bold text-muted">Customer</h3>
            <div className="rounded-xl border border-[var(--color-border)] bg-white p-4 text-sm">
              <DetailRow label="Name" value={booking.customerName} />
              {booking.customerEmail ? <DetailRow label="Email" value={booking.customerEmail} /> : null}
              {booking.customerPhone ? <DetailRow label="Phone" value={booking.customerPhone} /> : null}
            </div>
          </section>

          <section>
            <h3 className="mb-2 text-sm font-bold text-muted">Booking Info</h3>
            <div className="rounded-xl border border-[var(--color-border)] bg-white p-4 text-sm">
              {infoRows.map((r) => (
                <DetailRow key={r.label} label={r.label} value={r.value} />
              ))}
            </div>
          </section>

          <section>
            <h3 className="mb-2 text-sm font-bold text-muted">Payment</h3>
            <div className="rounded-xl border border-[var(--color-border)] bg-white p-4 text-sm">
              <DetailRow label="Amount" value={formatMoney(booking.totalAmount, booking.currency)} />
              <DetailRow label="Method" value={paymentMethodLabel(booking.paymentMethod)} />
              <DetailRow label="Status" value={paymentStatusLabel(booking.paymentStatus)} />
            </div>
          </section>

          {booking.specialRequests ? (
            <section>
              <h3 className="mb-2 text-sm font-bold text-muted">Special Requests</h3>
              <div className="rounded-xl border border-[var(--color-border)] bg-white p-4 text-sm">{booking.specialRequests}</div>
            </section>
          ) : null}

          {booking.status === "pending" ? (
            <div className="flex gap-3">
              <button
                type="button"
                className="btn flex-1 rounded-lg border border-[var(--color-danger)] py-2.5 text-sm font-semibold text-[var(--color-danger)] hover:bg-[var(--color-danger)]/5"
                onClick={onDecline}
              >
                Decline
              </button>
              <button type="button" className="btn btn-primary flex-1 rounded-lg py-2.5 text-sm font-semibold" onClick={onConfirm}>
                Confirm
              </button>
            </div>
          ) : null}
          {booking.status === "confirmed" ? (
            <button type="button" className="btn btn-primary w-full rounded-lg py-2.5 text-sm font-semibold" onClick={onCheckIn}>
              Check In Guest
            </button>
          ) : null}
        </div>
      </div>
    </div>
  );
}

function DetailRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4 border-b border-[var(--color-border)] py-2 last:border-0">
      <span className="text-muted">{label}</span>
      <span className="max-w-[55%] text-right font-semibold text-[var(--foreground)]">{value}</span>
    </div>
  );
}

export function BookingsPageClient() {
  const bookings = useMerchantDemoStore((s) => s.bookings);
  const updateBookingStatus = useMerchantDemoStore((s) => s.updateBookingStatus);
  const filterBookingsByType = useMerchantDemoStore((s) => s.filterBookingsByType);
  const clearBookingFilters = useMerchantDemoStore((s) => s.clearBookingFilters);

  const [tab, setTab] = useState<"all" | BookingStatus>("all");
  const [filterOpen, setFilterOpen] = useState(false);
  const [selected, setSelected] = useState<Booking | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const [isFiltered, setIsFiltered] = useState(false);

  const showToast = useCallback((msg: string) => {
    setToast(msg);
    window.setTimeout(() => setToast(null), 3200);
  }, []);

  const filteredByTab = useMemo(() => {
    if (tab === "all") return bookings;
    return bookings.filter((b) => b.status === tab);
  }, [bookings, tab]);

  const countFor = useCallback(
    (status: BookingStatus | "all") => {
      if (status === "all") return bookings.length;
      return bookings.filter((b) => b.status === status).length;
    },
    [bookings],
  );

  const emptyMessage = useMemo(() => {
    switch (tab) {
      case "pending":
        return "No pending bookings";
      case "confirmed":
        return "No confirmed bookings";
      case "completed":
        return "No completed bookings";
      default:
        return "No bookings yet";
    }
  }, [tab]);

  const handleFilterType = (type: BookingType) => {
    filterBookingsByType(type);
    setIsFiltered(true);
    setFilterOpen(false);
  };

  const handleClearFilters = () => {
    clearBookingFilters();
    setIsFiltered(false);
    setFilterOpen(false);
  };

  return (
    <div>
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">Bookings</h1>
        <div className="flex flex-wrap items-center gap-2">
          {isFiltered ? (
            <button type="button" className="rounded-lg border border-primary/30 bg-primary/5 px-3 py-1.5 text-xs font-semibold text-primary" onClick={handleClearFilters}>
              Clear type filter
            </button>
          ) : null}
          <button
            type="button"
            className="inline-flex items-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-3 py-2 text-sm font-medium shadow-sm hover:bg-gray-50"
            onClick={() => setFilterOpen(true)}
          >
            <Filter className="size-4" />
            Filter
          </button>
        </div>
      </div>

      <div className="mb-6 flex gap-1 overflow-x-auto rounded-xl border border-[var(--color-border)] bg-white p-1 shadow-sm">
        {TABS.map((t) => {
          const active = tab === t.key;
          const n = countFor(t.key);
          return (
            <button
              key={String(t.key)}
              type="button"
              onClick={() => setTab(t.key)}
              className={`shrink-0 rounded-lg px-4 py-2 text-sm font-semibold transition ${
                active ? "bg-primary text-white" : "text-muted hover:bg-gray-50"
              }`}
            >
              {t.label(n)}
            </button>
          );
        })}
      </div>

      {filteredByTab.length === 0 ? (
        <div className="flex min-h-[280px] flex-col items-center justify-center rounded-2xl border border-[var(--color-border)] bg-white py-16 text-muted">
          <CalendarDays className="mb-4 size-14 opacity-40" />
          <p>{emptyMessage}</p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {filteredByTab.map((b) => (
            <BookingCard key={b.id} booking={b} onOpen={setSelected} />
          ))}
        </div>
      )}

      {filterOpen ? (
        <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/40 sm:items-center" role="dialog">
          <button type="button" className="absolute inset-0" aria-label="Close" onClick={() => setFilterOpen(false)} />
          <div className="relative z-10 w-full max-w-md rounded-t-3xl bg-gray-50 p-4 shadow-xl sm:rounded-2xl">
            <div className="mx-auto mb-3 h-1 w-10 rounded-full bg-[var(--color-border)]" />
            <h2 className="mb-4 text-lg font-bold">Filter by Type</h2>
            <div className="space-y-0 rounded-xl border border-[var(--color-border)] bg-white overflow-hidden">
              {(["accommodation", "dining", "tour", "event"] as const).map((type) => (
                <button
                  key={type}
                  type="button"
                  className="flex w-full items-center gap-3 border-b border-[var(--color-border)] px-4 py-3 text-left text-sm last:border-0 hover:bg-gray-50"
                  onClick={() => handleFilterType(type)}
                >
                  <span className="text-2xl">{bookingTypeFilterIcon(type)}</span>
                  {bookingTypeLabel(type)}
                </button>
              ))}
            </div>
            <button type="button" className="mt-3 flex w-full items-center gap-2 rounded-xl border border-[var(--color-border)] bg-white px-4 py-3 text-sm font-medium hover:bg-gray-50" onClick={handleClearFilters}>
              Clear Filters
            </button>
          </div>
        </div>
      ) : null}

      {selected ? (
        <BookingDetailSheet
          booking={selected}
          onClose={() => setSelected(null)}
          onConfirm={() => {
            updateBookingStatus(selected.id, "confirmed");
            setSelected(null);
            showToast(`Booking for ${selected.customerName} confirmed`);
          }}
          onDecline={() => {
            if (typeof window !== "undefined" && !window.confirm(`Decline booking for ${selected.customerName}?`)) return;
            updateBookingStatus(selected.id, "cancelled");
            setSelected(null);
            showToast("Booking declined");
          }}
          onCheckIn={() => {
            updateBookingStatus(selected.id, "checkedIn");
            setSelected(null);
            showToast(`${selected.customerName} checked in successfully`);
          }}
        />
      ) : null}

      {toast ? (
        <div className="fixed bottom-6 left-1/2 z-[60] max-w-sm -translate-x-1/2 rounded-lg bg-[var(--foreground)] px-4 py-3 text-center text-sm text-white shadow-lg">
          {toast}
        </div>
      ) : null}
    </div>
  );
}
