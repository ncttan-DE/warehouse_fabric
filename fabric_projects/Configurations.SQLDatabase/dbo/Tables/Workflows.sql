CREATE TABLE [dbo].[Workflows] (
    [workflow_id]   INT            IDENTITY (1, 1) NOT NULL,
    [workflow_name] NVARCHAR (200) NOT NULL,
    [is_enable]     BIT            DEFAULT ((1)) NOT NULL,
    [src_id]        INT            NOT NULL,
    [created_at]    DATETIME2 (7)  DEFAULT (getdate()) NULL,
    [created_by]    NVARCHAR (100) NULL,
    [modified_at]   DATETIME2 (7)  NULL,
    [modified_by]   NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([workflow_id] ASC),
    CONSTRAINT [FK_Workflows_Source] FOREIGN KEY ([src_id]) REFERENCES [dbo].[Source_configurations] ([src_id])
);


GO

