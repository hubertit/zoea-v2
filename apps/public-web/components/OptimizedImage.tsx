'use client';

import Image from 'next/image';
import { useState } from 'react';

interface OptimizedImageProps {
  src: string;
  alt: string;
  fill?: boolean;
  className?: string;
  width?: number;
  height?: number;
  priority?: boolean;
}

export function OptimizedImage({ 
  src, 
  alt, 
  fill, 
  className, 
  width, 
  height,
  priority = false 
}: OptimizedImageProps) {
  const [error, setError] = useState(false);

  const fallbackImage = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800';

  if (error) {
    return (
      <div className={`bg-gray-100 flex items-center justify-center ${className}`}>
        <svg className="w-12 h-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      </div>
    );
  }

  return (
    <Image
      src={src || fallbackImage}
      alt={alt}
      fill={fill}
      width={width}
      height={height}
      className={className}
      onError={() => setError(true)}
      priority={priority}
      unoptimized
    />
  );
}
