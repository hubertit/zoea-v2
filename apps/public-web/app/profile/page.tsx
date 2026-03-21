'use client';

import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import { ListingCard } from '@/components/ListingCard';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { userApi, type User, type Favorite } from '@/lib/api/user';

export default function ProfilePage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [favorites, setFavorites] = useState<Favorite[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'favorites' | 'bookings'>('favorites');

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem('access_token');
      if (!token) {
        router.push('/login');
        return;
      }

      try {
        const [userData, favoritesData] = await Promise.all([
          userApi.getProfile(),
          userApi.getFavorites(),
        ]);
        setUser(userData);
        setFavorites(favoritesData);
      } catch (error) {
        console.error('Failed to fetch profile:', error);
        router.push('/login');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [router]);

  const handleLogout = () => {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    router.push('/');
  };

  if (loading) {
    return (
      <>
        <Header />
        <main className="pt-20 min-h-screen flex items-center justify-center">
          <div className="inline-block w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        </main>
        <Footer />
      </>
    );
  }

  if (!user) return null;

  return (
    <>
      <Header />
      <main className="pt-20 min-h-screen bg-gray-50">
        <div className="max-w-7xl mx-auto px-6 lg:px-8 py-12">
          <div className="bg-white rounded-2xl border border-gray-200 p-8 mb-8">
            <div className="flex flex-col md:flex-row gap-6 items-start md:items-center justify-between">
              <div className="flex items-center gap-6">
                <div className="w-20 h-20 bg-primary rounded-full flex items-center justify-center">
                  <span className="text-white text-3xl font-semibold">
                    {user.name.charAt(0).toUpperCase()}
                  </span>
                </div>
                <div>
                  <h1 className="text-2xl font-semibold text-gray-900 mb-1">
                    {user.name}
                  </h1>
                  <p className="text-[15px] text-gray-600">{user.email}</p>
                </div>
              </div>

              <button
                onClick={handleLogout}
                className="px-6 py-2.5 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors"
              >
                Sign out
              </button>
            </div>
          </div>

          <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
            <div className="border-b border-gray-200">
              <div className="flex">
                <button
                  onClick={() => setActiveTab('favorites')}
                  className={`flex-1 px-6 py-4 text-[15px] font-semibold transition-colors ${
                    activeTab === 'favorites'
                      ? 'text-primary border-b-2 border-primary'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  Favorites ({favorites.length})
                </button>
                <button
                  onClick={() => setActiveTab('bookings')}
                  className={`flex-1 px-6 py-4 text-[15px] font-semibold transition-colors ${
                    activeTab === 'bookings'
                      ? 'text-primary border-b-2 border-primary'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  Bookings (0)
                </button>
              </div>
            </div>

            <div className="p-8">
              {activeTab === 'favorites' && (
                <>
                  {favorites.length > 0 ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                      {favorites.map((favorite) => (
                        <ListingCard
                          key={favorite.listing.id}
                          id={favorite.listing.id}
                          name={favorite.listing.name}
                          slug={favorite.listing.slug}
                          image={favorite.listing.images?.[0]?.url || 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'}
                          city={favorite.listing.location.city}
                          rating={favorite.listing.rating}
                          reviewCount={favorite.listing.reviewCount}
                          priceRange={favorite.listing.priceRange}
                          isVerified={favorite.listing.isVerified}
                        />
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-16">
                      <svg className="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                      </svg>
                      <h2 className="text-xl font-semibold text-gray-900 mb-2">No favorites yet</h2>
                      <p className="text-[15px] text-gray-600 mb-6">
                        Start exploring and save your favorite places
                      </p>
                      <a
                        href="/"
                        className="inline-block px-6 py-3 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors"
                      >
                        Explore places
                      </a>
                    </div>
                  )}
                </>
              )}

              {activeTab === 'bookings' && (
                <div className="text-center py-16">
                  <svg className="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <h2 className="text-xl font-semibold text-gray-900 mb-2">No bookings yet</h2>
                  <p className="text-[15px] text-gray-600">
                    Your bookings will appear here
                  </p>
                </div>
              )}
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
