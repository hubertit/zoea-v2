'use client';

import Link from 'next/link';
import Image from 'next/image';
import { useState, useEffect } from 'react';

const NAV_ITEMS = [
  { href: '/explore', label: 'Explore', icon: 'explore' as const },
  { href: '/stay', label: 'Stay', icon: 'stay' as const },
  { href: '/dine', label: 'Dine', icon: 'dine' as const },
  { href: '/events', label: 'Events', icon: 'events' as const },
];

function NavMenuIcon({
  name,
  className = 'w-6 h-6',
}: {
  name: (typeof NAV_ITEMS)[number]['icon'];
  className?: string;
}) {
  const stroke = { strokeWidth: 2, strokeLinecap: 'round' as const, strokeLinejoin: 'round' as const };

  switch (name) {
    case 'explore':
      return (
        <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden>
          <path {...stroke} d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
        </svg>
      );
    case 'stay':
      return (
        <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden>
          <path {...stroke} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
      );
    case 'dine':
      return (
        <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden>
          <path {...stroke} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
      );
    case 'events':
      return (
        <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden>
          <path {...stroke} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      );
    default:
      return null;
  }
}

export function Header() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 10);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    setIsLoggedIn(!!localStorage.getItem('access_token'));
  }, []);

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled 
          ? 'bg-white/95 backdrop-blur-md shadow-sm' 
          : 'bg-white'
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 sm:h-18 lg:h-20">
          <Link href="/" className="flex items-center group flex-shrink-0">
            <Image
              src="/logo-dark.png"
              alt="Zoea"
              width={120}
              height={40}
              className="h-6 sm:h-7 lg:h-8 w-auto transition-transform group-hover:scale-105"
              priority
            />
          </Link>

          <nav className="hidden lg:flex items-center gap-5 xl:gap-8">
            {NAV_ITEMS.map(({ href, label, icon }) => (
              <Link
                key={href}
                href={href}
                className="group flex items-center gap-2.5 text-[15px] xl:text-[16px] font-medium text-gray-700 hover:text-primary transition-colors"
              >
                <NavMenuIcon
                  name={icon}
                  className="w-7 h-7 xl:w-8 xl:h-8 flex-shrink-0 text-gray-500 group-hover:text-primary transition-colors"
                />
                <span>{label}</span>
              </Link>
            ))}
          </nav>

          <div className="flex items-center gap-2 sm:gap-3 lg:gap-4">
            {isLoggedIn ? (
              <Link
                href="/profile"
                className="flex items-center gap-2 px-3 sm:px-4 py-2 text-[14px] sm:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
              >
                <svg className="w-6 h-6 xl:w-7 xl:h-7 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden>
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                <span className="hidden lg:inline">Profile</span>
              </Link>
            ) : (
              <>
                <Link
                  href="/login"
                  className="hidden sm:block text-[14px] lg:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors px-2 lg:px-0"
                >
                  Sign in
                </Link>
                <Link
                  href="/signup"
                  className="px-3 sm:px-4 lg:px-5 py-2 lg:py-2.5 bg-primary text-white text-[13px] sm:text-[14px] lg:text-[15px] font-medium rounded-lg lg:rounded-xl hover:bg-primary/90 transition-all whitespace-nowrap"
                >
                  Sign up
                </Link>
              </>
            )}

            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden p-2 text-gray-700 hover:text-primary transition-colors"
              aria-label="Menu"
            >
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                {mobileMenuOpen ? (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M6 18L18 6M6 6l12 12"
                  />
                ) : (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                )}
              </svg>
            </button>
          </div>
        </div>

        {mobileMenuOpen && (
          <div className="lg:hidden border-t border-gray-100 py-3 animate-in fade-in slide-in-from-top-2 duration-200">
            <nav className="flex flex-col gap-1">
              {NAV_ITEMS.map(({ href, label, icon }) => (
                <Link
                  key={href}
                  href={href}
                  className="group flex items-center gap-3 px-4 py-3.5 text-[16px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  <NavMenuIcon
                    name={icon}
                    className="w-8 h-8 flex-shrink-0 text-gray-500 group-hover:text-primary transition-colors"
                  />
                  {label}
                </Link>
              ))}
              {!isLoggedIn && (
                <>
                  <div className="h-px bg-gray-100 my-2" />
                  <Link
                    href="/login"
                    className="sm:hidden px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                    onClick={() => setMobileMenuOpen(false)}
                  >
                    Sign in
                  </Link>
                </>
              )}
            </nav>
          </div>
        )}
      </div>
    </header>
  );
}
