


go
create or alter procedure sp_insertTipoDocumento
    @abreviatura varchar(10),
    @nombre varchar(100)
as
begin
    insert into tipoDocumento (abreviatura,nombre)
    values (@abreviatura,@nombre);

    select SCOPE_IDENTITY() as idTipoDocumento;
end
go


exec sp_insertTipoDocumento 'CC', 'Cédula de Ciudadanía';