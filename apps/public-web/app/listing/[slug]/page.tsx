'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ReviewCard } from '@/components/ReviewCard';
import Image from 'next/image';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { listingsApi, type Listing } from '@/lib/api/listings';
import { reviewsApi, type Review } from '@/lib/api/reviews';

export default function ListingPage() {
  const params = useParams();
  const slug = params.slug as string;
  
  const [listing, setListing] = useState<Listing | null>(null);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [selectedImage, setSelectedImage] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [listingData, reviewsData] = await Promise.all([
          listingsApi.getById(slug),
          reviewsApi.getByListing(slug),
        ]);
        setListing(listingData);
        setReviews(reviewsData);
      } catch (error) {
        console.error('Failed to fetch data:', error);
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

  if (!listing) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Listing not found</h1>
            <Link href="/" className="text-primary hover:underline">
              Back to home
            </Link>
          </div>
        </main>
        <Footer />
      </>
    );
  }

  const images = listing.images?.length > 0 
    ? listing.images.map(img => img.media?.url)
    : ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'];

  return (
    <>
      <Header />
      <main className="pt-20">
        <div className="max-w-7xl mx-auto px-6 lg:px-8 py-8 lg:py-12">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-6"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Back to explore
          </Link>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-12">
            <div className="lg:col-span-2">
              <div className="mb-6">
                <div className="relative aspect-[16/10] rounded-2xl overflow-hidden mb-4">
                  <Image
                    src={images[selectedImage]}
                    alt={listing.name}
                    fill
                    className="object-cover"
                    unoptimized
                  />
                </div>

                {images.length > 1 && (
                  <div className="grid grid-cols-4 gap-3">
                    {images.map((image, index) => (
                      <button
                        key={index}
                        onClick={() => setSelectedImage(index)}
                        className={`relative aspect-[4/3] rounded-xl overflow-hidden ${
                          selectedImage === index ? 'ring-2 ring-primary' : ''
                        }`}
                      >
                        <Image
                          src={image}
                          alt={`View ${index + 1}`}
                          fill
                          className="object-cover"
                          unoptimized
                        />
                      </button>
                    ))}
                  </div>
                )}
              </div>

              <div className="space-y-8">
                <div>
                  <h1 className="text-3xl lg:text-4xl font-semibold text-gray-900 mb-3 flex items-center gap-2">
                    {listing.name}
                    {listing.isVerified && (
                      <svg className="w-6 h-6 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                      </svg>
                    )}
                  </h1>

                  <div className="flex items-center gap-4 text-[15px] text-gray-600 mb-4">
                    {listing.rating && (
                      <>
                        <div className="flex items-center gap-1.5">
                          <svg className="w-5 h-5 text-yellow-500 fill-current" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                          </svg>
                          <span className="font-semibold text-gray-900">{typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating).toFixed(1)}</span>
                          <span>({listing.reviewCount} reviews)</span>
                        </div>
                        <span>•</span>
                      </>
                    )}
                    <span>{listing.city?.name || listing.address}</span>
                  </div>

                  <p className="text-[15px] text-gray-600 leading-relaxed">
                    {listing.description}
                  </p>
                </div>

                {listing.amenities && listing.amenities.length > 0 && (
                  <div>
                    <h2 className="text-xl font-semibold text-gray-900 mb-4">Amenities</h2>
                    <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                      {listing.amenities.map((amenity) => (
                        <div key={amenity} className="flex items-center gap-2 text-[14px] text-gray-700">
                          <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                          </svg>
                          {amenity}
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div>
                  <h2 className="text-xl font-semibold text-gray-900 mb-4">Location</h2>
                  <p className="text-[15px] text-gray-600 mb-4">
                    {listing.address || listing.city?.name}
                  </p>
                  <div className="aspect-[16/9] bg-gray-100 rounded-2xl flex items-center justify-center">
                    <p className="text-gray-400">Map will be integrated here</p>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-6">
                    <h2 className="text-xl font-semibold text-gray-900">
                      Reviews ({reviews.length})
                    </h2>
                    {listing.rating && (
                      <div className="flex items-center gap-2">
                        <svg className="w-5 h-5 text-yellow-500 fill-current" viewBox="0 0 20 20">
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                        <span className="text-lg font-semibold text-gray-900">
                          {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating).toFixed(1)}
                        </span>
                      </div>
                    )}
                  </div>

                  {reviews.length > 0 ? (
                    <div className="space-y-6">
                      {reviews.slice(0, 5).map((review) => (
                        <ReviewCard key={review.id} review={review} />
                      ))}
                      {reviews.length > 5 && (
                        <button className="w-full py-3 text-[15px] font-semibold text-primary hover:underline">
                          Show all {reviews.length} reviews
                        </button>
                      )}
                    </div>
                  ) : (
                    <div className="text-center py-12 bg-gray-50 rounded-2xl">
                      <p className="text-[15px] text-gray-600">No reviews yet</p>
                    </div>
                  )}
                </div>
              </div>
            </div>

            <div className="lg:col-span-1">
              <div className="sticky top-24">
                <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
                  <div className="mb-6">
                    <p className="text-[13px] text-gray-600 mb-1">Price Range</p>
                    <p className="text-2xl font-semibold text-gray-900">
                      {listing.priceRange || `${listing.minPrice}-${listing.maxPrice} ${listing.currency}`}
                    </p>
                  </div>

                  <Link
                    href={`/booking/${listing.id}`}
                    className="block w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors mb-3 text-center"
                  >
                    Book Now
                  </Link>

                  <button className="w-full py-3.5 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors">
                    Contact
                  </button>

                  <div className="mt-6 pt-6 border-t border-gray-200 space-y-4">
                    {listing.operatingHours && (
                      <div className="flex items-start gap-3">
                        <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <div>
                          <p className="text-[13px] text-gray-600">Hours</p>
                          <p className="text-[14px] font-medium text-gray-900">
                            {listing.operatingHours.monday?.closed ? 'Closed' : `${listing.operatingHours.monday?.open} - ${listing.operatingHours.monday?.close}`}
                          </p>
                        </div>
                      </div>
                    )}

                    {listing.contactPhone && (
                      <div className="flex items-start gap-3">
                        <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                        <div>
                          <p className="text-[13px] text-gray-600">Phone</p>
                          <p className="text-[14px] font-medium text-gray-900">{listing.contactPhone}</p>
                        </div>
                      </div>
                    )}

                    {listing.contactEmail && (
                      <div className="flex items-start gap-3">
                        <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                        </svg>
                        <div>
                          <p className="text-[13px] text-gray-600">Email</p>
                          <p className="text-[14px] font-medium text-gray-900">{listing.contactEmail}</p>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
