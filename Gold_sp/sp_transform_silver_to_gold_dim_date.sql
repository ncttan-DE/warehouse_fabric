SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_dim_date]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO gold.dim_date (
        date_key, caldate, day, week, month, qtr, year, holiday
    )
    SELECT 
        s.dateid, s.caldate, s.day, s.week,
        s.month, s.qtr, s.year, s.holiday
    FROM silver.[date] s
    LEFT JOIN gold.dim_date g
        ON s.dateid = g.date_key
    WHERE g.date_key IS NULL;

END;
GO
