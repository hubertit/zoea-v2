'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Image from 'next/image';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { bookingsApi, type Booking } from '@/lib/api/bookings';

export default function BookingConfirmationPage() {
  const params = useParams();
  const bookingId = params.id as string;
  
  const [booking, setBooking] = useState<Booking | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchBooking = async () => {
      try {
        const data = await bookingsApi.getById(bookingId);
        setBooking(data);
      } catch (error) {
        console.error('Failed to fetch booking:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchBooking();
  }, [bookingId]);

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

  if (!booking) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Booking not found</h1>
          </div>
        </main>
        <Footer />
      </>
    );
  }

  return (
    <>
      <Header />
      <main className="pt-20 min-h-screen bg-gray-50">
        <div className="max-w-3xl mx-auto px-6 lg:px-8 py-12">
          <div className="bg-white rounded-2xl border border-gray-200 p-8 text-center mb-8">
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>

            <h1 className="text-3xl font-semibold text-gray-900 mb-3">
              Booking Confirmed!
            </h1>
            <p className="text-[15px] text-gray-600 mb-2">
              Your booking has been successfully confirmed.
            </p>
            <p className="text-[14px] text-gray-500">
              Booking ID: {booking.id}
            </p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-200 p-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Booking Details
            </h2>

            <div className="flex gap-4 mb-6 pb-6 border-b border-gray-200">
              <div className="relative w-24 h-24 rounded-xl overflow-hidden flex-shrink-0">
                <Image
                  src={booking.listing.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                  alt={booking.listing.name}
                  fill
                  className="object-cover"
                  unoptimized
                />
              </div>
              <div>
                <h3 className="text-[16px] font-semibold text-gray-900 mb-1">
                  {booking.listing.name}
                </h3>
                <p className="text-[14px] text-gray-600">
                  {booking.listing.city?.name || booking.listing.address}
                </p>
              </div>
            </div>

            <div className="space-y-4">
              {booking.bookingType === 'hotel' && (
                <>
                  {booking.checkInDate && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Check-in</span>
                      <span className="font-medium text-gray-900">
                        {new Date(booking.checkInDate).toLocaleDateString('en-US', { 
                          weekday: 'short', 
                          month: 'short', 
                          day: 'numeric', 
                          year: 'numeric' 
                        })}
                      </span>
                    </div>
                  )}

                  {booking.checkOutDate && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Check-out</span>
                      <span className="font-medium text-gray-900">
                        {new Date(booking.checkOutDate).toLocaleDateString('en-US', { 
                          weekday: 'short', 
                          month: 'short', 
                          day: 'numeric', 
                          year: 'numeric' 
                        })}
                      </span>
                    </div>
                  )}

                  {booking.roomCount && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Rooms</span>
                      <span className="font-medium text-gray-900">{booking.roomCount} {booking.roomCount === 1 ? 'room' : 'rooms'}</span>
                    </div>
                  )}
                </>
              )}

              {booking.bookingType === 'restaurant' && (
                <>
                  {booking.bookingDate && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Date</span>
                      <span className="font-medium text-gray-900">
                        {new Date(booking.bookingDate).toLocaleDateString('en-US', { 
                          weekday: 'short', 
                          month: 'short', 
                          day: 'numeric', 
                          year: 'numeric' 
                        })}
                      </span>
                    </div>
                  )}

                  {booking.bookingTime && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Time</span>
                      <span className="font-medium text-gray-900">{booking.bookingTime}</span>
                    </div>
                  )}

                  {booking.partySize && (
                    <div className="flex justify-between text-[15px]">
                      <span className="text-gray-600">Party size</span>
                      <span className="font-medium text-gray-900">{booking.partySize} {booking.partySize === 1 ? 'guest' : 'guests'}</span>
                    </div>
                  )}
                </>
              )}

              <div className="flex justify-between text-[15px]">
                <span className="text-gray-600">Guests</span>
                <span className="font-medium text-gray-900">{booking.guestCount}</span>
              </div>

              <div className="flex justify-between text-[15px] pt-4 border-t border-gray-200">
                <span className="text-gray-600">Status</span>
                <span className={`font-semibold ${
                  booking.status === 'confirmed' ? 'text-green-600' :
                  booking.status === 'pending' ? 'text-yellow-600' :
                  booking.status === 'cancelled' ? 'text-red-600' :
                  'text-gray-900'
                }`}>
                  {booking.status.charAt(0).toUpperCase() + booking.status.slice(1)}
                </span>
              </div>

              {booking.totalAmount && (
                <div className="flex justify-between text-[15px] pt-4 border-t border-gray-200">
                  <span className="text-gray-600">Total Amount</span>
                  <span className="text-xl font-semibold text-gray-900">
                    ${booking.totalAmount.toFixed(2)}
                  </span>
                </div>
              )}
            </div>

            <div className="mt-8 flex flex-col sm:flex-row gap-3">
              <Link
                href="/profile"
                className="flex-1 py-3.5 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors text-center"
              >
                View My Bookings
              </Link>
              <Link
                href="/"
                className="flex-1 py-3.5 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors text-center"
              >
                Back to Home
              </Link>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
