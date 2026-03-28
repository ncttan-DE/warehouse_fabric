CREATE TABLE [bronze].[sales] (
    [sellername]    VARCHAR (200)  NOT NULL,
    [buyername]     VARCHAR (200)  NOT NULL,
    [eventid]       INT            NOT NULL,
    [dateid]        INT            NOT NULL,
    [qtysold]       INT            NOT NULL,
    [pricepaid]     DECIMAL (8, 2) NULL,
    [commission]    DECIMAL (8, 2) NULL,
    [saletime]      DATETIME       NULL,
    [bronze_run_id] INT            NULL,
    [ingested_at]   DATETIME2 (7)  DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_sales_run_id]
    ON [bronze].[sales]([bronze_run_id] ASC);


GO

