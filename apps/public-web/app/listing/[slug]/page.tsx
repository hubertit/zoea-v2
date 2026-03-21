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
  const [showAllAmenities, setShowAllAmenities] = useState(false);
  const [showAllReviews, setShowAllReviews] = useState(false);
  const [isSaved, setIsSaved] = useState(false);
  const [scrollProgress, setScrollProgress] = useState(0);

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

  useEffect(() => {
    const handleScroll = () => {
      const totalHeight = document.documentElement.scrollHeight - window.innerHeight;
      const progress = (window.scrollY / totalHeight) * 100;
      setScrollProgress(progress);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

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
      <div className="fixed top-0 left-0 right-0 h-1 bg-gray-100 z-50">
        <div 
          className="h-full bg-gradient-to-r from-primary to-primary/70 transition-all duration-150"
          style={{ width: `${scrollProgress}%` }}
        />
      </div>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20 bg-gray-50">
        <div className="max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-20 xl:px-24 py-6 sm:py-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-[14px] sm:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-4 sm:mb-6 group"
          >
            <div className="w-8 h-8 rounded-full bg-gray-100 group-hover:bg-primary/10 flex items-center justify-center transition-colors">
              <svg className="w-4 h-4 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </div>
            <span>Back to listings</span>
          </Link>

          <div className="mb-4 sm:mb-6">
            <div className="flex items-start justify-between gap-4 mb-3 sm:mb-4">
              <h1 className="text-2xl sm:text-3xl lg:text-4xl font-semibold text-gray-900 flex-1">
                {listing.name}
              </h1>
              <div className="flex items-center gap-2 flex-shrink-0">
                <button
                  onClick={handleShare}
                  className="p-2.5 hover:bg-gray-100 rounded-full transition-colors group"
                  aria-label="Share"
                >
                  <svg className="w-5 h-5 text-gray-700 group-hover:text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                  </svg>
                </button>
                <button
                  onClick={() => setIsSaved(!isSaved)}
                  className="p-2.5 hover:bg-gray-100 rounded-full transition-colors group"
                  aria-label="Save"
                >
                  <svg className={`w-5 h-5 ${isSaved ? 'fill-red-500 text-red-500' : 'fill-none text-gray-700 group-hover:text-gray-900'}`} strokeWidth={2} stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
                  </svg>
                </button>
              </div>
            </div>
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
                  <div className="flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-blue-700 rounded-full">
                    <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                    </svg>
                    <span className="font-medium text-[13px]">Verified</span>
                  </div>
                </>
              )}
            </div>
          </div>

          {/* Image Gallery */}
          <div className="mb-8 sm:mb-10 lg:mb-12 relative">
            {images.length === 1 ? (
              // Single image layout
              <div className="relative aspect-[16/9] lg:aspect-[21/9] rounded-xl sm:rounded-2xl overflow-hidden group cursor-pointer" onClick={() => setShowAllPhotos(true)}>
                <Image
                  src={images[0] || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                  alt={listing.name}
                  fill
                  className="object-cover group-hover:scale-105 transition-transform duration-700"
                  unoptimized
                  priority
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/20 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
              </div>
            ) : (
              // Multiple images grid layout
              <>
                <div className="grid grid-cols-2 lg:grid-cols-4 gap-2 rounded-xl sm:rounded-2xl overflow-hidden">
                  <div className="col-span-2 lg:row-span-2 relative aspect-[4/3] lg:aspect-auto lg:h-[500px] cursor-pointer group" onClick={() => setShowAllPhotos(true)}>
                    <Image
                      src={images[0] || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                      alt={listing.name}
                      fill
                      className="object-cover group-hover:scale-105 transition-transform duration-700"
                      unoptimized
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/20 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                  </div>
                  {images.slice(1, 5).map((img, idx) => (
                    <div 
                      key={idx} 
                      className="relative aspect-[4/3] lg:h-[245px] cursor-pointer group"
                      onClick={() => setShowAllPhotos(true)}
                    >
                      <Image
                        src={img || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                        alt={`${listing.name} - ${idx + 2}`}
                        fill
                        className="object-cover group-hover:scale-105 transition-transform duration-700"
                        unoptimized
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/20 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                      {idx === 3 && images.length > 5 && (
                        <div className="absolute inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center">
                          <span className="text-white font-semibold text-base sm:text-lg">+{images.length - 5} more</span>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
                {images.length > 1 && (
                  <button
                    onClick={() => setShowAllPhotos(true)}
                    className="absolute bottom-6 right-6 hidden lg:flex items-center gap-2 px-4 py-2.5 bg-white hover:bg-gray-50 rounded-lg transition-all text-[14px] font-semibold shadow-lg hover:shadow-xl"
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    View all {images.length} photos
                  </button>
                )}
              </>
            )}
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-16 xl:gap-20">
            <div className="lg:col-span-2 space-y-8 sm:space-y-10 lg:space-y-12">
              {/* Host/Category Info */}
              <div className="pb-8 border-b border-gray-200">
                <div className="flex items-start justify-between gap-6">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-3">
                      <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-full bg-gradient-to-br from-primary to-primary/70 flex items-center justify-center text-white font-semibold text-lg sm:text-xl">
                        {listing.name.charAt(0).toUpperCase()}
                      </div>
                      <div>
                        <h2 className="text-xl sm:text-2xl font-semibold text-gray-900">
                          {listing.category.name}
                        </h2>
                        <p className="text-[14px] sm:text-[15px] text-gray-600">
                          {listing.city?.name || 'Rwanda'}
                        </p>
                      </div>
                    </div>
                    {(isHotel || isRestaurant) && (
                      <div className="flex flex-wrap items-center gap-2 mt-4">
                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-gray-50 text-gray-700 rounded-full text-[13px] font-medium">
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          {isHotel ? 'Instant Booking' : 'Reserve Table'}
                        </span>
                        {listing.isVerified && (
                          <span className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 text-blue-700 rounded-full text-[13px] font-medium">
                            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                            </svg>
                            Verified Partner
                          </span>
                        )}
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Highlights */}
              <div className="pb-8 border-b border-gray-200">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {listing.isVerified && (
                    <div className="flex items-start gap-3 p-4 rounded-xl bg-white border border-gray-200 shadow-sm">
                      <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                        </svg>
                      </div>
                      <div>
                        <h4 className="text-[14px] font-semibold text-gray-900 mb-0.5">Verified</h4>
                        <p className="text-[13px] text-gray-600">Confirmed by Zoea</p>
                      </div>
                    </div>
                  )}
                  {hasBooking && (
                    <div className="flex items-start gap-3 p-4 rounded-xl bg-white border border-gray-200 shadow-sm">
                      <div className="w-10 h-10 rounded-full bg-green-50 flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                      </div>
                      <div>
                        <h4 className="text-[14px] font-semibold text-gray-900 mb-0.5">Instant Booking</h4>
                        <p className="text-[13px] text-gray-600">Reserve now, pay later</p>
                      </div>
                    </div>
                  )}
                  {listing.rating && parseFloat(listing.rating.toString()) >= 4.5 && (
                    <div className="flex items-start gap-3 p-4 rounded-xl bg-white border border-gray-200 shadow-sm">
                      <div className="w-10 h-10 rounded-full bg-yellow-50 flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-yellow-600 fill-current" viewBox="0 0 20 20">
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                      </div>
                      <div>
                        <h4 className="text-[14px] font-semibold text-gray-900 mb-0.5">Guest Favorite</h4>
                        <p className="text-[13px] text-gray-600">Highly rated by visitors</p>
                      </div>
                    </div>
                  )}
                  {listing.amenities && listing.amenities.length > 5 && (
                    <div className="flex items-start gap-3 p-4 rounded-xl bg-white border border-gray-200 shadow-sm">
                      <div className="w-10 h-10 rounded-full bg-purple-50 flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                        </svg>
                      </div>
                      <div>
                        <h4 className="text-[14px] font-semibold text-gray-900 mb-0.5">Premium Amenities</h4>
                        <p className="text-[13px] text-gray-600">{listing.amenities.length}+ features</p>
                      </div>
                    </div>
                  )}
                </div>
              </div>

              {/* Description */}
              <div className="pb-8 border-b border-gray-200">
                <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                  <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5">About this place</h3>
                  <div className="relative">
                    <p className="text-[15px] sm:text-[16px] text-gray-700 leading-relaxed whitespace-pre-line">
                      {listing.description || listing.shortDescription || 'No description available.'}
                    </p>
                    {listing.shortDescription && listing.description && listing.description.length > 300 && (
                      <div className="mt-4">
                        <button className="text-[15px] font-semibold text-gray-900 underline hover:text-primary transition-colors">
                          Show more
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Amenities */}
              {listing.amenities && listing.amenities.length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                    <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">What this place offers</h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      {(showAllAmenities ? listing.amenities : listing.amenities.slice(0, 10)).map((amenity: any, idx: number) => (
                        <div key={idx} className="flex items-start gap-3 group">
                          <div className="w-10 h-10 rounded-lg bg-gray-50 group-hover:bg-primary/5 flex items-center justify-center flex-shrink-0 transition-colors">
                            <svg className="w-5 h-5 text-gray-700 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                          <span className="text-[15px] text-gray-700 pt-2">
                            {typeof amenity === 'string' ? amenity : amenity.name || amenity.title}
                          </span>
                        </div>
                      ))}
                    </div>
                    {listing.amenities.length > 10 && (
                      <button 
                        onClick={() => setShowAllAmenities(!showAllAmenities)}
                        className="mt-6 px-5 py-2.5 border border-gray-900 rounded-lg text-[15px] font-semibold hover:bg-gray-50 transition-colors inline-flex items-center gap-2"
                      >
                        {showAllAmenities ? (
                          <>
                            Show less
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
                            </svg>
                          </>
                        ) : (
                          <>
                            Show all {listing.amenities.length} amenities
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                            </svg>
                          </>
                        )}
                      </button>
                    )}
                  </div>
                </div>
              )}

              {/* Operating Hours */}
              {listing.operatingHours && Object.keys(listing.operatingHours).length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                    <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Hours</h3>
                    <div className="space-y-2">
                      {Object.entries(listing.operatingHours).map(([day, hours]: [string, any]) => {
                        const isToday = new Date().toLocaleDateString('en-US', { weekday: 'long' }).toLowerCase() === day.toLowerCase();
                        return (
                          <div key={day} className={`flex items-center justify-between text-[15px] px-4 py-3 rounded-lg transition-colors ${isToday ? 'bg-primary/5 border border-primary/20' : 'hover:bg-gray-50'}`}>
                            <span className={`font-medium capitalize ${isToday ? 'text-primary' : 'text-gray-900'}`}>
                              {day} {isToday && <span className="text-[12px] ml-1">(Today)</span>}
                            </span>
                            <span className={`font-medium ${hours.closed ? 'text-red-600' : isToday ? 'text-primary' : 'text-gray-600'}`}>
                              {hours.closed ? 'Closed' : `${hours.open} - ${hours.close}`}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                </div>
              )}

              {/* Reviews */}
              {reviews.length > 0 && (
                <div className="pb-8 border-b border-gray-200">
                  <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                    <div className="flex items-center justify-between mb-8">
                      <div className="flex items-center gap-3">
                        <svg className="w-6 h-6 text-gray-900 fill-current" viewBox="0 0 20 20">
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                        <div>
                          <h3 className="text-lg sm:text-xl font-semibold text-gray-900">
                            {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)} out of 5
                          </h3>
                          <p className="text-[14px] text-gray-600">{listing.reviewCount} reviews</p>
                        </div>
                      </div>
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      {(showAllReviews ? reviews : reviews.slice(0, 6)).map((review) => (
                        <ReviewCard key={review.id} review={review} />
                      ))}
                    </div>
                    {reviews.length > 6 && (
                      <button 
                        onClick={() => setShowAllReviews(!showAllReviews)}
                        className="mt-8 px-5 py-2.5 border border-gray-900 rounded-lg text-[15px] font-semibold hover:bg-gray-50 transition-colors inline-flex items-center gap-2"
                      >
                        {showAllReviews ? (
                          <>
                            Show less
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
                            </svg>
                          </>
                        ) : (
                          <>
                            Show all {reviews.length} reviews
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                            </svg>
                          </>
                        )}
                      </button>
                    )}
                  </div>
                </div>
              )}

              {/* Location */}
              <div className="pb-8 border-b border-gray-200">
                <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                  <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Where you'll be</h3>
                  <div className="space-y-5">
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                      </div>
                      <div>
                        <p className="text-[15px] sm:text-[16px] font-medium text-gray-900">
                          {listing.city?.name || 'Rwanda'}
                        </p>
                        <p className="text-[14px] sm:text-[15px] text-gray-600 mt-0.5">
                          {listing.address || 'Exact location provided after booking'}
                        </p>
                      </div>
                    </div>
                    <div className="relative bg-gradient-to-br from-gray-50 to-gray-100 rounded-xl sm:rounded-2xl h-[300px] sm:h-[400px] flex items-center justify-center overflow-hidden group">
                      <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAwIDEwIEwgNDAgMTAgTSAxMCAwIEwgMTAgNDAgTSAwIDIwIEwgNDAgMjAgTSAyMCAwIEwgMjAgNDAgTSAwIDMwIEwgNDAgMzAgTSAzMCAwIEwgMzAgNDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0icmdiYSgwLDAsMCwwLjAzKSIgc3Ryb2tlLXdpZHRoPSIxIi8+PC9wYXR0ZXJuPjwvZGVmcz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI2dyaWQpIi8+PC9zdmc+')] opacity-50" />
                      <div className="text-center text-gray-500 relative z-10">
                        <div className="w-16 h-16 mx-auto mb-3 rounded-full bg-white shadow-lg flex items-center justify-center group-hover:scale-110 transition-transform">
                          <svg className="w-8 h-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                          </svg>
                        </div>
                        <p className="text-[15px] font-medium text-gray-700">Interactive map</p>
                        <p className="text-[13px] text-gray-500 mt-1">Coming soon</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Contact */}
              {(listing.contactPhone || listing.contactEmail || listing.website) && (
                <div className="pb-8">
                  <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                    <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Get in touch</h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 gap-3">
                    {listing.contactPhone && (
                      <a href={`tel:${listing.contactPhone}`} className="flex items-center gap-4 p-4 rounded-xl border border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                        <div className="w-11 h-11 rounded-full bg-gray-50 group-hover:bg-primary/10 flex items-center justify-center flex-shrink-0 transition-colors">
                          <svg className="w-5 h-5 text-gray-700 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                          </svg>
                        </div>
                        <div className="flex-1">
                          <p className="text-[13px] text-gray-600 mb-0.5">Phone</p>
                          <p className="text-[15px] font-medium text-gray-900">{listing.contactPhone}</p>
                        </div>
                      </a>
                    )}
                    {listing.contactEmail && (
                      <a href={`mailto:${listing.contactEmail}`} className="flex items-center gap-4 p-4 rounded-xl border border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                        <div className="w-11 h-11 rounded-full bg-gray-50 group-hover:bg-primary/10 flex items-center justify-center flex-shrink-0 transition-colors">
                          <svg className="w-5 h-5 text-gray-700 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                          </svg>
                        </div>
                        <div className="flex-1">
                          <p className="text-[13px] text-gray-600 mb-0.5">Email</p>
                          <p className="text-[15px] font-medium text-gray-900 break-all">{listing.contactEmail}</p>
                        </div>
                      </a>
                    )}
                    {listing.website && (
                      <a href={listing.website} target="_blank" rel="noopener noreferrer" className="flex items-center gap-4 p-4 rounded-xl border border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                        <div className="w-11 h-11 rounded-full bg-gray-50 group-hover:bg-primary/10 flex items-center justify-center flex-shrink-0 transition-colors">
                          <svg className="w-5 h-5 text-gray-700 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                          </svg>
                        </div>
                        <div className="flex-1">
                          <p className="text-[13px] text-gray-600 mb-0.5">Website</p>
                          <p className="text-[15px] font-medium text-gray-900 truncate">Visit website</p>
                        </div>
                        <svg className="w-4 h-4 text-gray-400 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                        </svg>
                      </a>
                    )}
                    </div>
                  </div>
                </div>
              )}

              {/* Things to Know */}
              {(hasBooking || (listing.amenities && listing.amenities.length > 0)) && (
                <div className="pb-8">
                  <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 shadow-sm border border-gray-200">
                    <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Things to know</h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 gap-6">
                    {hasBooking && (
                      <div className="space-y-3">
                        <h4 className="text-[15px] font-semibold text-gray-900 flex items-center gap-2">
                          <div className="w-6 h-6 rounded-full bg-green-50 flex items-center justify-center">
                            <svg className="w-3.5 h-3.5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                          Cancellation policy
                        </h4>
                        <div className="space-y-2 text-[14px] text-gray-600 pl-8">
                          <p className="flex items-start gap-2">
                            Free cancellation up to 24 hours before your booking
                          </p>
                          <button className="text-primary font-medium hover:underline">
                            Learn more
                          </button>
                        </div>
                      </div>
                    )}
                    <div className="space-y-3">
                      <h4 className="text-[15px] font-semibold text-gray-900 flex items-center gap-2">
                        <div className="w-6 h-6 rounded-full bg-blue-50 flex items-center justify-center">
                          <svg className="w-3.5 h-3.5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                        </div>
                        House rules
                      </h4>
                      <div className="space-y-2 text-[14px] text-gray-600 pl-8">
                        <p>Check operating hours before visiting</p>
                        <p>Respect local customs and traditions</p>
                      </div>
                    </div>
                    <div className="space-y-3">
                      <h4 className="text-[15px] font-semibold text-gray-900 flex items-center gap-2">
                        <div className="w-6 h-6 rounded-full bg-purple-50 flex items-center justify-center">
                          <svg className="w-3.5 h-3.5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                          </svg>
                        </div>
                        Safety & property
                      </h4>
                      <div className="space-y-2 text-[14px] text-gray-600 pl-8">
                        {listing.isVerified && <p>Verified by Zoea</p>}
                        <p>Secure booking guaranteed</p>
                      </div>
                    </div>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Sticky Booking Card */}
            <div className="lg:col-span-1">
              <div className="lg:sticky lg:top-24">
                <div className="bg-white border border-gray-200 rounded-xl sm:rounded-2xl p-5 sm:p-6 shadow-xl shadow-black/5 hover:shadow-2xl hover:shadow-black/10 transition-all">
                  {/* Price */}
                  <div className="mb-6 pb-6 border-b border-gray-100">
                    <div className="flex items-baseline gap-2 mb-2">
                      <span className="text-2xl sm:text-3xl font-semibold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                        {listing.priceRange || `${listing.minPrice}-${listing.maxPrice} ${listing.currency}`}
                      </span>
                      {isRestaurant && <span className="text-[15px] text-gray-600">per person</span>}
                      {isHotel && <span className="text-[15px] text-gray-600">per night</span>}
                    </div>
                    {listing.rating && (
                      <div className="flex items-center gap-2 text-[14px]">
                        <div className="flex items-center gap-1">
                          <svg className="w-4 h-4 text-gray-900 fill-current" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                          </svg>
                          <span className="font-semibold text-gray-900">
                            {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)}
                          </span>
                        </div>
                        <span className="text-gray-600">({listing.reviewCount} reviews)</span>
                      </div>
                    )}
                  </div>

                  {hasBooking ? (
                    <>
                      {/* Booking Form Preview */}
                      <div className="space-y-3 mb-6">
                        {isHotel && (
                          <>
                            <div className="grid grid-cols-2 gap-2">
                              <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                                <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Check-in</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                              <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                                <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Checkout</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                            </div>
                            <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                              <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Guests</label>
                              <span className="text-[14px] text-gray-600">1 guest</span>
                            </div>
                          </>
                        )}
                        {isRestaurant && (
                          <>
                            <div className="grid grid-cols-2 gap-2">
                              <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                                <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Date</label>
                                <span className="text-[14px] text-gray-600">Add date</span>
                              </div>
                              <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                                <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Time</label>
                                <span className="text-[14px] text-gray-600">Add time</span>
                              </div>
                            </div>
                            <div className="border-2 border-gray-200 rounded-lg px-3 py-2.5 cursor-pointer hover:border-primary hover:bg-primary/5 transition-all group">
                              <label className="block text-[11px] font-semibold text-gray-700 group-hover:text-primary uppercase mb-1 transition-colors">Guests</label>
                              <span className="text-[14px] text-gray-600">2 guests</span>
                            </div>
                          </>
                        )}
                      </div>

                      <Link
                        href={`/booking/${listing.id}`}
                        className="block w-full py-3.5 bg-gradient-to-r from-primary to-primary/90 text-white text-[15px] font-semibold rounded-lg hover:from-primary/90 hover:to-primary/80 transition-all text-center shadow-lg shadow-primary/20 hover:shadow-xl hover:shadow-primary/30"
                      >
                        {isRestaurant ? 'Reserve a table' : 'Reserve'}
                      </Link>

                      <p className="text-center text-[13px] text-gray-600 mt-4 flex items-center justify-center gap-1.5">
                        <svg className="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Free cancellation
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
                          className="block w-full py-3.5 bg-gradient-to-r from-primary to-primary/90 text-white text-[15px] font-semibold rounded-lg hover:from-primary/90 hover:to-primary/80 transition-all text-center shadow-lg shadow-primary/20 hover:shadow-xl hover:shadow-primary/30"
                        >
                          Call now
                        </a>
                      )}
                    </div>
                  )}

                  {/* Share & Save */}
                  <div className="grid grid-cols-2 gap-3 mt-6 pt-6 border-t border-gray-100">
                    <button
                      onClick={handleShare}
                      className="flex items-center justify-center gap-2 px-4 py-2.5 text-[14px] font-medium text-gray-700 hover:bg-gray-50 rounded-lg transition-colors border border-transparent hover:border-gray-200"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                      </svg>
                      Share
                    </button>
                    <button 
                      onClick={() => setIsSaved(!isSaved)}
                      className={`flex items-center justify-center gap-2 px-4 py-2.5 text-[14px] font-medium rounded-lg transition-all border ${isSaved ? 'bg-red-50 text-red-600 border-red-200 hover:bg-red-100' : 'text-gray-700 hover:bg-gray-50 border-transparent hover:border-gray-200'}`}
                    >
                      <svg className={`w-4 h-4 ${isSaved ? 'fill-red-600' : 'fill-none'}`} strokeWidth={2} stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
                      </svg>
                      {isSaved ? 'Saved' : 'Save'}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Photo Gallery Modal */}
        {showAllPhotos && (
          <div className="fixed inset-0 bg-black/95 backdrop-blur-sm z-50 overflow-y-auto animate-in fade-in duration-300">
            <div className="min-h-screen">
              <div className="sticky top-0 z-10 bg-black/80 backdrop-blur-md border-b border-white/10">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
                  <button
                    onClick={() => setShowAllPhotos(false)}
                    className="flex items-center gap-2 text-white hover:text-gray-300 transition-colors group"
                  >
                    <div className="w-8 h-8 rounded-full bg-white/10 group-hover:bg-white/20 flex items-center justify-center transition-colors">
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </div>
                    <span className="text-[15px] font-medium hidden sm:inline">Close</span>
                  </button>
                  <div className="flex items-center gap-4">
                    <span className="text-white text-[14px] font-medium">
                      {selectedImageIndex + 1} / {images.length}
                    </span>
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => setSelectedImageIndex(Math.max(0, selectedImageIndex - 1))}
                        disabled={selectedImageIndex === 0}
                        className="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 disabled:opacity-30 disabled:cursor-not-allowed flex items-center justify-center transition-colors"
                      >
                        <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
                        </svg>
                      </button>
                      <button
                        onClick={() => setSelectedImageIndex(Math.min(images.length - 1, selectedImageIndex + 1))}
                        disabled={selectedImageIndex === images.length - 1}
                        className="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 disabled:opacity-30 disabled:cursor-not-allowed flex items-center justify-center transition-colors"
                      >
                        <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div className="max-w-6xl mx-auto px-4 sm:px-6 py-8 space-y-6">
                {images.map((img, idx) => (
                  <div 
                    key={idx} 
                    className="relative w-full aspect-[4/3] rounded-xl sm:rounded-2xl overflow-hidden bg-gray-900 shadow-2xl"
                    onClick={() => setSelectedImageIndex(idx)}
                  >
                    <Image
                      src={img || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200'}
                      alt={`${listing.name} - ${idx + 1}`}
                      fill
                      className="object-cover"
                      unoptimized
                    />
                    <div className="absolute bottom-4 left-4 bg-black/70 backdrop-blur-sm px-3 py-1.5 rounded-full">
                      <span className="text-white text-[13px] font-medium">{idx + 1} / {images.length}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Mobile Floating Booking Bar */}
        {hasBooking && (
          <div className="lg:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-3 shadow-2xl shadow-black/10 z-40 animate-in slide-in-from-bottom duration-300">
            <div className="flex items-center justify-between gap-4">
              <div>
                <div className="flex items-baseline gap-2">
                  <span className="text-xl font-semibold text-gray-900">
                    {listing.priceRange || `${listing.minPrice}-${listing.maxPrice} ${listing.currency}`}
                  </span>
                  <span className="text-[13px] text-gray-600">
                    {isRestaurant ? 'per person' : 'per night'}
                  </span>
                </div>
                {listing.rating && (
                  <div className="flex items-center gap-1 mt-1">
                    <svg className="w-3.5 h-3.5 text-gray-900 fill-current" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                    <span className="text-[13px] font-semibold text-gray-900">
                      {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)}
                    </span>
                  </div>
                )}
              </div>
              <Link
                href={`/booking/${listing.id}`}
                className="px-6 py-3 bg-gradient-to-r from-primary to-primary/90 text-white text-[15px] font-semibold rounded-lg hover:from-primary/90 hover:to-primary/80 transition-all shadow-lg shadow-primary/30"
              >
                {isRestaurant ? 'Reserve' : 'Book'}
              </Link>
            </div>
          </div>
        )}
      </main>
      <Footer />
    </>
  );
}
