# Management Portal Analysis

## Overview
This document analyzes what mobile features we implemented and what management interfaces exist or need to be created in the apps/admin-apps/public-web/merchant portal.

---

## What We Implemented in Mobile

### 1. Shop Features ✅
- **Products**: View, browse, add to cart, checkout
- **Services**: View, browse, book services
- **Menus**: View, browse, add items to cart
- **Cart**: Add, update quantities, remove items
- **Orders**: Create orders, view order history, cancel orders
- **Checkout**: Complete checkout flow with delivery/pickup options

### 2. Tour Features ✅
- **Tours**: Browse tours, view tour details
- **Tour Booking**: Book tours with schedules, guest details, pickup locations
- **Experiences Screen**: Filter tours by category (Tours, Adventures, Cultural)

---

## Current Portal Status

### Admin Portal (`/apps/admin-apps/public-web/dashboard`)

#### ✅ What Exists:
1. **Tours Page** (`/dashboard/tours`)
   - Status: ❌ **Placeholder only** - "Coming Soon"
   - No actual management interface

2. **Tour Operators Page** (`/dashboard/tour-operators`)
   - Status: ✅ **Implemented**
   - Shows users with `tour_operator` role
   - Can view operator details
   - **BUT**: No tour management, no operator-specific features

3. **Merchants Management** (`/dashboard/merchants`)
   - Status: ✅ **Fully Implemented**
   - CRUD operations for merchant profiles
   - Status management (pending, verified, rejected)

4. **Listings Management** (`/dashboard/listings`)
   - Status: ✅ **Fully Implemented**
   - CRUD operations for listings
   - Status management

5. **Bookings Management** (`/dashboard/bookings`)
   - Status: ✅ **Fully Implemented**
   - View all bookings
   - Update booking status
   - **BUT**: Only shows hotel/restaurant/event bookings, NOT shop orders or tour bookings

#### ❌ What's Missing:
1. **Products Management** - No UI exists
2. **Services Management** - No UI exists
3. **Menus Management** - No UI exists
4. **Orders Management** - No UI exists (orders are different from bookings)
5. **Tours Management** - Only placeholder
6. **Tour Bookings Management** - No UI exists
7. **Shop Settings** - No UI to enable/configure shop mode per listing

---

### Merchant Portal (`/apps/admin-apps/public-web/dashboard/my-*`)

#### ✅ What Exists:
1. **My Businesses** (`/dashboard/my-businesses`)
   - Status: ✅ **Implemented**
   - View/manage merchant's businesses

2. **My Listings** (`/dashboard/my-listings`)
   - Status: ✅ **Implemented**
   - CRUD operations for listings
   - Room types (hotels)
   - Tables (restaurants)
   - Images management

3. **My Bookings** (`/dashboard/my-bookings`)
   - Status: ✅ **Implemented**
   - View bookings for merchant's listings
   - Update booking status
   - **BUT**: Only shows hotel/restaurant bookings, NOT shop orders

4. **My Reviews** (`/dashboard/my-reviews`)
   - Status: ✅ **Implemented**
   - View and respond to reviews

5. **My Analytics** (`/dashboard/my-analytics`)
   - Status: ✅ **Implemented**
   - Revenue analytics
   - Booking analytics

#### ❌ What's Missing:
1. **Products Management** - No UI to create/edit/delete products
2. **Services Management** - No UI to create/edit/delete services
3. **Menus Management** - No UI to create/edit/delete menus, categories, items
4. **Orders Management** - No UI to view/manage shop orders
5. **Shop Settings** - No UI to enable shop mode or configure shop settings
6. **Inventory Management** - No UI to manage product inventory
7. **Service Bookings** - No UI to manage service bookings (separate from regular bookings)

---

### Tour Operators Portal

#### ❌ What's Missing (Everything):
1. **Tour Operators CANNOT login to merchant/admin portal**
   - Tour operators are separate from merchants
   - They have their own `TourOperatorProfile` (not `MerchantProfile`)
   - No dedicated portal exists for tour operators

