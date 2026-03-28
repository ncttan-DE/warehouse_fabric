
CREATE OR ALTER PROCEDURE [dbo].[sp_update_watermark_value]
(
    @table VARCHAR(100),
    @bronze_run_id INT,
    @src_obj_id int
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @IS_REQUIRED_UPDATE BIT = (SELECT CASE WHEN load_type = 'incremental' THEN 1 ELSE 0 END FROM dbo.Source_objects WHERE src_obj_id = @src_obj_id)

    IF(@IS_REQUIRED_UPDATE = 1)
    BEGIN
        DECLARE @column_watermark VARCHAR(100) = (SELECT watermark_column FROM dbo.Source_objects WHERE object_name = @table )

        /*
        Example: 
        DECLARE @watermark_value VARCHAR(100); 

        SELECT @watermark_value = max(saletime) 
        FROM bronze.sales WHERE bronze_run_id = 11; 
        
        UPDATE dbo.Source_objects 
        SET watermark_value = IIF(TRY_CONVERT(INT, @watermark_value) IS NOT NULL, @watermark_value, '' + @watermark_value + '') 
        WHERE src_obj_id = 3;

        SELECT @watermark_value AS watermark_value
        */

        DECLARE @sql varchar(max) = concat(
        'DECLARE @watermark_value VARCHAR(100); SELECT @watermark_value = max(',@column_watermark,') FROM bronze.',@table,
        ' WHERE bronze_run_id = ',@bronze_run_id
        )

        SET @sql  = CONCAT(@sql, '; UPDATE dbo.Source_objects', ' SET watermark_value = IIF(TRY_CONVERT(INT, @watermark_value) IS NOT NULL, @watermark_value, '''' + @watermark_value + '''')', ' WHERE src_obj_id = ', @src_obj_id)
    END
    
    SET @sql = CONCAT(@sql, '; SELECT  COUNT(1) AS no_record FROM bronze.', @table, ' WHERE bronze_run_id = ', @bronze_run_id)

    EXEC(@sql)
END
GO
