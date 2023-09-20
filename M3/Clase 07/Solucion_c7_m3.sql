use henry_3;

# 1) Genere 5 consultas simples con alguna función de agregación y filtrado sobre las tablas. Anote los resultados del la ficha de estadísticas.
	# Consulta 1
    select 
		b.Descripcion as canal,
        sum(a.Precio) as ventas_canal
        from venta a
        join canalventa b
			on (a.IdCanal = b.IdCanal)
		where year(fecha) = 2017
        group by canal
        order by canal; -- 0.313 sec / 0.000 sec
    
    # Consulta 2
    select 
		Provincia as Provincia,
        count(a.IdVenta) as N_Ventas
		from venta a
        join clientes b
			on (a.IdCliente = b.IdCliente)
		join localidad c
			on (b.IdLocalidad = c.IdLocalidad)
		join provincia d
			on (d.IdProvincia = c.IdProvincia)
		where year(fecha) = 2017
        group by Provincia
        order by Provincia; -- 0.359 sec / 0.000 sec

    # Consulta 3
	select 
		b.Sucursal as sucursal,
		sum(a.Precio) as Ventas
		from venta a
		join sucursales b
			on (a.IdSucursal = b.IdSucursal)
		where year(fecha) = 2017
		group by sucursal
		order by Ventas DESC; -- 0.265 sec / 0.000 sec
            
    # Consulta 4
    select 
		d.Provincia as Provincia,
		b.Sucursal as sucursal,
		sum(a.Precio) as Ventas
		from venta a
		join sucursales b
			on (a.IdSucursal = b.IdSucursal)
		join localidad c
			on (b.IdLocalidad = c.IdLocalidad)
		join provincia d
			on (d.IdProvincia = c.IdProvincia)
        where year(fecha) = 2017
		group by Provincia, sucursal
		order by Ventas DESC; -- 0.313 sec / 0.000 sec
    
    # Consulta 5
    select 
		c.TipoProducto as Tipo_Producto,
        avg(a.Precio) as Promedio_Venta
        from venta a
        join productos b
			on (a.IdProducto = b.IdProducto)
		join tipoproducto c
			on (b.IdTipoProducto = c.IdTipoProducto)
		group by Tipo_Producto
        order by Promedio_Venta; -- 0.578 sec / 0.000 sec
    
# 2) A partir del conjunto de datos elaborado en clases anteriores, genere las PK de cada una de las tablas a partir del campo que cumpla con los requisitos correspondientes.

-- primary key
alter table canalventa add primary key (IdCanal);
alter table cargo add primary key (IdCargo);
alter table clientes add primary key (IdCliente);
alter table compra add primary key (IdCompra);
alter table empleados add primary key (IdEmpleado);
alter table gasto add primary key (IdGasto);
alter table productos add primary key (IdProducto);
alter table proveedores add primary key (IdProveedor);
alter table sucursales add primary key (IdSucursal);
alter table tipogasto add primary key (IdTipoGasto);
alter table venta add primary key (IdVenta);

-- foreign key 
alter table clientes add constraint clientes_localidad foreign key (IdLocalidad) references localidad(IdLocalidad) on delete restrict on update restrict;

alter table compra add constraint compra_producto foreign key (IdProducto) references productos(IdProducto) on delete restrict on update restrict;
alter table compra add constraint compra_proveedor foreign key (IdProveedor) references proveedores(IdProveedor) on delete restrict on update restrict;

alter table empleados add constraint empleados_sucursal foreign key (IdSucursal) references sucursales(IdSucursal) on delete restrict on update restrict;
alter table empleados add constraint empleados_sector foreign key (IdSector) references sector(IdSector) on delete restrict on update restrict;

alter table gasto add constraint gasto_tipogasto foreign key (IdTipoGasto) references tipogasto(IdTipoGasto) on delete restrict on update restrict;
alter table gasto add constraint gasto_sucursal foreign key (IdSucursal) references sucursales(IdSucursal) on delete restrict on update restrict;

alter table productos add constraint producto_tipoproducto foreign key (IdTipoProducto) references tipoproducto(IdTipoProducto) on delete restrict on update restrict;

alter table proveedores add constraint proveedor_localidad foreign key (IdLocalidad) references localidad(IdLocalidad) on delete restrict on update restrict;

alter table sucursales add constraint sucursal_localidad foreign key (IdLocalidad) references localidad(IdLocalidad) on delete restrict on update restrict;

alter table venta add constraint venta_canal foreign key (IdCanal) references canalventa(IdCanal) on delete restrict on update restrict;
alter table venta add constraint venta_sucursal foreign key (IdSucursal) references sucursales(IdSucursal) on delete restrict on update restrict;
alter table venta add constraint venta_empleado foreign key (IdEmpleado) references empleados(IdEmpleado) on delete restrict on update restrict;
alter table venta add constraint venta_producto foreign key (IdProducto) references productos(IdProducto) on delete restrict on update restrict;

alter table venta change IdCliente IdCliente int not null;
alter table venta add constraint venta_cliente foreign key (IdCliente) references clientes(IdCliente) on delete restrict on update restrict; -- Se solucionó el error "Error Code: 3780. Referencing column 'IdCliente' and referenced column 'IdCliente' in foreign key constraint 'venta_ibfk_1' are incompatible" al cambiar el tipo de dato que existía en el IdCliente de la tabla venta.


