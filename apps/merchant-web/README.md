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

- **Framework**: Next.js (React, TypeScript) - *To be implemented*
- **Styling**: Tailwind CSS
- **State Management**: React Context / Zustand
- **API Client**: Axios
- **Authentication**: JWT tokens via backend API

## Status

⏳ **Planned** - This application is planned for future development.

## Difference from Admin App

| Feature | Merchant Web | Admin Web |
|---------|-------------|-----------|
| **Users** | Business owners, merchants | Platform administrators |
| **Access** | Own business data only | All platform data |
| **Features** | Bookings, inventory, revenue | User management, system config, analytics |
| **Permissions** | Limited to merchant role | Full platform access |
| **Deployment** | Separate (can update independently) | Separate |

## Getting Started

*To be implemented*

```bash
cd apps/merchant-web
npm install
npm run dev
```

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
