import { NextResponse } from "next/server";

const DEFAULT_PUBLIC_API_BASE =
  "https://zoea-africa.qtsoftwareltd.com/api";

function normalizeApiBase(raw: string): string {
  const t = raw.replace(/\/$/, "");
  if (t.endsWith("/api")) return t;
  return `${t}/api`;
}

function configuredApiBase(): string {
  return (
    process.env.NEXT_PUBLIC_API_URL?.trim() ||
    process.env.NEXT_PUBLIC_API_BASE_URL?.trim() ||
    DEFAULT_PUBLIC_API_BASE
  );
}

/** Same-origin health for Docker/UI; proxies to Nest `/health` (see admin-web). */
export async function GET(request: Request) {
  let apiBase = normalizeApiBase(configuredApiBase());

  try {
    const host = request.headers.get("host");
    const proto = request.headers.get("x-forwarded-proto") ?? "http";
    if (host) {
      const requestOrigin = `${proto}://${host}`;
      const apiOrigin = new URL(apiBase).origin;
      if (apiOrigin === requestOrigin) {
        apiBase = normalizeApiBase(DEFAULT_PUBLIC_API_BASE);
      }
    }
  } catch {
    /* ignore */
  }

  const url = `${apiBase}/health`;

  try {
    const res = await fetch(url, {
      cache: "no-store",
      headers: { Accept: "application/json" },
    });

    if (!res.ok) {
      return NextResponse.json(
        { status: "error", message: `Upstream ${res.status}` },
        { status: 503 }
      );
    }

    const data = await res.json();
    return NextResponse.json(data);
  } catch {
    return NextResponse.json(
      { status: "error", message: "Health check failed" },
      { status: 503 }
    );
  }
}
