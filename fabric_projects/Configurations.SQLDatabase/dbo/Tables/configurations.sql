CREATE TABLE [dbo].[configurations] (
    [config_id]    INT           IDENTITY (1, 1) NOT NULL,
    [config_name]  VARCHAR (20)  NOT NULL,
    [config_value] VARCHAR (MAX) NULL,
    [description]  VARCHAR (256) NULL
);


GO

