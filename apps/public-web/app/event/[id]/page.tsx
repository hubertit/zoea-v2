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

  const eventDetails = event.event;
  const owner = event.owner;

  return (
    <>
      <Header />
      <main className="pt-16 sm:pt-18 lg:pt-20 bg-gray-50">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
          <Link
            href="/events"
            className="inline-flex items-center gap-2 text-[14px] sm:text-[15px] font-medium text-gray-700 hover:text-primary transition-colors mb-4 sm:mb-6 group"
          >
            <div className="w-8 h-8 rounded-full bg-white border border-gray-200 group-hover:bg-primary/10 group-hover:border-primary flex items-center justify-center transition-colors">
              <svg className="w-4 h-4 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </div>
            <span>Back to events</span>
          </Link>

          {eventDetails.flyer && (
            <div className="relative aspect-[16/9] lg:aspect-[21/9] rounded-xl sm:rounded-2xl overflow-hidden mb-6 sm:mb-8">
              <Image
                src={eventDetails.flyer}
                alt={eventDetails.name}
                fill
                className="object-cover"
                unoptimized
                priority
              />
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
            <div className="lg:col-span-2 space-y-4">
              <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 border border-gray-200">
                <h1 className="text-2xl sm:text-3xl lg:text-4xl font-semibold text-gray-900 mb-4">
                  {eventDetails.name}
                </h1>
                <p className="text-[15px] sm:text-[16px] text-gray-700 leading-relaxed whitespace-pre-line">
                  {eventDetails.description}
                </p>
              </div>

              <div className="bg-white rounded-xl sm:rounded-2xl p-6 sm:p-8 border border-gray-200">
                <h3 className="text-lg sm:text-xl font-semibold text-gray-900 mb-6">Event Details</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Date</p>
                      <p className="text-[15px] font-medium text-gray-900">
                        {new Date(eventDetails.startDate).toLocaleDateString('en-US', {
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
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Time</p>
                      <p className="text-[15px] font-medium text-gray-900">
                        {new Date(eventDetails.startDate).toLocaleTimeString('en-US', {
                          hour: '2-digit',
                          minute: '2-digit',
                          hour12: false,
                        })} - {new Date(eventDetails.endDate).toLocaleTimeString('en-US', {
                          hour: '2-digit',
                          minute: '2-digit',
                          hour12: false,
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
                        {eventDetails.locationName}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Attendance</p>
                      <p className="text-[15px] font-medium text-gray-900">
                        {eventDetails.attending} / {eventDetails.maxAttendance} attending
                      </p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <div>
                      <p className="text-[13px] text-gray-600 mb-1">Organizer</p>
                      <div className="flex items-center gap-2">
                        <p className="text-[15px] font-medium text-gray-900">
                          {owner.name}
                        </p>
                        {owner.isVerified && (
                          <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                          </svg>
                        )}
                      </div>
                    </div>
                  </div>

                  {eventDetails.eventContext && (
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                        <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                        </svg>
                      </div>
                      <div>
                        <p className="text-[13px] text-gray-600 mb-1">Category</p>
                        <p className="text-[15px] font-medium text-gray-900">
                          {eventDetails.eventContext.name}
                        </p>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>

            <div className="lg:col-span-1">
              <div className="lg:sticky lg:top-24 bg-white border border-gray-200 rounded-xl sm:rounded-2xl p-5 sm:p-6 shadow-lg">
                {eventDetails.tickets && eventDetails.tickets.length > 0 && (
                  <div className="mb-6 pb-6 border-b border-gray-100">
                    <p className="text-[13px] text-gray-600 mb-2">Tickets from</p>
                    <p className="text-2xl sm:text-3xl font-semibold text-gray-900">
                      {eventDetails.tickets[0].currency} {eventDetails.tickets[0].price.toLocaleString()}
                    </p>
                  </div>
                )}

                <button className="w-full py-3.5 bg-gradient-to-r from-primary to-primary/90 text-white text-[15px] font-semibold rounded-lg hover:from-primary/90 hover:to-primary/80 transition-all text-center mb-3">
                  Get Tickets
                </button>

                <button className="w-full py-3.5 border border-gray-200 text-gray-900 text-[15px] font-semibold rounded-lg hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                  </svg>
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
