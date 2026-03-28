CREATE PROCEDURE bronze.sp_IngestData_category
    @data bronze.categoryTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.category (catid, catgroup, catname, catdesc, bronze_run_id)
    SELECT catid, catgroup, catname, catdesc, @bronze_run_id
    FROM @data;
END

GO

