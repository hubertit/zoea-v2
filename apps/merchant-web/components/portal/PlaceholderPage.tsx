export function PlaceholderPage({ title, description }: { title: string; description?: string }) {
  return (
    <div className="space-y-2">
      <h1 className="text-2xl font-semibold tracking-tight text-gray-900">{title}</h1>
      {description ? <p className="max-w-2xl text-sm text-gray-600 sm:text-base">{description}</p> : null}
      <div className="mt-8 rounded-2xl border border-gray-200 bg-white p-8 text-center text-sm text-gray-500 shadow-sm">
        This section will mirror the merchant mobile app. API wiring comes next.
      </div>
    </div>
  );
}
