'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ListingCard } from '@/components/ListingCard';
import Link from 'next/link';
import { useState } from 'react';

export default function CategoryPage() {
  const [sortBy, setSortBy] = useState('recommended');
  const [priceFilter, setPriceFilter] = useState('all');

  const category = {
    name: 'Hotels',
    description: 'Find the perfect place to stay in Rwanda',
    count: 124,
  };

  const listings = [
    { id: '1', name: 'Kigali Serena Hotel', slug: 'kigali-serena-hotel', image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800', city: 'Kigali', rating: 4.8, reviewCount: 245, priceRange: '$$$', isVerified: true },
    { id: '2', name: 'Radisson Blu Hotel', slug: 'radisson-blu', image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800', city: 'Kigali', rating: 4.7, reviewCount: 189, priceRange: '$$$', isVerified: true },
    { id: '3', name: 'The Retreat', slug: 'the-retreat', image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', city: 'Kigali', rating: 4.6, reviewCount: 156, priceRange: '$$', isVerified: false },
    { id: '4', name: 'Gorilla Mountain View Lodge', slug: 'gorilla-lodge', image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800', city: 'Musanze', rating: 4.9, reviewCount: 312, priceRange: '$$$', isVerified: true },
    { id: '5', name: 'Lake Kivu Hotel', slug: 'lake-kivu-hotel', image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', city: 'Gisenyi', rating: 4.5, reviewCount: 198, priceRange: '$$', isVerified: true },
    { id: '6', name: 'Akagera Game Lodge', slug: 'akagera-lodge', image: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800', city: 'Akagera', rating: 4.7, reviewCount: 267, priceRange: '$$$', isVerified: true },
  ];

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
              {category.description} · {category.count} places
            </p>
          </div>
        </div>

        <div className="max-w-7xl mx-auto px-6 lg:px-8 py-8 lg:py-12">
          <div className="flex flex-col md:flex-row gap-4 justify-between items-start md:items-center mb-8">
            <p className="text-[15px] text-gray-600">
              Showing {listings.length} of {category.count} places
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
              <ListingCard key={listing.id} {...listing} />
            ))}
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
