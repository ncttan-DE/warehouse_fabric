
CREATE VIEW dbo.vw_WorkflowCurrentStatus
AS
SELECT
    w.workflow_id,
    w.workflow_name,
    b.batch_id,
    b.batch_date,
    wo.WID,
    wo.status AS workflow_status,
    t.transform_name AS running_step,
    tr.status AS step_status,
    tr.start_time
FROM dbo.WorkflowOperations wo
LEFT JOIN dbo.Workflows w ON wo.workflow_id = w.workflow_id
LEFT JOIN dbo.Batches b ON wo.batch_id = b.batch_id
LEFT JOIN dbo.TransformationOperations tr ON wo.WID = tr.WID
LEFT JOIN dbo.Transformations t ON tr.transform_id = t.transform_id
WHERE wo.end_time IS NULL;

GO

