use checkpoint_m2;

select count(*) from venta; 		-- 43255 registros
select count(*) from canal_venta;	-- 3 registros
select count(*) from producto;		-- 291 registros

# ¿Cuál fue el canal de venta con mayores ventas registradas en el año 2017?

select 
	cv.IdCanal as ID,
    cv.Canal as Canal,
    count(v.IdVenta) as n_ventas
    
    from canal_venta cv
    join venta v
    on v.IdCanal = cv.IdCanal
    where year(v.Fecha) = 2017 
    group by ID
    order by n_ventas desc;

# ¿Cuál fue el canal de venta con menor cantidad de productos vendidos en el año 2020?

select 
	cv.IdCanal as ID,
    cv.Canal as Canal,
    count(v.IdVenta) as n_ventas
    
    from canal_venta cv
    join venta v
    on v.IdCanal = cv.IdCanal
    where year(v.Fecha) = 2020
    group by ID
    order by n_ventas asc;
    
# ¿Cuál es el Id del empleado que menor cantidad de productos vendió en el histórico de ventas de la empresa?

select 
	IdEmpleado as ID,
    count(IdVenta) as n_ventas
    
    from venta
    group by Id
    order by n_ventas asc
    limit 1;

# Se define el tiempo de entrega como el tiempo en días transcurrido entre que se realiza la compra y se efectua la entrega. Para realizar mejoras la dirección desea saber cuál es el mes con su respectivo año, con el promedio más bajo de este tiempo de entrega. (Fecha = Fecha de venta, Fecha_Entrega = Fecha de entrega) Proporcionar la respuesta con este formato: MMYYYY. (Si es Marzo del 2020 -> 032020)

select 
	concat(month(Fecha_Entrega),year(Fecha_Entrega)) as FechaEntrega,
    avg(timestampdiff(day,Fecha,Fecha_Entrega)) as Demora
    from venta
    group by FechaEntrega
    order by Demora desc
    limit 1;

# ¿Cuál es el promedio de precio de los productos cuyo concepto comienza con la letra C (Precio tomado de la tabla producto)? (Redondear a 2 decimales. Ej 648.2563 -> 648.26)

select * from producto;

select round(avg(precio),2) as Promedio
	from producto
    where Concepto like "C%";

# ¿Cuál es el id del Producto cuyo nombre es EPSON COPYFAX 2000?

select 
	idproducto as ID,
    concepto as nombre
    from producto
    where concepto like "EPSON COPYFAX 2000"; # 42737

# ¿Cuantos productos tienen la palabra CD en alguna parte de su descripción (Concepto = Descripción del Producto) y su precio es mayor a 500?

select 
	count(Concepto) as "Número de productos"
	from producto
    where concepto like "%CD%" AND Precio > 500;
    
# Considerando el año 2017, ¿Cuál fue el mes (considerando la fecha de venta, es decir, usando el campo Fecha) con mayor monto total de venta (monto de venta = Precio*Cantidad) para el empleado 1426?

select 
	month(Fecha) as Mes_Venta,
    sum(Precio * Cantidad) as Monto_Total,
    IdEmpleado as "ID Empleado"
    from venta
    where year(fecha) = 2017 AND IdEmpleado = 1426
    group by Mes_Venta
    order by Monto_Total DESC
    limit 1;