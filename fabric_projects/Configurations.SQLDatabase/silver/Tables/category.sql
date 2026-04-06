CREATE TABLE [silver].[category] (
    [catid]      INT            NOT NULL,
    [catgroup]   VARCHAR (10)   NULL,
    [catname]    VARCHAR (10)   NULL,
    [catdesc]    VARCHAR (50)   NULL,
    [hash_value] VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_category_catid]
    ON [silver].[category]([catid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_category_catid_hash]
    ON [silver].[category]([catid] ASC, [hash_value] ASC);


GO

