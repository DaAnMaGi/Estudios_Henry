use adventureworks;

# 1. Obtener un listado de contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5".

-- Tablas a usar: contact, product, shipmethod, productsubcategory, salesorderheader, salesorderdetail

select * from salesorderheader; -- so (X)
select * from product; -- p (X)
select * from shipmethod; -- s (X)
select * from productsubcategory; -- ps (X)
select * from contact; -- c (X)
select * from salesorderdetail; -- sd (X)

select 
	c.ContactID as id_contacto,
    concat(c.FirstName," ",c.LastName) as nombre_contacto
    from contact c
    
    join salesorderheader so
		on (c.ContactID = so.ContactID)
	join shipmethod s
		on (s.ShipMethodID = so.ShipMethodID)
	join salesorderdetail sd
		on (sd.SalesOrderID = so.SalesOrderID)
	join product p
		on (sd.ProductID = p.ProductID)
	join productsubcategory ps
		on (p.ProductSubcategoryID = ps.ProductSubcategoryID)
	
    where (ps.Name like "Mountain Bikes") 
		and (s.Name = "CARGO TRANSPORT 5") 
        and (year(so.OrderDate) between 2000 and 2003)
    group by id_contacto
    order by id_contacto;
    
# 2. Obtener un listado de contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los años 2000 y 2003 con la cantidad de productos adquiridos y ordenado por este valor, de forma descendente.

select 
	c.ContactID as id_contacto,
    concat(c.FirstName," ",c.LastName) as nombre_contacto,
    sum(sd.OrderQty) as total_productos
    from contact c
    
    join salesorderheader so
		on (c.ContactID = so.ContactID)
	join salesorderdetail sd
		on (sd.SalesOrderID = so.SalesOrderID)
	join product p
		on (sd.ProductID = p.ProductID)
	join productsubcategory ps
		on (p.ProductSubcategoryID = ps.ProductSubcategoryID)
	
    where (ps.Name like "Mountain Bikes") 
        and (year(so.OrderDate) between 2000 and 2003)
    group by id_contacto
    order by total_productos desc;

# 3. Obtener un listado de cual fue el volumen de compra (cantidad) por año y método de envío.

select * from salesorderheader; -- o (X)
select * from shipmethod; -- s (X)
select * from salesorderdetail; -- d (X)

select 
	year(o.OrderDate) as año,
    s.Name as Metodo_Envio,
    sum(d.OrderQty) as Volumen
    from salesorderheader o
    
    join shipmethod s
		on (o.ShipMethodID = s.ShipMethodID)
	join salesorderdetail d
		on (d.SalesOrderID = o.SalesOrderID)
	group by año, Metodo_Envio
    order by año, Volumen;

# 4. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos.

-- Valor total de ventas = precio unitario * total producto (en tabla salesorderdetail)

select * from product; -- p
select * from salesorderdetail; -- d
select * from productsubcategory; -- s
select * from productcategory; -- c

select 
	c.Name as categ_producto,
    sum(d.OrderQty * d.UnitPrice) as valor_total,
    sum(d.OrderQty) as productos_ventas,
    sum(d.LineTotal) as "Total venta opción b"
	from salesorderdetail d
    
    join product p
		on (d.ProductID = p.ProductID)
	join productsubcategory s
		on (s.ProductSubcategoryID = p.ProductSubcategoryID)
	join productcategory c
		on (c.ProductCategoryID = s.ProductCategoryID)
	
    group by categ_producto
    order by valor_total;
    
	-- Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'adventureworks.d.OrderQty' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

# 5. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, sólo para aquellos países donde se enviaron más de 15 mil productos.

-- Valor total de ventas = precio unitario * total producto (en tabla salesorderdetail)

select * from address; -- a (3)
select * from salesorderheader; -- o | Se puede usar ShipToAddressID (2)
select * from countryregion; -- cr (5)
select * from salesorderdetail; -- d (1)
select * from stateprovince; -- sp (4)

select 
	cr.Name as Pais,
    sum(d.OrderQty * d.UnitPrice) as valor_total,
    sum(d.OrderQty) as productos_ventas,
    sum(d.LineTotal) as valor_total_b
	
    from salesorderdetail d
    join salesorderheader o
		on (d.SalesOrderID = o.SalesOrderID)
	join address a
		on (a.AddressID = o.ShipToAddressID)
	join stateprovince sp
		on (sp.StateProvinceID = a.StateProvinceID)
	join countryregion cr
		on (cr.CountryRegionCode = sp.CountryRegionCode)
	group by Pais
    having productos_ventas > 15000
    order by productos_ventas desc;
    
# 6. Obtener un listado de las cohortes que no tienen alumnos asignados, utilizando la base de datos henry, desarrollada en el módulo anterior.

use clase_5;

select 
	c.idCohorte as Cohorte,
    c.codigo as Codigo_Cohorte,
    count(a.idCohorte) as n_alumnos
    
    from cohorte c
    left join alumnos a
		on (c.idCohorte = a.idCohorte )
	group by Cohorte
    having n_alumnos = 0;