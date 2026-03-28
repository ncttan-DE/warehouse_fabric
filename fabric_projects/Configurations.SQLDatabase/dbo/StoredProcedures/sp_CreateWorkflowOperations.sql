CREATE PROCEDURE [dbo].[sp_CreateWorkflowOperations]
(
    @workflow_id INT
    ,@batch_id INT
    ,@caller VARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO dbo.WorkflowOperations
            (workflow_id,
            status,
            batch_id,
            created_time,
            start_time,
            caller)
    VALUES
            (@workflow_id,
            'RUNNING',
            @batch_id,
            GETDATE(),
            GETDATE(),
            @caller);
    
    SELECT SCOPE_IDENTITY() AS WID;

END

GO

