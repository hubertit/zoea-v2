'use client';

import Link from 'next/link';
import Image from 'next/image';
import { useState, useEffect } from 'react';

const NAV_ITEMS = [
  { href: '/explore', label: 'Explore', emoji: '🗺️' },
  { href: '/stay', label: 'Stay', emoji: '🏨' },
  { href: '/dine', label: 'Dine', emoji: '🍽️' },
  { href: '/events', label: 'Events', emoji: '🎉' },
] as const;

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
            {NAV_ITEMS.map(({ href, label, emoji }) => (
              <Link
                key={href}
                href={href}
                className="group flex items-center gap-2.5 text-[15px] xl:text-[16px] font-medium text-gray-700 hover:text-primary transition-colors"
              >
                <span
                  className="text-xl xl:text-2xl leading-none flex-shrink-0 select-none transition-transform group-hover:scale-110"
                  aria-hidden
                >
                  {emoji}
                </span>
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
              {NAV_ITEMS.map(({ href, label, emoji }) => (
                <Link
                  key={href}
                  href={href}
                  className="group flex items-center gap-3 px-4 py-3.5 text-[16px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  <span className="text-2xl leading-none flex-shrink-0 select-none" aria-hidden>
                    {emoji}
                  </span>
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
