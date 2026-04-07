-- Unique Google Place ID for deduplication when scraping listings
ALTER TABLE "listings" ADD COLUMN IF NOT EXISTS "source_place_id" VARCHAR(255);

CREATE UNIQUE INDEX IF NOT EXISTS "listings_source_place_id_key" ON "listings"("source_place_id");
