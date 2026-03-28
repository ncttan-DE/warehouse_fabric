/* =====================================================
CREATE STORED PROCEDURES - BRONZE INGEST
===================================================== */

-- category
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_category;
GO
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

-- date
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_date;
GO
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

-- event
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_event;
GO
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

-- listing
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_listing;
GO
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

-- sales
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_sales;
GO
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

-- users
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_users;
GO
CREATE PROCEDURE bronze.sp_IngestData_users
    @data bronze.usersTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.users (
        userid, username, firstname, lastname, city, [state], email, phone,
        likesports, liketheatre, likeconcerts, likejazz, likeclassical,
        likeopera, likerock, likevegas, likebroadway, likemusicals,
        bronze_run_id
    )
    SELECT 
        userid, username, firstname, lastname, city, [state], email, phone,
        likesports, liketheatre, likeconcerts, likejazz, likeclassical,
        likeopera, likerock, likevegas, likebroadway, likemusicals,
        @bronze_run_id
    FROM @data;
END
GO

-- venue
DROP PROCEDURE IF EXISTS bronze.sp_IngestData_venue;
GO
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