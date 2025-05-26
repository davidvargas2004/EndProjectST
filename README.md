# EndProjectST
Ultima actualización para el proyecto final de Sistemas Transaccionales 




*USTED DEBE DE HACER LO SIGUIENTE*

Tablas:
1.	rolUniversitario
2.	descuentoRolUniversitario
3.	tipoDocumento
4.	cliente
5.	restaurante
6.	disponibilidadRestaurante
7.	opcionPago
8.	metodoPagoRestaurante
9.	categoriaProducto
10.	producto
11.	disponibilidadProducto
12.	precioProducto
13.	estadoServicio
SP, Triggers y Funciones por tabla:
•	rolUniversitario
o	SP: sp_insertRol, sp_updateRol, sp_deleteRol
o	Función: fn_getNombreRol(@id INT)
•	descuentoRolUniversitario
o	SP: sp_insertDescuentoRol, sp_updateDescuentoRol
o	Trigger: Validar que fechaInicio < fechaFin y que porcentajeDescuento <= 100
o	Función: fn_getDescuentoVigente(@idRol INT, @fecha DATE)
•	tipoDocumento
o	SP: sp_insertTipoDocumento, sp_updateTipoDocumento, sp_deleteTipoDocumento
•	cliente
o	SP: sp_insertCliente, sp_updateCliente, sp_deleteCliente
o	Función: fn_getClientePorDocumento(@nui VARCHAR)
•	restaurante
o	SP: sp_insertRestaurante, sp_updateRestaurante
o	Función: fn_getRestaurante(@id INT)
•	disponibilidadRestaurante
o	SP: sp_insertDisponibilidadRestaurante, sp_updateDisponibilidadRestaurante
•	opcionPago
o	SP: sp_insertOpcionPago, sp_updateOpcionPago, sp_deleteOpcionPago
•	metodoPagoRestaurante
o	SP: sp_insertMetodoPagoRestaurante, sp_updateMetodoPagoRestaurante
o	Función: fn_getMetodosPagoRestaurante(@idRestaurante INT)
•	categoriaProducto
o	SP: sp_insertCategoriaProducto, sp_updateCategoriaProducto
o	Trigger: Validar que horaInicio < horaFin
•	producto
o	SP: sp_insertProducto, sp_updateProducto
o	Función: fn_getProductosRestaurante(@idRestaurante INT)
•	disponibilidadProducto
o	SP: sp_insertDisponibilidadProducto, sp_updateDisponibilidadProducto
•	precioProducto
o	SP: sp_insertPrecioProducto
o	Trigger: Establecer automáticamente estado = 0 para precios antiguos del mismo producto
o	Función: fn_getPrecioActual(@idProducto INT)
•	estadoServicio
o	SP: sp_insertEstadoServicio, sp_updateEstadoServicio