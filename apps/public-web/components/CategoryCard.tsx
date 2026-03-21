import Link from 'next/link';
import Image from 'next/image';

interface CategoryCardProps {
  name: string;
  slug: string;
  image: string;
  count: number;
}

export function CategoryCard({ name, slug, image, count }: CategoryCardProps) {
  return (
    <Link href={`/category/${slug}`} className="group block">
      <div className="relative aspect-[4/3] rounded-xl sm:rounded-2xl overflow-hidden">
        <Image
          src={image}
          alt={name}
          fill
          className="object-cover group-hover:scale-110 transition-transform duration-500"
          unoptimized
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
        
        <div className="absolute inset-0 flex flex-col justify-end p-4 sm:p-5 lg:p-6">
          <h3 className="text-white text-base sm:text-lg lg:text-xl font-semibold mb-0.5 sm:mb-1">
            {name}
          </h3>
          <p className="text-white/90 text-[13px] sm:text-sm font-medium">
            {count} places
          </p>
        </div>
      </div>
    </Link>
  );
}
