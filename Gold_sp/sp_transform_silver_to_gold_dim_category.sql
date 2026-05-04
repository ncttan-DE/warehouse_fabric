SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_dim_category]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

            
            DECLARE @current_time DATETIME2 = GETDATE();

            ------------------------------------------------------------------
            -- STEP 1: INSERT NEW (catid not exist)
            ------------------------------------------------------------------
            INSERT INTO gold.dim_category (
                catid,
                catgroup,
                catname,
                catdesc,
                hash_value,
                effective_from,
                effective_to,
                is_current
            )
            SELECT 
                s.catid,
                s.catgroup,
                s.catname,
                s.catdesc,
                s.hash_value,
                @current_time,
                NULL,
                1
            FROM silver.category s
            LEFT JOIN gold.dim_category g
                ON s.catid = g.catid
                AND g.is_current = 1
            WHERE g.catid IS NULL;

            ------------------------------------------------------------------
            -- STEP 2: EXPIRE CHANGED RECORDS
            ------------------------------------------------------------------
            UPDATE g
            SET 
                g.effective_to = @current_time,
                g.is_current = 0
            FROM gold.dim_category g
            JOIN silver.category s
                ON g.catid = s.catid
            WHERE g.is_current = 1
            AND g.hash_value <> s.hash_value;

            ------------------------------------------------------------------
            -- STEP 3: INSERT NEW VERSION (ONLY CHANGED)
            ------------------------------------------------------------------
            INSERT INTO gold.dim_category (
                catid,
                catgroup,
                catname,
                catdesc,
                hash_value,
                effective_from,
                effective_to,
                is_current
            )
            SELECT 
                s.catid,
                s.catgroup,
                s.catname,
                s.catdesc,
                s.hash_value,
                @current_time,
                NULL,
                1
            FROM silver.category s
            JOIN gold.dim_category g ON s.catid = g.catid
            WHERE g.is_current = 0
            AND g.effective_to = @current_time;


        ------------------------------------------------------------------
        -- Step 4: Commit transaction if successful
        ------------------------------------------------------------------
        COMMIT;

    END TRY
    BEGIN CATCH
        ------------------------------------------------------------------
        -- Step 5: Rollback transaction in case of error
        ------------------------------------------------------------------
        IF @@TRANCOUNT > 0
            ROLLBACK;

        -- Re-throw the error for upstream handling
        THROW;
    END CATCH

END;
GO
