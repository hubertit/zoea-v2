import Link from 'next/link';
import Image from 'next/image';

interface ListingCardProps {
  id: string;
  name: string;
  slug: string;
  image: string;
  city: string;
  rating?: number;
  reviewCount: number;
  priceRange?: string;
  isVerified?: boolean;
}

export function ListingCard({
  id,
  name,
  slug,
  image,
  city,
  rating,
  reviewCount,
  priceRange,
  isVerified,
}: ListingCardProps) {
  return (
    <Link href={`/listing/${slug}`} className="group block">
      <div className="relative aspect-[4/3] rounded-2xl overflow-hidden mb-4">
        <Image
          src={image}
          alt={name}
          fill
          className="object-cover group-hover:scale-105 transition-transform duration-500"
          unoptimized
        />
        
        <button
          onClick={(e) => {
            e.preventDefault();
            console.log('Toggle favorite:', id);
          }}
          className="absolute top-4 right-4 w-10 h-10 bg-white/95 backdrop-blur-sm rounded-full flex items-center justify-center hover:scale-110 transition-transform shadow-lg"
        >
          <svg
            className="w-5 h-5 text-gray-700"
            fill="none"
            stroke="currentColor"
            strokeWidth={2}
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
            />
          </svg>
        </button>
      </div>

      <div className="space-y-2">
        <div className="flex items-start justify-between gap-2">
          <h3 className="text-[15px] font-semibold text-gray-900 group-hover:text-primary transition-colors line-clamp-2 flex items-center gap-1.5">
            {name}
            {isVerified && (
              <svg
                className="w-4 h-4 text-blue-500 flex-shrink-0"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fillRule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
                  clipRule="evenodd"
                />
              </svg>
            )}
          </h3>
        </div>

        <p className="text-[14px] text-gray-600">{city}</p>

        <div className="flex items-center justify-between pt-1">
          {rating && (
            <div className="flex items-center gap-1.5">
              <svg
                className="w-4 h-4 text-yellow-500 fill-current"
                viewBox="0 0 20 20"
              >
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
              <span className="text-[14px] font-semibold text-gray-900">
                {rating.toFixed(1)}
              </span>
              <span className="text-[13px] text-gray-500">
                ({reviewCount})
              </span>
            </div>
          )}

          {priceRange && (
            <span className="text-[14px] font-semibold text-gray-900">
              {priceRange}
            </span>
          )}
        </div>
      </div>
    </Link>
  );
}
