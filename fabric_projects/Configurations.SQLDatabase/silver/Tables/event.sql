CREATE TABLE [silver].[event] (
    [eventid]      INT            NOT NULL,
    [venuename]    VARCHAR (200)  NOT NULL,
    [categoryname] VARCHAR (200)  NOT NULL,
    [dateid]       INT            NOT NULL,
    [eventname]    VARCHAR (200)  NULL,
    [starttime]    DATETIME       NULL,
    [hash_value]   VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_event_eventid]
    ON [silver].[event]([eventid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_event_eventid_hash]
    ON [silver].[event]([eventid] ASC, [hash_value] ASC);


GO

