CREATE TABLE [silver].[users] (
    [userid]        INT            NOT NULL,
    [username]      CHAR (8)       NULL,
    [firstname]     VARCHAR (30)   NULL,
    [lastname]      VARCHAR (30)   NULL,
    [city]          VARCHAR (30)   NULL,
    [state]         CHAR (2)       NULL,
    [email]         VARCHAR (100)  NULL,
    [phone]         CHAR (14)      NULL,
    [likesports]    BIT            NULL,
    [liketheatre]   BIT            NULL,
    [likeconcerts]  BIT            NULL,
    [likejazz]      BIT            NULL,
    [likeclassical] BIT            NULL,
    [likeopera]     BIT            NULL,
    [likerock]      BIT            NULL,
    [likevegas]     BIT            NULL,
    [likebroadway]  BIT            NULL,
    [likemusicals]  BIT            NULL,
    [hash_value]    VARBINARY (32) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [IX_users_userid]
    ON [silver].[users]([userid] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_users_userid_hash]
    ON [silver].[users]([userid] ASC, [hash_value] ASC);


GO

