CREATE TYPE [bronze].[eventTableType] AS TABLE (
    [eventid]      INT           NULL,
    [venuename]    VARCHAR (200) NULL,
    [categoryname] VARCHAR (200) NULL,
    [dateid]       INT           NULL,
    [eventname]    VARCHAR (200) NULL,
    [starttime]    DATETIME      NULL);


GO

