'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Image from 'next/image';
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
  
  const [formData, setFormData] = useState({
    startDate: '',
    endDate: '',
    guests: 1,
    specialRequests: '',
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);

    try {
      const booking = await bookingsApi.create({
        listingId,
        startDate: formData.startDate,
        endDate: formData.endDate,
        guests: formData.guests,
        specialRequests: formData.specialRequests,
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
        <div className="max-w-5xl mx-auto px-6 lg:px-8 py-12">
          <h1 className="text-3xl font-semibold text-gray-900 mb-8">
            Complete your booking
          </h1>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2">
              <form onSubmit={handleSubmit} className="bg-white rounded-2xl border border-gray-200 p-8 space-y-6">
                {error && (
                  <div className="px-4 py-3 bg-red-50 border border-red-200 rounded-xl">
                    <p className="text-[14px] text-red-600">{error}</p>
                  </div>
                )}

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label htmlFor="startDate" className="block text-[14px] font-medium text-gray-900 mb-2">
                      Check-in Date
                    </label>
                    <input
                      id="startDate"
                      type="date"
                      value={formData.startDate}
                      onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                      className="w-full px-4 py-3 text-[15px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                      required
                    />
                  </div>

                  <div>
                    <label htmlFor="endDate" className="block text-[14px] font-medium text-gray-900 mb-2">
                      Check-out Date
                    </label>
                    <input
                      id="endDate"
                      type="date"
                      value={formData.endDate}
                      onChange={(e) => setFormData({ ...formData, endDate: e.target.value })}
                      className="w-full px-4 py-3 text-[15px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label htmlFor="guests" className="block text-[14px] font-medium text-gray-900 mb-2">
                    Number of Guests
                  </label>
                  <input
                    id="guests"
                    type="number"
                    min="1"
                    value={formData.guests}
                    onChange={(e) => setFormData({ ...formData, guests: parseInt(e.target.value) })}
                    className="w-full px-4 py-3 text-[15px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                    required
                  />
                </div>

                <div>
                  <label htmlFor="specialRequests" className="block text-[14px] font-medium text-gray-900 mb-2">
                    Special Requests (Optional)
                  </label>
                  <textarea
                    id="specialRequests"
                    value={formData.specialRequests}
                    onChange={(e) => setFormData({ ...formData, specialRequests: e.target.value })}
                    rows={4}
                    className="w-full px-4 py-3 text-[15px] border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent resize-none"
                    placeholder="Any special requirements or requests?"
                  />
                </div>

                <button
                  type="submit"
                  disabled={submitting}
                  className="w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {submitting ? 'Processing...' : 'Confirm Booking'}
                </button>
              </form>
            </div>

            <div className="lg:col-span-1">
              <div className="bg-white rounded-2xl border border-gray-200 p-6 sticky top-24">
                <h2 className="text-lg font-semibold text-gray-900 mb-4">
                  Booking Summary
                </h2>

              <div className="relative aspect-[4/3] rounded-xl overflow-hidden mb-4">
                <Image
                  src={listing.images?.[0]?.media?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                  alt={listing.name}
                  fill
                  className="object-cover"
                  unoptimized
                />
                </div>

                <h3 className="text-[16px] font-semibold text-gray-900 mb-1">
                  {listing.name}
                </h3>
                <p className="text-[14px] text-gray-600 mb-4">
                  {listing.city?.name || listing.address}
                </p>

                {listing.rating && (
                  <div className="flex items-center gap-1.5 mb-6">
                    <svg className="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                    <span className="text-[14px] font-semibold text-gray-900">
                      {typeof listing.rating === 'number' ? listing.rating.toFixed(1) : parseFloat(listing.rating || '0').toFixed(1)}
                    </span>
                    <span className="text-[13px] text-gray-500">
                      ({listing.reviewCount})
                    </span>
                  </div>
                )}

                <div className="border-t border-gray-200 pt-4 space-y-3">
                  {formData.startDate && formData.endDate && (
                    <div className="flex justify-between text-[14px]">
                      <span className="text-gray-600">Dates</span>
                      <span className="font-medium text-gray-900">
                        {new Date(formData.startDate).toLocaleDateString()} - {new Date(formData.endDate).toLocaleDateString()}
                      </span>
                    </div>
                  )}
                  <div className="flex justify-between text-[14px]">
                    <span className="text-gray-600">Guests</span>
                    <span className="font-medium text-gray-900">{formData.guests}</span>
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
