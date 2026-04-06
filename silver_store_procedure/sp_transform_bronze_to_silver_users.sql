CREATE OR ALTER PROCEDURE silver.sp_transform_bronze_to_silver_users
    @bronze_run_id INT
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Step 1: Extract + hash
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_users_hash;

    SELECT 
        userid,
        username,
        firstname,
        lastname,
        city,
        [state],
        email,
        phone,
        likesports,
        liketheatre,
        likeconcerts,
        likejazz,
        likeclassical,
        likeopera,
        likerock,
        likevegas,
        likebroadway,
        likemusicals,
        HASHBYTES(
            'SHA2_256',
            CONCAT(
                ISNULL(username,''),'|',
                ISNULL(firstname,''),'|',
                ISNULL(lastname,''),'|',
                ISNULL(email,''),'|',
                ISNULL(phone,'')
            )
        ) AS hash_value
    INTO #temp_users_hash
    FROM bronze.users
    WHERE bronze_run_id = @bronze_run_id;


    ------------------------------------------------------------------
    -- Step 2: Deduplicate
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_users_hash_rn;

    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY hash_value 
            ORDER BY userid DESC
        ) AS rn
    INTO #temp_users_hash_rn
    FROM #temp_users_hash;


    ------------------------------------------------------------------
    -- Step 3: Latest per userid
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS #temp_users_hash_latest;

    SELECT 
        userid,
        MAX(hash_value) AS max_hash_value
    INTO #temp_users_hash_latest
    FROM #temp_users_hash_rn
    WHERE rn = 1
    GROUP BY userid;


    ------------------------------------------------------------------
    -- Step 4: MERGE (NO DELETE)
    ------------------------------------------------------------------
    MERGE silver.users AS dest
    USING (
        SELECT s.*
        FROM #temp_users_hash_latest latest
        INNER JOIN #temp_users_hash_rn s 
            ON s.userid = latest.userid
            AND s.hash_value = latest.max_hash_value
            AND s.rn = 1
    ) AS src
    ON dest.userid = src.userid

    WHEN MATCHED 
        AND dest.hash_value <> src.hash_value THEN
        UPDATE SET 
            username = src.username,
            firstname = src.firstname,
            lastname = src.lastname,
            email = src.email,
            phone = src.phone

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            userid, username, firstname, lastname,
            city, [state], email, phone,
            likesports, liketheatre, likeconcerts,
            likejazz, likeclassical, likeopera,
            likerock, likevegas, likebroadway,
            likemusicals, hash_value
        )
        VALUES (
            src.userid, src.username, src.firstname, src.lastname,
            src.city, src.[state], src.email, src.phone,
            src.likesports, src.liketheatre, src.likeconcerts,
            src.likejazz, src.likeclassical, src.likeopera,
            src.likerock, src.likevegas, src.likebroadway,
            src.likemusicals, src.hash_value
        );

END
GO