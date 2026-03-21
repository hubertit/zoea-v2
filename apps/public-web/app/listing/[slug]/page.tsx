'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Image from 'next/image';
import Link from 'next/link';
import { useState } from 'react';

export default function ListingPage() {
  const [selectedImage, setSelectedImage] = useState(0);

  const listing = {
    name: 'Kigali Serena Hotel',
    city: 'Kigali',
    address: 'KN 3 Ave, Kigali',
    rating: 4.8,
    reviewCount: 245,
    priceRange: '$$$',
    isVerified: true,
    description: 'Experience luxury in the heart of Kigali. Our hotel offers world-class amenities, stunning views, and exceptional service. Perfect for both business and leisure travelers.',
    images: [
      'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=1200',
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200',
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1200',
      'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1200',
    ],
    amenities: ['Free WiFi', 'Pool', 'Restaurant', 'Spa', 'Gym', 'Parking'],
    hours: 'Open 24 hours',
    phone: '+250 788 123 456',
    email: 'info@example.com',
  };

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
                    src={listing.images[selectedImage]}
                    alt={listing.name}
                    fill
                    className="object-cover"
                    unoptimized
                  />
                </div>

                <div className="grid grid-cols-4 gap-3">
                  {listing.images.map((image, index) => (
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
                    <div className="flex items-center gap-1.5">
                      <svg className="w-5 h-5 text-yellow-500 fill-current" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                      <span className="font-semibold text-gray-900">{listing.rating}</span>
                      <span>({listing.reviewCount} reviews)</span>
                    </div>
                    <span>•</span>
                    <span>{listing.city}</span>
                  </div>

                  <p className="text-[15px] text-gray-600 leading-relaxed">
                    {listing.description}
                  </p>
                </div>

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

                <div>
                  <h2 className="text-xl font-semibold text-gray-900 mb-4">Location</h2>
                  <p className="text-[15px] text-gray-600 mb-4">{listing.address}</p>
                  <div className="aspect-[16/9] bg-gray-100 rounded-2xl flex items-center justify-center">
                    <p className="text-gray-400">Map will be integrated here</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="lg:col-span-1">
              <div className="sticky top-24">
                <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
                  <div className="mb-6">
                    <p className="text-[13px] text-gray-600 mb-1">Price Range</p>
                    <p className="text-2xl font-semibold text-gray-900">{listing.priceRange}</p>
                  </div>

                  <button className="w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors mb-3">
                    Book Now
                  </button>

                  <button className="w-full py-3.5 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors">
                    Contact
                  </button>

                  <div className="mt-6 pt-6 border-t border-gray-200 space-y-4">
                    <div className="flex items-start gap-3">
                      <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <div>
                        <p className="text-[13px] text-gray-600">Hours</p>
                        <p className="text-[14px] font-medium text-gray-900">{listing.hours}</p>
                      </div>
                    </div>

                    <div className="flex items-start gap-3">
                      <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                      </svg>
                      <div>
                        <p className="text-[13px] text-gray-600">Phone</p>
                        <p className="text-[14px] font-medium text-gray-900">{listing.phone}</p>
                      </div>
                    </div>

                    <div className="flex items-start gap-3">
                      <svg className="w-5 h-5 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      <div>
                        <p className="text-[13px] text-gray-600">Email</p>
                        <p className="text-[14px] font-medium text-gray-900">{listing.email}</p>
                      </div>
                    </div>
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
