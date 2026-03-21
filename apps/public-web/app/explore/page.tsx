'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { CategoryCard } from '@/components/CategoryCard';
import { ListingCard } from '@/components/ListingCard';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { categoriesApi, type Category } from '@/lib/api/categories';
import { listingsApi, type Listing } from '@/lib/api/listings';

export default function ExplorePage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [categoriesData, listingsData] = await Promise.all([
          categoriesApi.getAll(),
          listingsApi.getFeatured(12),
        ]);
        setCategories(categoriesData);
        setListings(listingsData);
      } catch (error) {
        console.error('Failed to fetch data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  return (
    <>
      <Header />
      <main className="pt-20">
        <div className="bg-gradient-to-br from-primary via-gray-900 to-gray-800 text-white">
          <div className="max-w-7xl mx-auto px-6 lg:px-8 py-20">
            <h1 className="text-4xl lg:text-5xl font-semibold mb-4">
              Explore Rwanda
            </h1>
            <p className="text-lg text-white/90">
              Discover amazing places, experiences, and adventures
            </p>
          </div>
        </div>

        <div className="max-w-7xl mx-auto px-6 lg:px-8 py-12">
          {loading ? (
            <div className="text-center py-20">
              <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <>
              <section className="mb-16">
                <h2 className="text-2xl font-semibold text-gray-900 mb-8">
                  Browse by Category
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5 lg:gap-6">
                  {categories.map((category) => (
                    <CategoryCard
                      key={category.slug}
                      name={category.name}
                      slug={category.slug}
                      image={category.image || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                      count={category.listingCount}
                    />
                  ))}
                </div>
              </section>

              <section>
                <div className="flex items-center justify-between mb-8">
                  <h2 className="text-2xl font-semibold text-gray-900">
                    Featured Places
                  </h2>
                  <Link href="/" className="text-[15px] font-semibold text-primary hover:underline">
                    See all
                  </Link>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 lg:gap-8">
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
              </section>
            </>
          )}
        </div>
      </main>
      <Footer />
    </>
  );
}
