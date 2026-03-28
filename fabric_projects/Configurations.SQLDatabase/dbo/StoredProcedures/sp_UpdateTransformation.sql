CREATE PROCEDURE [dbo].[sp_UpdateTransformation]
(
    @TID INT
    ,@Update_type VARCHAR(25)
    ,@Message VARCHAR(MAX) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

    IF @Update_type = 'COMPLETED'
    BEGIN
        UPDATE dbo.transformationOperations
        SET status = 'COMPLETED'
            ,end_time = GETDATE()
        WHERE TID = @TID
    END
    ELSE IF @Update_type = 'RUNNING'
    BEGIN
        UPDATE dbo.transformationOperations
        SET status = 'RUNNING'
            ,start_time = GETDATE()
        WHERE TID = @TID
    END
    ELSE IF @Update_type = 'FAILED'
    BEGIN
        UPDATE dbo.transformationOperations
        SET status = 'FAILED'
            ,end_time = GETDATE()
            ,message_error = @Message
        WHERE TID = @TID
    END

END

GO

