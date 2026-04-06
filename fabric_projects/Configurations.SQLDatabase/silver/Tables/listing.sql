CREATE TABLE [silver].[listing] (
    [listid]         INT            NOT NULL,
    [sellerid]       INT            NOT NULL,
    [eventid]        INT            NOT NULL,
    [dateid]         INT            NOT NULL,
    [numtickets]     INT            NOT NULL,
    [priceperticket] DECIMAL (8, 2) NULL,
    [totalprice]     DECIMAL (8, 2) NULL,
    [listtime]       DATETIME       NULL,
    [hash_value]     VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_listing_listid]
    ON [silver].[listing]([listid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_listing_listid_hash]
    ON [silver].[listing]([listid] ASC, [hash_value] ASC);


GO

