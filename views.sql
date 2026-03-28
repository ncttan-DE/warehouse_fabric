/* =====================================================
DROP VIEWS
===================================================== */

DROP VIEW IF EXISTS dbo.vw_FailedOperations;
DROP VIEW IF EXISTS dbo.vw_PipelineExecution;
DROP VIEW IF EXISTS dbo.vw_BronzeRuns;
DROP VIEW IF EXISTS dbo.vw_TransformationRuns;
DROP VIEW IF EXISTS dbo.vw_WorkflowRuns;
DROP VIEW IF EXISTS dbo.vw_WorkflowDefinitions;
DROP VIEW IF EXISTS dbo.vw_WorkflowCurrentStatus;
GO


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


/* =====================================================
4. Bronze Runs
===================================================== */

CREATE VIEW dbo.vw_BronzeRuns
AS
SELECT
    br.bronze_run_id,
    br.batch_id,
    b.batch_date,
    sc.source_name,
    so.object_name,
    br.status,
    br.rows_ingested,
    br.start_time,
    br.end_time,
    DATEDIFF(SECOND, br.start_time, br.end_time) AS duration_seconds
FROM dbo.Bronze_runs br
LEFT JOIN dbo.Batches b
    ON br.batch_id = b.batch_id
LEFT JOIN dbo.Source_objects so
    ON br.src_obj_id = so.src_obj_id
LEFT JOIN dbo.Source_configurations sc
    ON so.src_id = sc.src_id;
GO


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