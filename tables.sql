/* =====================================================
DROP TABLES
===================================================== */

IF OBJECT_ID('dbo.TransformationOperations', 'U') IS NOT NULL DROP TABLE dbo.TransformationOperations;
IF OBJECT_ID('dbo.WorkflowOperations', 'U') IS NOT NULL DROP TABLE dbo.WorkflowOperations;
IF OBJECT_ID('dbo.Bronze_runs', 'U') IS NOT NULL DROP TABLE dbo.Bronze_runs;
IF OBJECT_ID('dbo.Transformations', 'U') IS NOT NULL DROP TABLE dbo.Transformations;
IF OBJECT_ID('dbo.Batches', 'U') IS NOT NULL DROP TABLE dbo.Batches;
IF OBJECT_ID('dbo.Source_objects', 'U') IS NOT NULL DROP TABLE dbo.Source_objects;
IF OBJECT_ID('dbo.Source_configurations', 'U') IS NOT NULL DROP TABLE dbo.Source_configurations;
IF OBJECT_ID('dbo.Workflows', 'U') IS NOT NULL DROP TABLE dbo.Workflows;



/* =====================================================
1. SOURCE CONFIGURATIONS
===================================================== */

CREATE TABLE dbo.Source_configurations
(
    src_id INT IDENTITY(1,1) PRIMARY KEY,
    source_name NVARCHAR(200) NOT NULL,
    source_type NVARCHAR(50) NOT NULL,
    is_enable BIT DEFAULT 1
);



/* =====================================================
2. WORKFLOWS
===================================================== */

CREATE TABLE dbo.Workflows
(
    workflow_id INT IDENTITY(1,1) PRIMARY KEY,
    workflow_name NVARCHAR(200) NOT NULL,
    is_enable BIT NOT NULL DEFAULT 1,
    src_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100),
    modified_at DATETIME2,
    modified_by NVARCHAR(100),

    CONSTRAINT FK_Workflows_Source
    FOREIGN KEY (src_id)
    REFERENCES dbo.Source_configurations(src_id)
);



/* =====================================================
3. SOURCE OBJECTS
===================================================== */

CREATE TABLE dbo.Source_objects
(
    src_obj_id INT IDENTITY(1,1) PRIMARY KEY,
    src_id INT NOT NULL,
    object_name NVARCHAR(200) NOT NULL,
    load_type NVARCHAR(50),
    watermark_column NVARCHAR(100),
    watermark_value NVARCHAR(100),
    is_enable BIT DEFAULT 1,

    CONSTRAINT FK_SourceObjects_Source
    FOREIGN KEY (src_id)
    REFERENCES dbo.Source_configurations(src_id)
);



/* =====================================================
4. TRANSFORMATIONS
===================================================== */

CREATE TABLE dbo.Transformations
(
    transform_id INT IDENTITY(1,1) PRIMARY KEY,
    workflow_id INT NOT NULL,
    step_order INT NOT NULL,
    transform_name NVARCHAR(200) NOT NULL,
    is_enable BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    created_by NVARCHAR(100),
    modified_at DATETIME2,
    modified_by NVARCHAR(100),

    CONSTRAINT FK_Transformations_Workflow
    FOREIGN KEY (workflow_id)
    REFERENCES dbo.Workflows(workflow_id),

    CONSTRAINT UQ_Workflow_Step UNIQUE (workflow_id, step_order)
);



/* =====================================================
5. BATCHES
===================================================== */

CREATE TABLE dbo.Batches
(
    batch_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    batch_date DATE NOT NULL,
    status NVARCHAR(20) NOT NULL,
    start_time DATETIME2,
    end_time DATETIME2,
    created_time DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT CK_Batch_Status
    CHECK (status IN ('RUNNING','SUCCESS','FAILED'))
);



/* =====================================================
6. BRONZE RUNS
===================================================== */

CREATE TABLE dbo.Bronze_runs
(
    bronze_run_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    batch_id BIGINT NOT NULL,
    src_obj_id INT NOT NULL,
    status NVARCHAR(20),
    rows_ingested BIGINT,
    start_time DATETIME2,
    end_time DATETIME2,

    CONSTRAINT FK_BronzeRuns_Batch
    FOREIGN KEY (batch_id)
    REFERENCES dbo.Batches(batch_id),

    CONSTRAINT FK_BronzeRuns_SourceObject
    FOREIGN KEY (src_obj_id)
    REFERENCES dbo.Source_objects(src_obj_id),

    CONSTRAINT UQ_BronzeRun UNIQUE (batch_id, src_obj_id)
);



