-- Move listings from parent "Shopping" onto child subcategories (Malls, Markets, Boutiques, Arts & Crafts)
-- based on listing.type. Fixes empty subcategory tabs when every row used category_id = parent only.
--
-- Verified against production API (2026-03): 39 active listings on shopping parent;
-- 0 on each child. Distribution: boutique 31, attraction 5, mall 2, market 1.
--
-- Run against your DB (psql, admin tool, or prisma migrate raw). Review counts in NOTICE lines first.

DO $$
DECLARE
    shopping_parent_id UUID;
    malls_id UUID;
    markets_id UUID;
    boutiques_id UUID;
    arts_crafts_id UUID;
    n_mall INT;
    n_market INT;
    n_boutique INT;
    n_arts INT;
BEGIN
    SELECT id INTO shopping_parent_id
    FROM categories
    WHERE slug = 'shopping' AND parent_id IS NULL
    LIMIT 1;

    IF shopping_parent_id IS NULL THEN
        RAISE EXCEPTION 'Parent category shopping not found';
    END IF;

    SELECT c.id INTO malls_id
    FROM categories c
    JOIN categories p ON c.parent_id = p.id
    WHERE p.id = shopping_parent_id AND c.slug = 'malls'
    LIMIT 1;

    SELECT c.id INTO markets_id
    FROM categories c
    JOIN categories p ON c.parent_id = p.id
    WHERE p.id = shopping_parent_id AND c.slug = 'markets'
    LIMIT 1;

    SELECT c.id INTO boutiques_id
    FROM categories c
    JOIN categories p ON c.parent_id = p.id
    WHERE p.id = shopping_parent_id AND c.slug = 'boutiques'
    LIMIT 1;

    SELECT c.id INTO arts_crafts_id
    FROM categories c
    JOIN categories p ON c.parent_id = p.id
    WHERE p.id = shopping_parent_id AND c.slug = 'arts-crafts'
    LIMIT 1;

    RAISE NOTICE 'shopping parent %', shopping_parent_id;
    RAISE NOTICE 'malls % | markets % | boutiques % | arts-crafts %', malls_id, markets_id, boutiques_id, arts_crafts_id;

    IF malls_id IS NULL OR markets_id IS NULL OR boutiques_id IS NULL OR arts_crafts_id IS NULL THEN
        RAISE EXCEPTION 'One or more shopping children missing (malls/markets/boutiques/arts-crafts)';
    END IF;

    UPDATE listings
    SET category_id = malls_id, updated_at = NOW()
    WHERE category_id = shopping_parent_id AND type = 'mall' AND deleted_at IS NULL;
    GET DIAGNOSTICS n_mall = ROW_COUNT;

    UPDATE listings
    SET category_id = markets_id, updated_at = NOW()
    WHERE category_id = shopping_parent_id AND type = 'market' AND deleted_at IS NULL;
    GET DIAGNOSTICS n_market = ROW_COUNT;

    UPDATE listings
    SET category_id = boutiques_id, updated_at = NOW()
    WHERE category_id = shopping_parent_id AND type = 'boutique' AND deleted_at IS NULL;
    GET DIAGNOSTICS n_boutique = ROW_COUNT;

    -- Arts & crafts: listings still on shopping parent with type attraction (galleries, craft venues)
    UPDATE listings
    SET category_id = arts_crafts_id, updated_at = NOW()
    WHERE category_id = shopping_parent_id AND type = 'attraction' AND deleted_at IS NULL;
    GET DIAGNOSTICS n_arts = ROW_COUNT;

    RAISE NOTICE 'Updated mall->malls: %, market->markets: %, boutique->boutiques: %, attraction->arts-crafts: %',
        n_mall, n_market, n_boutique, n_arts;
END $$;

-- Optional verification
-- SELECT c.slug, COUNT(*) FROM listings l JOIN categories c ON c.id = l.category_id
-- WHERE c.parent_id = (SELECT id FROM categories WHERE slug = 'shopping' AND parent_id IS NULL)
-- GROUP BY c.slug;
