CREATE OR ALTER PROCEDURE silver.sp_transform_bronze_to_silver_sales
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 0: Refresh Silver view to ensure it's up-to-date before transformation
    ------------------------------------------------------------------
    TRUNCATE TABLE silver.sales;

    ------------------------------------------------------------------
    -- Step 1: Extract + hash
    --         + No dedup / merge because no business key
    --         + Treated as append-only fact table
    ------------------------------------------------------------------
    INSERT INTO silver.sales (
        sellername,
        buyername,
        eventid,
        dateid,
        qtysold,
        pricepaid,
        commission,
        saletime
    )
    SELECT 
        sellername,
        buyername,
        eventid,
        dateid,
        qtysold,
        pricepaid,
        commission,
        saletime
    FROM bronze.sales
    WHERE bronze_run_id = @bronze_run_id;

END
GO