CREATE PROCEDURE bronze.sp_IngestData_sales
    @data bronze.salesTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.sales (sellername, buyername, eventid, dateid, qtysold, pricepaid, commission, saletime, bronze_run_id)
    SELECT sellername, buyername, eventid, dateid, qtysold, pricepaid, commission, saletime, @bronze_run_id
    FROM @data;
END

GO

