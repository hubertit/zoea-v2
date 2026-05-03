"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { X } from "lucide-react";
import { useMerchantDemoStore } from "@/lib/store/merchant-demo-store";
import { businessCategoryIcon, businessCategoryLabel } from "@/lib/merchant/labels";
import type { Business, BusinessCategory } from "@/lib/types/merchant";

const CATEGORIES: BusinessCategory[] = [
  "hotel",
  "restaurant",
  "tourOperator",
  "eventVenue",
  "attraction",
  "transportation",
  "other",
];

export function BusinessFormPageClient({ businessId }: { businessId?: string }) {
  const router = useRouter();
  const upsertBusiness = useMerchantDemoStore((s) => s.upsertBusiness);
  const businesses = useMerchantDemoStore((s) => s.businesses);
  const isEditing = Boolean(businessId);

  const existing = useMemo(
    () => (businessId ? businesses.find((b) => b.id === businessId) : undefined),
    [businessId, businesses],
  );

  const [name, setName] = useState(() => existing?.name ?? "");
  const [description, setDescription] = useState(() => existing?.description ?? "");
  const [category, setCategory] = useState<BusinessCategory>(() => existing?.category ?? "hotel");
  const [address, setAddress] = useState(() => existing?.location.address ?? "");
  const [city, setCity] = useState(() => existing?.location.city ?? "Kigali");
  const [phone, setPhone] = useState(() => existing?.contact.phone ?? "");
  const [email, setEmail] = useState(() => existing?.contact.email ?? "");
  const [website, setWebsite] = useState(() => existing?.contact.website ?? "");
  const [saving, setSaving] = useState(false);

  const handleSave = () => {
    if (!name.trim()) return;
    setSaving(true);
    const now = new Date().toISOString();
    const id = existing?.id ?? (typeof crypto !== "undefined" ? crypto.randomUUID() : `b-${Date.now()}`);
    const next: Business = {
      id,
      ownerId: existing?.ownerId ?? "1",
      name: name.trim(),
      description: description.trim(),
      category,
      location: {
        latitude: existing?.location.latitude ?? 0,
        longitude: existing?.location.longitude ?? 0,
        address: address.trim(),
        city: city.trim() || "Kigali",
        country: existing?.location.country ?? "Rwanda",
        district: existing?.location.district,
      },
      contact: {
        phone: phone.trim() || undefined,
        email: email.trim() || undefined,
        website: website.trim() || undefined,
      },
      isVerified: existing?.isVerified ?? false,
      isActive: existing?.isActive ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      listingsCount: existing?.listingsCount ?? 0,
      rating: existing?.rating ?? 0,
      reviewCount: existing?.reviewCount ?? 0,
    };
    upsertBusiness(next);
    queueMicrotask(() => {
      setSaving(false);
      router.push("/businesses");
    });
  };

  if (isEditing && businessId && !existing) {
    return (
      <div className="rounded-2xl border border-[var(--color-border)] bg-white p-8 text-center shadow-sm">
        <p className="mb-4 text-muted">Business not found.</p>
        <Link href="/businesses" className="text-sm font-semibold text-primary underline">
          Back to businesses
        </Link>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl">
      <div className="mb-6 flex items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <Link
            href="/businesses"
            className="flex size-10 items-center justify-center rounded-xl border border-[var(--color-border)] text-muted transition hover:bg-gray-50"
            aria-label="Close"
          >
            <X className="size-5" />
          </Link>
          <h1 className="text-xl font-bold sm:text-2xl">{isEditing ? "Edit Business" : "New Business"}</h1>
        </div>
        <button type="button" className="btn btn-primary rounded-lg px-4 py-2 text-sm font-semibold" disabled={saving} onClick={handleSave}>
          {saving ? "Saving…" : "Save"}
        </button>
      </div>

      <div className="space-y-8 rounded-2xl border border-[var(--color-border)] bg-white p-6 shadow-sm">
        <section>
          <h2 className="mb-4 text-base font-bold">Business Information</h2>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Business Name</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Enter your business name"
            />
          </label>
          <p className="mb-2 text-sm text-muted">Category</p>
          <div className="flex flex-wrap gap-2">
            {CATEGORIES.map((c) => {
              const selected = category === c;
              return (
                <button
                  key={c}
                  type="button"
                  onClick={() => setCategory(c)}
                  className={`inline-flex items-center gap-2 rounded-xl border px-3 py-2 text-sm font-medium transition ${
                    selected ? "border-primary bg-primary text-white" : "border-[var(--color-border)] bg-white text-[var(--foreground)] hover:bg-gray-50"
                  }`}
                >
                  <span>{businessCategoryIcon(c)}</span>
                  {businessCategoryLabel(c)}
                </button>
              );
            })}
          </div>
          <label className="mt-4 block">
            <span className="mb-1 block text-sm text-muted">Description</span>
            <textarea
              className="min-h-[100px] w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={4}
            />
          </label>
        </section>

        <section>
          <h2 className="mb-4 text-base font-bold">Location</h2>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Address</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={address}
              onChange={(e) => setAddress(e.target.value)}
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-sm text-muted">City</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={city}
              onChange={(e) => setCity(e.target.value)}
            />
          </label>
        </section>

        <section>
          <h2 className="mb-4 text-base font-bold">Contact Information</h2>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Phone</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </label>
          <label className="mb-4 block">
            <span className="mb-1 block text-sm text-muted">Email</span>
            <input
              type="email"
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-sm text-muted">Website</span>
            <input
              className="w-full rounded-lg border border-[var(--color-border)] px-3 py-2.5 text-sm outline-none focus:border-primary"
              value={website}
              onChange={(e) => setWebsite(e.target.value)}
            />
          </label>
        </section>
      </div>
    </div>
  );
}
