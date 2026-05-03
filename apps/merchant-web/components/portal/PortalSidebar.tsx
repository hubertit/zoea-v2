"use client";

import { useCallback } from "react";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { ChevronsLeft, ChevronsRight, User } from "lucide-react";
import { MERCHANT_NAV_ITEMS } from "@/lib/config/merchant-nav.config";
import { getPortalSession } from "@/lib/auth/portal-session";
import { routes } from "@/lib/config/nav.config";

type PortalSidebarProps = {
  isOpen: boolean;
  collapsed: boolean;
  onClose: () => void;
  onCollapsedChange: (collapsed: boolean) => void;
};

export function PortalSidebar({ isOpen, collapsed, onClose, onCollapsedChange }: PortalSidebarProps) {
  const pathname = usePathname();
  const session = getPortalSession();
  const displayName = session?.displayName ?? "Merchant";
  const email = session?.email ?? "";

  const isActive = useCallback(
    (href: string) => pathname === href || !!pathname?.startsWith(`${href}/`),
    [pathname],
  );

  const handleLinkClick = () => {
    if (typeof window !== "undefined" && window.innerWidth < 1024) {
      onClose();
    }
  };

  const toggleCollapse = () => {
    onCollapsedChange(!collapsed);
  };

  return (
    <>
      {isOpen ? (
        <div
          className="fixed inset-0 z-40 min-h-dvh bg-black/50 lg:hidden"
          onClick={onClose}
          onKeyDown={(e) => e.key === "Escape" && onClose()}
          role="presentation"
          aria-hidden
        />
      ) : null}

      <aside
        className={[
          "fixed left-0 top-0 z-50 flex h-full min-h-dvh max-w-[85vw] flex-col overflow-y-auto overflow-x-hidden border-r transition-all duration-300 ease-in-out sm:max-w-xs",
          "w-64 border-[#0d1118] bg-[#181e29] text-white lg:max-w-none lg:translate-x-0",
          isOpen ? "translate-x-0" : "-translate-x-full",
          collapsed ? "lg:w-20" : "lg:w-64",
        ].join(" ")}
      >
        <div className="mb-2 shrink-0 border-b border-[#0d1118] p-4 sm:mb-4 sm:p-5">
          <div className={`flex items-center ${collapsed ? "justify-center" : "gap-3"}`}>
            <Link
              href={routes.dashboard}
              className={`flex min-h-11 items-center gap-3 ${collapsed ? "flex-1 justify-center" : "min-w-0 flex-1"}`}
              onClick={handleLinkClick}
            >
              <div className="relative flex shrink-0 items-center justify-center overflow-hidden rounded-full bg-transparent">
                <Image
                  src="/logo-sidebar.png"
                  alt="Zoea"
                  width={collapsed ? 32 : 40}
                  height={collapsed ? 32 : 40}
                  className="object-contain"
                  priority
                />
              </div>
              {!collapsed ? (
                <div className="flex min-w-0 flex-col">
                  <span className="truncate text-lg font-semibold leading-tight text-white sm:text-xl">Zoea</span>
                  <span className="mt-0.5 hidden truncate text-xs leading-tight text-white/80 sm:block">
                    Merchant portal
                  </span>
                </div>
              ) : null}
            </Link>
            <span className="hidden lg:inline-flex">
              <button
                type="button"
                onClick={toggleCollapse}
                className="flex min-h-11 min-w-11 items-center justify-center rounded-sm p-2 text-gray-300 transition-colors hover:bg-[#0d1118] hover:text-white"
                aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
                title={collapsed ? "Expand sidebar" : "Collapse sidebar"}
              >
                {collapsed ? <ChevronsRight className="size-4" /> : <ChevronsLeft className="size-4" />}
              </button>
            </span>
          </div>
        </div>

        <div
          className={`mb-2 flex shrink-0 flex-col items-center gap-3 p-4 sm:mb-4 sm:gap-4 sm:p-6 ${collapsed ? "lg:px-3" : ""}`}
        >
          <div
            className={[
              "flex items-center justify-center rounded-full border-2 border-white/30 bg-black/20 text-white transition-all duration-300 hover:border-white/50 hover:bg-black/30 active:scale-105",
              "h-14 w-14 sm:h-20 sm:w-20",
              collapsed ? "lg:h-12 lg:w-12" : "lg:h-24 lg:w-24",
            ].join(" ")}
          >
            <User className={collapsed ? "size-5" : "size-8"} strokeWidth={1.5} />
          </div>
          {!collapsed ? (
            <div className="w-full min-w-0 text-center">
              <div className="mb-0.5 truncate text-sm font-semibold text-white">{displayName}</div>
              {email ? <div className="mx-auto max-w-[12rem] truncate text-xs text-gray-300">{email}</div> : null}
            </div>
          ) : null}
        </div>

        <nav className="flex min-h-0 flex-1 flex-col overflow-y-auto py-0">
          <ul className="m-0 flex list-none flex-col gap-0 p-0">
            {MERCHANT_NAV_ITEMS.map((item) => {
              const active = isActive(item.href);
              const Icon = item.icon;
              return (
                <li key={item.href} className="my-0.5">
                  <Link
                    href={item.href}
                    onClick={handleLinkClick}
                    title={collapsed ? item.label : undefined}
                    className={[
                      "flex min-h-[44px] w-full items-center gap-3 px-4 py-3 text-left transition-all duration-200 sm:px-5 sm:py-4 md:px-7",
                      collapsed ? "justify-center px-3" : "",
                      active
                        ? "border-l-4 border-white/30 bg-[#0d1118] text-white"
                        : "border-l-4 border-transparent text-gray-300 hover:bg-[#0d1118] hover:text-white active:bg-[#0d1118]",
                    ].join(" ")}
                  >
                    <Icon className={`size-[18px] shrink-0 ${active ? "text-white" : "text-gray-300"}`} strokeWidth={2} />
                    {!collapsed ? (
                      <span className="flex-1 overflow-hidden text-ellipsis whitespace-nowrap text-sm font-medium">
                        {item.label}
                      </span>
                    ) : null}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
      </aside>
    </>
  );
}
