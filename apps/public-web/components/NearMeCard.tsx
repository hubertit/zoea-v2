import Link from 'next/link';
import Image from 'next/image';

interface NearMeCardProps {
  id: string;
  name: string;
  slug: string;
  image: string;
  city: string;
  category: string;
}

export function NearMeCard({
  id,
  name,
  slug,
  image,
  city,
  category,
}: NearMeCardProps) {
  return (
    <Link href={`/listing/${slug}`} className="group block">
      <div className="flex gap-3 sm:gap-4 bg-white rounded-lg sm:rounded-xl overflow-hidden hover:shadow-md transition-shadow">
        <div className="relative w-20 h-20 sm:w-24 sm:h-24 flex-shrink-0">
          <Image
            src={image}
            alt={name}
            fill
            className="object-cover"
            unoptimized
          />
        </div>

        <div className="flex-1 py-2.5 sm:py-3 pr-3 sm:pr-4 min-w-0">
          <h3 className="text-[14px] sm:text-[15px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-1 mb-1">
            {name}
          </h3>
          <div className="flex items-center gap-1.5 sm:gap-2 text-[12px] sm:text-[13px] text-gray-600">
            <div className="flex items-center gap-1">
              <svg className="w-3 h-3 sm:w-3.5 sm:h-3.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span className="truncate">{city}</span>
            </div>
            <span>•</span>
            <span className="truncate">{category}</span>
          </div>
        </div>
      </div>
    </Link>
  );
}
