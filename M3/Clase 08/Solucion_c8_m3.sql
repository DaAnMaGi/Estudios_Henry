use henry_3;

### Triggers

# 1 Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta.

drop table if exists usercambios_fact_venta;
create table usercambios_fact_venta (
	IdCambio int primary key not null auto_increment,
    IdVenta int,
    Fecha_Venta date,
    Fecha_Entrega date,
    IdCanal int,
    IdCliente int,
    IdEmpleado int,
    IdProducto int,
    Precio decimal(15,2),
    Cantidad int,
    Fecha_Ingreso date,
    Usuario_Ingreso varchar(50)
	);

# 2 Crear una acción que permita la carga de datos en la tabla anterior.

drop trigger if exists insert_fact_venta;
create trigger insert_fact_venta after insert on fact_venta
	for each row
    insert into usercambios_fact_venta (IdVenta,
										Fecha_Venta,
                                        Fecha_Entrega,
                                        IdCanal,
                                        IdCliente,
                                        IdEmpleado,
                                        IdProducto,
                                        Precio,
                                        Cantidad,
                                        Fecha_Ingreso,
                                        Usuario_ingreso) 
		values (New.IdVenta,
				New.Fecha,
                New.Fecha_Entrega,
                New.IdCanal,
				New.IdCliente,
				New.IdEmpleado,
				New.IdProducto,
				New.Precio,
				New.Cantidad,
                now(),
                current_user()
                );
    
# 3 Crear una tabla que permita registrar la cantidad total registros, luego de cada ingreso la tabla fact_venta.

drop table if exists registros_fact_venta;
create table registros_fact_venta (
	IdRegistro int primary key not null auto_increment,
    IdVenta int,
    Fecha_Registro date,
    Numero_Registros int,
    Usuario varchar(50)
	);

# 4 Crear una acción que permita la carga de datos en la tabla anterior.

drop trigger if exists subir_registros;
create trigger subir_registros after insert on fact_venta
	for each row
    insert into registros_fact_venta (IdVenta,
									Fecha_Registro,
                                    Numero_Registros,
                                    Usuario)
		values (New.IdVenta,
				now(),
				(select count(*) from fact_venta),
                current_user());

# 5 Crear una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de carga de los datos agrupados.

drop table if exists consolidado_insert;
create table consolidado_insert (
	IdConsolidado int primary key not null auto_increment,
    Nombre_tabla varchar(50),
    Fecha_Consolidad date,
    usuario varchar(50)
    );

	# Procedimiento por tabla 
    insert into consolidado_insert (Nombre_Tabla, Fecha_Consolidad, Usuario)
		values ("Ventas",(select count(*) from ventas),now(),current_user());
    insert into consolidado_insert (Nombre_Tabla, Fecha_Consolidad, Usuario)
		values ("Gasto",(select count(*) from gasto),now(),current_user());
    insert into consolidado_insert (Nombre_Tabla, Fecha_Consolidad, Usuario)
		values ("Compra",(select count(*) from cargo),now(),current_user());
        
# 6 Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.

drop table if exists actu_fact_venta;
create table actu_fact_venta (
	IdActualizacion int primary key not null auto_increment,
    IdVenta_Anterior int,
    IdVenta_Nuevo int,
    Fecha_Anterior date,
    Fecha_Nueva date,
    Fecha_Entrega_Anterior date,
    Fecha_Entrega_Nuevo date,
    IdCanal_Anterior int,
    IdCanal_Nuevo int,
    IdCliente_Anterior int,
    IdCliente_Nuevo int,
    IdEmpleado_Anterior int,
    IdEmpleado_Nuevo int,
    IdProducto_Anterior int,
    IdProducto_Nuevo int,
    Precio_Anterior int,
    Precio_Nuevo int,
    Cantidad_Anterior int,
    Cantidad_Nuevo int,
    Fecha_Actualizacion date,
    Usuario_Cambio varchar(50)
    );

# 7 Crear una acción que permita la carga de datos en la tabla anterior, para su actualización.

drop trigger if exists actualizaciones_fact;
create trigger actualizaciones_fact after update on fact_venta
	for each row
    insert into actu_fact_venta (
		IdVenta_Anterior,
		IdVenta_Nuevo,
		Fecha_Anterior,
		Fecha_Nueva,
		Fecha_Entrega_Anterior,
		Fecha_Entrega_Nuevo,
		IdCanal_Anterior,
		IdCanal_Nuevo,
		IdCliente_Anterior,
		IdCliente_Nuevo,
		IdEmpleado_Anterior,
		IdEmpleado_Nuevo,
		IdProducto_Anterior,
		IdProducto_Nuevo,
		Precio_Anterior,
		Precio_Nuevo,
		Cantidad_Anterior,
		Cantidad_Nuevo,
		Fecha_Actualizacion,
		Usuario_Cambio
		)
    values (
		old.IdVenta,
		new.IdVenta,
		old.Fecha,
		new.Fecha,
		old.Fecha_Entrega,
		new.Fecha_Entrega,
		old.IdCanal,
		new.IdCanal,
		old.IdCliente,
		new.IdCliente,
		old.IdEmpleado,
		new.IdEmpleado,
		old.IdProducto,
		new.IdProducto,
		old.Precio,
		new.Precio,
		old.Cantidad,
		new.Cantidad,
		now(),
		current_user()
		);

### Carga Incremental
# En este punto, ya contamos con toda la información de los datasets originales cargada en el DataWarehouse diseñado. Sin embargo, la gerencia, requiere la posibilidad de evaluar agregar a esa información la operatoria diara comenzando por la información de Ventas. Para lo cual, en la carpeta "Carga_Incremental" se disponibilizaron los archivos:
	# Ventas_Actualizado.csv: Tiene una estructura idéntica al original, pero con los registros del día 01/01/2021.
	# Clientes_Actializado.csv: Tiena una estructura idéntica al original, pero actualizado al día 01/01/2021.
    


# Es necesario diseñar un proceso que permita ingestar al DataWarehouse las novedades diarias, tanto de la tabla de ventas como de la tabla de clientes. Se debe tener en cuenta, que dichas fuentes actualizadas, contienen la información original más las novedades, por lo tanto, en la tabla de "ventas" es necesario identificar qué registros son nuevos y cuales ya estaban cargados anteriormente, y en la tabla de clientes tambien, con el agregado de que en ésta última, pueden haber además registros modificados, con lo que hay que hacer uso de los campos de auditoría de esa tabla, por ejemplo, Fecha_Modificación.