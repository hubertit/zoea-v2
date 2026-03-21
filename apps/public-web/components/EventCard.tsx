import Link from 'next/link';
import Image from 'next/image';
import type { Event } from '@/lib/api/events';

interface EventCardProps {
  event: Event;
}

export function EventCard({ event }: EventCardProps) {
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
          {event.image ? (
            <Image
              src={event.image}
              alt={event.name}
              fill
              className="object-cover group-hover:scale-105 transition-transform duration-700"
              unoptimized
            />
          ) : (
            <div className="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5" />
          )}
          
          <div className="absolute top-3 left-3 px-3 py-1.5 bg-white/95 backdrop-blur-sm rounded-lg">
            <p className="text-[12px] font-semibold text-primary">
              {new Date(event.startDate).toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
              })}
            </p>
          </div>

          {event.category && (
            <div className="absolute top-3 right-3 px-3 py-1 bg-primary/90 backdrop-blur-sm rounded-full">
              <p className="text-[11px] font-semibold text-white uppercase">
                {event.category}
              </p>
            </div>
          )}
        </div>

        <div className="p-4 space-y-3">
          <h3 className="text-[15px] sm:text-[16px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-2">
            {event.name}
          </h3>

          <div className="space-y-2 text-[13px] sm:text-[14px] text-gray-600">
            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span>{formatDate(event.startDate)}</span>
            </div>

            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>{formatTime(event.startDate)} - {formatTime(event.endDate)}</span>
            </div>

            <div className="flex items-center gap-2">
              <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span className="truncate">{event.location.city}</span>
            </div>
          </div>

          {event.organizer && (
            <div className="flex items-center gap-2 pt-2 border-t border-gray-100">
              <div className="w-6 h-6 rounded-full bg-gradient-to-br from-primary to-primary/70 flex items-center justify-center flex-shrink-0">
                <span className="text-white text-[10px] font-semibold">
                  {event.organizer.charAt(0).toUpperCase()}
                </span>
              </div>
              <span className="text-[13px] text-gray-600 truncate">{event.organizer}</span>
            </div>
          )}

          {event.price && (
            <div className="flex items-center justify-between pt-2">
              <span className="text-[14px] sm:text-[15px] font-semibold text-primary">
                From {event.price.currency} {event.price.min.toLocaleString()}
              </span>
            </div>
          )}
        </div>
      </div>
    </Link>
  );
}
