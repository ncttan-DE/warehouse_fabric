CREATE TABLE [bronze].[category] (
    [catid]         INT           NOT NULL,
    [catgroup]      VARCHAR (10)  NULL,
    [catname]       VARCHAR (10)  NULL,
    [catdesc]       VARCHAR (50)  NULL,
    [bronze_run_id] INT           NULL,
    [ingested_at]   DATETIME2 (7) DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_category_run_id]
    ON [bronze].[category]([bronze_run_id] ASC);


GO

