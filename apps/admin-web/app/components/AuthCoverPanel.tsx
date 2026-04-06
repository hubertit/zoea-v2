'use client';

import Image from 'next/image';

/**
 * Same photography set as public-mobile `kSplashBackgroundAssetPaths`
 * (assets/splash/*.jpg|jpeg), served from /public/auth/splash/.
 */
export const AUTH_SPLASH_IMAGES = [
  '/auth/splash/kigali.jpg',
  '/auth/splash/canopy.jpeg',
  '/auth/splash/nyungwe2.jpg',
] as const;

type AuthCoverPanelProps = {
  /** Which splash image to show (0 = Kigali, 1 = canopy, 2 = Nyungwe). */
  imageIndex?: number;
  /** Optional line shown over the image (bottom). */
  tagline?: string;
};

export default function AuthCoverPanel({ imageIndex = 0, tagline }: AuthCoverPanelProps) {
  const len = AUTH_SPLASH_IMAGES.length;
  const idx = ((imageIndex % len) + len) % len;
  const src = AUTH_SPLASH_IMAGES[idx];

  return (
    <div className="hidden lg:flex lg:w-[60%] relative min-h-screen overflow-hidden bg-[#0e1a30]">
      <Image
        src={src}
        alt="Rwanda — Zoea Africa"
        fill
        className="object-cover"
        sizes="60vw"
        priority
      />
      <div
        className="absolute inset-0 bg-gradient-to-t from-[#0a0f18]/90 via-[#0e1a30]/35 to-[#0e1a30]/50"
        aria-hidden
      />
      <div className="absolute inset-0 opacity-[0.12]" aria-hidden>
        <div
          className="absolute inset-0"
          style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
          }}
        />
      </div>
      {tagline ? (
        <div className="absolute bottom-10 left-10 right-10 z-10">
          <p className="text-white/95 text-xl sm:text-2xl font-semibold tracking-tight drop-shadow-lg max-w-md">
            {tagline}
          </p>
        </div>
      ) : null}
    </div>
  );
}
