'use client';

import Link from 'next/link';
import { Header } from '@/components/Header';
import { Hero } from '@/components/Hero';
import { CategoryCard } from '@/components/CategoryCard';
import { ListingCard } from '@/components/ListingCard';
import { Footer } from '@/components/Footer';
import { useEffect, useState } from 'react';
import { categoriesApi, type Category } from '@/lib/api/categories';
import { listingsApi, type Listing } from '@/lib/api/listings';

export default function Home() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [featuredListings, setFeaturedListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [categoriesData, listingsData] = await Promise.all([
          categoriesApi.getAll(),
          listingsApi.getFeatured(8),
        ]);
        setCategories(categoriesData.slice(0, 4));
        setFeaturedListings(listingsData);
      } catch (error) {
        console.error('Failed to fetch data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <>
        <Header />
        <Hero />
        <main className="py-20">
          <div className="max-w-7xl mx-auto px-6 lg:px-8 text-center">
            <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
          </div>
        </main>
        <Footer />
      </>
    );
  }
  return (
    <>
      <Header />
      <Hero />
      <main>
        <section className="py-16 lg:py-20 bg-gray-50">
          <div className="max-w-7xl mx-auto px-6 lg:px-8">
            <div className="text-center mb-12">
              <p className="text-[13px] font-semibold text-gray-500 tracking-wider uppercase mb-3">
                Explore by Category
              </p>
              <h2 className="text-3xl lg:text-4xl font-semibold text-gray-900">
                What are you looking for?
              </h2>
            </div>

            <div className="grid grid-cols-2 lg:grid-cols-4 gap-5 lg:gap-6">
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
          </div>
        </section>

        <section className="py-16 lg:py-20">
          <div className="max-w-7xl mx-auto px-6 lg:px-8">
            <div className="flex items-center justify-between mb-10">
              <h2 className="text-2xl lg:text-3xl font-semibold text-gray-900">
                Featured Places
              </h2>
              <Link
                href="/featured"
                className="text-[15px] font-semibold text-primary hover:underline"
              >
                See all
              </Link>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 lg:gap-8">
              {featuredListings.map((listing) => (
                <ListingCard
                  key={listing.id}
                  id={listing.id}
                  name={listing.name}
                  slug={listing.slug}
                  image={listing.images?.[0]?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                  city={listing.location.city}
                  rating={listing.rating}
                  reviewCount={listing.reviewCount}
                  priceRange={listing.priceRange}
                  isVerified={listing.isVerified}
                />
              ))}
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </>
  );
}

