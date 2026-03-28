

/* =====================================================
2. Workflow Runs
===================================================== */

CREATE VIEW [dbo].[vw_WorkflowRuns]
AS
SELECT
    wo.WID,
    wo.workflow_id,
    w.workflow_name,
    wo.batch_id,
    b.batch_date,
    wo.status,
    wo.start_time,
    wo.end_time,
    DATEDIFF(minute, wo.start_time, wo.end_time) AS duration_minutes,
    wo.caller,
    wo.message,
    wo.message_error
FROM dbo.WorkflowOperations wo
LEFT JOIN dbo.Workflows w
    ON wo.workflow_id = w.workflow_id
LEFT JOIN dbo.Batches b
    ON wo.batch_id = b.batch_id;

GO

