### Normalización

use henry_3;

# 1. Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias. Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.

select * from proveedores;

alter table proveedores change departamento Localidad varchar(50);
alter table proveedores change Estado Provincia varchar(50);


select localidad, provincia from clientes;
select localidad, provincia from sucursales;
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

select * from homologacion;

# Creación tabla provincia

drop table if exists provincia;
create table provincia (
	IdProvincia int not null primary key auto_increment,
    Provincia varchar(60)
    );

-- Revisión de los datos para normalizar
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

	-- Se crea una tabla temporal para almacenar los datos corregidos.
    create temporary table povincias_correcion
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
    

-- Obtención de los datos únicos de la primera normalización de provincia
select distinct provincia_corregida from (select *,
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
from (select distinct provincia from homologacion) A 
) B
order by 1;

-- Agregación de los datos distintos a la tabla provincia.

insert into provincia (Provincia) select distinct provincia_corregida from (select *,
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
from (select distinct provincia from homologacion) A 
) B
order by 1;

-- Revisión de la tabla provincia.

select * from provincia;

# Creación tabla localidades

drop table if exists localidad;
create table localidad(
	IdLocalidad int not null primary key auto_increment,
    Localidad varchar(100),
    IdProvincia int not null,
    foreign key (IdProvincia) references provincia(IdProvincia)
	);

select * from localidad;

-- Revisión de unión de la tabla homologación y los datos corregidos de las provincias.
select 
	c.*,
	B.provincia_corregida
    from homologacion c
    left join povincias_correcion B
		on (c.provincia = B.Provincia);

-- Se modifican las localidades para normalizar los datos. 
select distinct
localidad, 
case 
	when localidad LIKE 'Cap%l' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d.' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Cap%s' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad = 'Cdad de Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad De Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad de Buenos Aires' THEN 'CABA'
    ELSE localidad
end as localidad_corregida,
provincia_corregida 
from (select 
	c.*,
	B.provincia_corregida
    from homologacion c
    left join povincias_correcion B
		on (c.provincia = B.Provincia)) A
	order by localidad;

-- Se guarda la anterior selección en una tabla temporal 

drop table if exists correcciones_localidad;
create temporary table correcciones_localidad
select distinct
localidad, 
case 
	when localidad LIKE 'Cap%l' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Ca%d.' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad LIKE 'Cap%s' AND provincia_corregida LIKE '%Aires' THEN 'CABA'
    WHEN localidad = 'Cdad de Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad De Buenos Aires' THEN 'CABA'
    WHEN localidad = 'Ciudad de Buenos Aires' THEN 'CABA'
    ELSE localidad
end as localidad_corregida,
provincia_corregida 
from (select 
	c.*,
	B.provincia_corregida
    from homologacion c
    left join povincias_correcion B
		on (c.provincia = B.Provincia)) A
	order by localidad;

select * from correcciones_localidad;

SET SQL_SAFE_UPDATES = 0;

-- Se corrige el dato de CABA que es irregular 
update correcciones_localidad set provincia_corregida = 'Ciudad de Buenos Aires'
	where localidad_corregida = "CABA" and provincia_corregida != 'Ciudad de Buenos Aires';

-- Se llena la tabla localidad

select * from correcciones_localidad;

insert into localidad (Localidad,IdProvincia)
	select distinct 
		a.localidad_corregida,
        b.IdProvincia
	from correcciones_localidad a
    left join provincia b
		on a.provincia_corregida = b.Provincia;
        
select * from localidad;

-- Modificación de las tablas origen.
	-- Modificación tabla de cliente
    
    alter table clientes add IdLocalidad int;
    
		-- Creamos una tabla para revisar los datos finales
        create temporary table revision_localidad_provincia
        SELECT
			A.*,
			B.provincia,
			C.IdProvincia,
			D.IdLocalidad
			FROM
			correcciones_localidad A
			LEFT JOIN
			povincias_correcion B
			ON A.provincia_corregida = B.provincia_corregida
			LEFT JOIN
			provincia C
			on A.provincia_corregida = C.Provincia
			LEFT JOIN
			localidad D
			ON A.localidad_corregida = D.Localidad AND D.IdProvincia = C.IdProvincia;
		
        select * from revision_localidad_provincia;
        select * from clientes;
        
        -- Revisamos la información de clientes
        create temporary table homologacion_cliente
        select 
			a.IdCliente,
            b.IdLocalidad
            from clientes a
            left join revision_localidad_provincia b
				on (a.provincia = b.Provincia) AND (a.Localidad = b.Localidad);
        
        select * from homologacion_cliente;
        
        -- Insertamos los datos en la tabla cliente
		set @@net_read_timeout = 10000000;
		SET SQL_SAFE_UPDATES = 0;
        
        update clientes a
			join homologacion_cliente b
            on a.IdCliente = b.IdCliente
			set a.IdLocalidad = b.IdLocalidad;
        
        alter table clientes drop provincia;
        alter table clientes drop localidad;
        
        select * from clientes;
        
    -- Modificación tabla de proveedores
		-- Revisamos la información de proveedores
        select * from proveedores;
        select * from revision_localidad_provincia;
        
        create temporary table homologacion_proveedores
        select 
			a.IdProveedor,
            b.IdLocalidad
            from Proveedores a
            left join revision_localidad_provincia b
				on (a.provincia = b.Provincia) AND (a.Localidad = b.Localidad);
			
		select * from homologacion_proveedores;
        
        -- Insersión de nuevos datos
        alter table proveedores add IdLocalidad int after Ciudad;
        
        update proveedores a
			join homologacion_proveedores b on (a.IdProveedor = b.IdProveedor)
            set a.IdLocalidad = b.IdLocalidad;
            
		alter table proveedores drop provincia;
        alter table proveedores drop Localidad;
        
        select * from proveedores;
    
    -- Modificación tabla sucursales
		
        -- creación tabla homologación 
        
        select * from sucursales;
        select * from revision_localidad_provincia;
        
        drop table if exists homologacion_sucursales;
        create temporary table homologacion_sucursales
        select 
			a.IdSucursal,
            b.IdLocalidad
            from sucursales a
            left join revision_localidad_provincia b
				on (a.localidad = b.localidad) AND (a.Provincia = b.Provincia);
		
        select * from homologacion_sucursales; -- 4 5 7 8 9
        select * from sucursales;
		
        -- Insersión de la data en la tabla de sucursales
        
        alter table sucursales add IdLocalidad int after Localidad;
        
        update sucursales a
			left join homologacion_sucursales b on (a.IdSucursal = b.IdSucursal)
            set a.IdLocalidad = b.IdLocalidad;
            
            -- se revisa que hay datos nulos y se agrega el ID de la localidad que les corresponde.
		update sucursales
			set IdLocalidad = 73 where IdLocalidad is null;
		
        alter table sucursales drop Localidad;
        alter table sucursales drop provincia;
			
            -- revisión final de que la tabla esté completa.
		select * from sucursales;
        
