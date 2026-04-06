CREATE TABLE [silver].[sales] (
    [sellername] VARCHAR (200)  NOT NULL,
    [buyername]  VARCHAR (200)  NOT NULL,
    [eventid]    INT            NOT NULL,
    [dateid]     INT            NOT NULL,
    [qtysold]    INT            NOT NULL,
    [pricepaid]  DECIMAL (8, 2) NULL,
    [commission] DECIMAL (8, 2) NULL,
    [saletime]   DATETIME       NULL
);


GO

