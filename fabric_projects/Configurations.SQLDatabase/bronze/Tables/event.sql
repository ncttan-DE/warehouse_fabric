CREATE TABLE [bronze].[event] (
    [eventid]       INT           NOT NULL,
    [venuename]     VARCHAR (200) NOT NULL,
    [categoryname]  VARCHAR (200) NOT NULL,
    [dateid]        INT           NOT NULL,
    [eventname]     VARCHAR (200) NULL,
    [starttime]     DATETIME      NULL,
    [bronze_run_id] INT           NULL,
    [ingested_at]   DATETIME2 (7) DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_event_run_id]
    ON [bronze].[event]([bronze_run_id] ASC);


GO

