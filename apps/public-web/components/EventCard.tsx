import Link from 'next/link';
import Image from 'next/image';
import type { Event } from '@/lib/api/events';

interface EventCardProps {
  event: Event;
}

export function EventCard({ event }: EventCardProps) {
  return (
    <Link href={`/event/${event.id}`} className="group block">
      <div className="relative aspect-[16/9] rounded-2xl overflow-hidden mb-4">
        {event.image ? (
          <Image
            src={event.image}
            alt={event.name}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-500"
            unoptimized
          />
        ) : (
          <div className="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5" />
        )}
        
        <div className="absolute top-4 left-4 px-3 py-1.5 bg-white/95 backdrop-blur-sm rounded-lg">
          <p className="text-[12px] font-semibold text-primary">
            {new Date(event.startDate).toLocaleDateString('en-US', {
              month: 'short',
              day: 'numeric',
            })}
          </p>
        </div>
      </div>

      <div className="space-y-2">
        <h3 className="text-[16px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-2">
          {event.name}
        </h3>

        <p className="text-[14px] text-gray-600 flex items-center gap-1.5">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          {event.location.city}
        </p>

        {event.price && (
          <p className="text-[14px] font-semibold text-gray-900">
            {event.price.currency} {event.price.min}
            {event.price.max !== event.price.min && ` - ${event.price.max}`}
          </p>
        )}
      </div>
    </Link>
  );
}
