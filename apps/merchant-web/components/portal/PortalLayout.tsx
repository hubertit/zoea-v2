"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getPortalSession, PORTAL_SIDEBAR_COLLAPSED_KEY } from "@/lib/auth/portal-session";
import { routes } from "@/lib/config/nav.config";
import { PortalSidebar } from "@/components/portal/PortalSidebar";
import { PortalHeader } from "@/components/portal/PortalHeader";

type Gate = "loading" | "authed" | "unauthed";

export function PortalLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [gate, setGate] = useState<Gate>("loading");
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);

  useEffect(() => {
    queueMicrotask(() => {
      if (typeof window === "undefined") return;
      const saved = localStorage.getItem(PORTAL_SIDEBAR_COLLAPSED_KEY);
      if (saved === "true") setSidebarCollapsed(true);
      setGate(getPortalSession() ? "authed" : "unauthed");
    });
  }, []);

  useEffect(() => {
    if (gate === "unauthed") {
      router.replace(routes.login);
    }
  }, [gate, router]);

  const handleSidebarClose = useCallback(() => setSidebarOpen(false), []);
  const handleSidebarToggle = useCallback(() => setSidebarOpen((o) => !o), []);

  const handleSidebarCollapsedChange = useCallback((collapsed: boolean) => {
    setSidebarCollapsed(collapsed);
    if (typeof window !== "undefined") {
      localStorage.setItem(PORTAL_SIDEBAR_COLLAPSED_KEY, String(collapsed));
    }
  }, []);

  if (gate === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-100">
        <div className="text-center">
          <div className="mx-auto mb-4 flex size-16 animate-spin items-center justify-center rounded-full border-4 border-primary border-t-transparent" />
          <p className="text-gray-600">Loading…</p>
        </div>
      </div>
    );
  }

  if (gate === "unauthed") {
    return null;
  }

  return (
    <div className="flex h-screen min-h-[100dvh] overflow-hidden bg-gray-100">
      <PortalSidebar
        isOpen={sidebarOpen}
        collapsed={sidebarCollapsed}
        onClose={handleSidebarClose}
        onCollapsedChange={handleSidebarCollapsedChange}
      />
      <div
        className={`flex min-w-0 flex-1 flex-col transition-all duration-300 ${
          sidebarCollapsed ? "lg:ml-20" : "lg:ml-64"
        }`}
      >
        <PortalHeader onMenuToggle={handleSidebarToggle} />
        <main className="flex-1 overflow-x-hidden overflow-y-auto p-4 sm:p-5 md:p-6 lg:p-8">
          <div className="container-content">{children}</div>
        </main>
      </div>
    </div>
  );
}
