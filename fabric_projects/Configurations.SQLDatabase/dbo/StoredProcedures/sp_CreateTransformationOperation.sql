CREATE   PROCEDURE dbo.sp_CreateTransformationOperation
(
    @WID INT,
    @transform_id INT
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO dbo.TransformationOperations
    (
        WID,
        transform_id,
        status,
        created_time,
        start_time
    )
    VALUES
    (
        @WID,
        @transform_id,
        'RUNNING',
        GETDATE(),
        GETDATE()
    );

    SELECT SCOPE_IDENTITY() AS TID;

END

GO

