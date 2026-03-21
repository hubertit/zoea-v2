# Project Structure Recommendation

## Clarified Requirements

Based on your requirements:

1. **Zoea App** (Main Consumer App)
   - Mobile (Flutter)
   - Web (Public website)

2. **Merchant App** (Business Management)
   - Mobile (Flutter)
   - Web (Merchant portal)

3. **Admin & Partners** (Management & Reports)
   - Web only (Admin dashboard)

---

## Recommended Structure

### Option 1: Flat Structure (Recommended)

```
zoea2/
├── apps/public-mobile/              # Main consumer app (Flutter)
│   └── For: End users (travelers, tourists)
│
├── apps/public-web/                 # Main consumer web app
│   └── For: End users (public website)
│
├── merchant-apps/public-mobile/     # Merchant mobile app (Flutter)
│   └── For: Merchants managing business on mobile
│
├── merchant-apps/public-web/        # Merchant web portal
│   └── For: Merchants managing business on web
│
├── apps/admin-apps/public-web/              # Admin & Partners dashboard (Web)
│   └── For: Platform admins & partners
│
├── apps/backend/            # Shared API (NestJS)
│   └── Serves all apps
│
├── docs/               # Documentation
├── scripts/            # Shared scripts
├── migration/          # Database migrations
└── database/           # Database schemas
```

### Option 2: Grouped Structure

```
zoea2/
├── consumer/           # Main consumer apps
│   ├── apps/public-mobile/        # Flutter mobile app
│   └── apps/public-web/           # Public web app
│
├── merchant/            # Merchant apps
│   ├── apps/public-mobile/        # Merchant mobile app
│   └── apps/public-web/           # Merchant web portal
│
├── apps/admin-apps/public-web/              # Admin & Partners
│   └── apps/public-web/           # Admin dashboard (web only)
│
├── apps/backend/            # Shared API
├── docs/
├── scripts/
├── migration/
└── database/
```

---

## Recommendation: **Option 1 (Flat Structure)**

### Why Flat Structure?

1. **Clarity**: Each app is at the same level, easy to find
2. **Independence**: Each app has its own git repo (as you mentioned)
3. **Deployment**: Easier to deploy independently
4. **Team Work**: Clear ownership per app
5. **Consistency**: Matches current structure (mobile, backend, admin, web)

---

## Detailed Structure

### 1. Main Consumer Apps

#### `apps/public-mobile/` - Consumer Mobile App (Flutter)
```
apps/public-mobile/
├── lib/
│   ├── core/           # Shared core
│   └── features/       # Consumer features
│       ├── explore/
│       ├── listings/
│       ├── bookings/
│       └── profile/
└── ...
```
**Purpose**: End users browsing and booking
**Users**: Travelers, tourists, locals
**Platform**: iOS, Android

#### `apps/public-web/` - Consumer Web App
```
apps/public-web/
├── src/
│   ├── app/            # Next.js app directory
│   ├── components/     # UI components
│   └── lib/            # Utilities
└── ...
```
**Purpose**: Public website for end users
**Users**: General public
**Platform**: Web browsers
**Domain**: `zoea.africa` or `www.zoea.africa`

---

### 2. Merchant Apps

#### `merchant-apps/public-mobile/` - Merchant Mobile App (Flutter)
```
merchant-apps/public-mobile/
├── lib/
│   ├── core/           # Shared core (different from consumer)
│   └── features/       # Merchant features
│       ├── dashboard/  # Business dashboard
│       ├── listings/   # Manage listings
│       ├── bookings/   # Manage bookings
│       ├── analytics/   # Business analytics
│       └── revenue/    # Revenue tracking
└── ...
```
**Purpose**: Merchants managing business on mobile
**Users**: Hotel owners, restaurant owners, tour operators
**Platform**: iOS, Android
**Domain**: `merchant.zoea.africa` (deep linking)

#### `merchant-apps/public-web/` - Merchant Web Portal
```
merchant-apps/public-web/
├── src/
│   ├── app/            # Next.js app directory
│   ├── components/     # Merchant UI components
│   └── lib/            # Utilities
└── ...
```
**Purpose**: Merchants managing business on web
**Users**: Merchants (desktop/web preferred)
**Platform**: Web browsers
**Domain**: `merchant.zoea.africa`

---

### 3. Admin & Partners

#### `apps/admin-apps/public-web/` - Admin & Partners Dashboard (Web)
```
apps/admin-apps/public-web/
├── src/
│   ├── app/
│   │   ├── apps/admin-apps/public-web/      # Admin features
│   │   └── partners/   # Partner features
│   ├── components/
│   └── lib/
└── ...
```
**Purpose**: Platform management and reports
**Users**: Platform admins, partners, analysts
**Platform**: Web browsers only
**Domain**: `admin.zoea.africa`

**Features**:
- Platform-wide analytics
- User management
- Merchant management
- Content moderation
- Reports and insights
- Partner dashboards

---

## API Structure

### Backend Endpoints

```
apps/backend/
└── src/modules/
    ├── auth/           # Shared authentication
    ├── listings/       # Shared listings
    ├── bookings/       # Shared bookings
    ├── apps/admin-apps/public-web/          # Admin-only endpoints
    │   └── GET /apps/admin-apps/public-web/merchants
    │   └── GET /apps/admin-apps/public-web/analytics
    ├── merchant/        # Merchant-only endpoints
    │   └── GET /merchant/listings (own)
    │   └── GET /merchant/bookings (own)
    │   └── GET /merchant/analytics (own)
    └── consumer/       # Consumer endpoints
        └── GET /listings (public)
        └── GET /bookings (user's own)
```

