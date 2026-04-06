CREATE   PROCEDURE silver.sp_transform_bronze_to_silver_listing
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 1: Extract + hash
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_listing_hash;

    SELECT 
        listid,
        sellerid,
        eventid,
        dateid,
        numtickets,
        priceperticket,
        totalprice,
        listtime,
        HASHBYTES(
            'SHA2_256',
            CONCAT(
                sellerid,'|',eventid,'|',dateid,'|',
                numtickets,'|',priceperticket,'|',
                totalprice,'|',listtime
            )
        ) AS hash_value
    INTO #temp_listing_hash
    FROM bronze.listing
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_listing_hash_rn;

    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY listid DESC
        ) AS rn
    INTO #temp_listing_hash_rn
    FROM #temp_listing_hash;


    ------------------------------------------------------------------
    -- Step 3: Latest per listid
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_listing_hash_latest;

    SELECT 
        listid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_listing_hash_latest
    FROM #temp_listing_hash_rn
    WHERE rn = 1
    GROUP BY listid;


    ------------------------------------------------------------------
    -- Step 4: MERGE (NO DELETE)
    ------------------------------------------------------------------
    MERGE silver.listing AS dest
    USING (
        SELECT s.*
        FROM #temp_listing_hash_latest latest
        INNER JOIN #temp_listing_hash_rn s 
            ON s.listid = latest.listid
            AND s.hash_value = latest.max_hash_value
            AND s.rn = 1
    ) AS src
    ON dest.listid = src.listid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            sellerid = src.sellerid,
            eventid = src.eventid,
            dateid = src.dateid,
            numtickets = src.numtickets,
            priceperticket = src.priceperticket,
            totalprice = src.totalprice,
            listtime = src.listtime

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            listid, sellerid, eventid, dateid,
            numtickets, priceperticket,
            totalprice, listtime, hash_value
        )
        VALUES (
            src.listid, src.sellerid, src.eventid, src.dateid,
            src.numtickets, src.priceperticket,
            src.totalprice, src.listtime, src.hash_value
        );

END

GO

