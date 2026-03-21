'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';

export function Header() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 10);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled 
          ? 'bg-white/95 backdrop-blur-md shadow-sm' 
          : 'bg-white'
      }`}
    >
      <div className="max-w-7xl mx-auto px-6 lg:px-8">
        <div className="flex items-center justify-between h-20">
          <Link href="/" className="flex items-center gap-3 group">
            <div className="w-11 h-11 bg-primary rounded-xl flex items-center justify-center transition-transform group-hover:scale-105">
              <span className="text-white font-semibold text-xl">Z</span>
            </div>
            <span className="text-xl font-semibold text-gray-900 tracking-tight">zoea</span>
          </Link>

          <nav className="hidden lg:flex items-center gap-10">
            <Link
              href="/explore"
              className="text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
            >
              Explore
            </Link>
            <Link
              href="/stay"
              className="text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
            >
              Stay
            </Link>
            <Link
              href="/dine"
              className="text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
            >
              Dine
            </Link>
            <Link
              href="/events"
              className="text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
            >
              Events
            </Link>
          </nav>

          <div className="flex items-center gap-4">
            <Link
              href="/login"
              className="hidden lg:block text-[15px] font-medium text-gray-700 hover:text-primary transition-colors"
            >
              Sign in
            </Link>
            <Link
              href="/signup"
              className="px-5 py-2.5 bg-primary text-white text-[15px] font-medium rounded-xl hover:bg-primary/90 transition-all"
            >
              Sign up
            </Link>

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
          <div className="lg:hidden border-t border-gray-100 py-4 animate-in fade-in slide-in-from-top-2 duration-200">
            <nav className="flex flex-col gap-1">
              <Link
                href="/explore"
                className="px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                onClick={() => setMobileMenuOpen(false)}
              >
                Explore
              </Link>
              <Link
                href="/stay"
                className="px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                onClick={() => setMobileMenuOpen(false)}
              >
                Stay
              </Link>
              <Link
                href="/dine"
                className="px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                onClick={() => setMobileMenuOpen(false)}
              >
                Dine
              </Link>
              <Link
                href="/events"
                className="px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                onClick={() => setMobileMenuOpen(false)}
              >
                Events
              </Link>
              <div className="h-px bg-gray-100 my-2" />
              <Link
                href="/login"
                className="px-4 py-3 text-[15px] font-medium text-gray-700 hover:text-primary hover:bg-gray-50 rounded-lg transition-colors"
                onClick={() => setMobileMenuOpen(false)}
              >
                Sign in
              </Link>
            </nav>
          </div>
        )}
      </div>
    </header>
  );
}
