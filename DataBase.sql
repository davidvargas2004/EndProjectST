use master;
go

drop database if exists lunch_Uniminuto;
go

create database lunch_Uniminuto;
go 

use lunch_Uniminuto;
go

-- definir si es estudiante o otra profesion en la U
create table rolUniversitario (
    id int identity(1,1) primary key,
    nombre varchar(250) not null
);

-- definir los diferentes descuentos que tendran
create table descuentoRolUniversitario (
    id int identity(1,1) primary key,
    idRolUniversitario int not null,
    fechaRegistrada datetime2 not null, -- fechaCreacion
    porcentajeDescuento decimal(5,2) not null, -- porcentaje de descuento en formato (100,00 %)
    fechaInicio date not null,
    fechaFin date not null,
    limiteRedimir int, -- para definir el cupo limite
    cantidadUsados int, -- para definir cuantos ya se han usado
    constraint fk_descuentoRolUniversitario_rolUniversitario
        foreign key (idRolUniversitario) references rolUniversitario(id)
)

-- tipo de documento que tendra el cliente (cc, ti, pep, etc...)
create table tipoDocumento (
    id int identity(1,1) primary key,
    abreviatura varchar(10) not null,
    nombre varchar(100) not null
);

-- datos central de la base de datos los clientes
create table cliente (
    id int identity(1,1) primary key,
    idTipoDocumento int not null,
    nui varchar(15) not null, -- Nº de identificacion del documento del cliente
    nombres varchar(250) not null,
    nCelular varchar(10) not null,
    email varchar(250) not null,
    direccionResidencia varchar(250),
    idRolCliente int not null,
    constraint fk_cliente_tipoDocumento
        foreign key (idTipoDocumento) references tipoDocumento(id),
    constraint fk_cliente_rolUniversitario
        foreign key (idRolCliente) references rolUniversitario(id)
);

-- datos del restaurante
create table restaurante (
    id int identity(1,1) primary key,
    nit varchar(15) not null, -- nº de identificacion del documento del restaurante
    razonSocial varchar(250) not null, -- nombre del restaurante
    nCelular varchar(10) not null,
    email varchar(250) not null,
    direccion varchar(250) not null
);

-- recurso para saber sus dias de funcionamiento normal...
create table disponibilidadRestaurante (
    idRestaurante int not null,
    dia int not null,-- los dias de la semana enumerados del 1 al 7, iniciando a partir del lunes=1
    estado bit not null,-- 0 = NO_LABORA y 1 = LABORA
    horaInicio time,-- en caso de que 'LABORA' indicar hora inicio jornada de atencion
    horaFin time,-- en caso de que 'LABORA' indicar hora fin jornada de atencion
    constraint fk_disponibilidadRestaurante_restaurante 
        foreign key (idRestaurante) references restaurante(id),
    constraint chk_diaDisponibilidad
        check (dia between 1 and 7)
);

-- diferentes alternativas de pago, informacion que tendran cada restaurante como alternativa a seleccionar
create table opcionPago (
    id int identity(1,1) primary key,
    nombre varchar(250) not null
);

-- se indicara cuales seran los metodos de pago para cada restaurante, TENER CUIDADO CON EL MANEJO DE LA LLAVE PRIMARIA COMPUESTA
create table metodoPagoRestaurante (
    idRestaurante int not null,
    idOpcionPago int not null,
    descripcion varchar(250) not null,-- por ejemplo si la opcion de pago hacer referencia a PSE adjuntar el hipervinculo para redireccionar al cliente para efectuar el pago
    constraint pk_metodoPagoRestaurante
        primary key (idRestaurante, idOpcionPago),
    constraint fk_metodoPagoRestaurante_restaurante 
        foreign key (idRestaurante) references restaurante(id),
    constraint fk_metodoPagoRestaurante_opcionPago 
        foreign key (idOpcionPago) references opcionPago(id)
);

-- definir la categoria (desayunos, almuerzos, comidas, onces, etc...), con sus respectivas franjas de tiempo
create table categoriaProducto (
    id int identity(1,1) primary key,
    nombre varchar(100) not null,
    horaInicio time not null,
    horaFin time not null,
    descripcion varchar(250) not null
);

-- las diferentes mercancias que vendera cada restaurante...
create table producto (
    id int identity(1,1) primary key,
    idRestaurante int not null,
    nombre varchar(100) not null,
    descripcion varchar(250) not null,
    tipoProducto bit not null,-- 0 = comida y 1 = bebida
    idCategoria int not null,
    constraint fk_producto_restaurante
        foreign key (idRestaurante) references restaurante(id),
    constraint fk_producto_categoriaProducto
        foreign key (idCategoria) references categoriaProducto(id)
);

