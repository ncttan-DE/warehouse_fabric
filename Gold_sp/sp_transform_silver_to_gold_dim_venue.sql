SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_dim_venue]
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- INSERT NEW
    ------------------------------------------------------------------
    INSERT INTO gold.dim_venue (
        venueid, venuename, venuecity, venuestate, venueseats, hash_value
    )
    SELECT 
        s.venueid, s.venuename, s.venuecity, s.venuestate, s.venueseats, s.hash_value
    FROM silver.venue s
    LEFT JOIN gold.dim_venue g
        ON s.venueid = g.venueid
    WHERE g.venueid IS NULL;

    ------------------------------------------------------------------
    -- UPDATE ONLY CHANGED
    ------------------------------------------------------------------
    UPDATE g
    SET 
        g.venuename = s.venuename,
        g.venuecity = s.venuecity,
        g.venuestate = s.venuestate,
        g.venueseats = s.venueseats,
        g.hash_value = s.hash_value
    FROM gold.dim_venue g
    JOIN silver.venue s
        ON g.venueid = s.venueid
    WHERE g.hash_value <> s.hash_value;

END;
GO
