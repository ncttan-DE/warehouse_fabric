CREATE TABLE [dbo].[Transformations] (
    [transform_id]   INT            IDENTITY (1, 1) NOT NULL,
    [workflow_id]    INT            NOT NULL,
    [step_order]     INT            NOT NULL,
    [transform_name] NVARCHAR (200) NOT NULL,
    [is_enable]      BIT            DEFAULT ((1)) NOT NULL,
    [created_at]     DATETIME2 (7)  DEFAULT (getdate()) NULL,
    [created_by]     NVARCHAR (100) NULL,
    [modified_at]    DATETIME2 (7)  NULL,
    [modified_by]    NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([transform_id] ASC),
    CONSTRAINT [FK_Transformations_Workflow] FOREIGN KEY ([workflow_id]) REFERENCES [dbo].[Workflows] ([workflow_id]),
    CONSTRAINT [UQ_Workflow_Step] UNIQUE NONCLUSTERED ([workflow_id] ASC, [step_order] ASC)
);


GO

