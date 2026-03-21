import Link from 'next/link';
import Image from 'next/image';

interface TourCardProps {
  id: string;
  name: string;
  slug: string;
  image: string;
  city: string;
  duration: string;
  difficulty: string;
  price: string;
}

export function TourCard({
  id,
  name,
  slug,
  image,
  city,
  duration,
  difficulty,
  price,
}: TourCardProps) {
  return (
    <Link href={`/tour/${slug}`} className="group block">
      <div className="relative aspect-[4/3] rounded-xl sm:rounded-2xl overflow-hidden mb-3 sm:mb-4">
        <Image
          src={image}
          alt={name}
          fill
          className="object-cover group-hover:scale-105 transition-transform duration-500"
          unoptimized
        />
        <div className="absolute top-3 right-3 sm:top-4 sm:right-4 px-2.5 sm:px-3 py-1 sm:py-1.5 bg-white/95 backdrop-blur-sm rounded-full">
          <span className="text-[12px] sm:text-[13px] font-semibold text-gray-900">{price}</span>
        </div>
      </div>

      <div className="space-y-1.5 sm:space-y-2">
        <h3 className="text-[14px] sm:text-[15px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-2">
          {name}
        </h3>

        <div className="flex items-center gap-2 sm:gap-3 text-[12px] sm:text-[13px] text-gray-600 flex-wrap">
          <div className="flex items-center gap-1">
            <svg className="w-3.5 h-3.5 sm:w-4 sm:h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span className="truncate">{city}</span>
          </div>
          <span className="hidden sm:inline">•</span>
          <div className="flex items-center gap-1">
            <svg className="w-3.5 h-3.5 sm:w-4 sm:h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span className="truncate">{duration}</span>
          </div>
          <span className="hidden sm:inline">•</span>
          <span className="capitalize truncate">{difficulty}</span>
        </div>
      </div>
    </Link>
  );
}
