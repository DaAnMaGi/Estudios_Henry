use henry;

-- Alumno/s que ingresó/ingresaron primero

select * 
from alumno
where DATE(fechaIngreso) = 
	(select MIN(fechaIngreso) from alumno);

-- Alumno/s que ingresó/ingresaron de último
select * 
from alumno
where DATE(fechaIngreso) = 
	(select MAX(fechaIngreso) from alumno);
    
-- Listado de cohortes que no tienen alumnos registrados

select * 
from cohorte
where idCohorte not in 
	(select distinct idCohorte from alumno);

use adventureworks;

-- Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y método de envío mostrando para cada registro, qué porcentaje representa del total del año. Resolver utilizando Subconsultas y Funciones Ventana, luego comparar la diferencia en la demora de las consultas.

-- Subconsultas -- 0.844 sec / 0.000 sec
select 
	dos.año,
	dos.metodo, 
    dos.cantidad,
    round((dos.cantidad / uno.cantidad_año) * 100, 2) as porcentaje
from (
	select 	
		year(orderDate) as año,
		sm.Name as metodo, 
		sum(d.OrderQty) as cantidad
	from salesorderheader h
	join shipmethod sm on sm.ShipMethodID = h.ShipMethodID
	join salesorderdetail d on d.SalesOrderID = h.SalesOrderID
	group by año, metodo 
	order by año
    ) dos
join (
    select year(oh.OrderDate) as año, sum(od.OrderQty) as cantidad_año
	from salesorderdetail od
	join salesorderheader oh on od.SalesOrderID = oh.SalesOrderID
    group by año
    ) uno 
on uno.año = dos.año;

-- Función Ventana -- 0.562 sec / 0.000 sec
select 
	dos.año,
	dos.metodo, 
    dos.cantidad,
    round((dos.cantidad / sum(dos.cantidad) over (partition by dos.año)) * 100, 2) as porcentaje
from (
	select 	
		year(orderDate) as año,
		sm.Name as metodo, 
		sum(d.OrderQty) as cantidad
	from salesorderheader h
	join shipmethod sm on sm.ShipMethodID = h.ShipMethodID
	join salesorderdetail d on d.SalesOrderID = h.SalesOrderID
	group by año, metodo 
	order by año
    ) dos;

-- Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.

select 
	uno.categoria,
    uno.cantidad,
    round((uno.cantidad / sum(uno.cantidad) over ()) * 100,2) as "% Cantidad",
    uno.ventas,
    round((uno.ventas / sum(uno.ventas) over ()) * 100,2) as "% Ventas"
from (
	select 
		pc.Name as categoria,
		sum(d.OrderQty) as cantidad,
		sum(d.LineTotal) as ventas
	from salesorderdetail d
	join product p on p.ProductID = d.ProductID
	join productsubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
	join productcategory pc on pc.ProductCategoryID = psc.ProductCategoryID
	group by pc.Name
    ) uno
;

-- Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.

select 
	uno.pais,
    uno.cantidad,
    round((uno.cantidad / sum(uno.cantidad) over())*100,2) as "% Cantidad",
    uno.ventas,
    round((uno.ventas / sum(uno.ventas) over())*100,2) as "% Ventas"
from (select 
		cr.Name as pais,
		sum(d.OrderQty) as cantidad,
		sum(d.LineTotal) as ventas
	from salesorderdetail d
	join salesorderheader h on h.SalesOrderID = d.SalesOrderID
	join address ad on ad.AddressID = h.ShipToAddressID
	join stateprovince stp on stp.StateProvinceID = ad.StateProvinceID
	join countryregion cr on cr.CountryRegionCode = stp.CountryRegionCode
	group by pais
    ) uno ;

-- Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().

select 
	uno.ProductID,
    uno.cantidad,
    avg(uno.LineTotal) as mediana_ventas
from (
	select 
		ProductID, 
		LineTotal,
		count(*) over (partition by ProductID) as cantidad,
		row_number() over (partition by ProductID order by LineTotal) as n_linea
	from salesorderdetail
    ) uno
where 
	((floor(cantidad/2) = ceiling(cantidad/2)) and (n_linea = floor(cantidad/2) OR n_linea = ceiling(cantidad/2)))
    OR
    ((floor(cantidad/2) <> ceiling(cantidad/2)) and n_linea = ceiling(cantidad/2))
group by uno.ProductID;
