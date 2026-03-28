CREATE TABLE [dbo].[Bronze_runs] (
    [bronze_run_id] BIGINT        IDENTITY (1, 1) NOT NULL,
    [batch_id]      BIGINT        NOT NULL,
    [src_obj_id]    INT           NOT NULL,
    [status]        NVARCHAR (20) NULL,
    [rows_ingested] BIGINT        NULL,
    [start_time]    DATETIME2 (7) NULL,
    [end_time]      DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([bronze_run_id] ASC),
    CONSTRAINT [FK_BronzeRuns_Batch] FOREIGN KEY ([batch_id]) REFERENCES [dbo].[Batches] ([batch_id]),
    CONSTRAINT [FK_BronzeRuns_SourceObject] FOREIGN KEY ([src_obj_id]) REFERENCES [dbo].[Source_objects] ([src_obj_id]),
    CONSTRAINT [UQ_BronzeRun] UNIQUE NONCLUSTERED ([batch_id] ASC, [src_obj_id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_BronzeRuns_Batch]
    ON [dbo].[Bronze_runs]([batch_id] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_BronzeRuns_SourceObject]
    ON [dbo].[Bronze_runs]([src_obj_id] ASC);


GO

