SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [gold].[sp_transform_silver_to_gold_dim_user]
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- STEP 1: INSERT NEW
    ------------------------------------------------------------------
    INSERT INTO gold.dim_user (
        userid, username, firstname, lastname,
        city, state, email, phone,
        likesports, liketheatre, likeconcerts,
        likejazz, likeclassical, likeopera,
        likerock, likevegas, likebroadway, likemusicals,
        hash_value
    )
    SELECT 
        s.userid, s.username, s.firstname, s.lastname,
        s.city, s.state, s.email, s.phone,
        s.likesports, s.liketheatre, s.likeconcerts,
        s.likejazz, s.likeclassical, s.likeopera,
        s.likerock, s.likevegas, s.likebroadway, s.likemusicals,
        s.hash_value
    FROM silver.users s
    LEFT JOIN gold.dim_user g
        ON s.userid = g.userid
    WHERE g.userid IS NULL;

    ------------------------------------------------------------------
    -- STEP 2: UPDATE CHANGED
    ------------------------------------------------------------------
    UPDATE g
    SET 
        g.username = s.username,
        g.firstname = s.firstname,
        g.lastname = s.lastname,
        g.city = s.city,
        g.state = s.state,
        g.email = s.email,
        g.phone = s.phone,
        g.likesports = s.likesports,
        g.liketheatre = s.liketheatre,
        g.likeconcerts = s.likeconcerts,
        g.likejazz = s.likejazz,
        g.likeclassical = s.likeclassical,
        g.likeopera = s.likeopera,
        g.likerock = s.likerock,
        g.likevegas = s.likevegas,
        g.likebroadway = s.likebroadway,
        g.likemusicals = s.likemusicals,
        g.hash_value = s.hash_value
    FROM gold.dim_user g
    JOIN silver.users s
        ON g.userid = s.userid
    WHERE g.hash_value <> s.hash_value;

END;
GO
