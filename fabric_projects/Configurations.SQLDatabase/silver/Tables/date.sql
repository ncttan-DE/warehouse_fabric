CREATE TABLE [silver].[date] (
    [dateid]     INT            NOT NULL,
    [caldate]    DATE           NOT NULL,
    [day]        CHAR (3)       NOT NULL,
    [week]       INT            NOT NULL,
    [month]      CHAR (5)       NOT NULL,
    [qtr]        CHAR (5)       NOT NULL,
    [year]       INT            NOT NULL,
    [holiday]    BIT            NULL,
    [hash_value] VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_date_dateid]
    ON [silver].[date]([dateid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_date_dateid_hash]
    ON [silver].[date]([dateid] ASC, [hash_value] ASC);


GO

