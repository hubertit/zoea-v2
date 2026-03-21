# Zoea Public Web Application

A modern, clean web application for discovering the best places to stay, dine, and explore in Rwanda.

## Tech Stack

- **Framework**: Next.js 16 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Font**: Inter (matching mobile app)
- **HTTP Client**: Axios
- **API**: https://zoea-africa.qtsoftwareltd.com/api

## Features

### Core Pages
- **Home** (`/`) - Hero section, categories, featured listings
- **Explore** (`/explore`) - All categories and listings
- **Stay** (`/stay`) - Accommodation listings
- **Dine** (`/dine`) - Restaurant listings
- **Events** (`/events`) - SINC events integration
- **Search** (`/search`) - Search results with filters

### Listing Features
- **Category Pages** (`/category/[slug]`) - Filtered listings with sort/filter
- **Listing Detail** (`/listing/[slug]`) - Full details, images, reviews, map
- **Favorites** - Save/unsave listings (requires auth)
- **Reviews** - Display user reviews with ratings

### User Features
- **Login** (`/login`) - JWT authentication
- **Signup** (`/signup`) - User registration
- **Profile** (`/profile`) - User dashboard with favorites and bookings tabs
- **Bookings** - View booking history and status

### Booking Flow
- **Booking Page** (`/booking/[listingId]`) - Date selection, guest count
- **Confirmation** (`/booking/confirmation/[id]`) - Booking success page

### UI Components
- **Header** - Sticky header with scroll effect, mobile menu
- **Hero** - Gradient background with search form
- **Footer** - Multi-column with social links
- **BottomNav** - Mobile-only bottom navigation
- **Cards** - Listing, Category, Event, Review cards
- **Loading** - Reusable loading spinner

## Design System

- **Primary Color**: #181E29 (Zoea brand)
- **Font**: Inter (300, 400, 500, 600, 700)
- **Spacing**: Consistent 4px-based scale
- **Border Radius**: xl (12px) for most elements
- **Shadows**: Minimal, subtle shadows
- **Responsive**: Mobile-first with breakpoints

## Getting Started

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

Open [http://localhost:3001](http://localhost:3001) to view the app.

## API Integration

All pages fetch real data from the backend:
- Categories and listings from Zoea API
- Events from SINC API
- Authentication with JWT tokens
- Automatic token refresh on 401 errors

## Deployment

Ready for deployment to Vercel or any Node.js hosting platform.
