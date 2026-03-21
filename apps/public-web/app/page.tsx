'use client';

import Link from 'next/link';
import { Header } from '@/components/Header';
import { Hero } from '@/components/Hero';
import { CategoryCard } from '@/components/CategoryCard';
import { ListingCard } from '@/components/ListingCard';
import { NearMeCard } from '@/components/NearMeCard';
import { TourCard } from '@/components/TourCard';
import { HappeningEventCard } from '@/components/HappeningEventCard';
import { Footer } from '@/components/Footer';
import { useEffect, useState } from 'react';
import { categoriesApi, type Category } from '@/lib/api/categories';
import { listingsApi, type Listing } from '@/lib/api/listings';
import { toursApi, type Tour } from '@/lib/api/tours';
import { eventsApi, type Event } from '@/lib/api/events';

export default function Home() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [featuredListings, setFeaturedListings] = useState<Listing[]>([]);
  const [nearMeListings, setNearMeListings] = useState<Listing[]>([]);
  const [tours, setTours] = useState<Tour[]>([]);
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [categoriesData, listingsData, nearMeData, toursData, eventsData] = await Promise.all([
          categoriesApi.getAll(),
          listingsApi.getFeatured(8),
          listingsApi.getRandom(9),
          toursApi.getAll({ limit: 6 }),
          eventsApi.getAll({ limit: 6 }),
        ]);
        setCategories(categoriesData.slice(0, 4));
        setFeaturedListings(listingsData);
        setNearMeListings(nearMeData);
        setTours(toursData.data);
        setEvents(eventsData.events);
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
        <main className="py-12 sm:py-16 lg:py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
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
        <section className="py-10 sm:py-12 lg:py-14">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-8 sm:mb-10 lg:mb-12">
              <p className="text-[12px] sm:text-[13px] font-semibold text-gray-500 tracking-wider uppercase mb-2 sm:mb-3">
                Explore by Category
              </p>
              <h2 className="text-2xl sm:text-3xl lg:text-4xl font-semibold text-gray-900">
                What are you looking for?
              </h2>
            </div>

            <div className="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-3 sm:gap-4">
              {categories.map((category) => (
                <CategoryCard
                  key={category.slug}
                  name={category.name}
                  slug={category.slug}
                  icon={category.icon}
                  count={category.listingCount}
                />
              ))}
            </div>
          </div>
        </section>

        {/* Happening Section */}
        <section className="py-10 sm:py-12 lg:py-14 bg-gray-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8 sm:mb-10">
              <h2 className="text-xl sm:text-2xl lg:text-3xl font-semibold text-gray-900">
                Happening
              </h2>
              <Link
                href="/events"
                className="text-[13px] sm:text-[14px] lg:text-[15px] font-semibold text-primary hover:underline"
              >
                View More
              </Link>
            </div>

            {events.length > 0 ? (
              <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
                {events.map((event) => (
                  <HappeningEventCard key={event.id} event={event} />
                ))}
              </div>
            ) : (
              <div className="text-center py-10">
                <svg className="w-12 h-12 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <p className="text-[14px] text-gray-600">No events happening today</p>
              </div>
            )}
          </div>
        </section>

        <section className="py-10 sm:py-12 lg:py-14">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8 sm:mb-10">
              <h2 className="text-xl sm:text-2xl lg:text-3xl font-semibold text-gray-900">
                Featured Places
              </h2>
              <Link
                href="/featured"
                className="text-[13px] sm:text-[14px] lg:text-[15px] font-semibold text-primary hover:underline"
              >
                See all
              </Link>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5 sm:gap-6 lg:gap-8">
              {featuredListings
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
          </div>
        </section>

        <section className="py-10 sm:py-12 lg:py-14 bg-gray-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8 sm:mb-10">
              <h2 className="text-xl sm:text-2xl lg:text-3xl font-semibold text-gray-900">
                Near Me
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-4">
              {nearMeListings
                .filter((listing) => listing.city?.name)
                .map((listing) => (
                  <NearMeCard
                    key={listing.id}
                    id={listing.id}
                    name={listing.name}
                    slug={listing.slug}
                    image={listing.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                    city={listing.city?.name || ''}
                    category={listing.category.name}
                  />
                ))}
            </div>
          </div>
        </section>

        <section className="py-10 sm:py-12 lg:py-14">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8 sm:mb-10">
              <h2 className="text-xl sm:text-2xl lg:text-3xl font-semibold text-gray-900">
                Tour Packages
              </h2>
              <Link
                href="/tours"
                className="text-[13px] sm:text-[14px] lg:text-[15px] font-semibold text-primary hover:underline"
              >
                View All
              </Link>
            </div>

            {tours.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5 sm:gap-6 lg:gap-8">
                {tours.map((tour) => (
                  <TourCard
                    key={tour.id}
                    id={tour.id}
                    name={tour.name}
                    slug={tour.slug}
                    image={tour.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800'}
                    city={tour.city?.name || tour.country?.name || ''}
                    duration={tour.duration}
                    difficulty={tour.difficulty}
                    price={`${tour.minPrice}-${tour.maxPrice} ${tour.currency}`}
                  />
                ))}
              </div>
            ) : (
              <div className="text-center py-10 sm:py-12 bg-gray-50 rounded-xl sm:rounded-2xl">
                <svg className="w-14 h-14 sm:w-16 sm:h-16 mx-auto text-gray-400 mb-3 sm:mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
                </svg>
                <p className="text-[14px] sm:text-[15px] text-gray-600">No tour packages available</p>
              </div>
            )}
          </div>
        </section>
      </main>
      <Footer />
    </>
  );
}

