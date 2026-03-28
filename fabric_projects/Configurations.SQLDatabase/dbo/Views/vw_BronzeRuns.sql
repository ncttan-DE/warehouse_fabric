

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

