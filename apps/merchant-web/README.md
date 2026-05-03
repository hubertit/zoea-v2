# Zoea Merchant Web Portal

**Business Management Portal for Merchants**

## Overview

The Merchant Web Portal is a dedicated web application for business owners and merchants to manage their presence on the Zoea platform. This is separate from the Admin dashboard to provide a tailored experience for merchant operations.

## Purpose

- Manage business listings (accommodations, restaurants, tours, activities)
- Handle bookings and reservations
- Track revenue and analytics
- Manage inventory and availability
- Respond to reviews and customer inquiries
- Update business information and media

## Technology Stack

- **Framework**: Next.js 16 (React 19, TypeScript)
- **Styling**: Tailwind CSS
- **State Management**: React Context / Zustand
- **API Client**: Axios
- **Authentication**: JWT tokens via backend API

## Status

**Scaffolded** — Next.js app runs locally (`npm run dev`). Features from the list below are still to be built.

## Difference from Admin App

| Feature | Merchant Web | Admin Web |
|---------|-------------|-----------|
| **Users** | Business owners, merchants | Platform administrators |
| **Access** | Own business data only | All platform data |
| **Features** | Bookings, inventory, revenue | User management, system config, analytics |
| **Permissions** | Limited to merchant role | Full platform access |
| **Deployment** | Separate (can update independently) | Separate |

## Getting Started

```bash
cd apps/merchant-web
npm install
npm run dev
```

Open **http://localhost:3010** — `/` redirects to **`/auth/login`**. Auth UI follows the same split layout as Gemura Web (40% form / 60% cover) with Zoea branding. Register: **`/auth/register`**.

Port **3010** avoids clashing with other apps on 3000.

## API Integration

Connects to: `https://zoea-africa.qtsoftwareltd.com/api`

Uses merchant-specific endpoints:
- `/merchants/profile`
- `/merchants/listings`
- `/merchants/bookings`
- `/merchants/analytics`
- `/merchants/reviews`

## Future Features

- Dashboard with key metrics (bookings, revenue, reviews)
- Listing management (create, edit, delete)
- Booking calendar and management
- Revenue reports and analytics
- Review management and responses
- Media gallery management
- Availability and pricing management
- Notification center
- Multi-location support
