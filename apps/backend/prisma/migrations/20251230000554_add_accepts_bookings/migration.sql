-- AlterTable (aligned with 20251230000559_add_accepts_bookings for DBs that recorded this name)
ALTER TABLE "listings" ADD COLUMN IF NOT EXISTS "accepts_bookings" BOOLEAN DEFAULT false;
