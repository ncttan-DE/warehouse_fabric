
CREATE   PROCEDURE [dbo].[sp_update_watermark_value]
(
    @table VARCHAR(100),
    @bronze_run_id INT,
    @src_obj_id int
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @IS_REQUIRED_UPDATE BIT = (
        SELECT CASE 
            WHEN load_type = 'incremental' THEN 1 
            ELSE 0 
        END
        FROM dbo.Source_objects
        WHERE src_obj_id = @src_obj_id
    );

    DECLARE @sql NVARCHAR(MAX) = '';

    IF (@IS_REQUIRED_UPDATE = 1)
    BEGIN
        DECLARE @column_watermark VARCHAR(100) = (
            SELECT watermark_column
            FROM dbo.Source_objects
            WHERE object_name = @table
        );

        SET @sql = 
            'DECLARE @watermark_value VARCHAR(100); ' +
            'SELECT @watermark_value = MAX(' + @column_watermark + ') ' +
            'FROM bronze.' + @table + ' ' +
            'WHERE bronze_run_id = ' + CAST(@bronze_run_id AS VARCHAR) + '; ' +

            'IF (@watermark_value IS NOT NULL) ' +
            'BEGIN ' +
                'UPDATE dbo.Source_objects ' +
                'SET watermark_value = @watermark_value ' +
                'WHERE src_obj_id = ' + CAST(@src_obj_id AS VARCHAR) + '; ' +
            'END; ';
    END

    -- Final result logic
    SET @sql = @sql +
            'SELECT COUNT(1) AS no_record ' +
            'FROM bronze.' + @table + ' ' +
            'WHERE bronze_run_id = ' + CAST(@bronze_run_id AS VARCHAR);

    EXEC(@sql)
END

GO

