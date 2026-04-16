-- Rename column to `updated_by` (Prisma field: updatedById)
ALTER TABLE "listings" RENAME COLUMN "updated_by_user_id" TO "updated_by";

ALTER TABLE "listings" RENAME CONSTRAINT "listings_updated_by_user_id_fkey" TO "listings_updated_by_fkey";

ALTER INDEX "idx_listings_updated_by_user" RENAME TO "idx_listings_updated_by";
