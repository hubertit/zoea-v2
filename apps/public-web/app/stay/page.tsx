'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ListingCard } from '@/components/ListingCard';
import { useState, useEffect } from 'react';
import { listingsApi, type Listing } from '@/lib/api/listings';
import { categoriesApi } from '@/lib/api/categories';

export default function StayPage() {
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchListings = async () => {
      try {
        const categories = await categoriesApi.getAll();
        const accommodationCategory = categories.find(
          (cat) => cat.slug === 'accommodation' || cat.name.toLowerCase() === 'accommodation'
        );
        
        if (accommodationCategory) {
          const response = await listingsApi.getByCategory(accommodationCategory.id, { limit: 20 });
          setListings(response.data);
        }
      } catch (error) {
        console.error('Failed to fetch accommodations:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchListings();
  }, []);

  return (
    <>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20">
        <div className="bg-gradient-to-br from-primary via-gray-900 to-gray-800 text-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 lg:py-20">
            <h1 className="text-3xl sm:text-4xl lg:text-5xl font-semibold mb-3 sm:mb-4">
              Places to Stay
            </h1>
            <p className="text-base sm:text-lg text-white/90">
              Find the perfect accommodation for your visit to Rwanda
            </p>
          </div>
        </div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
          {loading ? (
            <div className="text-center py-16 sm:py-20">
              <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
            </div>
          ) : listings.length > 0 ? (
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
              <p className="text-[14px] sm:text-[15px] text-gray-600">No accommodations found</p>
            </div>
          )}
        </div>
      </main>
      <Footer />
    </>
  );
}
