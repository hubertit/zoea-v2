'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Image from 'next/image';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { listingsApi, type Listing } from '@/lib/api/listings';
import { bookingsApi } from '@/lib/api/bookings';

export default function BookingPage() {
  const params = useParams();
  const router = useRouter();
  const listingId = params.listingId as string;
  
  const [listing, setListing] = useState<Listing | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  
  const [hotelFormData, setHotelFormData] = useState({
    checkInDate: '',
    checkOutDate: '',
    guestCount: 1,
    roomCount: 1,
    specialRequests: '',
    fullName: '',
    email: '',
    phone: '',
  });

  const [restaurantFormData, setRestaurantFormData] = useState({
    bookingDate: '',
    bookingTime: '',
    guestCount: 2,
    specialRequests: '',
    fullName: '',
    email: '',
    phone: '',
  });

  useEffect(() => {
    const fetchListing = async () => {
      const token = localStorage.getItem('access_token');
      if (!token) {
        router.push('/login');
        return;
      }

      try {
        const data = await listingsApi.getById(listingId);
        setListing(data);
      } catch (error) {
        console.error('Failed to fetch listing:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchListing();
  }, [listingId, router]);

  const isHotel = listing?.category.slug.toLowerCase().includes('accommodation') || 
                  listing?.category.slug.toLowerCase().includes('hotel');
  const isRestaurant = listing?.category.slug.toLowerCase().includes('restaurant') || 
                       listing?.category.slug.toLowerCase().includes('dining') ||
                       listing?.category.slug.toLowerCase().includes('cafe');

  const handleHotelSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);

    try {
      const booking = await bookingsApi.create({
        listingId,
        bookingType: 'hotel',
        checkInDate: hotelFormData.checkInDate,
        checkOutDate: hotelFormData.checkOutDate,
        guestCount: hotelFormData.guestCount,
        roomCount: hotelFormData.roomCount,
        specialRequests: hotelFormData.specialRequests,
        fullName: hotelFormData.fullName,
        email: hotelFormData.email,
        phone: hotelFormData.phone,
      });
      router.push(`/booking/confirmation/${booking.id}`);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Booking failed. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleRestaurantSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);

    try {
      const booking = await bookingsApi.create({
        listingId,
        bookingType: 'restaurant',
        bookingDate: restaurantFormData.bookingDate,
        bookingTime: restaurantFormData.bookingTime,
        guestCount: restaurantFormData.guestCount,
        specialRequests: restaurantFormData.specialRequests,
        fullName: restaurantFormData.fullName,
        email: restaurantFormData.email,
        phone: restaurantFormData.phone,
      });
      router.push(`/booking/confirmation/${booking.id}`);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Booking failed. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

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

  const primaryImage = listing.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800';

  return (
    <>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20 min-h-screen bg-gray-50">
        <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10 lg:py-12">
          <Link
            href={`/listing/${listing.slug}`}
            className="inline-flex items-center gap-2 text-[14px] sm:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-6 sm:mb-8"
          >
            <svg className="w-4 h-4 sm:w-5 sm:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Back to listing
          </Link>

          <h1 className="text-2xl sm:text-3xl lg:text-4xl font-semibold text-gray-900 mb-8 sm:mb-10 lg:mb-12">
            {isRestaurant ? 'Reserve a table' : 'Complete your booking'}
          </h1>

          <div className="grid grid-cols-1 lg:grid-cols-5 gap-8 lg:gap-12">
            <div className="lg:col-span-3">
              {isHotel ? (
                <form onSubmit={handleHotelSubmit} className="space-y-6 sm:space-y-8">
                  {error && (
                    <div className="px-4 py-3 bg-red-50 border border-red-200 rounded-lg sm:rounded-xl">
                      <p className="text-[13px] sm:text-[14px] text-red-600">{error}</p>
                    </div>
                  )}

                  {/* Dates Section */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Your stay</h2>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
                      <div>
                        <label htmlFor="checkInDate" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Check-in
                        </label>
                        <input
                          id="checkInDate"
                          type="date"
                          value={hotelFormData.checkInDate}
                          onChange={(e) => setHotelFormData({ ...hotelFormData, checkInDate: e.target.value })}
                          min={new Date().toISOString().split('T')[0]}
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        />
                      </div>
                      <div>
                        <label htmlFor="checkOutDate" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Check-out
                        </label>
                        <input
                          id="checkOutDate"
                          type="date"
                          value={hotelFormData.checkOutDate}
                          onChange={(e) => setHotelFormData({ ...hotelFormData, checkOutDate: e.target.value })}
                          min={hotelFormData.checkInDate || new Date().toISOString().split('T')[0]}
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        />
                      </div>
                    </div>
                  </div>

                  {/* Guests Section */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Guests and rooms</h2>
                    <div className="space-y-5">
                      <div className="flex items-center justify-between pb-5 border-b border-gray-200">
                        <div>
                          <p className="text-[15px] sm:text-[16px] font-medium text-gray-900">Guests</p>
                          <p className="text-[13px] sm:text-[14px] text-gray-600">How many people?</p>
                        </div>
                        <div className="flex items-center gap-3 sm:gap-4">
                          <button
                            type="button"
                            onClick={() => setHotelFormData({ ...hotelFormData, guestCount: Math.max(1, hotelFormData.guestCount - 1) })}
                            className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
                            disabled={hotelFormData.guestCount <= 1}
                          >
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
                            </svg>
                          </button>
                          <span className="text-[15px] sm:text-[16px] font-medium text-gray-900 w-8 text-center">{hotelFormData.guestCount}</span>
                          <button
                            type="button"
                            onClick={() => setHotelFormData({ ...hotelFormData, guestCount: hotelFormData.guestCount + 1 })}
                            className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors"
                          >
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                            </svg>
                          </button>
                        </div>
                      </div>

                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-[15px] sm:text-[16px] font-medium text-gray-900">Rooms</p>
                          <p className="text-[13px] sm:text-[14px] text-gray-600">How many rooms?</p>
                        </div>
                        <div className="flex items-center gap-3 sm:gap-4">
                          <button
                            type="button"
                            onClick={() => setHotelFormData({ ...hotelFormData, roomCount: Math.max(1, hotelFormData.roomCount - 1) })}
                            className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
                            disabled={hotelFormData.roomCount <= 1}
                          >
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
                            </svg>
                          </button>
                          <span className="text-[15px] sm:text-[16px] font-medium text-gray-900 w-8 text-center">{hotelFormData.roomCount}</span>
                          <button
                            type="button"
                            onClick={() => setHotelFormData({ ...hotelFormData, roomCount: hotelFormData.roomCount + 1 })}
                            className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors"
                          >
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                            </svg>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Contact Information */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Contact details</h2>
                    <div className="space-y-4 sm:space-y-5">
                      <div>
                        <label htmlFor="fullName" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Full Name
                        </label>
                        <input
                          id="fullName"
                          type="text"
                          value={hotelFormData.fullName}
                          onChange={(e) => setHotelFormData({ ...hotelFormData, fullName: e.target.value })}
                          placeholder="John Doe"
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        />
                      </div>
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
                        <div>
                          <label htmlFor="email" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                            Email
                          </label>
                          <input
                            id="email"
                            type="email"
                            value={hotelFormData.email}
                            onChange={(e) => setHotelFormData({ ...hotelFormData, email: e.target.value })}
                            placeholder="you@example.com"
                            className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                          />
                        </div>
                        <div>
                          <label htmlFor="phone" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                            Phone Number
                          </label>
                          <input
                            id="phone"
                            type="tel"
                            value={hotelFormData.phone}
                            onChange={(e) => setHotelFormData({ ...hotelFormData, phone: e.target.value })}
                            placeholder="+250 700 000 000"
                            className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Special Requests */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Special requests</h2>
                    <textarea
                      value={hotelFormData.specialRequests}
                      onChange={(e) => setHotelFormData({ ...hotelFormData, specialRequests: e.target.value })}
                      placeholder="Any special requests or requirements?"
                      rows={4}
                      className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all resize-none"
                    />
                  </div>

                  <button
                    type="submit"
                    disabled={submitting}
                    className="w-full py-3.5 sm:py-4 bg-primary text-white text-[15px] sm:text-[16px] font-semibold rounded-lg sm:rounded-xl hover:bg-primary/90 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    {submitting ? 'Processing...' : 'Confirm and book'}
                  </button>
                </form>
              ) : isRestaurant ? (
                <form onSubmit={handleRestaurantSubmit} className="space-y-6 sm:space-y-8">
                  {error && (
                    <div className="px-4 py-3 bg-red-50 border border-red-200 rounded-lg sm:rounded-xl">
                      <p className="text-[13px] sm:text-[14px] text-red-600">{error}</p>
                    </div>
                  )}

                  {/* Date & Time Section */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">When are you dining?</h2>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
                      <div>
                        <label htmlFor="bookingDate" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Date
                        </label>
                        <input
                          id="bookingDate"
                          type="date"
                          value={restaurantFormData.bookingDate}
                          onChange={(e) => setRestaurantFormData({ ...restaurantFormData, bookingDate: e.target.value })}
                          min={new Date().toISOString().split('T')[0]}
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        />
                      </div>
                      <div>
                        <label htmlFor="bookingTime" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Time
                        </label>
                        <select
                          id="bookingTime"
                          value={restaurantFormData.bookingTime}
                          onChange={(e) => setRestaurantFormData({ ...restaurantFormData, bookingTime: e.target.value })}
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        >
                          <option value="">Select time</option>
                          {Array.from({ length: 14 }, (_, i) => i + 11).map(hour => (
                            <>
                              <option key={`${hour}:00`} value={`${hour.toString().padStart(2, '0')}:00`}>
                                {hour > 12 ? hour - 12 : hour}:00 {hour >= 12 ? 'PM' : 'AM'}
                              </option>
                              <option key={`${hour}:30`} value={`${hour.toString().padStart(2, '0')}:30`}>
                                {hour > 12 ? hour - 12 : hour}:30 {hour >= 12 ? 'PM' : 'AM'}
                              </option>
                            </>
                          ))}
                        </select>
                      </div>
                    </div>
                  </div>

                  {/* Party Size */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Party size</h2>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-[15px] sm:text-[16px] font-medium text-gray-900">Number of guests</p>
                        <p className="text-[13px] sm:text-[14px] text-gray-600">Including yourself</p>
                      </div>
                      <div className="flex items-center gap-3 sm:gap-4">
                        <button
                          type="button"
                          onClick={() => setRestaurantFormData({ ...restaurantFormData, guestCount: Math.max(1, restaurantFormData.guestCount - 1) })}
                          className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
                          disabled={restaurantFormData.guestCount <= 1}
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
                          </svg>
                        </button>
                        <span className="text-[15px] sm:text-[16px] font-medium text-gray-900 w-8 text-center">{restaurantFormData.guestCount}</span>
                        <button
                          type="button"
                          onClick={() => setRestaurantFormData({ ...restaurantFormData, guestCount: restaurantFormData.guestCount + 1 })}
                          className="w-8 h-8 sm:w-9 sm:h-9 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                          </svg>
                        </button>
                      </div>
                    </div>
                  </div>

                  {/* Contact Information */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Contact details</h2>
                    <div className="space-y-4 sm:space-y-5">
                      <div>
                        <label htmlFor="fullName" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                          Full Name
                        </label>
                        <input
                          id="fullName"
                          type="text"
                          value={restaurantFormData.fullName}
                          onChange={(e) => setRestaurantFormData({ ...restaurantFormData, fullName: e.target.value })}
                          placeholder="John Doe"
                          className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                          required
                        />
                      </div>
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
                        <div>
                          <label htmlFor="email" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                            Email
                          </label>
                          <input
                            id="email"
                            type="email"
                            value={restaurantFormData.email}
                            onChange={(e) => setRestaurantFormData({ ...restaurantFormData, email: e.target.value })}
                            placeholder="you@example.com"
                            className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                          />
                        </div>
                        <div>
                          <label htmlFor="phone" className="block text-[13px] sm:text-[14px] font-medium text-gray-900 mb-2">
                            Phone Number
                          </label>
                          <input
                            id="phone"
                            type="tel"
                            value={restaurantFormData.phone}
                            onChange={(e) => setRestaurantFormData({ ...restaurantFormData, phone: e.target.value })}
                            placeholder="+250 700 000 000"
                            className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Special Requests */}
                  <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 lg:p-8">
                    <h2 className="text-lg sm:text-xl font-semibold text-gray-900 mb-5 sm:mb-6">Special requests</h2>
                    <textarea
                      value={restaurantFormData.specialRequests}
                      onChange={(e) => setRestaurantFormData({ ...restaurantFormData, specialRequests: e.target.value })}
                      placeholder="Dietary restrictions, seating preferences, etc."
                      rows={4}
                      className="w-full px-3 sm:px-4 py-2.5 sm:py-3 text-[14px] sm:text-[15px] border border-gray-300 rounded-lg sm:rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all resize-none"
                    />
                  </div>

                  <button
                    type="submit"
                    disabled={submitting}
                    className="w-full py-3.5 sm:py-4 bg-primary text-white text-[15px] sm:text-[16px] font-semibold rounded-lg sm:rounded-xl hover:bg-primary/90 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    {submitting ? 'Processing...' : 'Confirm reservation'}
                  </button>
                </form>
              ) : (
                <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-8 text-center">
                  <p className="text-[15px] text-gray-600">
                    Booking is not available for this listing type.
                  </p>
                  <Link
                    href={`/listing/${listing.slug}`}
                    className="inline-block mt-4 text-[15px] font-semibold text-primary hover:underline"
                  >
                    Back to listing
                  </Link>
                </div>
              )}
            </div>

            {/* Booking Summary Card - Sticky on desktop */}
            <div className="lg:col-span-2">
              <div className="lg:sticky lg:top-24">
                <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 p-5 sm:p-6 shadow-lg">
                  <h3 className="text-base sm:text-lg font-semibold text-gray-900 mb-5 sm:mb-6">Booking summary</h3>
                  
                  {/* Listing Info */}
                  <div className="flex gap-4 pb-5 sm:pb-6 border-b border-gray-200">
                    <div className="relative w-20 h-20 sm:w-24 sm:h-24 rounded-lg sm:rounded-xl overflow-hidden flex-shrink-0">
                      <Image
                        src={primaryImage}
                        alt={listing.name}
                        fill
                        className="object-cover"
                        unoptimized
                      />
                    </div>
                    <div className="flex-1 min-w-0">
                      <h4 className="text-[15px] sm:text-[16px] font-semibold text-gray-900 mb-1 line-clamp-2">
                        {listing.name}
                      </h4>
                      <p className="text-[13px] sm:text-[14px] text-gray-600 mb-2">
                        {listing.city?.name || listing.address}
                      </p>
                      {listing.rating && (
                        <div className="flex items-center gap-1">
                          <svg className="w-3.5 h-3.5 sm:w-4 sm:h-4 text-gray-900 fill-current" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                          </svg>
                          <span className="text-[13px] sm:text-[14px] font-semibold text-gray-900">
                            {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)}
                          </span>
                          <span className="text-[12px] sm:text-[13px] text-gray-600">
                            ({listing.reviewCount})
                          </span>
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Booking Details */}
                  <div className="py-5 sm:py-6 space-y-3 sm:space-y-4">
                    {isHotel && hotelFormData.checkInDate && hotelFormData.checkOutDate && (
                      <>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Dates</span>
                          <span className="text-gray-900 font-medium">
                            {new Date(hotelFormData.checkInDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - {new Date(hotelFormData.checkOutDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                          </span>
                        </div>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Guests</span>
                          <span className="text-gray-900 font-medium">{hotelFormData.guestCount} {hotelFormData.guestCount === 1 ? 'guest' : 'guests'}</span>
                        </div>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Rooms</span>
                          <span className="text-gray-900 font-medium">{hotelFormData.roomCount} {hotelFormData.roomCount === 1 ? 'room' : 'rooms'}</span>
                        </div>
                      </>
                    )}
                    {isRestaurant && restaurantFormData.bookingDate && restaurantFormData.bookingTime && (
                      <>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Date</span>
                          <span className="text-gray-900 font-medium">
                            {new Date(restaurantFormData.bookingDate).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}
                          </span>
                        </div>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Time</span>
                          <span className="text-gray-900 font-medium">{restaurantFormData.bookingTime}</span>
                        </div>
                        <div className="flex justify-between text-[14px] sm:text-[15px]">
                          <span className="text-gray-600">Party size</span>
                          <span className="text-gray-900 font-medium">{restaurantFormData.guestCount} {restaurantFormData.guestCount === 1 ? 'guest' : 'guests'}</span>
                        </div>
                      </>
                    )}
                  </div>

                  {/* Cancellation Policy */}
                  <div className="pt-5 sm:pt-6 border-t border-gray-200">
                    <h4 className="text-[14px] sm:text-[15px] font-semibold text-gray-900 mb-3">Cancellation policy</h4>
                    <p className="text-[13px] sm:text-[14px] text-gray-600 leading-relaxed">
                      {isRestaurant 
                        ? 'Free cancellation up to 2 hours before your reservation. Cancel after that and you may be charged.'
                        : 'Free cancellation before 24 hours of check-in. Cancel after that and you may be charged for the first night.'
                      }
                    </p>
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
