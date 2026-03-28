

/* =====================================================
1. Workflow Definitions
===================================================== */

CREATE VIEW dbo.vw_WorkflowDefinitions
AS
SELECT
    w.workflow_id,
    w.workflow_name,
    w.src_id,
    w.is_enable AS workflow_enable,
    t.transform_id,
    t.step_order,
    t.transform_name,
    t.is_enable AS transform_enable
FROM dbo.Workflows w
LEFT JOIN dbo.Transformations t
    ON w.workflow_id = t.workflow_id;

GO

