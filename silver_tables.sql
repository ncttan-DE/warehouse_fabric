CREATE SCHEMA silver;
GO

-- =====================================================
-- CATEGORY
-- =====================================================
CREATE TABLE silver.category (
    catid INT NOT NULL,
    catgroup VARCHAR(10) NULL,
    catname VARCHAR(10) NULL,
    catdesc VARCHAR(50) NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_category_catid
ON silver.category(catid);
GO

CREATE NONCLUSTERED INDEX IX_category_catid_hash
ON silver.category(catid, hash_value);
GO


-- =====================================================
-- DATE
-- =====================================================
CREATE TABLE silver.[date] (
    dateid INT NOT NULL,
    caldate DATE NOT NULL,
    [day] CHAR(3) NOT NULL,
    week INT NOT NULL,
    [month] CHAR(5) NOT NULL,
    qtr CHAR(5) NOT NULL,
    [year] INT NOT NULL,
    holiday BIT NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_date_dateid
ON silver.[date](dateid);
GO

CREATE NONCLUSTERED INDEX IX_date_dateid_hash
ON silver.[date](dateid, hash_value);
GO


-- =====================================================
-- EVENT (keep denormalized like bronze)
-- =====================================================
CREATE TABLE silver.event (
    eventid INT NOT NULL,
    venuename VARCHAR(200) NOT NULL,
    categoryname VARCHAR(200) NOT NULL,
    dateid INT NOT NULL,
    eventname VARCHAR(200) NULL,
    starttime DATETIME NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_event_eventid
ON silver.event(eventid);
GO

CREATE NONCLUSTERED INDEX IX_event_eventid_hash
ON silver.event(eventid, hash_value);
GO


-- =====================================================
-- LISTING
-- =====================================================
CREATE TABLE silver.listing (
    listid INT NOT NULL,
    sellerid INT NOT NULL,
    eventid INT NOT NULL,
    dateid INT NOT NULL,
    numtickets INT NOT NULL,
    priceperticket DECIMAL(8,2) NULL,
    totalprice DECIMAL(8,2) NULL,
    listtime DATETIME NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_listing_listid
ON silver.listing(listid);
GO

CREATE NONCLUSTERED INDEX IX_listing_listid_hash
ON silver.listing(listid, hash_value);
GO


-- =====================================================
-- SALES (no business key → keep as-is, no forced PK)
-- =====================================================
CREATE TABLE silver.sales (
    sellername VARCHAR(200) NOT NULL,
    buyername VARCHAR(200) NOT NULL,
    eventid INT NOT NULL,
    dateid INT NOT NULL,
    qtysold INT NOT NULL,
    pricepaid DECIMAL(8,2) NULL,
    commission DECIMAL(8,2) NULL,
    saletime DATETIME NULL
);
GO


-- =====================================================
-- USERS
-- =====================================================
CREATE TABLE silver.users (
    userid INT NOT NULL,
    username CHAR(8) NULL,
    firstname VARCHAR(30) NULL,
    lastname VARCHAR(30) NULL,
    city VARCHAR(30) NULL,
    [state] CHAR(2) NULL,
    email VARCHAR(100) NULL,
    phone CHAR(14) NULL,
    likesports BIT NULL,
    liketheatre BIT NULL,
    likeconcerts BIT NULL,
    likejazz BIT NULL,
    likeclassical BIT NULL,
    likeopera BIT NULL,
    likerock BIT NULL,
    likevegas BIT NULL,
    likebroadway BIT NULL,
    likemusicals BIT NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_users_userid
ON silver.users(userid);
GO

CREATE NONCLUSTERED INDEX IX_users_userid_hash
ON silver.users(userid, hash_value);
GO


-- =====================================================
-- VENUE
-- =====================================================
CREATE TABLE silver.venue (
    venueid INT NOT NULL,
    venuename VARCHAR(100) NULL,
    venuecity VARCHAR(30) NULL,
    venuestate CHAR(2) NULL,
    venueseats INT NULL,
    hash_value VARBINARY(32) NOT NULL
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_venue_venueid
ON silver.venue(venueid);
GO

CREATE NONCLUSTERED INDEX IX_venue_venueid_hash
ON silver.venue(venueid, hash_value);
GO