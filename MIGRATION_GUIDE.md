# Project Reorganization Migration Guide

**Date**: March 21, 2026  
**Change**: Moved all applications into `/apps` directory

## What Changed

### Directory Structure

**Before:**
```
zoea2/
├── backend/
├── mobile/
├── web/
├── merchant-mobile/
├── admin/
├── docs/
├── database/
└── scripts/
```

**After:**
```
zoea2/
├── apps/
│   ├── backend/          # NestJS API
│   ├── public-mobile/    # Consumer mobile (was: mobile/)
│   ├── public-web/       # Consumer web (was: web/)
│   ├── merchant-mobile/  # Merchant mobile
│   ├── merchant-web/     # Merchant portal (NEW - planned)
│   └── admin-web/        # Admin dashboard (was: admin/)
├── docs/
├── database/
└── scripts/
```

## Path Changes Reference

| Old Path | New Path |
|----------|----------|
| `backend/` | `apps/backend/` |
| `mobile/` | `apps/public-mobile/` |
| `web/` | `apps/public-web/` |
| `merchant-mobile/` | `apps/merchant-mobile/` |
| `admin/` | `apps/admin-web/` |
| N/A | `apps/merchant-web/` (new) |

## Updated Files

### Configuration Files
- ✅ `README.md` - Updated all paths and structure
- ✅ `CHANGELOG.md` - Updated app references
- ✅ `docker-compose.dev.yml` - Updated backend path
- ✅ `scripts/setup-dev.sh` - Updated all app paths
- ✅ `database/scripts/README.md` - Updated Prisma path

### Documentation
- ✅ All 81 documentation files in `/docs` updated
- ✅ All `cd` commands updated
- ✅ All path references updated

### Scripts
- ✅ `apps/backend/deploy-now.sh` - Uses dynamic path resolution (no changes needed)
- ✅ `apps/backend/scripts/sync-all-environments.sh` - Uses dynamic path resolution
- ✅ `apps/admin-web/deploy-admin.sh` - Uses dynamic path resolution

## For Developers

### If you have local clones

**Option 1: Pull the changes (Recommended)**
```bash
cd /path/to/zoea2
git pull origin main
```

Git will automatically handle the file moves in your working directory.

**Option 2: Fresh clone**
```bash
git clone <repo-url> zoea2-new
cd zoea2-new
```

### Update your commands

**Old commands:**
```bash
cd backend && npm run start:dev
cd mobile && flutter run
cd admin && npm run dev
```

**New commands:**
```bash
cd apps/backend && npm run start:dev
cd apps/public-mobile && flutter run
cd apps/admin-web && npm run dev
```

### IDE/Editor Configuration

If you have IDE configurations pointing to old paths:
- **IntelliJ/Android Studio**: Reimport the project
- **VS Code**: Update `launch.json` and `tasks.json` if they reference specific paths
- **Flutter**: Run `flutter pub get` in the new location

## Benefits of New Structure

1. **Clear Organization**: All apps in one place
2. **Consistent Naming**: `public-*` for consumers, `merchant-*` for businesses
3. **Separation of Concerns**: Admin and merchant apps are now separate
4. **Scalability**: Easy to add new apps (e.g., `apps/partner-web/`)
5. **Better Security**: Admin and merchant apps can be deployed independently

## Verification

All scripts and builds have been tested and work correctly with the new structure:
- ✅ Backend build: `cd apps/backend && npm run build`
- ✅ Mobile analyze: `cd apps/public-mobile && flutter analyze`
- ✅ Setup script: `bash scripts/setup-dev.sh`
- ✅ All deployment scripts use dynamic path resolution

## Questions?

If you encounter any issues with the new structure, check:
1. Are you in the correct directory? (use `pwd` to verify)
2. Did you pull the latest changes? (`git pull origin main`)
3. Are your IDE configurations updated?

For any path-related issues, refer to the "Path Changes Reference" table above.
