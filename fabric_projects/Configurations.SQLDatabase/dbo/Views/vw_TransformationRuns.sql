

/* =====================================================
3. Transformation Runs
===================================================== */

CREATE VIEW dbo.vw_TransformationRuns
AS
SELECT
    tr.TID,
    tr.WID,
    w.workflow_name,
    t.transform_name,
    t.step_order,
    tr.status,
    tr.start_time,
    tr.end_time,
    DATEDIFF(SECOND, tr.start_time, tr.end_time) AS duration_seconds,
    tr.message,
    tr.message_error
FROM dbo.TransformationOperations tr
LEFT JOIN dbo.Transformations t
    ON tr.transform_id = t.transform_id
LEFT JOIN dbo.Workflows w
    ON t.workflow_id = w.workflow_id;

GO