/* =====================================================
7. WORKFLOW OPERATIONS (NO FK)
===================================================== */

CREATE TABLE dbo.WorkflowOperations
(
    WID BIGINT IDENTITY(1,1) PRIMARY KEY,
    workflow_id INT NOT NULL,
    batch_id BIGINT,
    status NVARCHAR(20) NOT NULL,
    message NVARCHAR(MAX),
    message_error NVARCHAR(MAX),
    created_time DATETIME2 DEFAULT GETDATE(),
    start_time DATETIME2,
    end_time DATETIME2,
    caller NVARCHAR(100)
);



/* =====================================================
8. TRANSFORMATION OPERATIONS (NO FK)
===================================================== */

CREATE TABLE dbo.TransformationOperations
(
    TID BIGINT IDENTITY(1,1) PRIMARY KEY,
    WID BIGINT NOT NULL,
    transform_id INT NOT NULL,
    status NVARCHAR(20) NOT NULL,
    message NVARCHAR(MAX),
    message_error NVARCHAR(MAX),
    created_time DATETIME2 DEFAULT GETDATE(),
    start_time DATETIME2,
    end_time DATETIME2
);



/* =====================================================
INDEXES
===================================================== */

CREATE INDEX IX_WorkflowOperations_Workflow
ON dbo.WorkflowOperations(workflow_id, created_time DESC);

CREATE INDEX IX_WorkflowOperations_Batch
ON dbo.WorkflowOperations(batch_id);

CREATE INDEX IX_TransformationOperations_WID
ON dbo.TransformationOperations(WID);

CREATE INDEX IX_TransformationOperations_Transform
ON dbo.TransformationOperations(transform_id);

CREATE INDEX IX_Batches_Date
ON dbo.Batches(batch_date);

CREATE INDEX IX_BronzeRuns_Batch
ON dbo.Bronze_runs(batch_id);

CREATE INDEX IX_BronzeRuns_SourceObject
ON dbo.Bronze_runs(src_obj_id);

CREATE INDEX IX_SourceObjects_Source
ON dbo.Source_objects(src_id);

/* =====================================================
1. SOURCE CONFIGURATIONS
===================================================== */

INSERT INTO dbo.Source_configurations (source_name, source_type)
VALUES 
('tickit', 'sql db'),
('salesforce', 'api');


/* =====================================================
2. WORKFLOWS
===================================================== */

INSERT INTO dbo.Workflows (workflow_name, src_id, created_by)
VALUES
('tickit_data_pipeline', 1, 'system'),
('salesforce_pipeline', 2, 'system');


/* =====================================================
3. SOURCE OBJECTS
===================================================== */

INSERT INTO dbo.Source_objects (src_id, object_name, load_type, watermark_column)
VALUES
(1,'users','incremental','updated_at'),
(1,'event','incremental','updated_at'),
(1,'sale','incremental','updated_at'),
(1,'listing','incremental','updated_at'),
(1,'date','incremental','updated_at'),
(1,'venue','incremental','updated_at'),
(1,'category','incremental','updated_at'),
(2,'accounts','full',NULL),
(2,'opportunities','incremental','last_modified');


/* =====================================================
4. TRANSFORMATIONS
===================================================== */

INSERT INTO dbo.Transformations (workflow_id, step_order, transform_name, created_by)
VALUES
-- tickit
(1,1,'Ingest Source to Bronze','system'),
(1,2,'Transform Bronze to Silver','system'),
(1,3,'Transform Silver to Gold','system'),

-- salesforce
(2,1,'Ingest API to Bronze','system'),
(2,2,'Transform Bronze to Silver','system');


/* =====================================================
5. BATCHES
===================================================== */

INSERT INTO dbo.Batches (batch_date, status, start_time, end_time)
VALUES
-- completed success batch
(CAST(GETDATE()-1 AS DATE), 'SUCCESS', DATEADD(HOUR,-26,GETDATE()), DATEADD(HOUR,-25,GETDATE())),

-- failed batch
(CAST(GETDATE() AS DATE), 'FAILED', DATEADD(HOUR,-2,GETDATE()), DATEADD(HOUR,-1,GETDATE())),

-- running batch
(CAST(GETDATE() AS DATE), 'RUNNING', DATEADD(MINUTE,-10,GETDATE()), NULL);



