'use client';

import Link from 'next/link';
import { Header } from '@/components/Header';
import { Hero } from '@/components/Hero';
import { CategoryCard } from '@/components/CategoryCard';
import { ListingCard } from '@/components/ListingCard';

const categories = [
  { name: 'Hotels', slug: 'hotels', image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800', count: 124 },
  { name: 'Restaurants', slug: 'restaurants', image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800', count: 89 },
  { name: 'Tours', slug: 'tours', image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800', count: 56 },
  { name: 'Attractions', slug: 'attractions', image: 'https://images.unsplash.com/photo-1533587851505-d119e13fa0d7?w=800', count: 42 },
];

const listings = [
  { id: '1', name: 'Kigali Serena Hotel', slug: 'kigali-serena-hotel', image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800', city: 'Kigali', rating: 4.8, reviewCount: 245, priceRange: '$$$', isVerified: true },
  { id: '2', name: 'Heaven Restaurant', slug: 'heaven-restaurant', image: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800', city: 'Kigali', rating: 4.6, reviewCount: 189, priceRange: '$$', isVerified: true },
  { id: '3', name: 'Volcanoes National Park', slug: 'volcanoes-national-park', image: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', city: 'Musanze', rating: 4.9, reviewCount: 512, priceRange: '$$$', isVerified: true },
  { id: '4', name: 'Inema Arts Center', slug: 'inema-arts-center', image: 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800', city: 'Kigali', rating: 4.7, reviewCount: 156, priceRange: '$', isVerified: false },
];

export default function Home() {
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
                <CategoryCard key={category.slug} {...category} />
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
              {listings.map((listing) => (
                <ListingCard key={listing.id} {...listing} />
              ))}
            </div>
          </div>
        </section>
      </main>
    </>
  );
}

