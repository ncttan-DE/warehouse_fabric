CREATE TABLE [dbo].[Batches] (
    [batch_id]     BIGINT        IDENTITY (1, 1) NOT NULL,
    [batch_date]   DATE          NOT NULL,
    [status]       NVARCHAR (20) NOT NULL,
    [start_time]   DATETIME2 (7) NULL,
    [end_time]     DATETIME2 (7) NULL,
    [created_time] DATETIME2 (7) DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([batch_id] ASC),
    CONSTRAINT [CK_Batch_Status] CHECK ([status]='FAILED' OR [status]='SUCCESS' OR [status]='RUNNING')
);


GO

CREATE NONCLUSTERED INDEX [IX_Batches_Date]
    ON [dbo].[Batches]([batch_date] ASC);


GO

