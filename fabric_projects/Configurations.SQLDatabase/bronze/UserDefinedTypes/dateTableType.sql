CREATE TYPE [bronze].[dateTableType] AS TABLE (
    [dateid]  INT      NULL,
    [caldate] DATE     NULL,
    [day]     CHAR (3) NULL,
    [week]    INT      NULL,
    [month]   CHAR (5) NULL,
    [qtr]     CHAR (5) NULL,
    [year]    INT      NULL,
    [holiday] BIT      NULL);


GO

