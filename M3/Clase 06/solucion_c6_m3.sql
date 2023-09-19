### Normalización

use henry_3;

# 1. Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias. Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.

select * from proveedores;

alter table proveedores change departamento Localidad varchar(50);
alter table proveedores change Estado Provincia varchar(50);


select localidad, provincia from clientes;
select localidad, provincia from sucursales;
select * from proveedores;
select localidad, provincia from proveedores;

-- FUNCIÓN: UNION
	-- Union -- Trae pares únicos
    -- Union all -- trae todos los pares

drop table if exists homologacion;
create temporary table homologacion
	select localidad, provincia from clientes
    union
	select localidad, provincia from sucursales
	union
    select localidad, provincia from proveedores;

select *,
 case 
	when provincia = "C deBuenos Aires" then "Ciudad de Buenos Aires"
    when provincia = "Caba" then "Ciudad de Buenos Aires"
    when provincia = "B%s" then "Buenos Aires"
    when provincia = "Bs%s." then "Buenos Aires"
    when provincia like "Bs%s" then "Buenos Aires"
    when provincia like "P%s" then "Buenos Aires"
    when provincia like "P%as." then "Buenos Aires"
    when provincia like "B%res" then "Buenos Aires"
    when provincia = "Bs.As. " then "Buenos Aires"
    else provincia 
end as provincia_corregida
from (select distinct provincia from homologacion) a;

drop table if exists provincia;
create table provincia (
	IdProvincia int not null auto_increment,
    Provincia varchar(60),
    primary key(IdProvincia)
    );

insert into provincia (Provincia) select distinct provincia_corregida from (
select *, case 
	when provincia = "C deBuenos Aires" then "Ciudad de Buenos Aires"
    when provincia = "Caba" then "Ciudad de Buenos Aires"
    when provincia = "B%s" then "Buenos Aires"
    when provincia = "Bs%s." then "Buenos Aires"
    when provincia like "Bs%s" then "Buenos Aires"
    when provincia like "P%s" then "Buenos Aires"
    when provincia like "P%as." then "Buenos Aires"
    when provincia like "B%res" then "Buenos Aires"
    when provincia = "Bs.As. " then "Buenos Aires"
    else provincia 
end as provincia_corregida
from (select distinct provincia from homologacion) a
) b;


# 2. Es necesario discretizar el campo edad en la tabla cliente.

### Outliers
# 1. Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad. Realizar diversas consultas para verificar la importancia de haber detectado Outliers. Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.

select * from venta;

select *,
	avg(cantidad) over() + 3 * std(cantidad) over () as limite_superior,
    avg(cantidad) over() - 3 * std(cantidad) over () as limite_superior    
    from venta;

### ETL
# 1. Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, aplicar las transformaciones o reglas de negocio necesarias a los datos y generar el modelo final que va a ser consumido desde los reportes. Este proceso debe ser claro y autodocumentado. ¿Se puede armar un esquema, donde sea posible detectar con mayor facilidad futuros errores en los datos?

	# Flaggeando los datos --> Usando un CASE WHEN
    # Revisando que los datos no estén repetidos por ID 
    # Revisando los datos vacíos.
    #

### KPI
# Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables, por lo tanto debemos asegurarnos de contar con los datos adecuados. ¿Necesito tener el claro las métricas que voy a utilizar? ¿La métrica necesaria debe tener algún filtro en especial? La Meta que se definió ¿se calcula con la misma métrica?

	# Solución 1 ) ROI sucursal ((Total de ventas por sucursal anual - total gasto por sucursal anual) / total gasto por sucursal anual).
    # Solución 2 ) % De eficacia de venta por colaborador -- Número de ventas por colaborador mensual / promedio de ventas de los colaboradores (se puede hacer por sucursal o para el promedio total de ventas todos los empleados).
    # Solución 3 ) Revisión de las ganancias por producto y popularidad del mismo producto -- Total de ventas por producto / total de ventas totales (o se puede hacer por categoría) y total de número de ventas por producto / total de ventas.