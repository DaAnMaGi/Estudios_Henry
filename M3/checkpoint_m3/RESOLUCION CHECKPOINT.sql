use henry_checkpoint_m3;

# Del total de clientes que realizaron compras en 2020 ¿Qué porcentaje lo hizo sólo en una única sucursal? (Responder con valores entre 0 y 1, redondeado a 2 decimales)

select 
	*,
    round((n_clientes/total_clientes),2) as porcentaje
from
(select 
	*,
    count(cliente) over () as total_clientes,
    count(cliente) over (partition by sucursal) as n_clientes
from
(select 
	IdCliente as cliente,
    count(distinct IdSucursal) as sucursal
    from venta
    where year(fecha) = 2020
    group by cliente
    order by sucursal) A ) B;
    
# La ganancia neta por sucursal es las ventas menos los gastos, el sector de Marketing desea saber cuál sucursal tiene la mayor ganancia neta en el 2020 (Ganancia = Venta - Gasto)

	# venta = precio * cantidad
    
    select 
    a.IdSucursal,
    b.sucursal,
    (a.ventas_sucursal - b.total_gasto) as ganancia_neta
    from(  
    select 
    *,
    sum(Precio * Cantidad) over (partition by IdSucursal) as ventas_sucursal
    from venta
		where year(Fecha) = 2020) a
    join (    
	select 
    a.*,
    sum(b.Monto) over (partition by b.IdSucursal) as total_gasto
    from sucursal a
    join gasto b
		on (a.IdSucursal = b.IdSucursal)
	where year(b.Fecha) = 2020) b
    on (a.IdSucursal = b.IdSucursal)
    order by ganancia_neta desc;

# Del total de clientes que realizaron compras en 2019 ¿Qué porcentaje lo hizo sólo en una única sucursal? (Responder con valores entre 0 y 1, redondeado a 2 decimales)

select 
	*,
    round((n_clientes/total_clientes),2) as porcentaje
from
(select 
	*,
    count(cliente) over () as total_clientes,
    count(cliente) over (partition by sucursal) as n_clientes
from
(select 
	IdCliente as cliente,
    count(distinct IdSucursal) as sucursal
    from venta
    where year(fecha) = 2019
    group by cliente
    order by sucursal) A ) B;

# ¿Cuál es la sucursal con mayor venta (venta = Precio * Cantidad)?

select 
	b.Sucursal as sucursal,
    sum(a.Precio * a.Cantidad) as venta
    from venta a
    join sucursal b
		on (a.IdSucursal = b.IdSucursal)
	group by sucursal
    order by venta desc;

# Del total de clientes que realizaron compras en 2020 ¿Qué porcentaje no había realizado compras en 2019? (Responder con valores entre 0 y 1, redondeado a 2 decimales)

select 
	IdCliente as clientes_2020,
    count(IdCliente) over () as t_clientes_2020
    from venta
    where year(Fecha) = 2020; -- 9061
    
select 
	IdCliente as clientes_2019, 
    count(IdCliente) over () as t_cliente_2019
	from venta
    where year(Fecha) = 2019;
    
select 
    count(IdCliente) as t_cliente
	from venta
    where (IdCliente IN (
select 
	IdCliente as clientes_2020
    from venta
    where year(Fecha) = 2020)) and (IdCliente not in (select 
	IdCliente as clientes_2019
	from venta
    where year(Fecha) = 2019)); -- 3489
    
select round(3489/9061,2);

# La compañia desea saber el ingreso total de dinero mes a mes, teniendo en cuenta las ventas,las compras que se hacen en la compañia y los gastos adicionales es decir: [ingreso = ventas(precio*Cantidad) -compras(Precio*cantidad) - gastos]. Desean comparar dicho ingreso mes a mes entre 2020 y 2019 (ejemplo: ingreso_junio2020 - ingreso_junio2019), ¿Cuál es el mes de 2020 que tuvo mayor crecimiento con respecto al de 2019?

# Del total de clientes ¿Qué porcentaje realizó compras sólo por el canal online entre 2019 y 2020? (Responder con valores entre 0 y 1, redondeado a 2 decimales)

-- Clientes entre 2019 y 2020
select 
	IdCliente as clientes_2019_2020
    from venta
    where (year(Fecha) between 2019 and 2020);
    
select 
	count(distinct IdCliente) as t_clientes_2019_2020
    from venta
    where (year(Fecha) between 2019 and 2020); -- 16260

