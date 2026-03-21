# Zoea Project

**Discover Rwanda Like Never Before**

This is the main Zoea project directory containing all related applications and services for the Zoea travel and tourism platform.

## Project Structure

```
zoea2/
├── apps/                    # All applications
│   ├── backend/             # NestJS backend API
│   │   ├── src/             # Source code
│   │   ├── prisma/          # Database schema
│   │   └── .git/            # Git repository
│   ├── public-mobile/       # Consumer mobile app (Flutter)
│   │   ├── lib/             # Flutter source code
│   │   ├── android/         # Android platform files
│   │   ├── ios/             # iOS platform files
│   │   ├── pubspec.yaml     # Flutter dependencies
│   │   └── .git/            # Git repository
│   ├── public-web/          # Consumer web app (Next.js)
│   │   └── .git/            # Git repository (ready for remote)
│   ├── merchant-mobile/     # Merchant mobile app (Flutter)
│   │   ├── lib/             # Flutter source code
│   │   ├── android/         # Android platform files
│   │   ├── ios/             # iOS platform files
│   │   ├── pubspec.yaml     # Flutter dependencies
│   │   └── .git/            # Git repository
│   └── merchant-web/        # Merchant & admin web portal (Next.js)
│       ├── src/             # Source code
│       └── .git/            # Git repository
├── docs/                    # Documentation
│   ├── notes/               # Development notes and fix summaries
│   └── ...                  # Organized documentation by topic
├── scripts/                 # Shared scripts
├── database/                # Database schemas and scripts
│   ├── scripts/             # SQL scripts for data operations
│   └── ...                  # Database schemas and dumps
└── logs/                    # Deployment and execution logs
```

## Applications

### 1. Backend API (`apps/backend/`)
- **Technology**: NestJS (TypeScript)
- **Database**: PostgreSQL 16 + PostGIS
- **ORM**: Prisma
- **Purpose**: RESTful API serving all applications
- **Status**: ✅ Production Ready
- **Repository**: `https://github.com/zoea-africa/zoea2-apis.git`
- **API Base URL**: `https://zoea-africa.qtsoftwareltd.com/api`
- **Swagger Docs**: `https://zoea-africa.qtsoftwareltd.com/api/docs`

### 2. Public Mobile App (`apps/public-mobile/`)
- **Technology**: Flutter (Dart)
- **Platform**: iOS, Android
- **Purpose**: Consumer-facing mobile application
- **Status**: ✅ Active Development
- **Repository**: `https://github.com/hubertit/zoea.mobile.2.git`

### 3. Public Web App (`apps/public-web/`)
- **Technology**: Next.js (planned)
- **Purpose**: Public-facing website for consumers
- **Status**: ⏳ Planned

### 4. Merchant Mobile App (`apps/merchant-mobile/`)
- **Technology**: Flutter (Dart)
- **Platform**: iOS, Android
- **Purpose**: Merchant business management mobile app
- **Status**: ✅ Active Development
- **Repository**: `https://github.com/zoea-africa/zoea-partner-mobile.git`

### 5. Merchant Web Portal (`apps/merchant-web/`)
- **Technology**: Next.js (React, TypeScript)
- **Purpose**: Merchant & admin management dashboard
- **Status**: ✅ Active Development

## Quick Start

### Backend API (NestJS)
```bash
cd apps/backend
npm install
cp env.example .env
# Edit .env with your database credentials
npx prisma generate
npx prisma migrate dev
npm run start:dev
```

### Public Mobile (Flutter)
```bash
cd apps/public-mobile
flutter pub get
flutter run
```

### Public Web (Next.js)
```bash
cd apps/public-web
npm install
npm run dev
```

### Merchant Mobile (Flutter)
```bash
cd apps/merchant-mobile
flutter pub get
flutter run
```

### Merchant Web (Next.js)
```bash
cd apps/merchant-web
npm install
npm run dev
```

## Technology Stack Summary

| Application | Framework | Language | Database | Key Libraries |
|------------|-----------|----------|----------|---------------|
| Consumer Mobile | Flutter | Dart | N/A (API client) | Riverpod, GoRouter, Dio |
| Merchant Mobile | Flutter | Dart | N/A (API client) | Riverpod, GoRouter, Dio |
| Backend | NestJS | TypeScript | PostgreSQL 16 + PostGIS | Prisma, JWT, Swagger |
| Admin | Next.js | TypeScript | MySQL (legacy) | React, Tailwind, ApexCharts |
| Consumer Web | Next.js (planned) | TypeScript | N/A (API client) | React, Tailwind |
| Merchant Web | Next.js (planned) | TypeScript | N/A (API client) | React, Tailwind |

