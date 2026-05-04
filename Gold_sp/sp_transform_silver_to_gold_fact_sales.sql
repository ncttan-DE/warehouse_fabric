SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_fact_sales]
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- INSERT NEW FACT RECORDS
    ------------------------------------------------------------------
    INSERT INTO gold.fact_sales (
        user_key,
        event_key,
        venue_key,
        category_key,
        date_key,
        qtysold,
        pricepaid,
        commission,
        saletime
    )
    SELECT 
        ISNULL(u.user_key, -1)       AS user_key,
        ISNULL(e.event_key, -1)      AS event_key,
        ISNULL(v.venue_key, -1)      AS venue_key,
        ISNULL(c.category_key, -1)   AS category_key,
        ISNULL(d.date_key, -1)       AS date_key,
        s.qtysold,
        s.pricepaid,
        s.commission,
        s.saletime
    FROM silver.sales s

    -- USER
    LEFT JOIN gold.dim_user u
        ON s.buyername = u.username

    -- EVENT
    LEFT JOIN gold.dim_event e
        ON s.eventid = e.eventid

    -- VENUE
    LEFT JOIN gold.dim_venue v
        ON e.venueid = v.venueid

    -- CATEGORY (SCD TYPE 2 🔥)
    LEFT JOIN gold.dim_category c
        ON c.catid = e.eventid   -- ⚠️ adjust if needed
       AND s.saletime >= c.effective_from
       AND (s.saletime < c.effective_to OR c.effective_to IS NULL)

    -- DATE
    LEFT JOIN gold.dim_date d
        ON s.dateid = d.date_key

    ------------------------------------------------------------------
    -- PREVENT DUPLICATE LOAD
    ------------------------------------------------------------------
    WHERE NOT EXISTS (
        SELECT 1
        FROM gold.fact_sales f
        WHERE 
            f.user_key     = ISNULL(u.user_key, -1)
            AND f.event_key    = ISNULL(e.event_key, -1)
            AND f.date_key     = ISNULL(d.date_key, -1)
            AND f.qtysold      = s.qtysold
            AND f.saletime     = s.saletime
    );

END;
GO
