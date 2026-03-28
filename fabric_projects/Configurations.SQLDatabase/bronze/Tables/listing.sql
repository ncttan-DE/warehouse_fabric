CREATE TABLE [bronze].[listing] (
    [listid]         INT            NOT NULL,
    [sellerid]       INT            NOT NULL,
    [eventid]        INT            NOT NULL,
    [dateid]         INT            NOT NULL,
    [numtickets]     INT            NOT NULL,
    [priceperticket] DECIMAL (8, 2) NULL,
    [totalprice]     DECIMAL (8, 2) NULL,
    [listtime]       DATETIME       NULL,
    [bronze_run_id]  INT            NULL,
    [ingested_at]    DATETIME2 (7)  DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_listing_run_id]
    ON [bronze].[listing]([bronze_run_id] ASC);


GO

