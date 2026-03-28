CREATE   PROCEDURE dbo.sp_GetOrCreateBronzeRuns
    @batch_id INT,
    @src_id INT
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------
    -- 1. Validate that the batch exists
    --------------------------------------------------
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Batches WHERE batch_id = @batch_id
    )
    BEGIN
        RAISERROR('Batch_id does not exist', 16, 1);
        RETURN;
    END

    --------------------------------------------------
    -- 2. Check if dbo.Bronze_runs already exist for this batch
    --------------------------------------------------
    IF EXISTS (
        SELECT 1 
        FROM dbo.Bronze_runs 
        WHERE batch_id = @batch_id
    )
    BEGIN
        --------------------------------------------------
        -- RETRY MODE:
        -- Return only records that are not successfully processed
        -- Includes:
        --   - PENDING (not yet processed)
        --   - FAILED (previous attempt failed)
        --------------------------------------------------
        SELECT 
            br.bronze_run_id,
            br.batch_id,
            br.src_obj_id,
            so.object_name,
            br.status,
            br.rows_ingested,
            br.start_time,
            br.end_time,
            CONCAT('SELECT * FROM dbo.', so.object_name, IIF(so.load_type = 'incremental', CASE
                                                                                                WHEN so.watermark_datatype = 'DATETIME' THEN  CONCAT(' WHERE ', so.watermark_column, ' > ''', COALESCE(so.watermark_value, '1900-01-01'), '''')
                                                                                                WHEN so.watermark_datatype = 'INT' THEN  CONCAT(' WHERE ', so.watermark_column, ' > ', COALESCE(so.watermark_value, 0), '')
                                                                                                ELSE ''
                                                                                            END  , ''), '') AS query_
        FROM dbo.Bronze_runs br
        INNER JOIN dbo.Source_objects so ON br.src_obj_id = so.src_obj_id
        WHERE br.batch_id = @batch_id
            AND br.status IN ('PENDING', 'RUNNING', 'FAILED');

        RETURN;
    END

    --------------------------------------------------
    -- 3. FIRST RUN:
    -- No existing dbo.Bronze_runs → create new records
    -- for all enabled source objects
    --------------------------------------------------
    INSERT INTO dbo.Bronze_runs (
        batch_id,
        src_obj_id,
        status
    )
    SELECT 
        @batch_id,
        so.src_obj_id,
        'PENDING'
    FROM Source_objects so
    WHERE so.is_enable = 1
        AND so.src_id = @src_id;

    --------------------------------------------------
    -- 4. Return all newly created records (PENDING)
    --------------------------------------------------
    SELECT 
        br.bronze_run_id,
        br.batch_id,
        br.src_obj_id,
        so.object_name,
        br.status,
        br.rows_ingested,
        br.start_time,
        br.end_time,
            CONCAT('SELECT * FROM dbo.', so.object_name, IIF(so.load_type = 'incremental', CASE
                                                                                                WHEN so.watermark_datatype = 'DATETIME' THEN  CONCAT(' WHERE ', so.watermark_column, ' > ''', COALESCE(so.watermark_value, '1900-01-01'), '''')
                                                                                                WHEN so.watermark_datatype = 'INT' THEN  CONCAT(' WHERE ', so.watermark_column, ' > ', COALESCE(so.watermark_value, 0), '')
                                                                                                ELSE ''
                                                                                            END  , ''), '') AS query_
    FROM dbo.Bronze_runs br
    INNER JOIN dbo.Source_objects so ON br.src_obj_id = so.src_obj_id
    WHERE br.batch_id = @batch_id
        AND br.status = 'PENDING';

END

GO

