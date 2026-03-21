import Link from 'next/link';

interface CategoryCardProps {
  name: string;
  slug: string;
  icon?: string;
  count: number;
}

const getIconForCategory = (iconName?: string) => {
  // Map icon names to emoji icons for badge style
  switch (iconName?.toLowerCase()) {
    case 'hotel':
    case 'accommodation':
    case 'bed':
      return '🏨';
    case 'restaurant':
    case 'dining':
    case 'food':
      return '🍽️';
    case 'event':
    case 'events':
    case 'calendar':
      return '🎉';
    case 'nightlife':
    case 'night':
    case 'moon':
      return '🌙';
    case 'experience':
    case 'experiences':
    case 'adventure':
      return '🗺️';
    case 'shopping':
    case 'shopping_bag':
    case 'shop':
      return '🛍️';
    case 'attractions':
    case 'attraction':
      return '🎭';
    default:
      return '📍';
  }
};

export function CategoryCard({ name, slug, icon, count }: CategoryCardProps) {
  return (
    <Link href={`/category/${slug}`} className="group flex-shrink-0">
      <div className="px-4 sm:px-5 py-2.5 sm:py-3 bg-white border border-gray-200 rounded-full hover:border-primary hover:bg-gray-50 transition-all duration-200 flex items-center gap-2">
        <span className="text-base sm:text-lg">{getIconForCategory(icon)}</span>
        <span className="text-gray-900 text-[13px] sm:text-[14px] font-medium whitespace-nowrap">
          {name}
        </span>
      </div>
    </Link>
  );
}

