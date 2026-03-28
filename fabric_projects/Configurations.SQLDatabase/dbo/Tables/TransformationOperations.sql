CREATE TABLE [dbo].[TransformationOperations] (
    [TID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [WID]           BIGINT         NOT NULL,
    [transform_id]  INT            NOT NULL,
    [status]        NVARCHAR (20)  NOT NULL,
    [message]       NVARCHAR (MAX) NULL,
    [message_error] NVARCHAR (MAX) NULL,
    [created_time]  DATETIME2 (7)  DEFAULT (getdate()) NULL,
    [start_time]    DATETIME2 (7)  NULL,
    [end_time]      DATETIME2 (7)  NULL,
    PRIMARY KEY CLUSTERED ([TID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_TransformationOperations_Transform]
    ON [dbo].[TransformationOperations]([transform_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TransformationOperations_WID]
    ON [dbo].[TransformationOperations]([WID] ASC);


GO

