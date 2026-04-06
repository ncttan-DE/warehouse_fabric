CREATE TABLE [silver].[venue] (
    [venueid]    INT            NOT NULL,
    [venuename]  VARCHAR (100)  NULL,
    [venuecity]  VARCHAR (30)   NULL,
    [venuestate] CHAR (2)       NULL,
    [venueseats] INT            NULL,
    [hash_value] VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_venue_venueid]
    ON [silver].[venue]([venueid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_venue_venueid_hash]
    ON [silver].[venue]([venueid] ASC, [hash_value] ASC);


GO

