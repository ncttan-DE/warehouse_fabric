SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_dim_event]
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- INSERT NEW
    ------------------------------------------------------------------
    INSERT INTO gold.dim_event (
        eventid, eventname, starttime,
        venueid, categoryname, hash_value
    )
    SELECT 
        s.eventid, s.eventname, s.starttime,
        NULL, s.categoryname, s.hash_value
    FROM silver.event s
    LEFT JOIN gold.dim_event g
        ON s.eventid = g.eventid
    WHERE g.eventid IS NULL;

    ------------------------------------------------------------------
    -- UPDATE ONLY CHANGED
    ------------------------------------------------------------------
    UPDATE g
    SET 
        g.eventname = s.eventname,
        g.starttime = s.starttime,
        g.categoryname = s.categoryname,
        g.hash_value = s.hash_value
    FROM gold.dim_event g
    JOIN silver.event s
        ON g.eventid = s.eventid
    WHERE g.hash_value <> s.hash_value;

END;
GO
