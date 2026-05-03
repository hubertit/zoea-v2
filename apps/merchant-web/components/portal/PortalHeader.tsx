"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Bell, ChevronDown, Menu, Search, User, LogOut, Settings } from "lucide-react";
import { clearPortalSession, getPortalSession } from "@/lib/auth/portal-session";
import { routes } from "@/lib/config/nav.config";

type PortalHeaderProps = {
  onMenuToggle: () => void;
};

export function PortalHeader({ onMenuToggle }: PortalHeaderProps) {
  const router = useRouter();
  const session = getPortalSession();
  const [searchTerm, setSearchTerm] = useState("");
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const [notificationsOpen, setNotificationsOpen] = useState(false);

  const userMenuRef = useRef<HTMLDivElement>(null);
  const notificationsRef = useRef<HTMLDivElement>(null);

  const userName = session?.displayName ?? "Merchant";
  const userEmail = session?.email ?? "";

  const notifications: { id: string; title: string; time: string; read: boolean }[] = [];
  const unreadCount = 0;

  useEffect(() => {
    const close = (e: MouseEvent) => {
      const t = e.target as Node;
      if (userMenuRef.current && !userMenuRef.current.contains(t)) setUserMenuOpen(false);
      if (notificationsRef.current && !notificationsRef.current.contains(t)) setNotificationsOpen(false);
    };
    if (userMenuOpen || notificationsOpen) {
      document.addEventListener("mousedown", close);
    }
    return () => document.removeEventListener("mousedown", close);
  }, [userMenuOpen, notificationsOpen]);

  const handleLogout = () => {
    clearPortalSession();
    router.push(routes.login);
  };

  return (
    <header className="safe-area-inset sticky top-0 z-50 border-b border-gray-200 bg-white">
      <div className="flex min-h-14 items-center gap-2 px-3 sm:min-h-16 sm:gap-4 sm:px-4 md:min-h-[72px] md:px-6 lg:h-20 lg:px-8">
        <button
          type="button"
          onClick={onMenuToggle}
          className="mr-1 flex min-h-11 min-w-11 flex-shrink-0 cursor-pointer items-center justify-center rounded-lg border border-gray-200 bg-gray-50 p-2.5 text-gray-900 transition-all hover:border-gray-300 hover:bg-gray-100 hover:text-primary active:scale-95 active:bg-gray-200 lg:hidden"
          aria-label="Toggle sidebar"
        >
          <Menu className="size-4" />
        </button>

        <div className="relative hidden max-w-[200px] flex-1 sm:block md:max-w-[260px] lg:max-w-[320px] xl:max-w-[360px]">
          <div className="relative w-full">
            <div className="pointer-events-none absolute bottom-0 left-0 top-0 z-10 flex w-12 items-center justify-center text-gray-400">
              <Search className="size-4" />
            </div>
            <input
              type="text"
              placeholder="Search bookings, listings…"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full rounded-sm border border-gray-200 bg-gray-50 py-2.5 pl-12 pr-4 text-sm text-gray-900 placeholder-gray-500 focus:border-primary focus:bg-white focus:outline-none focus:ring-1 focus:ring-primary"
            />
          </div>
        </div>

        <div className="flex-1" />

        <div className="flex flex-shrink-0 items-center gap-3">
          <div className="relative" ref={notificationsRef}>
            <button
              type="button"
              onClick={() => {
                setNotificationsOpen((o) => !o);
                setUserMenuOpen(false);
              }}
              className="relative flex min-h-11 min-w-11 cursor-pointer items-center justify-center rounded-lg border-none bg-transparent p-2 text-gray-700 transition-all hover:bg-gray-100 active:scale-95"
              aria-label="Notifications"
            >
              <Bell className="size-4" />
              {unreadCount > 0 ? (
                <span className="absolute -right-0.5 -top-0.5 flex h-[18px] min-w-[18px] items-center justify-center rounded-full border-2 border-white bg-red-500 px-1 text-[10px] font-semibold text-white">
                  {unreadCount > 9 ? "9+" : unreadCount}
                </span>
              ) : null}
            </button>

            {notificationsOpen ? (
              <div className="absolute right-0 top-full z-[1000] mt-2 max-h-[70vh] w-[min(100vw-2rem,20rem)] overflow-y-auto rounded-xl border border-gray-200 bg-white sm:max-h-96 sm:w-80">
                <div className="flex items-center justify-between border-b border-gray-200 p-4">
                  <h3 className="m-0 text-sm font-semibold text-gray-900">Notifications</h3>
                  <Link
                    href={routes.dashboard}
                    onClick={() => setNotificationsOpen(false)}
                    className="text-sm text-primary no-underline hover:opacity-80"
                  >
                    View all
                  </Link>
                </div>
                <div className="max-h-[300px] overflow-y-auto py-2">
                  {notifications.length === 0 ? (
                    <div className="p-8 text-center">
                      <p className="m-0 text-sm text-gray-500">No notifications</p>
                    </div>
                  ) : null}
                </div>
              </div>
            ) : null}
          </div>

          <div className="relative flex items-center gap-3" ref={userMenuRef}>
            <div className="hidden text-right sm:block">
              <p className="m-0 text-sm font-semibold leading-tight text-gray-900">{userName}</p>
              <p className="m-0 truncate text-xs leading-tight text-gray-500">{userEmail || "—"}</p>
            </div>
            <button
              type="button"
              onClick={() => {
                setUserMenuOpen((o) => !o);
                setNotificationsOpen(false);
              }}
              className="flex min-h-11 cursor-pointer items-center gap-2 rounded-lg border-none bg-transparent p-2 transition-all hover:bg-gray-100 active:scale-95"
              aria-label="User menu"
            >
              <div className="flex size-9 flex-shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary">
                <User className="size-4" />
              </div>
              <ChevronDown
                className={`size-4 flex-shrink-0 text-gray-600 transition-transform ${userMenuOpen ? "rotate-180" : ""}`}
              />
            </button>

            {userMenuOpen ? (
              <div className="absolute right-0 top-full z-[1000] mt-2 w-48 min-w-[200px] max-w-[calc(100vw-2rem)] rounded-xl border border-gray-200 bg-white shadow-lg">
                <div className="py-1">
                  <div className="border-b border-gray-200 px-4 py-3">
                    <p className="m-0 mb-1 text-sm font-semibold text-gray-900">{userName}</p>
                    <p className="m-0 text-xs text-gray-500">{userEmail || "No email"}</p>
                  </div>
                  <div className="my-1 h-px bg-gray-200" />
                  <Link
                    href={routes.profile}
                    onClick={() => setUserMenuOpen(false)}
                    className="flex w-full cursor-pointer items-center gap-3 border-none bg-transparent px-4 py-3 text-left text-sm text-gray-700 no-underline transition-colors hover:bg-gray-50"
                  >
                    <Settings className="size-4 text-gray-500" />
                    <span>Profile &amp; settings</span>
                  </Link>
                  <div className="my-1 h-px bg-gray-200" />
                  <button
                    type="button"
                    onClick={handleLogout}
                    className="flex w-full cursor-pointer items-center gap-3 border-none bg-transparent px-4 py-3 text-left text-sm text-red-600 transition-colors hover:bg-red-50"
                  >
                    <LogOut className="size-4 text-gray-500" />
                    <span>Log out</span>
                  </button>
                </div>
              </div>
            ) : null}
          </div>
        </div>
      </div>
    </header>
  );
}
