

/* =====================================================
5. Pipeline Execution
===================================================== */

CREATE VIEW dbo.vw_PipelineExecution
AS
SELECT
    w.workflow_name,
    b.batch_date,
    wo.WID,
    wo.status AS workflow_status,
    t.step_order,
    t.transform_name,
    tr.status AS transform_status,
    tr.start_time,
    tr.end_time
FROM dbo.WorkflowOperations wo
LEFT JOIN dbo.Workflows w
    ON wo.workflow_id = w.workflow_id
LEFT JOIN dbo.Batches b
    ON wo.batch_id = b.batch_id
LEFT JOIN dbo.TransformationOperations tr
    ON wo.WID = tr.WID
LEFT JOIN dbo.Transformations t
    ON tr.transform_id = t.transform_id;

GO

