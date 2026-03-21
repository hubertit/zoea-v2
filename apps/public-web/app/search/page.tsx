'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ListingCard } from '@/components/ListingCard';
import Link from 'next/link';
import { useState, useEffect, Suspense } from 'react';
import { useSearchParams } from 'next/navigation';
import { listingsApi, type Listing } from '@/lib/api/listings';

function SearchContent() {
  const searchParams = useSearchParams();
  const query = searchParams.get('q') || '';
  const location = searchParams.get('location') || '';
  
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState(query);
  const [searchLocation, setSearchLocation] = useState(location);

  useEffect(() => {
    const fetchResults = async () => {
      if (!query && !location) {
        setLoading(false);
        return;
      }

      try {
        const response = await listingsApi.search(query, location);
        setListings(response.data);
      } catch (error) {
        console.error('Search failed:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchResults();
  }, [query, location]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const params = new URLSearchParams();
    if (searchQuery) params.set('q', searchQuery);
    if (searchLocation) params.set('location', searchLocation);
    window.location.href = `/search?${params.toString()}`;
  };

  return (
    <>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20">
        <div className="bg-gray-50 border-b border-gray-200">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
            <form onSubmit={handleSearch} className="max-w-4xl">
              <div className="bg-white rounded-xl sm:rounded-2xl p-1.5 sm:p-2 shadow-sm border border-gray-200">
                <div className="flex flex-col lg:flex-row gap-1.5 sm:gap-2">
                  <div className="flex-1">
                    <input
                      type="text"
                      placeholder="What are you looking for?"
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      className="w-full h-11 sm:h-12 px-4 sm:px-5 text-[14px] sm:text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-lg sm:rounded-xl"
                    />
                  </div>

                  <div className="w-px bg-gray-200 hidden lg:block" />

                  <div className="flex-1">
                    <input
                      type="text"
                      placeholder="Where?"
                      value={searchLocation}
                      onChange={(e) => setSearchLocation(e.target.value)}
                      className="w-full h-11 sm:h-12 px-4 sm:px-5 text-[14px] sm:text-[15px] text-gray-900 placeholder-gray-400 bg-transparent focus:outline-none rounded-lg sm:rounded-xl"
                    />
                  </div>

                  <button
                    type="submit"
                    className="h-11 sm:h-12 px-6 sm:px-8 bg-primary text-white text-[14px] sm:text-[15px] font-semibold rounded-lg sm:rounded-xl hover:bg-primary/90 transition-all"
                  >
                    Search
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
          {loading ? (
            <div className="text-center py-16 sm:py-20">
              <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <>
              <div className="mb-6 sm:mb-8">
                <h1 className="text-xl sm:text-2xl lg:text-3xl font-semibold text-gray-900 mb-2">
                  Search Results
                </h1>
                <p className="text-[14px] sm:text-[15px] text-gray-600">
                  {listings.length > 0 
                    ? `Found ${listings.length} ${listings.length === 1 ? 'place' : 'places'}`
                    : 'No results found'
                  }
                  {query && ` for "${query}"`}
                  {location && ` in ${location}`}
                </p>
              </div>

              {listings.length > 0 ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5 sm:gap-6 lg:gap-8">
                  {listings
                    .filter((listing) => listing.city?.name)
                    .map((listing) => (
                      <ListingCard
                        key={listing.id}
                        id={listing.id}
                        name={listing.name}
                        slug={listing.slug}
                        image={listing.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                        city={listing.city?.name || ''}
                        rating={typeof listing.rating === 'number' ? listing.rating : parseFloat(listing.rating || '0')}
                        reviewCount={listing.reviewCount}
                        priceRange={listing.priceRange || `${listing.minPrice}-${listing.maxPrice} ${listing.currency}`}
                        isVerified={listing.isVerified}
                      />
                    ))}
                </div>
              ) : (
                <div className="text-center py-16 sm:py-20 bg-gray-50 rounded-xl sm:rounded-2xl">
                  <svg className="w-14 h-14 sm:w-16 sm:h-16 text-gray-300 mx-auto mb-3 sm:mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                  <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-2">No results found</h2>
                  <p className="text-[14px] sm:text-[15px] text-gray-600 mb-5 sm:mb-6 px-4">
                    Try adjusting your search or browse our categories
                  </p>
                  <Link
                    href="/"
                    className="inline-block px-5 sm:px-6 py-2.5 sm:py-3 bg-primary text-white text-[14px] sm:text-[15px] font-semibold rounded-lg sm:rounded-xl hover:bg-primary/90 transition-colors"
                  >
                    Back to home
                  </Link>
                </div>
              )}
            </>
          )}
        </div>
      </main>
      <Footer />
    </>
  );
}

export default function SearchPage() {
  return (
    <Suspense fallback={
      <>
        <Header />
        <main className="pt-16 sm:pt-18 lg:pt-20 min-h-screen flex items-center justify-center">
          <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        </main>
        <Footer />
      </>
    }>
      <SearchContent />
    </Suspense>
  );
}