-- Clientes entre 2019 y 2020 que sólo han usado el canal online
select 
IdCliente as cliente_solo_online
from venta
where ( IdCliente in (select
cliente
from (select 
	distinct IdCliente as cliente,
    count(distinct IdCanal) over (partiton by IdCliente) as total_canales
    from venta
    where (year(Fecha) between 2019 and 2020)) A
    where total_canales = 1
    ) ) and (IdCanal = 2); -- 1516
    
-- Resolución punto 

select 
	count(a.clientes_2019_2020) as "Total Clientes 2019-2020",
    count(b.cliente_solo_online) as "Total cliente sólo canal online"
    from 
    (select 
	IdCliente as clientes_2019_2020
    from venta
    where (year(Fecha) between 2019 and 2020)) a
    left join (
    select 
a.IdCliente as cliente_solo_online
from venta a
join  
(select
cliente
from (select 
	IdCliente as cliente,
    count(distinct IdCanal) as total_canales
    from venta
    where (year(Fecha) between 2019 and 2020)
    group by IdCliente) A
    where total_canales = 1) b
    on (a.IdCliente = b.cliente)
    where a.IdCanal = 2
    ) b
    on (a.clientes_2019_2020 = b.cliente_solo_online);

# La ganancia neta por tipo de producto es las ventas menos las compras, se desea saber cuál tipo de producto tiene la mayor ganancia neta en el 2020 (Ganancia = Venta - Compra)

select
tipo_producto, 
sum(venta-compra) as ganancias
from 
(select 
	c.TipoProducto as tipo_producto,
    sum(a.Precio * a.Cantidad) as venta,
    sum(d.Precio * d.Cantidad) as compra
    from venta a
    join producto b
		on (a.IdProducto = b.IdProducto)
	join tipo_producto c
		on (c.IdTipoProducto = b.IdTipoProducto)
    join compra d
		on (d.IdProducto = a.IdProducto)
	where year(a.Fecha) = 2020
    group by tipo_producto) a
    group by tipo_producto
    order by ganancias desc;

-- --------------------------------------------------------------------------------------------------------------------
### tablas de comisiones

create temporary table comisiones
	select * from cordoba_centro
    union
	select * from cordoba_cerro
    union
	select * from cordoba_quiroz;

# ¿Cuál es la sucursal que más Venta (Precio * Cantidad) hizo en 2020 y 2019 a clientes que viven fuera de su provincia?

select * from comisiones where anio between 2019 and 2020;
select * from provincia;
select * from localidad;

select 
	b.Sucursal,
    sum(a.precio * a.cantidad) as ventas
    from venta a
    join (select * from comisiones where anio between 2019 and 2020) b
    on (a.IdSucursal = b.IdSucursal)
    join cliente c
		on (a.IdCliente = c.IdCliente)
	join localidad d
		on (d.IdLocalidad = c.IdLocalidad)
	where d.IdProvincia != 2
    group by b.sucursal
    order by ventas desc;

# ¿Cuál es la sucursal donde trabaja el empleado que menor comisión obtuvo en diciembre del año 2019?

select * from comisiones;

select 
	CodigoEmpleado,
    Sucursal,
    Porcentaje,
    anio,
    mes
    from comisiones
    where anio = 2019
		and mes = 12
	order by porcentaje;


#  La ganancia neta por sucursal es las ventas menos los gastos (Ganancia = Venta - Gasto) ¿Cuál es la sucursal con menor ganancia neta en 2019 en la provincia de Córdoba si además quitamos los pagos por comisiones?

select * from comisiones;

-- tabla temporal que recopila las ganancias
create temporary table ganancias
select
	t.ID as ID,
    t.Sucursal as Sucursal,
    t.ventas as ventas,
    sum(c.monto) as gasto
    from
    (select 
	a.IdSucursal as ID, 
    a.Sucursal as Sucursal, 
    sum(b.Precio * b.Cantidad) as ventas
    from comisiones a
    join venta b on (a.IdSucursal = b.IdSucursal)
    where year(b.Fecha) = 2019
    group by ID, Sucursal) t
	join gasto c on (c.IdSucursal = t.ID)
    where year(c.fecha) = 2019
    group by ID, sucursal;

-- solucion 
select * from ganancias;
select 
	Sucursal, 
    sum(ventas - gasto) as ganancia
    from ganancias
    group by Sucursal
    order by ganancia desc;
    

# ¿Cuál es el código de empleado del empleado que mayor comisión obtuvo en diciembre del año 2019?

select 
	CodigoEmpleado,
    Porcentaje,
    anio,
    mes
    from comisiones
    where anio = 2019
		and mes = 12
	order by porcentaje desc;