# 3) Genere la indexación de los campos que representen fechas o ID en las tablas:
	-- venta.
    alter table venta add index(IdVenta);
    alter table venta add index(Fecha);
    alter table venta add index(Fecha_Entrega);
    alter table venta add index(IdCanal);
    alter table venta add index(IdCliente);
    alter table venta add index(IdSucursal);
    alter table venta add index(IdEmpleado);
    alter table venta add index(IdProducto);
    
	-- cana_venta.
    alter table canalventa add index(IdCanal);
	
    -- producto.
	alter table productos add index(IdProducto);
    alter table productos add index(IdTipoProducto);
    
    -- tipo_producto.
    alter table tipoproducto add index(IdTipoProducto);
    
	-- sucursal.
    alter table sucursales add index(IdSucursal);
    alter table sucursales add index(IdLocalidad);
    
	-- empleado.
    alter table empleados add index(IdEmpleado);
    alter table empleados add index(IdSucursal);
    alter table empleados add index(IdSector);
    alter table empleados add index(IdCargo);
    
	-- localidad.
    alter table localidad add index(IdLocalidad);
    alter table localidad add index(IdProvincia);
    
	-- proveedor.
	alter table proveedores add index(IdProveedor);
    alter table proveedores add index(IdLocalidad);
    
    -- gasto.
	alter table gasto add index(IdGasto);
    alter table gasto add index(IdSucursal);
    alter table gasto add index(IdTipoGasto);
    alter table gasto add index(Fecha);
    
    -- cliente.
    alter table clientes add index(IdCliente);
    
	alter table clientes change Fecha_Alta Fecha_Alta date;
    alter table clientes add index(Fecha_Alta);
    
    alter table clientes change Fecha_Ultima_Modificacion Fecha_Ultima_Modificacion date;
    alter table clientes add index(Fecha_Ultima_Modificacion);
    
    alter table clientes add index(IdLocalidad);
    
	-- compra.
    alter table compra add index(IdCompra);
    alter table compra add index(Fecha);
    alter table compra add index(IdProducto);
    alter table compra add index(IdProveedor);
    
# 4) Ahora que las tablas están indexadas, vuelva a ejecutar las consultas del punto 1 y evalue las estadístias. ¿Nota alguna diferencia?.

# Consulta 1
    select 
		b.Descripcion as canal,
        sum(a.Precio) as ventas_canal
        from venta a
        join canalventa b
			on (a.IdCanal = b.IdCanal)
		where year(fecha) = 2017
        group by canal
        order by canal; -- ANTES: 0.313 sec / 0.000 sec || DESPUÉS: 0.407 sec / 0.000 sec
    
    # Consulta 2
    select 
		Provincia as Provincia,
        count(a.IdVenta) as N_Ventas
		from venta a
        join clientes b
			on (a.IdCliente = b.IdCliente)
		join localidad c
			on (b.IdLocalidad = c.IdLocalidad)
		join provincia d
			on (d.IdProvincia = c.IdProvincia)
		where year(fecha) = 2017
        group by Provincia
        order by Provincia; -- ANTES: 0.359 sec / 0.000 sec || DESPUÉS: 0.453 sec / 0.000 sec

    # Consulta 3
	select 
		b.Sucursal as sucursal,
		sum(a.Precio) as Ventas
		from venta a
		join sucursales b
			on (a.IdSucursal = b.IdSucursal)
		where year(fecha) = 2017
		group by sucursal
		order by Ventas DESC; -- ANTES: 0.265 sec / 0.000 sec || DESPUES: 0.375 sec / 0.000 sec
            
    # Consulta 4
    select 
		d.Provincia as Provincia,
		b.Sucursal as sucursal,
		sum(a.Precio) as Ventas
		from venta a
		join sucursales b
			on (a.IdSucursal = b.IdSucursal)
		join localidad c
			on (b.IdLocalidad = c.IdLocalidad)
		join provincia d
			on (d.IdProvincia = c.IdProvincia)
        where year(fecha) = 2017
		group by Provincia, sucursal
		order by Ventas DESC; -- ANTES 0.313 sec / 0.000 sec || DESPUES: 0.375 sec / 0.000 sec
    
    # Consulta 5
    select 
		c.TipoProducto as Tipo_Producto,
        avg(a.Precio) as Promedio_Venta
        from venta a
        join productos b
			on (a.IdProducto = b.IdProducto)
		join tipoproducto c
			on (b.IdTipoProducto = c.IdTipoProducto)
		group by Tipo_Producto
        order by Promedio_Venta; -- ANTES: 0.578 sec / 0.000 sec || DESPUES: 0.563 sec / 0.000 sec

# 5) Genere una nueva tabla que lleve el nombre fact_venta (modelo estrella) que pueda agrupar los hechos relevantes de la tabla venta, los campos a considerar deben ser los siguientes:
	-- IdVenta
	-- Fecha
	-- Fecha_Entrega
	-- IdCanal
	-- IdCliente
	-- IdEmpleado
	-- IdProducto
	-- Precio
	-- Cantidad
    
    drop table if exists fact_venta;
    create table fact_venta (
    IdVenta int,
	Fecha date,
	Fecha_Entrega date,
	IdCanal int,
	IdCliente int,
	IdEmpleado int,
	IdProducto int,
	Precio decimal(15,2),
	Cantidad int
    );
    
# 6) A partir de la tabla creada en el punto anterior, deberá poblarla con los datos de la tabla ventas.

insert into fact_venta 
	select IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
    from venta;
    