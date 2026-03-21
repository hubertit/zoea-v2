import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { BottomNav } from "@/components/BottomNav";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Zoea - Discover Rwanda",
  description: "Explore the best hotels, restaurants, tours, and experiences in Rwanda",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full">
      <body className={`${inter.className} min-h-full antialiased pb-16 lg:pb-0`}>
        {children}
        <BottomNav />
      </body>
    </html>
  );
}
