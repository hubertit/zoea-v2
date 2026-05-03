const SESSION_KEY = "zoea_merchant_portal_session";

export type PortalSession = {
  displayName: string;
  email: string;
};

export function getPortalSession(): PortalSession | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = sessionStorage.getItem(SESSION_KEY);
    if (!raw) return null;
    return JSON.parse(raw) as PortalSession;
  } catch {
    return null;
  }
}

export function setPortalSession(session: PortalSession): void {
  sessionStorage.setItem(SESSION_KEY, JSON.stringify(session));
}

export function clearPortalSession(): void {
  sessionStorage.removeItem(SESSION_KEY);
}

export const PORTAL_SIDEBAR_COLLAPSED_KEY = "zoea_merchant_sidebar_collapsed";
