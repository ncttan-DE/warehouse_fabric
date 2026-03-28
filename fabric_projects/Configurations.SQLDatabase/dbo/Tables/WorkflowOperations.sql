CREATE TABLE [dbo].[WorkflowOperations] (
    [WID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [workflow_id]   INT            NOT NULL,
    [batch_id]      BIGINT         NULL,
    [status]        NVARCHAR (20)  NOT NULL,
    [message]       NVARCHAR (MAX) NULL,
    [message_error] NVARCHAR (MAX) NULL,
    [created_time]  DATETIME2 (7)  DEFAULT (getdate()) NULL,
    [start_time]    DATETIME2 (7)  NULL,
    [end_time]      DATETIME2 (7)  NULL,
    [caller]        NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([WID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_WorkflowOperations_Batch]
    ON [dbo].[WorkflowOperations]([batch_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_WorkflowOperations_Workflow]
    ON [dbo].[WorkflowOperations]([workflow_id] ASC, [created_time] DESC);


GO

