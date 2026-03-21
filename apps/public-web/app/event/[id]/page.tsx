'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Image from 'next/image';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { eventsApi, type Event } from '@/lib/api/events';

export default function EventDetailPage() {
  const params = useParams();
  const eventId = params.id as string;
  
  const [event, setEvent] = useState<Event | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const data = await eventsApi.getById(eventId);
        setEvent(data);
      } catch (error) {
        console.error('Failed to fetch event:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchEvent();
  }, [eventId]);

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

  if (!event) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Event not found</h1>
            <Link href="/events" className="text-primary hover:underline">
              Back to events
            </Link>
          </div>
        </main>
        <Footer />
      </>
    );
  }

  return (
    <>
      <Header />
      <main className="pt-20">
        <div className="max-w-5xl mx-auto px-6 lg:px-8 py-8 lg:py-12">
          <Link
            href="/events"
            className="inline-flex items-center gap-2 text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-6"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Back to events
          </Link>

          {event.image && (
            <div className="relative aspect-[21/9] rounded-2xl overflow-hidden mb-8">
              <Image
                src={event.image}
                alt={event.name}
                fill
                className="object-cover"
                unoptimized
              />
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 space-y-8">
              <div>
                <h1 className="text-3xl lg:text-4xl font-semibold text-gray-900 mb-4">
                  {event.name}
                </h1>
                <p className="text-[15px] text-gray-700 leading-relaxed">
                  {event.description}
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <p className="text-[13px] text-gray-600 mb-1">Date & Time</p>
                    <p className="text-[15px] font-medium text-gray-900">
                      {new Date(event.startDate).toLocaleDateString('en-US', {
                        weekday: 'long',
                        month: 'long',
                        day: 'numeric',
                        year: 'numeric',
                      })}
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <div>
                    <p className="text-[13px] text-gray-600 mb-1">Location</p>
                    <p className="text-[15px] font-medium text-gray-900">
                      {event.location.name}
                    </p>
                    <p className="text-[14px] text-gray-600">
                      {event.location.city}
                    </p>
                  </div>
                </div>

                {event.organizer && (
                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Organizer</p>
                      <p className="text-[15px] font-medium text-gray-900">
                        {event.organizer}
                      </p>
                    </div>
                  </div>
                )}

                {event.category && (
                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Category</p>
                      <p className="text-[15px] font-medium text-gray-900">
                        {event.category}
                      </p>
                    </div>
                  </div>
                )}
              </div>
            </div>

            <div className="lg:col-span-1">
              <div className="sticky top-24 bg-white border border-gray-200 rounded-2xl p-6">
                {event.price && (
                  <div className="mb-6">
                    <p className="text-[13px] text-gray-600 mb-1">Price</p>
                    <p className="text-2xl font-semibold text-gray-900">
                      {event.price.currency} {event.price.min}
                      {event.price.max !== event.price.min && ` - ${event.price.max}`}
                    </p>
                  </div>
                )}

                {event.website && (
                  <a
                    href={event.website}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="block w-full py-3.5 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors text-center mb-3"
                  >
                    Get Tickets
                  </a>
                )}

                <button className="w-full py-3.5 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors">
                  Share Event
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
