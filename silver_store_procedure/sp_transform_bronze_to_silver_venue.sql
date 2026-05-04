CREATE OR ALTER PROCEDURE silver.sp_transform_bronze_to_silver_venue
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 0: Refresh Silver view to ensure it's up-to-date before transformation
    ------------------------------------------------------------------
    TRUNCATE TABLE silver.venue;

    ------------------------------------------------------------------
    -- Step 1: Extract data from Bronze for the given run_id
    --         + Generate hash_value (used for change detection)
    --         + Hash is created from business columns (non-key fields)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_venue_hash;

    SELECT 
        venueid,
        venuename,
        venuecity,
        venuestate,
        venueseats,
        HASHBYTES(
            'SHA2_256',
            CONCAT(
                ISNULL(venuename,''),'|',
                ISNULL(venuecity,''),'|',
                ISNULL(venuestate,''),'|',
                ISNULL(venueseats,0)
            )
        ) AS hash_value
    INTO #temp_venue_hash
    FROM bronze.venue
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate records based on hash_value
    --         + If multiple records have same content (same hash),
    --           keep only one (latest by venueid DESC)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_venue_hash_rn;

    SELECT 
        venueid,
        venuename,
        venuecity,
        venuestate,
        venueseats,
        hash_value,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY venueid DESC
        ) AS rn
    INTO #temp_venue_hash_rn
    FROM #temp_venue_hash;


    ------------------------------------------------------------------
    -- Step 3: Get latest version per venueid
    --         + For each venueid, keep the latest distinct hash
    --         + Ensures only 1 record per business key (venueid)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_venue_hash_latest;

    SELECT 
        venueid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_venue_hash_latest
    FROM #temp_venue_hash_rn
    WHERE rn = 1
    GROUP BY venueid;


    ------------------------------------------------------------------
    -- Step 4: MERGE into Silver
    --         + MATCHED: update only when hash_value is different
    --         + NOT MATCHED: insert new records
    --         + NO DELETE (incremental load)
    ------------------------------------------------------------------
    MERGE silver.venue AS dest
    USING (
        SELECT s.*
        FROM #temp_venue_hash_latest latest
        INNER JOIN #temp_venue_hash_rn s 
            ON s.venueid = latest.venueid
            AND s.hash_value = latest.max_hash_value
            AND s.rn = 1
    ) AS src
    ON dest.venueid = src.venueid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            dest.venuename = src.venuename,
            dest.venuecity = src.venuecity,
            dest.venuestate = src.venuestate,
            dest.venueseats = src.venueseats

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            venueid,
            venuename,
            venuecity,
            venuestate,
            venueseats,
            hash_value
        )
        VALUES (
            src.venueid,
            src.venuename,
            src.venuecity,
            src.venuestate,
            src.venueseats,
            src.hash_value
        );

END
GO