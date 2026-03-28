CREATE   PROCEDURE dbo.sp_UpdateSuccessStatusOperations
(
    @TID INT,
    @WID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    UPDATE dbo.TransformationOperations
    SET status = 'SUCCESS'
        ,end_time = GETDATE()
    WHERE TID = @TID;

    UPDATE dbo.WorkflowOperations
    SET status = 'SUCCESS'
        ,end_time = GETDATE()
    WHERE WID = @WID;

END

GO

