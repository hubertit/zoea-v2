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
      {/* YouTube Video Background */}
      <div className="absolute inset-0 w-full h-full overflow-hidden">
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

      {/* Dark Overlay */}
      <div className="absolute inset-0 bg-black/50" />
      
      <div className="relative max-w-7xl mx-auto px-6 lg:px-8 py-24 lg:py-32">
        <div className="max-w-3xl mx-auto text-center mb-12">
          <h1 className="text-5xl lg:text-6xl font-semibold mb-6 tracking-tight">
            Discover Rwanda
          </h1>
          <p className="text-xl lg:text-2xl text-white/90 font-light">
            Find the best places to stay, dine, and explore
          </p>
        </div>

        <form onSubmit={handleSearch} className="max-w-4xl mx-auto">
          <div className="bg-white rounded-2xl p-2 shadow-2xl shadow-black/20">
            <div className="flex flex-col lg:flex-row gap-2">
              <div className="flex-1 relative">
                <input
                  type="text"
                  placeholder="What are you looking for?"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-14 px-6 text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-xl hover:bg-gray-50 transition-colors"
                />
              </div>

              <div className="w-px bg-gray-200 hidden lg:block" />

              <div className="flex-1 relative">
                <input
                  type="text"
                  placeholder="Where?"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="w-full h-14 px-6 text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-xl hover:bg-gray-50 transition-colors"
                />
              </div>

              <button
                type="submit"
                className="h-14 px-8 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-all hover:scale-[1.02] active:scale-[0.98] flex items-center justify-center gap-2"
              >
                <svg
                  className="w-5 h-5"
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
                Search
              </button>
            </div>
          </div>
        </form>

        <div className="mt-10 flex flex-wrap justify-center gap-3">
          {[
            { name: 'Hotels', icon: '🏨' },
            { name: 'Restaurants', icon: '🍽️' },
            { name: 'Tours', icon: '🗺️' },
            { name: 'Attractions', icon: '🎭' },
            { name: 'Events', icon: '🎉' },
            { name: 'Nightlife', icon: '🌙' },
          ].map((category) => (
            <button
              key={category.name}
              className="px-5 py-2.5 bg-white/10 backdrop-blur-sm text-white text-[14px] font-medium rounded-full hover:bg-white/20 transition-all hover:scale-105 flex items-center gap-2"
            >
              <span>{category.icon}</span>
              {category.name}
            </button>
          ))}
        </div>
      </div>
    </section>
  );
}
