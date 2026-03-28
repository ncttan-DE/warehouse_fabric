CREATE TABLE bronze.category (
    catid INT NOT NULL,
    catgroup VARCHAR(10) NULL,
    catname VARCHAR(10) NULL,
    catdesc VARCHAR(50) NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);
GO
CREATE INDEX IX_bronze_category_run_id ON bronze.category(bronze_run_id);
GO
CREATE TABLE bronze.[date] (
    dateid INT NOT NULL,
    caldate DATE NOT NULL,
    [day] CHAR(3) NOT NULL,
    week INT NOT NULL,
    [month] CHAR(5) NOT NULL,
    qtr CHAR(5) NOT NULL,
    [year] INT NOT NULL,
    holiday BIT NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);
GO
CREATE INDEX IX_bronze_date_run_id ON bronze.date(bronze_run_id);
GO
CREATE TABLE bronze.event (
    eventid INT NOT NULL,
    venuename VARCHAR(200) NOT NULL,
    categoryname VARCHAR(200) NOT NULL,
    dateid INT NOT NULL,
    eventname VARCHAR(200) NULL,
    starttime DATETIME NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);
GO
CREATE INDEX IX_bronze_event_run_id ON bronze.event(bronze_run_id);
GO

CREATE TABLE bronze.listing (
    listid INT NOT NULL,
    sellerid INT NOT NULL,
    eventid INT NOT NULL,
    dateid INT NOT NULL,
    numtickets INT NOT NULL,
    priceperticket DECIMAL(8,2) NULL,
    totalprice DECIMAL(8,2) NULL,
    listtime DATETIME NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);

GO
CREATE INDEX IX_bronze_listing_run_id ON bronze.listing(bronze_run_id);
GO

CREATE TABLE bronze.sales (
    sellername VARCHAR(200) NOT NULL,
    buyername VARCHAR(200) NOT NULL,
    eventid INT NOT NULL,
    dateid INT NOT NULL,
    qtysold INT NOT NULL,
    pricepaid DECIMAL(8,2) NULL,
    commission DECIMAL(8,2) NULL,
    saletime DATETIME NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);


GO
CREATE INDEX IX_bronze_sales_run_id ON bronze.sales(bronze_run_id);
GO
CREATE TABLE bronze.users (
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
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);

GO
CREATE INDEX IX_bronze_users_run_id ON bronze.users(bronze_run_id);
GO
CREATE TABLE bronze.venue (
    venueid INT NOT NULL,
    venuename VARCHAR(100) NULL,
    venuecity VARCHAR(30) NULL,
    venuestate CHAR(2) NULL,
    venueseats INT NULL,
    bronze_run_id INT,
    ingested_at DATETIME2 DEFAULT GETDATE()
);

GO
CREATE INDEX IX_bronze_venue_run_id ON bronze.venue(bronze_run_id);