# 2. Es necesario discretizar el campo edad en la tabla cliente.

select * from clientes;

alter table clientes add rango_edad varchar(60) after edad;

update clientes set rango_edad = "Hasta 30 años" where edad <= 30 and rango_edad is null;
update clientes set rango_edad = "Entre 31 y 40 años" where edad <= 40 and rango_edad is null;
update clientes set rango_edad = "Entre 41 y 50 años" where edad <= 50 and rango_edad is null;
update clientes set rango_edad = "Entre 51 y 60 años" where edad <= 60 and rango_edad is null;
update clientes set rango_edad = "Mayor a 60 años" where edad > 60 and rango_edad is null;

select 
	rango_edad,
    count(*) as "Total clientes"
	from clientes
    group by rango_edad;

### Outliers
# 1. Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad. Realizar diversas consultas para verificar la importancia de haber detectado Outliers. Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.
	
    select * from venta;
	select * from productos;
    
	-- Se genera una consulta general en donde obtengamos el dato mínimo y máximo para Precio y cantidad por categoría de producto.
    select 
		a.*, 
        b.IdTipoProducto,
		avg(a.Precio) over (partition by b.IdTipoProducto) - (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_inferior_precio,
        avg(a.Precio) over (partition by b.IdTipoProducto) + (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_superior_precio,
        avg(a.Cantidad) over (partition by b.IdTipoProducto) - (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_inferior_cantidad,
		avg(a.Cantidad) over (partition by b.IdTipoProducto) + (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_superior_cantidad
        
        from venta a
        join productos b 
			on (a.IdProducto = b.IdProducto);
	
    -- Se genera una consulta en donde obtengamos los datos por encima o por debajo de los límites para Precio
    select 
		*, 
        case 
			when Precio > limite_superior_precio or Precio < limite_inferior_precio then 1
            else 0
        end as limite_precio
        from (
			select 
				a.*, 
				b.IdTipoProducto,
				avg(a.Precio) over (partition by b.IdTipoProducto) - (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_inferior_precio,
				avg(a.Precio) over (partition by b.IdTipoProducto) + (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_superior_precio
				from venta a
				join productos b 
					on (a.IdProducto = b.IdProducto)
			) A;
            
	-- Revisamos outliers para precio haciendo uso de las consultas anteriores.
	select 
	 * 
	 from (select 
	*, 
	case 
		when Precio > limite_superior_precio or Precio < limite_inferior_precio then 1
		else 0
	end as limite_precio
	from (
		select 
			a.*, 
			b.IdTipoProducto,
			avg(a.Precio) over (partition by b.IdTipoProducto) - (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_inferior_precio,
			avg(a.Precio) over (partition by b.IdTipoProducto) + (3 * std(a.Precio) over (partition by b.IdTipoProducto)) as limite_superior_precio
			from venta a
			join productos b 
				on (a.IdProducto = b.IdProducto)
		) A ) B
		where limite_precio = 1;
	
	-- Generamos la consulta para cantidad de los datos por encima o por debajo de los límites.
        select 
        *,
        case 
			when Cantidad < limite_inferior_cantidad or Cantidad > limite_superior_cantidad then 1
            else 0			
		end as limite_cantidad
        from (
        select 
		a.*, 
        b.IdTipoProducto,
		avg(a.Cantidad) over (partition by b.IdTipoProducto) - (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_inferior_cantidad,
		avg(a.Cantidad) over (partition by b.IdTipoProducto) + (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_superior_cantidad
        
        from venta a
        join productos b 
			on (a.IdProducto = b.IdProducto) ) A;
    
    -- Se obtienen los outliers de cantidad.
    select 
    * 
    from (
		select 
			*,
			case 
				when Cantidad < limite_inferior_cantidad or Cantidad > limite_superior_cantidad then 1
				else 0			
			end as limite_cantidad
			from (
			select 
			a.*, 
			b.IdTipoProducto,
			avg(a.Cantidad) over (partition by b.IdTipoProducto) - (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_inferior_cantidad,
			avg(a.Cantidad) over (partition by b.IdTipoProducto) + (3 * std(a.Cantidad) over (partition by b.IdTipoProducto)) as limite_superior_cantidad
			
			from venta a
			join productos b 
				on (a.IdProducto = b.IdProducto) ) A
    ) B
    where limite_cantidad = 1;
	
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