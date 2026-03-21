'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ReviewCard } from '@/components/ReviewCard';
import Image from 'next/image';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { listingsApi, type Listing } from '@/lib/api/listings';
import { reviewsApi, type Review } from '@/lib/api/reviews';

export default function ListingPage() {
  const params = useParams();
  const router = useRouter();
  const slug = params.slug as string;
  
  const [listing, setListing] = useState<Listing | null>(null);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [selectedImageIndex, setSelectedImageIndex] = useState(0);
  const [showAllPhotos, setShowAllPhotos] = useState(false);
  const [loading, setLoading] = useState(true);
  const [showShareMenu, setShowShareMenu] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const listingData = await listingsApi.getBySlug(slug);
        setListing(listingData);
        
        try {
          const reviewsData = await reviewsApi.getByListing(listingData.id);
          setReviews(reviewsData);
        } catch (reviewError) {
          console.error('Failed to fetch reviews:', reviewError);
          setReviews([]);
        }
      } catch (error) {
        console.error('Failed to fetch listing:', error);
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
        <main className="pt-16 sm:pt-18 lg:pt-20 min-h-screen flex items-center justify-center">
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
        <main className="pt-16 sm:pt-18 lg:pt-20 min-h-screen flex items-center justify-center">
          <div className="text-center px-4">
            <h1 className="text-xl sm:text-2xl font-semibold text-gray-900 mb-2">Listing not found</h1>
            <Link href="/" className="text-[14px] sm:text-[15px] text-primary hover:underline">
              Back to home
            </Link>
          </div>
        </main>
        <Footer />
      </>
    );
  }

  const images = listing.images?.length > 0 
    ? listing.images.map(img => img.media?.url).filter(Boolean)
    : ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'];

  const isHotel = listing.category.slug.toLowerCase().includes('accommodation') || 
                  listing.category.slug.toLowerCase().includes('hotel');
  const isRestaurant = listing.category.slug.toLowerCase().includes('restaurant') || 
                       listing.category.slug.toLowerCase().includes('dining') ||
                       listing.category.slug.toLowerCase().includes('cafe');
  const hasBooking = isHotel || isRestaurant;

  const handleShare = () => {
    if (navigator.share) {
      navigator.share({
        title: listing.name,
        text: listing.shortDescription || listing.description,
        url: window.location.href,
      });
    } else {
      setShowShareMenu(!showShareMenu);
    }
  };

  return (
    <>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20 bg-white">
        <div className="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-20 xl:px-24 py-6 sm:py-8">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-[14px] sm:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-4 sm:mb-6"
          >
            <svg className="w-4 h-4 sm:w-5 sm:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Back
          </Link>

          <div className="mb-4 sm:mb-6">
            <h1 className="text-2xl sm:text-3xl lg:text-4xl font-semibold text-gray-900 mb-3 sm:mb-4">
              {listing.name}
            </h1>
            <div className="flex flex-wrap items-center gap-3 sm:gap-4 text-[14px] sm:text-[15px]">
              {listing.rating && (
                <div className="flex items-center gap-1.5">
                  <svg className="w-4 h-4 text-gray-900 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                  <span className="font-semibold text-gray-900">
                    {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)}
                  </span>
                  <span className="text-gray-600">
                    ({listing.reviewCount} reviews)
                  </span>
                </div>
              )}
              <span className="text-gray-300">•</span>
              <div className="flex items-center gap-1.5 text-gray-700">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                <span>{listing.city?.name || listing.address}</span>
              </div>
              {listing.isVerified && (
                <>
                  <span className="text-gray-300">•</span>
                  <div className="flex items-center gap-1.5 text-blue-600">
                    <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                    </svg>
                    <span className="font-medium">Verified</span>
                  </div>
                </>
              )}
            </div>
          </div>

          {/* Image Gallery */}
          <div className="mb-8 sm:mb-10 lg:mb-12">
            {images.length === 1 ? (
              // Single image layout
              <div className="relative aspect-[16/9] lg:aspect-[21/9] rounded-xl sm:rounded-2xl overflow-hidden">
                <Image
                  src={images[0] || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                  alt={listing.name}
                  fill
                  className="object-cover"
                  unoptimized
                  priority
                />
              </div>
            ) : (
              // Multiple images grid layout
              <>
                <div className="grid grid-cols-1 lg:grid-cols-4 gap-2 rounded-xl sm:rounded-2xl overflow-hidden">
                  <div className="lg:col-span-2 lg:row-span-2 relative aspect-[4/3] lg:aspect-auto lg:h-[500px] cursor-pointer group" onClick={() => setShowAllPhotos(true)}>
                    <Image
                      src={images[0] || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                      alt={listing.name}
                      fill
                      className="object-cover group-hover:brightness-95 transition-all"
                      unoptimized
                    />
                  </div>
                  {images.slice(1, 5).map((img, idx) => (
                    <div 
                      key={idx} 
                      className="hidden lg:block relative aspect-[4/3] lg:h-[245px] cursor-pointer group"
                      onClick={() => setShowAllPhotos(true)}
                    >
                      <Image
                        src={img || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                        alt={`${listing.name} - ${idx + 2}`}
                        fill
                        className="object-cover group-hover:brightness-95 transition-all"
                        unoptimized
                      />
                      {idx === 3 && images.length > 5 && (
                        <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
                          <span className="text-white font-semibold text-lg">+{images.length - 5} photos</span>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
                {images.length > 1 && (
                  <button
                    onClick={() => setShowAllPhotos(true)}
                    className="hidden lg:flex items-center gap-2 mt-4 px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors text-[14px] font-medium"
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    Show all {images.length} photos
                  </button>
                )}
              </>
            )}
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-16 xl:gap-20">
            <div className="lg:col-span-2 space-y-8 sm:space-y-10 lg:space-y-12">
              {/* Host/Category Info */}
              <div className="pb-8 border-b border-gray-200">
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h2 className="text-xl sm:text-2xl font-semibold text-gray-900 mb-2">
                      {listing.category.name} in {listing.city?.name || 'Rwanda'}
                    </h2>
                    {(isHotel || isRestaurant) && (
                      <div className="flex items-center gap-3 text-[14px] sm:text-[15px] text-gray-600">
                        {isHotel && <span>Accommodation</span>}
                        {isRestaurant && <span>Dining</span>}
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Description */}
              <div className="pb-8 border-b border-gray-200">
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-4">About this place</h3>
                <p className="text-[15px] sm:text-[16px] text-gray-700 leading-relaxed whitespace-pre-line">
                  {listing.description || listing.shortDescription || 'No description available.'}
                </p>
              </div>

              {/* Amenities */}
              {listing.amenities && listing.amenities.length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">What this place offers</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {listing.amenities.slice(0, 10).map((amenity: any, idx: number) => (
                      <div key={idx} className="flex items-center gap-3">
                        <svg className="w-6 h-6 text-gray-700 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                        </svg>
                        <span className="text-[15px] text-gray-700">
                          {typeof amenity === 'string' ? amenity : amenity.name || amenity.title}
                        </span>
                      </div>
                    ))}
                  </div>
                  {listing.amenities.length > 10 && (
                    <button className="mt-6 px-5 py-2.5 border border-gray-900 rounded-lg text-[15px] font-semibold hover:bg-gray-50 transition-colors">
                      Show all {listing.amenities.length} amenities
                    </button>
                  )}
                </div>
              )}

              {/* Operating Hours */}
              {listing.operatingHours && Object.keys(listing.operatingHours).length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Hours</h3>
                  <div className="space-y-3">
                    {Object.entries(listing.operatingHours).map(([day, hours]: [string, any]) => (
                      <div key={day} className="flex items-center justify-between text-[15px]">
                        <span className="text-gray-900 font-medium capitalize">{day}</span>
                        <span className="text-gray-600">
                          {hours.closed ? 'Closed' : `${hours.open} - ${hours.close}`}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Reviews */}
              {reviews.length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <div className="flex items-center gap-2 mb-6">
                    <svg className="w-5 h-5 text-gray-900 fill-current" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                    <h3 className="text-lg sm:text-xl font-semibold text-gray-900">
                      {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)} · {listing.reviewCount} reviews
                    </h3>
                  </div>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 sm:gap-8">
                    {reviews.slice(0, 6).map((review) => (
                      <ReviewCard key={review.id} review={review} />
                    ))}
                  </div>
                  {reviews.length > 6 && (
                    <button className="mt-6 px-5 py-2.5 border border-gray-900 rounded-lg text-[15px] font-semibold hover:bg-gray-50 transition-colors">
                      Show all {reviews.length} reviews
                    </button>
                  )}
                </div>
              )}

              {/* Location */}
              <div className="pb-8 border-b border-gray-200">
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Location</h3>
                <div className="space-y-4">
                  <p className="text-[15px] text-gray-700">
                    {listing.address || listing.city?.name || 'Location not specified'}
                  </p>
                  <div className="bg-gray-100 rounded-xl h-[300px] sm:h-[400px] flex items-center justify-center">
                    <div className="text-center text-gray-500">
                      <svg className="w-12 h-12 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      <p className="text-[14px]">Map view</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Contact */}
              {(listing.contactPhone || listing.contactEmail || listing.website) && (
                <div className="pb-8">
                  <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Contact</h3>
                  <div className="space-y-4">
                    {listing.contactPhone && (
                      <a href={`tel:${listing.contactPhone}`} className="flex items-center gap-3 text-[15px] text-gray-700 hover:text-primary transition-colors">
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                        {listing.contactPhone}
                      </a>
                    )}
                    {listing.contactEmail && (
                      <a href={`mailto:${listing.contactEmail}`} className="flex items-center gap-3 text-[15px] text-gray-700 hover:text-primary transition-colors">
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                        </svg>
                        {listing.contactEmail}
                      </a>
                    )}
                    {listing.website && (
                      <a href={listing.website} target="_blank" rel="noopener noreferrer" className="flex items-center gap-3 text-[15px] text-gray-700 hover:text-primary transition-colors">
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                        </svg>
                        Visit website
                      </a>
                    )}
                  </div>
                </div>
              )}
            </div>

            {/* Sticky Booking Card */}
            <div className="lg:col-span-1">
              <div className="lg:sticky lg:top-24">
                <div className="bg-white border border-gray-200 rounded-xl sm:rounded-2xl p-5 sm:p-6 shadow-xl shadow-black/5">
                  {/* Price */}
                  <div className="mb-6">
                    <div className="flex items-baseline gap-2">
                      <span className="text-2xl sm:text-3xl font-semibold text-gray-900">
                        {listing.priceRange || `${listing.minPrice}-${listing.maxPrice} ${listing.currency}`}
                      </span>
                      {isRestaurant && <span className="text-[15px] text-gray-600">per person</span>}
                      {isHotel && <span className="text-[15px] text-gray-600">per night</span>}
                    </div>
                  </div>

                  {hasBooking ? (
                    <>
                      {/* Booking Form Preview */}
                      <div className="space-y-3 mb-6">
                        {isHotel && (
                          <>
                            <div className="grid grid-cols-2 gap-2">
                              <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                                <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Check-in</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                              <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                                <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Checkout</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                            </div>
                            <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                              <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Guests</label>
                              <span className="text-[14px] text-gray-600">1 guest</span>
                            </div>
                          </>
                        )}
                        {isRestaurant && (
                          <>
                            <div className="grid grid-cols-2 gap-2">
                              <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                                <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Date</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                              <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                                <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Time</label>
                                <span className="text-[14px] text-gray-600">Add time</span>
                              </div>
                            </div>
                            <div className="border border-gray-300 rounded-lg px-3 py-2.5 cursor-pointer hover:border-gray-900 transition-colors">
                              <label className="block text-[11px] font-semibold text-gray-900 uppercase mb-1">Guests</label>
                              <span className="text-[14px] text-gray-600">2 guests</span>
                            </div>
                          </>
                        )}
                      </div>

                      <Link
                        href={`/booking/${listing.id}`}
                        className="block w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-lg hover:bg-primary/90 transition-all text-center"
                      >
                        {isRestaurant ? 'Reserve a table' : 'Reserve'}
                      </Link>

                      <p className="text-center text-[13px] text-gray-600 mt-4">
                        You won't be charged yet
                      </p>
                    </>
                  ) : (
                    <div className="space-y-4">
                      <p className="text-[15px] text-gray-700 text-center">
                        Contact this place for more information
                      </p>
                      {listing.contactPhone && (
                        <a
                          href={`tel:${listing.contactPhone}`}
                          className="block w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-lg hover:bg-primary/90 transition-all text-center"
                        >
                          Call now
                        </a>
                      )}
                    </div>
                  )}

                  {/* Share & Save */}
                  <div className="grid grid-cols-2 gap-3 mt-6 pt-6 border-t border-gray-200">
                    <button
                      onClick={handleShare}
                      className="flex items-center justify-center gap-2 px-4 py-2.5 text-[14px] font-medium text-gray-700 hover:bg-gray-50 rounded-lg transition-colors"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                      </svg>
                      Share
                    </button>
                    <button className="flex items-center justify-center gap-2 px-4 py-2.5 text-[14px] font-medium text-gray-700 hover:bg-gray-50 rounded-lg transition-colors">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
                      </svg>
                      Save
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Photo Gallery Modal */}
        {showAllPhotos && (
          <div className="fixed inset-0 bg-black z-50 overflow-y-auto">
            <div className="min-h-screen">
              <div className="sticky top-0 z-10 bg-black/95 backdrop-blur-sm">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
                  <button
                    onClick={() => setShowAllPhotos(false)}
                    className="flex items-center gap-2 text-white hover:text-gray-300 transition-colors"
                  >
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                    <span className="text-[15px] font-medium">Close</span>
                  </button>
                  <span className="text-white text-[14px]">
                    {selectedImageIndex + 1} / {images.length}
                  </span>
                </div>
              </div>
              <div className="max-w-5xl mx-auto px-4 sm:px-6 py-8 space-y-4">
                {images.map((img, idx) => (
                  <div key={idx} className="relative w-full aspect-[4/3] rounded-xl overflow-hidden">
                    <Image
                      src={img || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                      alt={`${listing.name} - ${idx + 1}`}
                      fill
                      className="object-cover"
                      unoptimized
                    />
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </main>
      <Footer />
    </>
  );
}
