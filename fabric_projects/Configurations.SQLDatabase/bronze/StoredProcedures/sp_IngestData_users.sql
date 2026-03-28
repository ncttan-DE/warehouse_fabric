CREATE PROCEDURE bronze.sp_IngestData_users
    @data bronze.usersTableType READONLY,
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO bronze.users (
        userid, username, firstname, lastname, city, [state], email, phone,
        likesports, liketheatre, likeconcerts, likejazz, likeclassical,
        likeopera, likerock, likevegas, likebroadway, likemusicals,
        bronze_run_id
    )
    SELECT 
        userid, username, firstname, lastname, city, [state], email, phone,
        likesports, liketheatre, likeconcerts, likejazz, likeclassical,
        likeopera, likerock, likevegas, likebroadway, likemusicals,
        @bronze_run_id
    FROM @data;
END

GO

