DROP PROCEDURE [dbo].[sp_FindAndCreateBatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindAndCreateBatch]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @Batch_id INT
            ,@today DATE = GETDATE()
            ,@is_retry BIT

    SELECT @Batch_id = batch_id
            ,@today = batch_date
    FROM dbo.Batches
    WHERE status IN ('RUNNING', 'FAILED')
    ORDER BY created_time DESC;

    IF(@Batch_id IS NOT NULL)
    BEGIN
        UPDATE dbo.Batches
        SET status = 'RUNNING'
        WHERE batch_id = @Batch_id

        SET @is_retry = 1

    END
    ELSE
    BEGIN

        INSERT INTO dbo.Batches
                (batch_date
                ,status
                ,created_time)
        VALUES
                (@today,
                'RUNNING',
                @today);
        
        SET @Batch_id = SCOPE_IDENTITY();
        SET @is_retry = 0

    END

    SELECT @Batch_id AS batch_id
            ,@today AS batch_date
            ,@is_retry AS is_retry
END
GO
