CREATE PROCEDURE dbo.select_sotr
    @SortBy NVARCHAR(50) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Dep NVARCHAR(50) = NULL,
    @Post NVARCHAR(50) = NULL,
    @LastNamePart NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.last_name + ' ' + LEFT(p.first_name,1) + '. ' + LEFT(p.second_name,1) + '.' AS ���,
        s.name AS ������,
        d.name AS �����,
        po.name AS ���������,
        p.date_employ AS ����_����������,
        p.date_uneploy AS ����_����������
    FROM dbo.persons p
    JOIN dbo.status s ON p.status = s.id
    JOIN dbo.deps d ON p.id_dep = d.id
    JOIN dbo.posts po ON p.id_post = po.id
    WHERE
        (@Status IS NULL OR s.name = @Status) AND
        (@Dep IS NULL OR d.name = @Dep) AND
        (@Post IS NULL OR po.name = @Post) AND
        (@LastNamePart IS NULL OR p.last_name LIKE '%' + @LastNamePart + '%')
    ORDER BY
        CASE WHEN @SortBy = N'���' THEN p.last_name END,
        CASE WHEN @SortBy = N'������' THEN s.name END,
        CASE WHEN @SortBy = N'�����' THEN d.name END,
        CASE WHEN @SortBy = N'���������' THEN po.name END,
        CASE WHEN @SortBy = N'���� �����' THEN p.date_employ END,
        CASE WHEN @SortBy = N'���� ����������' THEN p.date_uneploy END;
END
GO

select * from posts;

EXEC dbo.select_sotr;