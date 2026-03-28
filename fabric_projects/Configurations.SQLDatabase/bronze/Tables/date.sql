CREATE TABLE [bronze].[date] (
    [dateid]        INT           NOT NULL,
    [caldate]       DATE          NOT NULL,
    [day]           CHAR (3)      NOT NULL,
    [week]          INT           NOT NULL,
    [month]         CHAR (5)      NOT NULL,
    [qtr]           CHAR (5)      NOT NULL,
    [year]          INT           NOT NULL,
    [holiday]       BIT           NULL,
    [bronze_run_id] INT           NULL,
    [ingested_at]   DATETIME2 (7) DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_date_run_id]
    ON [bronze].[date]([bronze_run_id] ASC);


GO

