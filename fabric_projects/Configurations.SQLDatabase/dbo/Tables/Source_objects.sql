CREATE TABLE [dbo].[Source_objects] (
    [src_obj_id]         INT            IDENTITY (1, 1) NOT NULL,
    [src_id]             INT            NOT NULL,
    [object_name]        NVARCHAR (200) NOT NULL,
    [load_type]          NVARCHAR (50)  NULL,
    [watermark_column]   NVARCHAR (100) NULL,
    [is_enable]          BIT            DEFAULT ((1)) NULL,
    [watermark_value]    VARCHAR (100)  NULL,
    [watermark_datatype] VARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([src_obj_id] ASC),
    CONSTRAINT [FK_SourceObjects_Source] FOREIGN KEY ([src_id]) REFERENCES [dbo].[Source_configurations] ([src_id])
);


GO

CREATE NONCLUSTERED INDEX [IX_SourceObjects_Source]
    ON [dbo].[Source_objects]([src_id] ASC);


GO

