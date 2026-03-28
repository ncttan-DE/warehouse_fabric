

/* =====================================================
6. Failed Operations
===================================================== */

CREATE VIEW dbo.vw_FailedOperations
AS
SELECT
    w.workflow_name,
    t.transform_name,
    tr.status,
    tr.message_error,
    tr.start_time
FROM dbo.TransformationOperations tr
LEFT JOIN dbo.Transformations t
    ON tr.transform_id = t.transform_id
LEFT JOIN dbo.Workflows w
    ON t.workflow_id = w.workflow_id
WHERE tr.status = 'FAILED';

GO

