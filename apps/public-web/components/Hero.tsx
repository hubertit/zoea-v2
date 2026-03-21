'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export function Hero() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [location, setLocation] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const params = new URLSearchParams();
    if (searchQuery) params.set('q', searchQuery);
    if (location) params.set('location', location);
    router.push(`/search?${params.toString()}`);
  };

  return (
    <section className="relative bg-gradient-to-br from-primary via-gray-900 to-gray-800 text-white overflow-hidden">
      {/* YouTube Video Background - Hidden on mobile for performance */}
      <div className="hidden md:block absolute inset-0 w-full h-full overflow-hidden">
        <iframe
          className="absolute top-1/2 left-1/2 w-[100vw] h-[56.25vw] min-h-[100vh] min-w-[177.77vh] -translate-x-1/2 -translate-y-1/2"
          src="https://www.youtube.com/embed/-kerFdxWG-w?autoplay=1&mute=1&loop=1&playlist=-kerFdxWG-w&controls=0&showinfo=0&rel=0&modestbranding=1&playsinline=1&enablejsapi=1"
          title="Background video"
          allow="autoplay; encrypted-media"
          style={{
            pointerEvents: 'none',
          }}
        />
      </div>

      {/* Gradient background for mobile */}
      <div className="md:hidden absolute inset-0 bg-gradient-to-br from-primary via-gray-900 to-gray-800">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmZmZmYiIGZpbGwtb3BhY2l0eT0iMC4wMyI+PHBhdGggZD0iTTM2IDM0djItMnptMC0ydjItMnptLTItMnYyLTJ6bTAtMnYyLTJ6bS0yLTJ2Mi0yem0wLTJ2Mi0yem0tMi0ydjItMnptMC0ydjItMnoiLz48L2c+PC9nPjwvc3ZnPg==')] opacity-40" />
      </div>

      {/* Dark Overlay */}
      <div className="absolute inset-0 bg-black/50" />
      
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 sm:py-20 lg:py-24 xl:py-32">
        <div className="max-w-3xl mx-auto text-center mb-8 sm:mb-10 lg:mb-12">
          <h1 className="text-3xl sm:text-4xl md:text-5xl lg:text-6xl font-semibold mb-4 sm:mb-5 lg:mb-6 tracking-tight px-4">
            Discover Rwanda
          </h1>
          <p className="text-base sm:text-lg md:text-xl lg:text-2xl text-white/90 font-light px-4">
            Find the best places to stay, dine, and explore
          </p>
        </div>

        <form onSubmit={handleSearch} className="max-w-4xl mx-auto px-4">
          <div className="bg-white rounded-xl sm:rounded-2xl p-1.5 sm:p-2 shadow-2xl shadow-black/20">
            <div className="flex flex-col lg:flex-row gap-1.5 sm:gap-2">
              <div className="flex-1 relative">
                <input
                  type="text"
                  placeholder="What are you looking for?"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-12 sm:h-14 px-4 sm:px-6 text-[14px] sm:text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-lg sm:rounded-xl hover:bg-gray-50 transition-colors"
                />
              </div>

              <div className="w-px bg-gray-200 hidden lg:block" />

              <div className="flex-1 relative">
                <input
                  type="text"
                  placeholder="Where?"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="w-full h-12 sm:h-14 px-4 sm:px-6 text-[14px] sm:text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-lg sm:rounded-xl hover:bg-gray-50 transition-colors"
                />
              </div>

              <button
                type="submit"
                className="h-12 sm:h-14 px-6 sm:px-8 bg-primary text-white text-[14px] sm:text-[15px] font-semibold rounded-lg sm:rounded-xl hover:bg-primary/90 transition-all hover:scale-[1.02] active:scale-[0.98] flex items-center justify-center gap-2"
              >
                <svg
                  className="w-4 h-4 sm:w-5 sm:h-5"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                  />
                </svg>
                <span className="hidden sm:inline">Search</span>
                <span className="sm:hidden">Go</span>
              </button>
            </div>
          </div>
        </form>
      </div>
    </section>
  );
}
