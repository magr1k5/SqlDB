ALTER PROCEDURE dbo.select_sotr
    @SortBy NVARCHAR(50) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Dep NVARCHAR(50) = NULL,
    @Post NVARCHAR(50) = NULL,
    @LastNamePart NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.last_name + ' ' + LEFT(p.first_name,1) + '. ' + LEFT(p.second_name,1) + '.' AS ФИО,
        s.name AS Статус,
        d.name AS Отдел,
        po.name AS Должность,
        p.date_employ AS Дата_Зачисления,
        p.date_uneploy AS Дата_Увольнения
    FROM dbo.persons p
    JOIN dbo.status s ON p.status = s.id
    JOIN dbo.deps d ON p.id_dep = d.id
    JOIN dbo.posts po ON p.id_post = po.id
    WHERE
        (@Status IS NULL OR s.name = @Status) AND
        (@Dep IS NULL OR d.name = @Dep) AND
        (@Post IS NULL OR po.name = @Post) AND
        (
            @LastNamePart IS NULL OR
            p.last_name LIKE '%' + @LastNamePart + '%' OR
            p.first_name LIKE '%' + @LastNamePart + '%' OR
            p.second_name LIKE '%' + @LastNamePart + '%' OR
            (p.last_name + ' ' + p.first_name + ' ' + p.second_name) LIKE '%' + @LastNamePart + '%' OR
            d.name LIKE '%' + @LastNamePart + '%' OR
            po.name LIKE '%' + @LastNamePart + '%'
        )
    ORDER BY
        CASE WHEN @SortBy = N'ФИО' THEN p.last_name END,
        CASE WHEN @SortBy = N'Статус' THEN s.name END,
        CASE WHEN @SortBy = N'Отдел' THEN d.name END,
        CASE WHEN @SortBy = N'Должность' THEN po.name END,
        CASE WHEN @SortBy = N'Дата приёма' THEN p.date_employ END,
        CASE WHEN @SortBy = N'Дата увольнения' THEN p.date_uneploy END;
END
GO

CREATE PROCEDURE dbo.stat_sotr
    @StatusId INT = NULL,
    @DateFrom DATE,
    @DateTo DATE,
    @Mode NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Mode = 'employ'
    BEGIN
        SELECT 
            CAST(p.date_employ AS DATE) AS Дата,
            COUNT(*) AS Количество
        FROM dbo.persons p
        WHERE p.date_employ BETWEEN @DateFrom AND @DateTo
          AND (@StatusId IS NULL OR p.status = @StatusId)
        GROUP BY CAST(p.date_employ AS DATE)
        ORDER BY Дата;
    END
    ELSE IF @Mode = 'uneploy'
    BEGIN
        SELECT 
            CAST(p.date_uneploy AS DATE) AS Дата,
            COUNT(*) AS Количество
        FROM dbo.persons p
        WHERE p.date_uneploy BETWEEN @DateFrom AND @DateTo
          AND (@StatusId IS NULL OR p.status = @StatusId)
        GROUP BY CAST(p.date_uneploy AS DATE)
        ORDER BY Дата;
    END
END
GO

ALTER PROCEDURE dbo.stat_sotr
    @StatusId INT = NULL,
    @DateFrom DATE,
    @DateTo DATE,
    @Mode NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Mode = 'employ'
    BEGIN
        SELECT 
            CAST(p.date_employ AS DATE) AS Дата,
            p.last_name AS Фамилия,
            s.name AS Статус
        FROM dbo.persons p
        JOIN dbo.status s ON p.status = s.id
        WHERE p.date_employ BETWEEN @DateFrom AND @DateTo
          AND (@StatusId IS NULL OR p.status = @StatusId)
        ORDER BY Дата, Фамилия;
    END
    ELSE IF @Mode = 'uneploy'
    BEGIN
        SELECT 
            CAST(p.date_uneploy AS DATE) AS Дата,
            p.last_name AS Фамилия,
            s.name AS Статус
        FROM dbo.persons p
        JOIN dbo.status s ON p.status = s.id
        WHERE p.date_uneploy BETWEEN @DateFrom AND @DateTo
          AND (@StatusId IS NULL OR p.status = @StatusId)
        ORDER BY Дата, Фамилия;
    END
END
GO
