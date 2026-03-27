import { NextResponse } from 'next/server';

/** Hosted API used when local `NEXT_PUBLIC_API_URL` points at this Next server (same origin) or is unreachable. */
const DEFAULT_PUBLIC_API_BASE =
  'https://zoea-africa.qtsoftwareltd.com/api';

function normalizeApiBase(raw: string): string {
  const t = raw.replace(/\/$/, '');
  if (t.endsWith('/api')) return t;
  return `${t}/api`;
}

function healthUrlForBase(apiBase: string): string {
  return `${normalizeApiBase(apiBase)}/health`;
}

/**
 * Same-origin health probe for the admin UI.
 * The browser calls this route; the server fetches the real API `/health`
 * so browser CORS does not apply. Upstream URL comes from `NEXT_PUBLIC_API_URL`
 * (must be the Nest base URL ending in `/api`, not the admin app itself).
 */
export async function GET(request: Request) {
  const configured =
    process.env.NEXT_PUBLIC_API_URL?.trim() || DEFAULT_PUBLIC_API_BASE;

  let apiBase = normalizeApiBase(configured);

  try {
    const host = request.headers.get('host');
    const proto = request.headers.get('x-forwarded-proto') ?? 'http';
    if (host) {
      const requestOrigin = `${proto}://${host}`;
      const apiOrigin = new URL(apiBase).origin;
      if (apiOrigin === requestOrigin) {
        // e.g. admin + API both configured on :3000 — would recurse; use hosted health.
        apiBase = normalizeApiBase(DEFAULT_PUBLIC_API_BASE);
      }
    }
  } catch {
    /* ignore URL parse errors */
  }

  const url = `${apiBase}/health`;

  try {
    const res = await fetch(url, {
      cache: 'no-store',
      headers: { Accept: 'application/json' },
    });

    if (!res.ok) {
      if (process.env.NODE_ENV === 'development') {
        console.error(
          `[admin-web] Health upstream ${res.status} for ${url}. ` +
            'Is Nest running? `NEXT_PUBLIC_API_URL` must be your API base (e.g. http://localhost:3000/api), not the admin app.'
        );
      }
      return NextResponse.json(
        { status: 'error', message: `Upstream ${res.status}` },
        { status: 503 }
      );
    }

    const data = await res.json();
    return NextResponse.json(data);
  } catch (e) {
    if (process.env.NODE_ENV === 'development') {
      console.error(
        `[admin-web] Health fetch failed for ${url}:`,
        e instanceof Error ? e.message : e
      );
    }
    return NextResponse.json(
      { status: 'error', message: 'Health check failed' },
      { status: 503 }
    );
  }
}
