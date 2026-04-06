CREATE   PROCEDURE silver.sp_transform_bronze_to_silver_date
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 1: Extract data from Bronze for the given run_id
    --         + Generate hash_value (used for change detection)
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_date_hash;

    SELECT 
        dateid,
        caldate,
        [day],
        week,
        [month],
        qtr,
        [year],
        holiday,
        HASHBYTES(
            'SHA2_256',
            CONCAT(
                caldate,'|',[day],'|',week,'|',
                [month],'|',qtr,'|',[year],'|',holiday
            )
        ) AS hash_value
    INTO #temp_date_hash
    FROM bronze.[date]
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate records based on hash_value
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_date_hash_rn;

    SELECT 
        dateid,
        caldate,
        [day],
        week,
        [month],
        qtr,
        [year],
        holiday,
        hash_value,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY dateid DESC
        ) AS rn
    INTO #temp_date_hash_rn
    FROM #temp_date_hash;


    ------------------------------------------------------------------
    -- Step 3: Get latest version per dateid
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_date_hash_latest;

    SELECT 
        dateid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_date_hash_latest
    FROM #temp_date_hash_rn
    WHERE rn = 1
    GROUP BY dateid;


    ------------------------------------------------------------------
    -- Step 4: MERGE into Silver (NO DELETE - incremental load)
    ------------------------------------------------------------------
    MERGE silver.[date] AS dest
    USING (
        SELECT s.*
        FROM #temp_date_hash_latest latest
        INNER JOIN #temp_date_hash_rn s ON s.dateid = latest.dateid
                                        AND s.hash_value = latest.max_hash_value
                                        AND s.rn = 1
    ) AS src
    ON dest.dateid = src.dateid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            caldate = src.caldate,
            [day] = src.[day],
            week = src.week,
            [month] = src.[month],
            qtr = src.qtr,
            [year] = src.[year],
            holiday = src.holiday

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            dateid, caldate, [day], week,
            [month], qtr, [year], holiday, hash_value
        )
        VALUES (
            src.dateid, src.caldate, src.[day], src.week,
            src.[month], src.qtr, src.[year], src.holiday, src.hash_value
        );

END

GO

