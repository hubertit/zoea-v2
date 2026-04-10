-- Referral program rules (DB-driven) + points on codes/rewards.

CREATE TABLE "referral_program_rules" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "name" VARCHAR(100) NOT NULL,
    "referrer_points" INTEGER NOT NULL,
    "referee_points" INTEGER NOT NULL,
    "effective_from" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "effective_to" TIMESTAMPTZ(6),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "referral_program_rules_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "idx_referral_program_rules_active_window" ON "referral_program_rules"("is_active", "effective_from", "effective_to");

ALTER TABLE "referral_codes" DROP COLUMN IF EXISTS "total_earnings";
ALTER TABLE "referral_codes" ADD COLUMN IF NOT EXISTS "total_points_earned" INTEGER DEFAULT 0;
ALTER TABLE "referral_codes" ADD COLUMN IF NOT EXISTS "pending_points" INTEGER DEFAULT 0;

ALTER TABLE "referral_rewards" ADD COLUMN IF NOT EXISTS "points" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "referral_rewards" ALTER COLUMN "amount" DROP NOT NULL;

UPDATE "referral_rewards"
SET "points" = GREATEST(0, ROUND("amount")::integer)
WHERE "points" = 0 AND "amount" IS NOT NULL;

INSERT INTO "referral_program_rules" ("id", "name", "referrer_points", "referee_points", "effective_from", "is_active")
VALUES (uuid_generate_v4(), 'default', 500, 300, CURRENT_TIMESTAMP, true);