-- definir en que dias se dispondran para la venta de dicho producto
create table disponibilidadProducto (
    idProducto int not null,
    dia int not null,-- los dias de la semana enumerados del 1 al 7, iniciando a partir del lunes=1
    estado bit not null,-- 0 = NO_VENTA y 1 = VENTA
    constraint fk_disponibilidadProducto_producto
        foreign key (idProducto) references producto(id),
    constraint chk_diaDisponibilidadProducto
        check (dia between 1 and 7)
);

-- definir el cobro preciso del producto
create table precioProducto (
    id int identity(1,1) primary key,
    idProducto int not null,
    fechaRegistrada datetime2 not null,
    precio decimal(18,2) not null,
    estado bit not null,-- 0 = NO_USO y 1 = USO
    constraint fk_precioProducto_producto
        foreign key (idProducto) references producto(id)

);

-- definir los diferentes estados que tendran las ordenes de servicio (preparando, en camino, entregado, cancelado, etc...)
create table estadoServicio (
    id int identity(1,1) primary key,
    nombre varchar(100) not null,
    descripcion varchar(250) not null
);

-- Manejo de una orden del cliente
create table ordenServicio (
    id int identity(1,1) primary key,
    idCliente int not null,
    idRestaurante int not null,
    idOpcionPago int not null, -- tener cuidado con esta llave, pues debera ser de la llave principal compuesta de la tabla metodoPagoRestaurante
    idDescuentoRol int, -- trigger manejara esta accion de asignar el descuento correspondiente...
    idEstadoServicio int, -- definir inicialmente el estado de servicio (preparando...) por defecto
    fechaCompra  datetime2 not null,-- fecha en la que ordena
    fechaEntrega datetime2 not null,-- fecha en la que planeaa recibir la ordenServicio (Limite de 1 dia de diferencia)
    direccionDomicilio varchar(250) not null,-- Importante indicar donde desea recibir el pedido...
    abono decimal(18,2),-- Trigger manejara este dato, consultando los saldos que tiene el cliente debido a modificaciones en sistema...
    subtotal decimal(18,2),-- Trigger manejara este dato, consultado en detallesOrdenServicio todos los listados de productos comprados...
    total decimal(18,2),-- Trigger manejara este dato aplicando el descuento que tiene vinculado, abono de los saldos a el subtotal a cobrar...
    estadoPago bit not null,
    constraint fk_ordenServicio_cliente
        foreign key (idCliente) references cliente(id),
    constraint fk_ordenServicio_restaurante
        foreign key (idRestaurante) references restaurante(id),
    constraint fk_ordenServicio_metodoPago
        foreign key (idRestaurante, idOpcionPago) references metodoPagoRestaurante(idRestaurante, idOpcionPago),
    constraint fk_ordenServicio_descuentoRol
        foreign key (idDescuentoRol) references descuentoRolUniversitario(id),
    constraint fk_ordenServicio_estadoServicio
        foreign key (idEstadoServicio) references estadoServicio(id)    
);

-- Maneja todos los pagos/abonos efectuados por el cliente a una orden de servicio...
create table pago (
    idOrdenServicio int not null,
    fechaRegistrada datetime2 not null,
    valorEfectuado decimal(18,2) not null,
    constraint fk_pago_ordenServicio
        foreign key (idOrdenServicio) references ordenServicio(id)
);

-- definicion de todas las compras que realiza un cliente en una orden de servicio... 
create table detallesOrdenServicio (
    idOrdenServicio int not null,
    idProducto int not null,
    idPrecioProducto int not null,
    cantidad int not null,
    subTotal decimal(18,2),-- trigger ejecuta esta informacion 
    constraint fk_detallesOrdenServicio_ordenServicio
        foreign key (idOrdenServicio) references ordenServicio(id),
    constraint fk_detallesOrdenServicio_producto
        foreign key (idProducto) references producto(id),
    constraint fk_detallesOrdenServicio_precioProducto
        foreign key (idPrecioProducto) references precioProducto(id)
);

-- tabla para manejar saldos de los clientes y/o restaurantes
create table saldo (
    id int identity(1,1) primary key,
    idCliente int,
    idRestaurante int,
    saldoTotal decimal(18,2),
    constraint fk_saldo_cliente 
        foreign key (idCliente) references cliente(id),    
    constraint fk_saldo_restaurante 
        foreign key (idRestaurante) references restaurante(id),
    constraint chk_saldo_unico_cliente_restaurante
        check (
            (idCliente is not null and idRestaurante is null) or 
            (idCliente is null and idRestaurante is not null))
);

-- Tabla para manejar los saldos unitarios que tienen dependiendo si son modificaciones internas en la base de datos, o abonos que realizara el cliente para manejar dinero en la base de datos
create table saldosUnitarios (
    idSaldo int identity(1,1) primary key,
    fechaRegistrada datetime2 not null,
    subSaldo decimal(18,2) not null,
    tipoMovimiento varchar(250), -- Trigger manejara este dato, definiendo si la consignacion realizada es por parte de una transaccion del sistema o abono del cliente...
    constraint fk_saldosUnitarios_saldo
        foreign key (idSaldo) references saldo(id)
);