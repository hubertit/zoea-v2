import { Header } from '@/components/Header';
import { Footer } from '@/components/Footer';
import Link from 'next/link';

export default function NotFound() {
  return (
    <>
      <Header />
      <main className="pt-20 min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center px-6">
          <div className="mb-8">
            <h1 className="text-8xl font-bold text-primary mb-4">404</h1>
            <h2 className="text-3xl font-semibold text-gray-900 mb-3">
              Page not found
            </h2>
            <p className="text-[15px] text-gray-600 max-w-md mx-auto">
              Sorry, we couldn't find the page you're looking for. 
              It might have been moved or deleted.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="/"
              className="px-6 py-3 bg-primary text-white text-[15px] font-semibold rounded-xl hover:bg-primary/90 transition-colors"
            >
              Back to Home
            </Link>
            <Link
              href="/explore"
              className="px-6 py-3 border-2 border-gray-200 text-gray-900 text-[15px] font-semibold rounded-xl hover:bg-gray-50 transition-colors"
            >
              Explore Places
            </Link>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
