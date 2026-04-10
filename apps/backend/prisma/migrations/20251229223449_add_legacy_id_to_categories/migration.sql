-- AlterTable: Add legacy_id to categories
-- Same as 20241229220000_add_legacy_id_to_categories; kept for DBs that recorded this migration name.
ALTER TABLE "categories" ADD COLUMN IF NOT EXISTS "legacy_id" INTEGER;

-- Create unique index on legacy_id for categories
CREATE UNIQUE INDEX IF NOT EXISTS "idx_categories_legacy_id" ON "categories"("legacy_id") WHERE "legacy_id" IS NOT NULL;
