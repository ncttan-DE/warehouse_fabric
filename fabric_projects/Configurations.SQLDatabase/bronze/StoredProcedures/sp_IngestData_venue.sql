CREATE PROCEDURE bronze.sp_IngestData_venue
    @data bronze.venueTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.venue (venueid, venuename, venuecity, venuestate, venueseats, bronze_run_id)
    SELECT venueid, venuename, venuecity, venuestate, venueseats, @bronze_run_id
    FROM @data;
END

GO

