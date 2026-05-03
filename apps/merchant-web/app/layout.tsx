import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import "react-phone-number-input/style.css";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#181E29",
};

export const metadata: Metadata = {
  title: {
    default: "Zoea Merchant",
    template: "%s | Zoea Merchant",
  },
  description: "Manage your Zoea business — listings, bookings, and growth.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={inter.variable}>
      <body className="font-sans antialiased min-h-[100dvh] overflow-x-hidden">{children}</body>
    </html>
  );
}
