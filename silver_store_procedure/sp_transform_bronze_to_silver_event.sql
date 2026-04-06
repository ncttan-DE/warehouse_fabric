CREATE OR ALTER PROCEDURE silver.sp_transform_bronze_to_silver_event
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 1: Extract + hash
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_event_hash;

    SELECT 
        eventid,
        venuename,
        categoryname,
        dateid,
        eventname,
        starttime,
        HASHBYTES(
            'SHA2_256',
            CONCAT(
                ISNULL(venuename,''),'|',
                ISNULL(categoryname,''),'|',
                dateid,'|',
                ISNULL(eventname,''),'|',
                starttime
            )
        ) AS hash_value
    INTO #temp_event_hash
    FROM bronze.event
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_event_hash_rn;

    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY eventid DESC
        ) AS rn
    INTO #temp_event_hash_rn
    FROM #temp_event_hash;


    ------------------------------------------------------------------
    -- Step 3: Latest per eventid
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_event_hash_latest;

    SELECT 
        eventid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_event_hash_latest
    FROM #temp_event_hash_rn
    WHERE rn = 1
    GROUP BY eventid;


    ------------------------------------------------------------------
    -- Step 4: MERGE (NO DELETE)
    ------------------------------------------------------------------
    MERGE silver.event AS dest
    USING (
        SELECT s.*
        FROM #temp_event_hash_latest latest
        INNER JOIN #temp_event_hash_rn s 
            ON s.eventid = latest.eventid
            AND s.hash_value = latest.max_hash_value
            AND s.rn = 1
    ) AS src
    ON dest.eventid = src.eventid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            venuename = src.venuename,
            categoryname = src.categoryname,
            dateid = src.dateid,
            eventname = src.eventname,
            starttime = src.starttime

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            eventid, venuename, categoryname,
            dateid, eventname, starttime, hash_value
        )
        VALUES (
            src.eventid, src.venuename, src.categoryname,
            src.dateid, src.eventname, src.starttime, src.hash_value
        );

END
GO