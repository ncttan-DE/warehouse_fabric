CREATE TYPE bronze.categoryTableType AS TABLE
(
    catid INT,
    catgroup VARCHAR(10),
    catname VARCHAR(10),
    catdesc VARCHAR(50)
);

CREATE TYPE bronze.dateTableType AS TABLE
(
    dateid INT,
    caldate DATE,
    [day] CHAR(3),
    week INT,
    [month] CHAR(5),
    qtr CHAR(5),
    [year] INT,
    holiday BIT
);

CREATE TYPE bronze.eventTableType AS TABLE
(
    eventid INT,
    venuename VARCHAR(200),
    categoryname VARCHAR(200),
    dateid INT,
    eventname VARCHAR(200),
    starttime DATETIME
);

CREATE TYPE bronze.listingTableType AS TABLE
(
    listid INT,
    sellerid INT,
    eventid INT,
    dateid INT,
    numtickets INT,
    priceperticket DECIMAL(8,2),
    totalprice DECIMAL(8,2),
    listtime DATETIME
);

CREATE TYPE bronze.salesTableType AS TABLE
(
    sellername VARCHAR(200),
    buyername VARCHAR(200),
    eventid INT,
    dateid INT,
    qtysold INT,
    pricepaid DECIMAL(8,2),
    commission DECIMAL(8,2),
    saletime DATETIME
);

CREATE TYPE bronze.usersTableType AS TABLE
(
    userid INT,
    username CHAR(8),
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    city VARCHAR(30),
    [state] CHAR(2),
    email VARCHAR(100),
    phone CHAR(14),
    likesports BIT,
    liketheatre BIT,
    likeconcerts BIT,
    likejazz BIT,
    likeclassical BIT,
    likeopera BIT,
    likerock BIT,
    likevegas BIT,
    likebroadway BIT,
    likemusicals BIT
);

CREATE TYPE bronze.venueTableType AS TABLE
(
    venueid INT,
    venuename VARCHAR(100),
    venuecity VARCHAR(30),
    venuestate CHAR(2),
    venueseats INT
);