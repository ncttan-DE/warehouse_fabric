CREATE PROCEDURE bronze.sp_IngestData_event
    @data bronze.eventTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.event (eventid, venuename, categoryname, dateid, eventname, starttime, bronze_run_id)
    SELECT eventid, venuename, categoryname, dateid, eventname, starttime, @bronze_run_id
    FROM @data;
END

GO

