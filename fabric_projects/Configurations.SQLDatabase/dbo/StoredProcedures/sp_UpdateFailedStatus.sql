CREATE   PROCEDURE dbo.sp_UpdateFailedStatus
(
    @messages NVARCHAR(MAX)
)
AS
BEGIN

    SET NOCOUNT ON;

    -- Parse JSON into table
    DECLARE @ErrorTable TABLE (
        [type] VARCHAR(20),
        [TID] INT,
        [WID] INT,
        [message] NVARCHAR(MAX)
    );

    INSERT INTO @ErrorTable ([type], [TID], [WID], [message])
    SELECT 
        [type],
        [TID],
        [WID],
        [message]
    FROM OPENJSON(@messages)
    WITH (
        [type] VARCHAR(20),
        [TID] INT,
        [WID] INT,
        [message] NVARCHAR(MAX)
    );

    UPDATE tra
    SET tra.status = 'FAILED'
        ,tra.message_error = err.message
        ,tra.end_time = GETDATE()
    FROM @ErrorTable err
    INNER JOIN dbo.TransformationOperations tra on tra.TID = err.TID;

    UPDATE wor
    SET wor.status = 'FAILED'
        ,wor.end_time = GETDATE()
        ,wor.message_error = CONCAT(t.transform_name, ' failed. Error: ', err.message)
    from @ErrorTable err
    INNER join dbo.TransformationOperations tra on tra.TID = err.TID
    INNER JOIN dbo.Transformations t ON t.transform_id = tra.transform_id
    INNER join dbo.WorkflowOperations wor on wor.WID = err.WID;

    SELECT *
    from @ErrorTable err
    INNER join dbo.TransformationOperations tra on tra.TID = err.TID
    INNER JOIN dbo.Transformations t ON t.transform_id = tra.transform_id
    INNER join dbo.WorkflowOperations wor on wor.WID = err.WID;

END

GO

