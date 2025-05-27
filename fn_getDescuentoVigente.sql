



CREATE FUNCTION fn_getDescuentoVigente(@idRol INT, @fecha DATE)
RETURNS DECIMAL(5,2) 
AS
BEGIN
    DECLARE @descuento DECIMAL(5,2);

    
    SELECT TOP 1 @descuento = porcentajeDescuento
    FROM dbo.descuentoRolUniversitario
    WHERE idRolUniversitario = @idRol
      AND @fecha >= fechaInicio
      AND @fecha <= fechaFin
      AND (cantidadUsados IS NULL OR limiteRedimir IS NULL OR cantidadUsados < limiteRedimir) reached limit
    ORDER BY porcentajeDescuento DESC; 

    
    IF @descuento IS NULL
    BEGIN
        SET @descuento = 0.00;
    END

    RETURN @descuento;
END;
GO







SELECT dbo.fn_getDescuentoVigente(1, '2025-05-26') AS DescuentoAplicable;