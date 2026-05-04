CREATE OR ALTER PROCEDURE silver.sp_transform_bronze_to_silver_category
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    
    ------------------------------------------------------------------
    -- Step 0: Refresh Silver view to ensure it's up-to-date before transformation
    ------------------------------------------------------------------
    TRUNCATE TABLE silver.category;

    ------------------------------------------------------------------
    -- Step 1: Extract data from Bronze for the given run_id
    --         + Generate hash_value (used for change detection)
    --         + Hash is created from business columns (non-key fields)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_categories_hash;

    SELECT 
        catid,
        catgroup,
        catname,
        catdesc,
        HASHBYTES(
            'SHA2_256', 
            CONCAT(
                ISNULL(catgroup, ''),
                '|',
                ISNULL(catname, ''),
                '|',
                ISNULL(catdesc, '')
            )
        ) AS hash_value
    INTO #temp_categories_hash
    FROM bronze.category
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate records based on hash_value
    --         + If multiple records have same content (same hash),
    --           keep only one (latest by catid DESC)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_categories_hash_rn;

    SELECT 
        catid,
        catgroup,
        catname,
        catdesc,
        hash_value,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY catid DESC
        ) AS rn
    INTO #temp_categories_hash_rn
    FROM #temp_categories_hash;


    ------------------------------------------------------------------
    -- Step 3: Get latest version per catid
    --         + For each catid, keep the latest distinct hash
    --         + Ensures only 1 record per business key (catid)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_categories_hash_latest;

    SELECT 
        catid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_categories_hash_latest
    FROM #temp_categories_hash_rn
    WHERE rn = 1
    GROUP BY catid;


    ------------------------------------------------------------------
    -- Step 4: MERGE into Silver
    --         + MATCHED: update only when hash_value is different
    --         + NOT MATCHED: insert new records
    --         + NOT MATCHED BY SOURCE: delete (full load behavior)
    ------------------------------------------------------------------
    MERGE silver.category AS dest
    USING (
        SELECT s.*
        FROM #temp_categories_hash_latest latest
        INNER JOIN #temp_categories_hash_rn s ON s.catid = latest.catid
                                            AND s.hash_value = latest.max_hash_value
                                            AND s.rn = 1
    ) AS src
    ON dest.catid = src.catid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            dest.catgroup = src.catgroup,
            dest.catname = src.catname,
            dest.catdesc = src.catdesc

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            catid,
            catgroup,
            catname,
            catdesc,
            hash_value
        )
        VALUES (
            src.catid,
            src.catgroup,
            src.catname,
            src.catdesc,
            src.hash_value
        )

    WHEN NOT MATCHED BY SOURCE THEN -- Full load: remove records not in source
        DELETE;

END
GO