---

## Git Repositories

Each app maintains its own repository:

```
zoea2/
├── apps/public-mobile/            # git: zoea.mobile.2.git
├── apps/public-web/               # git: (to be configured)
├── merchant-apps/public-mobile/   # git: (to be configured)
├── merchant-apps/public-web/      # git: (to be configured)
├── apps/admin-apps/public-web/             # git: (to be configured)
└── apps/backend/           # git: zoea2-apis.git
```

---

## Domain Structure

```
zoea.africa              # Main consumer web app
www.zoea.africa          # Main consumer web app (alias)
merchant.zoea.africa     # Merchant web portal
admin.zoea.africa        # Admin & Partners dashboard
api.zoea.africa          # Backend API (or zoea-africa.qtsoftwareltd.com/api)
```

---

## Shared Resources

### What Can Be Shared?

1. **Backend API**: All apps use the same API
2. **Design System**: Shared UI components (if using same framework)
3. **Types**: Shared TypeScript types (if applicable)
4. **Utilities**: Shared utility functions

### What Should NOT Be Shared?

1. **Business Logic**: Different for each app
2. **UI Components**: Tailored per app
3. **Navigation**: Different user flows
4. **State Management**: App-specific

---

## Migration Plan

### Phase 1: Current State
```
✅ apps/public-mobile/          # Consumer mobile (exists)
✅ apps/backend/         # API (exists)
✅ apps/admin-apps/public-web/           # Admin dashboard (exists)
✅ apps/public-web/             # Consumer web (exists, needs setup)
```

### Phase 2: Add Merchant Apps
```
1. Create merchant-apps/public-mobile/ directory
2. Create merchant-apps/public-web/ directory
3. Extract merchant features from apps/admin-apps/public-web/ (if any)
4. Build merchant-specific features
```

### Phase 3: Refine Admin
```
1. Focus apps/admin-apps/public-web/ on platform management
2. Remove merchant self-service (moved to merchant apps)
3. Add partner-specific features
```

---

## Technology Stack Summary

| App | Framework | Platform | Users |
|-----|-----------|----------|-------|
| **apps/public-mobile/** | Flutter | iOS, Android | Consumers |
| **apps/public-web/** | Next.js | Web | Consumers |
| **merchant-apps/public-mobile/** | Flutter | iOS, Android | Merchants |
| **merchant-apps/public-web/** | Next.js | Web | Merchants |
| **apps/admin-apps/public-web/** | Next.js | Web | Admins, Partners |
| **apps/backend/** | NestJS | API | All apps |

---

## Benefits of This Structure

### 1. Clear Separation
- ✅ Each app has distinct purpose
- ✅ No confusion about which app does what
- ✅ Easy to find code

### 2. Independent Development
- ✅ Teams can work in parallel
- ✅ Different release cycles
- ✅ No merge conflicts

### 3. Independent Deployment
- ✅ Deploy consumer apps separately
- ✅ Deploy merchant apps separately
- ✅ Deploy admin separately
- ✅ Scale based on usage

### 4. Security
- ✅ Clear security boundaries
- ✅ Role-based access per app
- ✅ Different authentication flows

### 5. User Experience
- ✅ Tailored UX per user type
- ✅ Optimized for each platform
- ✅ Focused features

---

## File Structure Example

```
zoea2/
├── apps/public-mobile/                    # Consumer mobile app
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── apps/public-web/                       # Consumer web app
│   ├── src/
│   ├── public/
│   └── package.json
│
├── merchant-apps/public-mobile/            # Merchant mobile app
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── merchant-apps/public-web/               # Merchant web portal
│   ├── src/
│   ├── public/
│   └── package.json
│
├── apps/admin-apps/public-web/                     # Admin & Partners dashboard
│   ├── src/
│   ├── public/
│   └── package.json
│
├── apps/backend/                   # Shared API
│   ├── src/
│   ├── prisma/
│   └── package.json
│
├── docs/                      # Documentation
├── scripts/                   # Shared scripts
├── migration/                 # Database migrations
└── database/                  # Database schemas
```

---

## Next Steps

1. ✅ **Create `merchant-apps/public-mobile/` directory**
   - Initialize Flutter project
   - Set up merchant-specific features

2. ✅ **Create `merchant-apps/public-web/` directory**
   - Initialize Next.js project
   - Set up merchant portal

3. ✅ **Update `apps/admin-apps/public-web/`**
   - Focus on platform management
   - Add partner features

4. ✅ **Update `apps/public-web/`**
   - Set up consumer web app
   - Public-facing features

5. ✅ **Update IntelliJ configuration**
   - Add new modules
   - Update `.idea/modules.xml`

6. ✅ **Update documentation**
   - Project structure
   - Features per app
   - Deployment guides

---

## Recommendation Summary

**✅ Use Flat Structure with 5 Apps:**

1. `apps/public-mobile/` - Consumer mobile
2. `apps/public-web/` - Consumer web
3. `merchant-apps/public-mobile/` - Merchant mobile
4. `merchant-apps/public-web/` - Merchant web
5. `apps/admin-apps/public-web/` - Admin & Partners (web)

**All sharing the same `apps/backend/` API.**

This structure:
- ✅ Matches your requirements
- ✅ Clear separation of concerns
- ✅ Independent development
- ✅ Scalable and maintainable
- ✅ Industry best practice

