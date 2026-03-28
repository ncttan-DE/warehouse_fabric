CREATE PROCEDURE bronze.sp_IngestData_listing
    @data bronze.listingTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.listing (listid, sellerid, eventid, dateid, numtickets, priceperticket, totalprice, listtime, bronze_run_id)
    SELECT listid, sellerid, eventid, dateid, numtickets, priceperticket, totalprice, listtime, @bronze_run_id
    FROM @data;
END

GO

