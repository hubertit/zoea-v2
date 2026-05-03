export function formatShortDate(iso: string): string {
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return iso;
  return d.toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" });
}

export function formatMoney(amount: number, currency: string): string {
  const n = Number.isInteger(amount) ? amount.toFixed(0) : amount.toFixed(2);
  return `${currency} ${n}`;
}
