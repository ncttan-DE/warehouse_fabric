CREATE TABLE [dbo].[Source_configurations] (
    [src_id]      INT            IDENTITY (1, 1) NOT NULL,
    [source_name] NVARCHAR (200) NOT NULL,
    [source_type] NVARCHAR (50)  NOT NULL,
    [is_enable]   BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([src_id] ASC)
);


GO

