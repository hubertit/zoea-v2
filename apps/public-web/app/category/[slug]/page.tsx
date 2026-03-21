'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ListingCard } from '@/components/ListingCard';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { categoriesApi, type Category } from '@/lib/api/categories';
import { listingsApi, type Listing } from '@/lib/api/listings';

export default function CategoryPage() {
  const params = useParams();
  const slug = params.slug as string;
  
  const [category, setCategory] = useState<Category | null>(null);
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState('recommended');
  const [priceFilter, setPriceFilter] = useState('all');

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [categoryData, listingsData] = await Promise.all([
          categoriesApi.getBySlug(slug),
          listingsApi.getByCategory(slug, { limit: 20 }),
        ]);
        setCategory(categoryData);
        setListings(listingsData.data);
      } catch (error) {
        console.error('Failed to fetch category data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [slug]);

  if (loading) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        </main>
        <Footer />
      </>
    );
  }

  if (!category) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Category not found</h1>
            <Link href="/" className="text-primary hover:underline">
              Back to home
            </Link>
          </div>
        </main>
        <Footer />
      </>
    );
  }

  return (
    <>
      <Header />
      <main className="pt-20">
        <div className="bg-gray-50 border-b border-gray-200">
          <div className="max-w-7xl mx-auto px-6 lg:px-8 py-12">
            <Link
              href="/"
              className="inline-flex items-center gap-2 text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-6"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
              Back to explore
            </Link>

            <h1 className="text-4xl lg:text-5xl font-semibold text-gray-900 mb-3">
              {category.name}
            </h1>
            <p className="text-[15px] text-gray-600">
              {category.description || `Discover the best ${category.name.toLowerCase()} in Rwanda`} · {category.listingCount} places
            </p>
          </div>
        </div>

        <div className="max-w-7xl mx-auto px-6 lg:px-8 py-8 lg:py-12">
          <div className="flex flex-col md:flex-row gap-4 justify-between items-start md:items-center mb-8">
            <p className="text-[15px] text-gray-600">
              Showing {listings.length} of {category.listingCount} places
            </p>

            <div className="flex flex-wrap gap-3">
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="px-4 py-2.5 text-[14px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent bg-white"
              >
                <option value="recommended">Recommended</option>
                <option value="rating">Highest Rated</option>
                <option value="reviews">Most Reviewed</option>
                <option value="price-low">Price: Low to High</option>
                <option value="price-high">Price: High to Low</option>
              </select>

              <select
                value={priceFilter}
                onChange={(e) => setPriceFilter(e.target.value)}
                className="px-4 py-2.5 text-[14px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent bg-white"
              >
                <option value="all">All Prices</option>
                <option value="$">$ - Budget</option>
                <option value="$$">$$ - Moderate</option>
                <option value="$$$">$$$ - Luxury</option>
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 lg:gap-8">
            {listings.map((listing) => (
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
      </main>
      <Footer />
    </>
  );
}
