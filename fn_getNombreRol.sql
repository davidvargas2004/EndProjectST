CREATE FUNCTION fn_getNombreRol(@id INT)
RETURNS VARCHAR(250)
AS
BEGIN
    DECLARE @nombreRol VARCHAR(250);

    SELECT @nombreRol = nombre
    FROM rolUniversitario
    WHERE id = @id;

    RETURN @nombreRol;
END;
GO

SELECT dbo.fn_getNombreRol(1) AS NombreRol;