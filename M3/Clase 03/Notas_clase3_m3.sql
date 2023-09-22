use adventureworks;

select * from vendor;
select * from contact;
select * from salesorderheader;

# Subconsultas

-- Usando el where
SELECT * FROM contact 
	WHERE ContactID 
		IN (SELECT ContactID 
			FROM salesorderheader 
            WHERE date(OrderDate) = '2002-01-01');

-- Usando el select

select # No es muy eficiente, podríamos usar un join que es muchas veces más rápido.
	contact.FirstName,
    contact.LastName,
    (select count(*) 
		from salesorderheader 
        where salesorderheader.ContactID = contact.ContactID) as Total_Ventas
    from contact;
    
-- Subconsulta en having

select c.ContactID,
	sum(h.TotalDue) as TotalVentas
	from salesorderheader h
    join contact c
		on (c.ContactID = h.ContactID)
	group by c.ContactID -- 1
    having sum(h.TotalDue) > (select avg(TotalDue) from salesorderheader);

-- SUBCONSULTA EN FROM 

select 
	concat(c.FirstName," ",c.LastName) as "Nombre completo",
	ventas.TotalVentas
	from (
		select 
			contactID,
			sum(TotalDue) as TotalVentas
			from salesorderheader
			group by contactID
			) as ventas
	join contact c
		on (c.contactID = ventas.contactID);

# Vistas
        
use clase_5;

select IDAlumno, FechaIngreso
from alumnos
where fechaIngreso = (select min(fechaingreso) as fecha from alumnos);

-- Crear una vista

create view primerosAlumnos as
	select IDAlumno, FechaIngreso
	from alumnos
	where fechaIngreso = (select min(fechaingreso) as fecha from alumnos);

select * from primerosalumnos;

-- Modificar vista 

alter view primerosalumnos as
	select 
		IdAlumno,
        concat(apellido," ",nombre) as "Nombre Completo",
        fechaIngreso
	from alumnos
    where fechaIngreso = (
		select max(fechaIngreso) as Fecha from alumnos
        );

select * from primerosalumnos;

--  Eliminar una vista
drop view primerosalumnos;

# Funciones ventanas

use adventureworks;

select 
	date(OrderDate) as "Fecha",
    avg(TotalDue) as "Promedio Ventas"
    from salesorderheader
    group by OrderDate;

-- ANTES DE LA FUNCIÓN VENTANA 
select 
	v.OrderDate,
	v.TotalDue,
    v2.Promedio_Ventas
    from salesorderheader v
    join (
		select 
			OrderDate as Fecha,
			avg(TotalDue) as Promedio_ventas
		from salesorderheader
        group by OrderDate
        ) as v2
	on (v.OrderDate = v2.Fecha);
    
-- DESPUÉS DE LA FUNCIÓN VENTANA
select date(OrderDate), 
	totalDue,
    avg(TotalDue)
    OVER (
	partition by date(OrderDate)
    )
    from salesorderheaderproductdescriptionproductdescription;
   
-- Las funciones ventanas se realizan sobre una de las vistas o variables a mostrar del QUERY.

-- Otras funciones ventanas: row_number, rank, first_value, last_value, partition by

select * from purchaseorderheader;

select DISTINCT year(OrderDate),
	sum(TotalDue)
		over (
		partition by year(OrderDate)
		) AS cantidad_compras
    from purchaseorderheader;
    
-- El partition by sirve para "subdividir" los registros que nos encontramos. 

select distinct concat(c.FirstName," ",c.LastName) as "Nombre Cliente",
	max(h.TotalDue) over (partition by c.ContactID) - min(h.TotalDue) over (partition by c.ContactID) as Diferencia_Gastos
    from salesorderheader h
    join contact c	on (c.ContactID = h.ContactID);