/* =====================================================
6. BRONZE RUNS
===================================================== */

-- Batch 1 (SUCCESS)
INSERT INTO dbo.Bronze_runs (batch_id, src_obj_id, status, rows_ingested, start_time, end_time)
VALUES
(1,1,'SUCCESS',1000,DATEADD(HOUR,-26,GETDATE()),DATEADD(HOUR,-25,GETDATE())),
(1,2,'SUCCESS',2000,DATEADD(HOUR,-26,GETDATE()),DATEADD(HOUR,-25,GETDATE())),
(1,3,'SUCCESS',1500,DATEADD(HOUR,-26,GETDATE()),DATEADD(HOUR,-25,GETDATE())),
(1,4,'SUCCESS',1200,DATEADD(HOUR,-26,GETDATE()),DATEADD(HOUR,-25,GETDATE()));

-- Batch 2 (FAILED)
INSERT INTO dbo.Bronze_runs (batch_id, src_obj_id, status, rows_ingested, start_time, end_time)
VALUES
(2,1,'SUCCESS',1100,DATEADD(HOUR,-2,GETDATE()),DATEADD(HOUR,-1,GETDATE())),
(2,2,'FAILED',NULL,DATEADD(HOUR,-2,GETDATE()),DATEADD(HOUR,-1,GETDATE()));

-- Batch 3 (RUNNING)
INSERT INTO dbo.Bronze_runs (batch_id, src_obj_id, status, start_time)
VALUES
(3,1,'RUNNING',DATEADD(MINUTE,-10,GETDATE())),
(3,2,'RUNNING',DATEADD(MINUTE,-10,GETDATE()));



/* =====================================================
7. WORKFLOW OPERATIONS
===================================================== */

-- SUCCESS run
INSERT INTO dbo.WorkflowOperations
(workflow_id, batch_id, status, message, created_time, start_time, end_time, caller)
VALUES
(1,1,'SUCCESS','Tickit pipeline completed',
 DATEADD(HOUR,-26,GETDATE()),
 DATEADD(HOUR,-26,GETDATE()),
 DATEADD(HOUR,-25,GETDATE()),
 'scheduler');

-- FAILED run
INSERT INTO dbo.WorkflowOperations
(workflow_id, batch_id, status, message, message_error, created_time, start_time, end_time, caller)
VALUES
(1,2,'FAILED','Pipeline failed','Silver step failed',
 DATEADD(HOUR,-2,GETDATE()),
 DATEADD(HOUR,-2,GETDATE()),
 DATEADD(HOUR,-1,GETDATE()),
 'scheduler');

-- RUNNING
INSERT INTO dbo.WorkflowOperations
(workflow_id, batch_id, status, message, created_time, start_time, caller)
VALUES
(1,3,'RUNNING','Pipeline running',
 GETDATE(),
 DATEADD(MINUTE,-10,GETDATE()),
 'scheduler');



/* =====================================================
8. TRANSFORMATION OPERATIONS
===================================================== */

-- SUCCESS FLOW (WID = 1)
INSERT INTO dbo.TransformationOperations
(WID, transform_id, status, message, start_time, end_time)
VALUES
(1,1,'SUCCESS','Bronze done',DATEADD(HOUR,-26,GETDATE()),DATEADD(HOUR,-25,GETDATE())),
(1,2,'SUCCESS','Silver done',DATEADD(HOUR,-25,GETDATE()),DATEADD(HOUR,-25,GETDATE())),
(1,3,'SUCCESS','Gold done',DATEADD(HOUR,-25,GETDATE()),DATEADD(HOUR,-25,GETDATE()));

-- FAILED FLOW (WID = 2)
INSERT INTO dbo.TransformationOperations
(WID, transform_id, status, message, message_error, start_time, end_time)
VALUES
(2,1,'SUCCESS','Bronze done',NULL,DATEADD(HOUR,-2,GETDATE()),DATEADD(HOUR,-1,GETDATE())),
(2,2,'FAILED','Transform error','PK violation',
 DATEADD(HOUR,-2,GETDATE()),DATEADD(HOUR,-1,GETDATE()));

-- RUNNING FLOW (WID = 3)
INSERT INTO dbo.TransformationOperations
(WID, transform_id, status, message, start_time)
VALUES
(3,1,'RUNNING','Bronze loading',DATEADD(MINUTE,-10,GETDATE()));