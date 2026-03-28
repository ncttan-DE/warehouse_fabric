CREATE TABLE [bronze].[venue] (
    [venueid]       INT           NOT NULL,
    [venuename]     VARCHAR (100) NULL,
    [venuecity]     VARCHAR (30)  NULL,
    [venuestate]    CHAR (2)      NULL,
    [venueseats]    INT           NULL,
    [bronze_run_id] INT           NULL,
    [ingested_at]   DATETIME2 (7) DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_venue_run_id]
    ON [bronze].[venue]([bronze_run_id] ASC);


GO

