CREATE TYPE [bronze].[listingTableType] AS TABLE (
    [listid]         INT            NULL,
    [sellerid]       INT            NULL,
    [eventid]        INT            NULL,
    [dateid]         INT            NULL,
    [numtickets]     INT            NULL,
    [priceperticket] DECIMAL (8, 2) NULL,
    [totalprice]     DECIMAL (8, 2) NULL,
    [listtime]       DATETIME       NULL);


GO