## API Information

**Production Base URL**: `https://zoea-africa.qtsoftwareltd.com/api`  
**Swagger Documentation**: `https://zoea-africa.qtsoftwareltd.com/api/docs`  
**Authentication**: JWT (Access Token + Refresh Token)

## Git Repositories

Each application maintains its own git repository:
- **apps/backend/**: `https://github.com/zoea-africa/zoea2-apis.git`
- **apps/public-mobile/**: `https://github.com/hubertit/zoea.mobile.2.git`
- **apps/public-web/**: (to be configured)
- **apps/merchant-mobile/**: `https://github.com/zoea-africa/zoea-partner-mobile.git`
- **apps/merchant-web/**: (to be configured)

## Deployment

### Backend Deployment
```bash
cd apps/backend
./sync-all-environments.sh
# Then SSH into servers and run:
# docker-compose down && docker-compose up --build -d
```

### Mobile Deployment
Standard Flutter deployment process:
- Android: `flutter build appbundle --release`
- iOS: `flutter build ios --release`

## Documentation

**📚 [Complete Documentation Index](docs/DOCUMENTATION_INDEX.md)** - Navigate all documentation easily

Comprehensive documentation is available in the `/docs/` directory:

### Project Organization
- **[Development Notes](docs/notes/)** - Fix summaries, analysis documents, and development notes
- **[Database Scripts](database/scripts/)** - SQL scripts for database operations

### Key Documentation Files
- **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete documentation navigation
- **[CHANGELOG.md](CHANGELOG.md)** - Version history across all apps
- **[Project Overview](docs/01-project-overview/01-project-overview.md)** - Complete project overview
- **[Features Breakdown](docs/01-project-overview/03-features.md)** - Feature breakdown by application
- **[API Reference](docs/11-api-reference/01-api-overview.md)** - Complete API endpoint reference
- **[Architecture](docs/02-architecture/01-system-architecture.md)** - System architecture details
- **[Development Guide](docs/10-development/01-development-guide.md)** - Development setup and guidelines
- **[User Flows](docs/12-features/02-user-flows.md)** - User flow documentation
- **[Database Schema](docs/08-database/01-database-schema.md)** - Database schema documentation

### Quick Start Guides
- **[Backend API Quick Start](apps/backend/QUICKSTART.md)** - Set up backend in 10 minutes ⚡
- **[Public Mobile Quick Start](apps/public-mobile/QUICKSTART.md)** - Get mobile app running in 5 minutes ⚡

### Application-Specific Documentation
- **Backend API**: [apps/backend/README.md](apps/backend/README.md)
- **Public Mobile**: [apps/public-mobile/README.md](apps/public-mobile/README.md)
- **Public Web**: [apps/public-web/README.md](apps/public-web/README.md)
- **Merchant Mobile**: [apps/merchant-mobile/README.md](apps/merchant-mobile/README.md)
- **Merchant Web**: [apps/merchant-web/README.md](apps/merchant-web/README.md)

## Recent Updates

### January 2025
- ✅ **Dark Mode Support**: Complete dark mode implementation in mobile app
- ✅ **Theme Persistence**: User theme preferences (Light/Dark/System) saved across sessions
- ✅ **Theme-Aware UI**: All components and logos adapt to active theme
- ✅ **Enhanced UX**: Improved contrast and readability in both light and dark modes

### December 2024
- ✅ **Sorting Functionality**: Dynamic sorting for listings (rating, name, price, date, popularity)
- ✅ **Filtering**: Enhanced filters (rating, price range, featured status)
- ✅ **Share Functionality**: Share listings, events, accommodations, and referral codes
- ✅ **Search**: Search functionality for bookings
- ✅ **Skeleton Loaders**: Improved loading states with shimmer effects
- ✅ **HTML Entities Fix**: Fixed broken special characters in listings database
- ✅ **Enhanced Swagger Docs**: Comprehensive API documentation

## Changelog

Detailed version history is available in the following files:
- **[Platform Changelog](CHANGELOG.md)** - Overall platform changes
- **[Backend Changelog](apps/backend/CHANGELOG.md)** - API and backend changes
- **[Public Mobile Changelog](apps/public-mobile/CHANGELOG.md)** - Public mobile app changes
- **[Merchant Mobile Changelog](apps/merchant-mobile/CHANGELOG.md)** - Merchant mobile app changes
- **[Merchant Web Changelog](apps/merchant-web/CHANGELOG.md)** - Merchant & admin web changes

## Project Location

**Project Root**: `/Users/macbookpro/projects/flutter/zoea2`

This is your main working directory. All development happens here.

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines on contributing to the project.

## License

[Add license information here]
