# Para resolver estas actividades usaremos la base de datos "adventureworks" del script AdventureWorks.sql (de la clase 1).

# Recuerda revisar la cápsula de la clase para reforzar cómo realizar subconsultas.

use adventureworks;

# 1. Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y método de envío mostrando para cada registro, qué porcentaje representa del total del año. Resolver utilizando Subconsultas y Funciones Ventana, luego comparar la diferencia en la demora de las consultas.<br> 

select * from salesorderheader; -- h
select * from salesorderdetail; -- d
select * from shipmethod; -- s 

-- Subconsulta | Total segundos: 1.828 sec / 0.000 sec

select 
	s.año as Año,
    s.categoria as "Categoría de envío",
    s.volumen as "Volumen de ventas por categoría",
    round((s.volumen/t.Total_Volumen)*100,2) as "% de ventas del año"
    from (
		select year(h.OrderDate) as año, sum(d.OrderQty) as Total_Volumen
			from salesorderheader h
			join salesorderdetail d	on (h.SalesOrderID = d.SalesOrderID)
			group by año
		) t
	join (
		select year(h.OrderDate) as año, s.name as categoria, sum(d.OrderQty) as volumen
			from salesorderheader h
			join salesorderdetail d on (h.SalesOrderID = d.SalesOrderID)
			join shipmethod s on (s.ShipMethodID = h.ShipMethodID)
			group by año, categoria
    ) s
		on (s.año = t.año)
    group by año, s.categoria
    order by año, s.categoria;

	-- Selección de total por año
	select 
		year(h.OrderDate) as año,
		sum(d.OrderQty) as Total_Volumen
		from salesorderheader h
		join salesorderdetail d
			on (h.SalesOrderID = d.SalesOrderID)
		group by año;

	-- Selección de total por año y categoría 
	select 
			year(h.OrderDate) as año,
			s.name as categoria,
			sum(d.OrderQty) as volumen
		from salesorderheader h
		join salesorderdetail d
			on (h.SalesOrderID = d.SalesOrderID)
		join shipmethod s
			on (s.ShipMethodID = h.ShipMethodID)
		group by año, categoria; 

-- Función Ventana | Total Segundos: 1.250 sec / 0.000 sec

select 
	t.año,
	t.categoria,
	t.volumen,
	round((t.volumen/sum(t.volumen) OVER (partition by t.año))*100,2) as Volumen_Total
	from (
    select 
			year(h.OrderDate) as año,
			s.name as categoria,
			sum(d.OrderQty) as volumen
		from salesorderheader h
		join salesorderdetail d
			on (h.SalesOrderID = d.SalesOrderID)
		join shipmethod s
			on (s.ShipMethodID = h.ShipMethodID)
		group by año, categoria
    ) as t
	order by año; 

# 2. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.<br>

select
	categoria,
    volumen,
    round((volumen/sum(volumen) over())*100,2) as porcentaje_volumen,
    total_venta,
    round((total_venta/sum(total_venta) over())*100,2) as porcentaje_total_venta
	from (select 
		s.name as categoria,
		sum(d.OrderQty) as volumen,
		sum(d.LineTotal) as total_venta
		from salesorderheader h
		join salesorderdetail d
			on (h.SalesOrderID = d.SalesOrderID)
		join shipmethod s
			on (s.ShipMethodID = h.ShipMethodID)
		group by categoria) s;

# 3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, mostrando para ambos, su porcentaje respecto del total.<br>

select * from address; 
select * from stateprovince;
select * from countryregion;
select * from salesorderdetail;
select * from salesorderheader;

select
	Pais,
    Numero_Ventas,
    round((Numero_ventas/sum(Numero_ventas) over())*100,2) as "Porcentaje del Total del Número de Ventas",
    Valor_Ventas,
    round((Valor_Ventas/sum(Valor_Ventas) over())*100,2) as "Porcentaje del Total del Valor de las Ventas"
    from (select 
		c.Name as Pais,
		sum(d.OrderQty) as Numero_Ventas,
		sum(LineTotal) as Valor_Ventas
		from salesorderheader h
		join salesorderdetail d
			on (h.SalesOrderID = d.SalesOrderID)
		join address a
			on (h.ShipToAddressID = a.AddressID)
		join stateprovince s
			on (a.StateProvinceID = s.StateProvinceID)
		join countryregion c
			on (s.CountryRegionCode = c.CountryRegionCode)
		group by Pais
		order by Pais) p;
    
# 4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().select 

select * from product; -- p
select * from salesorderdetail; -- d

select
	p.ProductID as ID,
    sum(d.LineTotal) as Mediana,
    sum(OrderQty) as N_Ordenes
    from product p
    join salesorderdetail d
		on (d.ProductID = p.ProductID)
	group by ID
    order by ID;
