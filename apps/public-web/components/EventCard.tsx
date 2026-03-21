import Link from 'next/link';
import Image from 'next/image';
import type { Event } from '@/lib/api/events';

interface EventCardProps {
  event: Event;
}

export function EventCard({ event }: EventCardProps) {
  const eventDetails = event.event;
  const owner = event.owner;

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    });
  };

  return (
    <Link href={`/event/${event.id}`} className="group block">
      <div className="bg-white rounded-xl sm:rounded-2xl border border-gray-200 overflow-hidden hover:border-gray-300 transition-all">
        <div className="relative aspect-[16/9] overflow-hidden">
          {eventDetails.flyer ? (
            <Image
              src={eventDetails.flyer}
              alt={eventDetails.name}
              fill
              className="object-cover group-hover:scale-105 transition-transform duration-700"
              unoptimized
            />
          ) : (
            <div className="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5" />
          )}
          
          <div className="absolute top-3 left-3 px-3 py-1.5 bg-white/95 backdrop-blur-sm rounded-lg">
            <p className="text-[12px] font-semibold text-primary">
              {new Date(eventDetails.startDate).toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
              })}
            </p>
          </div>

          {eventDetails.eventContext && (
            <div className="absolute top-3 right-3 px-3 py-1 bg-primary/90 backdrop-blur-sm rounded-full">
              <p className="text-[11px] font-semibold text-white uppercase">
                {eventDetails.eventContext.name}
              </p>
            </div>
          )}
        </div>

        <div className="p-4 space-y-3">
          <h3 className="text-[15px] sm:text-[16px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-2">
            {eventDetails.name}
          </h3>

          <div className="space-y-2 text-[13px] sm:text-[14px] text-gray-600">
            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span>{formatDate(eventDetails.startDate)}</span>
            </div>

            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>{formatTime(eventDetails.startDate)} - {formatTime(eventDetails.endDate)}</span>
            </div>

            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span className="truncate">{eventDetails.locationName}</span>
            </div>
          </div>

          <div className="flex items-center gap-2 pt-2 border-t border-gray-100">
            {owner.imageUrl ? (
              <Image
                src={owner.imageUrl}
                alt={owner.name}
                width={24}
                height={24}
                className="rounded-full flex-shrink-0"
                unoptimized
              />
            ) : (
              <div className="w-6 h-6 rounded-full bg-gradient-to-br from-primary to-primary/70 flex items-center justify-center flex-shrink-0">
                <span className="text-white text-[10px] font-semibold">
                  {owner.name.charAt(0).toUpperCase()}
                </span>
              </div>
            )}
            <span className="text-[13px] text-gray-600 truncate">{owner.name}</span>
            {owner.isVerified && (
              <svg className="w-4 h-4 text-blue-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
              </svg>
            )}
          </div>

          {eventDetails.tickets && eventDetails.tickets.length > 0 && (
            <div className="flex items-center justify-between pt-2">
              <span className="text-[14px] sm:text-[15px] font-semibold text-primary">
                From {eventDetails.tickets[0].currency} {eventDetails.tickets[0].price.toLocaleString()}
              </span>
              <div className="flex items-center gap-1 text-[13px] text-gray-600">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                <span>{eventDetails.attending}/{eventDetails.maxAttendance}</span>
              </div>
            </div>
          )}
        </div>
      </div>
    </Link>
  );
}
