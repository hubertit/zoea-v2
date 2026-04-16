-- AlterTable
ALTER TABLE "listings" ADD COLUMN "updated_by_user_id" UUID;

-- AddForeignKey
ALTER TABLE "listings" ADD CONSTRAINT "listings_updated_by_user_id_fkey" FOREIGN KEY ("updated_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- CreateIndex
CREATE INDEX "idx_listings_updated_by_user" ON "listings"("updated_by_user_id");
