CREATE PROCEDURE bronze.sp_IngestData_date
    @data bronze.dateTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.[date] (dateid, caldate, [day], week, [month], qtr, [year], holiday, bronze_run_id)
    SELECT dateid, caldate, [day], week, [month], qtr, [year], holiday, @bronze_run_id
    FROM @data;
END

GO

