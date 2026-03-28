CREATE TABLE [bronze].[users] (
    [userid]        INT           NOT NULL,
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
    [likemusicals]  BIT           NULL,
    [bronze_run_id] INT           NULL,
    [ingested_at]   DATETIME2 (7) DEFAULT (getdate()) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_bronze_users_run_id]
    ON [bronze].[users]([bronze_run_id] ASC);


GO