2. **No Tour Management Interface**
   - Cannot create/edit/delete tours
   - Cannot manage tour schedules
   - Cannot view tour bookings
   - Cannot manage tour images

3. **No Tour Operator Dashboard**
   - No analytics
   - No booking management
   - No revenue tracking

---

## Backend API Status

### ✅ APIs That Exist (with Auth):

1. **Products API** (`/products`)
   - ✅ GET (public)
   - ✅ POST (authenticated - but no merchant verification)
   - ✅ PUT (authenticated - but no merchant verification)
   - ✅ DELETE (authenticated - but no merchant verification)
   - ⚠️ **Issue**: No authorization check to verify merchant owns the listing

2. **Services API** (`/services`)
   - ✅ GET (public)
   - ✅ POST (authenticated - but no merchant verification)
   - ✅ PUT (authenticated - but no merchant verification)
   - ✅ DELETE (authenticated - but no merchant verification)
   - ⚠️ **Issue**: No authorization check to verify merchant owns the listing

3. **Menus API** (`/menus`)
   - ✅ GET (public)
   - ✅ POST (authenticated - but no merchant verification)
   - ✅ PUT (authenticated - but no merchant verification)
   - ✅ DELETE (authenticated - but no merchant verification)
   - ⚠️ **Issue**: No authorization check to verify merchant owns the listing

