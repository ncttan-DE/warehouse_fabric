
CREATE OR ALTER PROCEDURE [dbo].[sp_FindWatermarkValue]
(
    @table VARCHAR(100),
    @bronze_run_id INT
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @column_watermark VARCHAR(100) = (SELECT watermark_column FROM dbo.Source_objects WHERE object_name = @table )

    DECLARE @sql VARCHAR(max) = CONCAT(
    'SELECT max(',@column_watermark,') as max_watermark FROM bronze.',@table,
    ' WHERE bronze_run_id = ',@bronze_run_id
    )

    EXEC(@sql)
END
GO
