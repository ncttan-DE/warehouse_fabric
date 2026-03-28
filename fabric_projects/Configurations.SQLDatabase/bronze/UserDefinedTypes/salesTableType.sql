CREATE TYPE [bronze].[salesTableType] AS TABLE (
    [sellername] VARCHAR (200)  NULL,
    [buyername]  VARCHAR (200)  NULL,
    [eventid]    INT            NULL,
    [dateid]     INT            NULL,
    [qtysold]    INT            NULL,
    [pricepaid]  DECIMAL (8, 2) NULL,
    [commission] DECIMAL (8, 2) NULL,
    [saletime]   DATETIME       NULL);


GO

