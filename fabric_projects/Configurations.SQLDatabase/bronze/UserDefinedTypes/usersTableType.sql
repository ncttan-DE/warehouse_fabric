CREATE TYPE [bronze].[usersTableType] AS TABLE (
    [userid]        INT           NULL,
    [username]      CHAR (8)      NULL,
    [firstname]     VARCHAR (30)  NULL,
    [lastname]      VARCHAR (30)  NULL,
    [city]          VARCHAR (30)  NULL,
    [state]         CHAR (2)      NULL,
    [email]         VARCHAR (100) NULL,
    [phone]         CHAR (14)     NULL,
    [likesports]    BIT           NULL,
    [liketheatre]   BIT           NULL,
    [likeconcerts]  BIT           NULL,
    [likejazz]      BIT           NULL,
    [likeclassical] BIT           NULL,
    [likeopera]     BIT           NULL,
    [likerock]      BIT           NULL,
    [likevegas]     BIT           NULL,
    [likebroadway]  BIT           NULL,
    [likemusicals]  BIT           NULL);


GO

