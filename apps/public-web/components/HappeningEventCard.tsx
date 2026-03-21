import Link from 'next/link';
import Image from 'next/image';
import type { Event } from '@/lib/api/events';

interface HappeningEventCardProps {
  event: Event;
}

export function HappeningEventCard({ event }: HappeningEventCardProps) {
  const eventDetails = event.event;

  if (!eventDetails) {
    return null;
  }

  const formatDateTime = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const isToday =
      date.getDate() === now.getDate() &&
      date.getMonth() === now.getMonth() &&
      date.getFullYear() === now.getFullYear();

    const time = date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    });

    if (isToday) {
      return `Today, ${time}`;
    } else {
      const dateStr = date.toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
      });
      return `${dateStr}, ${time}`;
    }
  };

  return (
    <Link
      href={`/event/${event.id}`}
      className="group block flex-shrink-0 w-[200px]"
    >
      <div className="relative h-[120px] rounded-xl overflow-hidden">
        {eventDetails.flyer ? (
          <Image
            src={eventDetails.flyer}
            alt={eventDetails.name}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-500"
            unoptimized
          />
        ) : (
          <div className="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center">
            <svg className="w-10 h-10 text-primary/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
        )}

        {/* Gradient overlay */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent" />

        {/* Event details */}
        <div className="absolute bottom-0 left-0 right-0 p-3">
          <h3 className="text-white text-[12px] font-semibold mb-1 line-clamp-1">
            {eventDetails.name}
          </h3>
          <p className="text-white/80 text-[11px] font-medium">
            {formatDateTime(eventDetails.startDate)}
          </p>
        </div>
      </div>
    </Link>
  );
}