4. **Orders API** (`/orders`)
   - ✅ GET (authenticated - user's orders)
   - ✅ GET `/orders/merchant/:merchantId` (merchant's orders)
   - ✅ POST (create order from cart)
   - ✅ PATCH (update status)
   - ✅ DELETE (cancel order)
   - ✅ **Good**: Has merchant-specific endpoint

5. **Tours API** (`/tours`)
   - ✅ GET (public)
   - ✅ POST (authenticated - but no operator verification)
   - ✅ PUT (authenticated - but no operator verification)
   - ✅ DELETE (authenticated - but no operator verification)
   - ⚠️ **Issue**: No authorization check to verify operator owns the tour

---

## What Needs to Be Implemented

### Priority 1: Critical (Merchant Portal)

#### 1. Products Management
- **Location**: `/dashboard/my-listings/[id]/products`
- **Features Needed**:
  - List products for a listing
  - Create product (with variants, inventory, pricing)
  - Edit product
  - Delete product
  - Manage product variants
  - Manage inventory
  - Upload product images
  - Set product status (draft, active, inactive)

#### 2. Services Management
- **Location**: `/dashboard/my-listings/[id]/services`
- **Features Needed**:
  - List services for a listing
  - Create service (with pricing, duration, availability)
  - Edit service
  - Delete service
  - Manage service bookings
  - Set service status

#### 3. Menus Management
- **Location**: `/dashboard/my-listings/[id]/menus`
- **Features Needed**:
  - List menus for a listing
  - Create menu
  - Edit menu
  - Delete menu
  - Manage menu categories
  - Manage menu items (with pricing, descriptions, images)
  - Organize items by category

#### 4. Orders Management
- **Location**: `/dashboard/my-orders` or `/dashboard/my-listings/[id]/orders`
- **Features Needed**:
  - List all orders for merchant's listings
  - View order details
  - Update order status (pending → confirmed → shipped → delivered)
  - Update fulfillment status
  - Cancel orders
  - Filter by status, date range, listing
  - Export orders (CSV/Excel)

#### 5. Shop Settings
- **Location**: `/dashboard/my-listings/[id]/shop-settings`
- **Features Needed**:
  - Enable/disable shop mode
  - Configure shop settings (delivery, pickup, dine-in)
  - Configure payment methods
  - Set delivery zones/areas

---

### Priority 2: Important (Tour Operators Portal)

#### 1. Tour Operators Login & Portal
- **Decision Needed**: 
  - Option A: Allow tour operators to login to admin portal with restricted access
  - Option B: Create separate tour operator portal
  - Option C: Add tour operator section to existing merchant portal

#### 2. Tours Management
- **Location**: `/dashboard/my-tours` (if using admin portal) or separate portal
- **Features Needed**:
  - List tours for operator
  - Create tour (with details, pricing, itinerary)
  - Edit tour
  - Delete tour
  - Manage tour images
  - Set tour status (draft → active)

#### 3. Tour Schedules Management
- **Location**: `/dashboard/my-tours/[id]/schedules`
- **Features Needed**:
  - List schedules for a tour
  - Create schedule (date, time, available spots)
  - Edit schedule
  - Delete schedule
  - Manage availability
  - Set price overrides per schedule

#### 4. Tour Bookings Management
- **Location**: `/dashboard/my-tours/[id]/bookings` or `/dashboard/my-tour-bookings`
- **Features Needed**:
  - List all tour bookings
  - View booking details (guests, pickup location, special requests)
  - Update booking status
  - Cancel bookings
  - Filter by tour, date, status

#### 5. Tour Operator Dashboard
- **Location**: `/dashboard/my-tour-dashboard`
- **Features Needed**:
  - Overview stats (total tours, bookings, revenue)
  - Recent bookings
  - Upcoming schedules
  - Revenue analytics

---

### Priority 3: Backend Fixes

#### 1. Add Authorization Checks
- **Products**: Verify merchant owns the listing before allowing create/update/delete
- **Services**: Verify merchant owns the listing before allowing create/update/delete
- **Menus**: Verify merchant owns the listing before allowing create/update/delete
- **Tours**: Verify operator owns the tour before allowing create/update/delete

#### 2. Add Merchant-Specific Endpoints
- `GET /merchants/businesses/:businessId/listings/:listingId/products`
- `GET /merchants/businesses/:businessId/listings/:listingId/services`
- `GET /merchants/businesses/:businessId/listings/:listingId/menus`
- `GET /merchants/businesses/:businessId/orders`
- `GET /merchants/businesses/:businessId/listings/:listingId/orders`

#### 3. Add Tour Operator Endpoints
- `GET /tour-operators/my-tours`
- `GET /tour-operators/my-tours/:tourId`
- `POST /tour-operators/my-tours`
- `PUT /tour-operators/my-tours/:tourId`
- `DELETE /tour-operators/my-tours/:tourId`
- `GET /tour-operators/my-tours/:tourId/schedules`
- `POST /tour-operators/my-tours/:tourId/schedules`
- `GET /tour-operators/my-bookings`

---

## Summary

### ✅ What Works:
- Backend APIs exist for all features
- Merchant portal exists for listings/bookings
- Admin portal exists for general management

### ❌ What's Missing:
1. **Merchant Portal**: Products, Services, Menus, Orders, Shop Settings management
2. **Tour Operators**: No portal exists at all
3. **Authorization**: Backend APIs don't verify ownership
4. **UI**: No management interfaces for shop features

### 🎯 Recommendation:
1. **Immediate**: Add Products/Services/Menus/Orders management to merchant portal
2. **Short-term**: Add authorization checks to backend APIs
3. **Medium-term**: Create tour operator portal or add tour operator section to admin portal
4. **Long-term**: Add analytics, reporting, and advanced features

---

## Answer to User's Question

**Q: Are tour operators able to login to merchants/admin portal and manage it or we need to implement?**

**A: NO, tour operators CANNOT currently login to merchant/admin portal. We NEED to implement:**
1. Tour operator authentication/authorization
2. Tour operator portal (or section in admin portal)
3. Tour management interfaces
4. Tour booking management

**Q: Everything we implemented in mobile needs to be managed?**

**A: YES, we need to implement management for:**
1. ✅ Products - **MISSING**
2. ✅ Services - **MISSING**
3. ✅ Menus - **MISSING**
4. ✅ Orders - **MISSING** (different from bookings)
5. ✅ Tours - **MISSING**
6. ✅ Tour Bookings - **MISSING**
7. ✅ Shop Settings - **MISSING**

