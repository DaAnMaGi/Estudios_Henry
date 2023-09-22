use henry_3;
SET SQL_SAFE_UPDATES = 0; # Quitar el modo seguro para poder editar las tablas

select * from canalventa;
select * from clientes;
select * from compra;
select * from empleados;
select * from gasto;
select * from productos;
select * from proveedores;
select * from sucursales;
select * from tipogasto;
select * from venta;

select max(Fecha_Ultima_Modificacion) from clientes;

# Pregunta 5 -- ¿Hay claves duplicadas?
select count(*), count(distinct codigo) from canalventa;
select count(ID), count(distinct ID) from clientes;
select count(IdCompra), count(distinct IdCompra) from compra;
select count(ID_empleado), count(distinct ID_empleado) from empleados;
select count(IdGasto), count(distinct IdGasto) from gasto;
select count(ID_PRODUCTO), count(distinct ID_PRODUCTO) from productos;
select count(IDProveedor), count(distinct IDProveedor) from proveedores;
select count(ID), count(distinct ID) from sucursales;
select count(IdTipoGasto), count(distinct IdTipoGasto) from tipogasto;
select count(IdVenta), count(distinct IdVenta) from venta;

# PREGUNTA 6 - CREAR PROCEDIMIENTOS 
/*
SET GLOBAL log_bin_trust_function_creators = 1;
-- 8 y 9)
/*Función y Procedimiento provistos*/
DROP FUNCTION IF EXISTS `UC_Words`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension calendario*/
DROP TABLE IF EXISTS `calendario`;
CREATE TABLE calendario (
        id                      INTEGER PRIMARY KEY,  -- year*10000+month*100+day
        fecha                 	DATE NOT NULL,
        anio                    INTEGER NOT NULL,
        mes                   	INTEGER NOT NULL, -- 1 to 12
        dia                     INTEGER NOT NULL, -- 1 to 31
        trimestre               INTEGER NOT NULL, -- 1 to 4
        semana                  INTEGER NOT NULL, -- 1 to 52/53
        dia_nombre              VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        mes_nombre              VARCHAR(9) NOT NULL -- 'January', 'February'...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

ALTER TABLE `calendario` ADD UNIQUE(`fecha`);
CALL Llenar_dimension_calendario('2015-01-01', '2020-12-31');

/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Calendario.csv' 
INTO TABLE calendario
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;*/

# Punto 6 y 7 - Revisión de los datos, limpieza.
-- canalventa
alter table canalventa change codigo IdCanal INT(11) NOT NULL;
SELECT * FROM canalventa;

-- clientes

select * from clientes;

	-- Revisión de datos nulos // Maneras de revisar datos nulos
    -- Opción 1, revisión de columna, 1 por una
    select *  from clientes where isnull(provincia);
	select * from clientes where isnull(Nombre_y_Apellido);
    select * from clientes where isnull(Domicilio);
    select * from clientes where isnull(Telefono);
    select * from clientes where isnull(Edad); -- No se encontraron faltantes en edad
    select * from clientes where isnull(Localidad);
    select * from clientes where isnull(X);
    select * from clientes where isnull(Y);
    select * from clientes where isnull(Fecha_Alta);
    select * from clientes where isnull(Usuario_Alta);
    select * from clientes where isnull(Fecha_Ultima_Modificacion);
    
    -- Opción 2, revisión de conteo de datos, la expresión count(*) cuenta todos los rows (independiente de si hay o no nulos), la expresión count(column) sólo cuenta los datos no nulos:
    select count(*), count(provincia), count(Nombre_y_Apellido), count(Domicilio), count(Telefono), count(Edad), count(Localidad),
		count(x), count(Y), count(Fecha_Alta), count(Usuario_Alta), count(Fecha_Ultima_Modificacion), count(Usuario_Ultima_Modificacion), count(Marca_Baja)
        from clientes;
	
    -- Opción 3, revisando el dataframe en python con pandas, usando la función pd.dataFrame.info() // Esta información se realiza sobre el documento de la solución de la tarea de la clase 4. 
    
    -- limpieza de datos. 

SET SQL_SAFE_UPDATES = 0; # Quitar el modo seguro para poder editar las tablas

ALTER TABLE clientes CHANGE ID IdClientes INT(11) not null;
update clientes set X = 0 where X IS NULL;
update clientes set Y = 0 where Y IS NULL;
ALTER TABLE clientes change X Longitud decimal(15,13) not null default 0;
ALTER TABLE clientes change Y Latitud decimal(15,13) not null default 0;
ALTER TABLE clientes drop col10;
update clientes set Provincia = "No hay datos" where Provincia IS NULL;
update clientes set Domicilio = "No hay datos" where Domicilio IS NULL;
update clientes set Localidad = "No hay datos" where Localidad IS NULL;
update clientes set Telefono = "No hay datos" where Telefono IS NULL;
update clientes set Nombre_y_Apellido = "No hay datos" where Nombre_y_Apellido IS NULL;
ALTER TABLE clientes CHANGE IdClientes IdCliente INT(11) not null;

select * from clientes;
# Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- compra

select * from compra; -- No tiene campos nulos.

alter table compra change IdCompra IdCompra INT not null;
alter table compra change Fecha Fecha date;
alter table compra change IdProducto IdProducto int not null;
alter table compra change IdProveedor IdProveedor INT not null;
alter table compra change Cantidad Cantidad INT;
alter table compra change Precio Precio dec(15,2);

select * from compra;

-- empleados
select * from empleados; -- no tiene nulos

alter table empleados change ID_empleado IdEmpleado INT not null;
alter table empleados change Salario Salario INT not null;

-- gasto
select * from gasto; -- No tiene nulos

alter table gasto change IdGasto IdGasto INT NOT null;
alter table gasto change IdSucursal IdSucursal INT NOT null;
alter table gasto change IdTipoGasto IdTipoGasto INT NOT null;
alter table gasto change Fecha Fecha date;
alter table gasto change Monto Monto decimal(15,2);


-- productos
select * from productos; -- Tiene en la columna "Tipo" datos nulos

alter table productos change ID_PRODUCTO IdProducto INT not null;
alter table productos change Concepto Producto varchar(60);
update productos set Tipo = "No hay datos" where Tipo is null;
alter table productos change Precio Precio decimal(15,3);

select * from productos;

-- proveedores
select * from proveedores; 

alter table proveedores change IDProveedor IdProveedor int not null;
update proveedores set Nombre = "No hay dato" where Nombre is null;
alter table proveedores change Nombre Nombre varchar(60);
alter table proveedores change Address Direccion varchar(60);
alter table proveedores change City Ciudad varchar(60);
alter table proveedores change State Estado varchar(60);
alter table proveedores change Country Pais varchar(60);
alter table proveedores change departamen Departamento varchar(60);

select * from proveedores; 

-- sucursales
select * from sucursales; -- No hay datos nulos.

alter table sucursales change ID IdSucursal int not null;
alter table sucursales change Sucursal Sucursal varchar(50);
alter table sucursales change Direccion Direccion varchar(60);
alter table sucursales change Localidad Localidad varchar(60);
alter table sucursales change Provincia Provincia varchar(60);
alter table sucursales change Latitud Latitud decimal(15,6);
alter table sucursales change Longitud Longitud decimal(15,6);

select * from sucursales;

-- tipogasto
select * from tipogasto; -- No tiene datos nulos

alter table tipogasto change IdTipoGasto IdTipoGasto int not null;
alter table tipogasto change Descripcion Tipo_Gasto varchar(50);
alter table tipogasto change Monto_Aproximado Monto_Aproximado int;

select * from tipogasto; 

-- venta
select * from venta;

alter table venta change IdVenta IdVenta int not null;
alter table venta change Fecha Fecha date;
alter table venta change Fecha_Entrega Fecha_Entrega date;
alter table venta change IdCanal IdCanal int not null;
alter table venta change IdSucursal IdSucursal int not null;
alter table venta change IdEmpleado IdEmpleado int not null;
alter table venta change IdProducto IdProducto int not null;
update venta set Precio = 0 where Precio is null; 
alter table venta change Precio Precio dec(15,2);
update venta set Cantidad = 0 where Cantidad is null;
alter table venta change Cantidad Cantidad int;

select * from venta; 

# Punto 8. Utilizar la funcion provista 'UC_Words' (Homework_Utiles.sql) para modificar a letra capital los campos que contengan descripciones para todas las tablas.

update canalventa set DESCRIPCION = UC_Words(TRIM(DESCRIPCION));
update clientes set Provincia = UC_Words(TRIM(Provincia)),
					Nombre_y_Apellido = UC_Words(TRIM(Nombre_y_Apellido));
update empleados set Apellido = UC_Words(trim(Apellido)),
					 Nombre = UC_Words(trim(Nombre));
update productos set Producto = UC_Words(trim(Producto));
update proveedores set Nombre = UC_Words(trim(Nombre)),
						Direccion = UC_Words(trim(Direccion));
update sucursales set Sucursal = UC_Words(trim(Sucursal)),
						Direccion = UC_Words(trim(Direccion));
update tipogasto set Tipo_Gasto = UC_Words(trim(Tipo_Gasto));

# Punto 9 

select * from venta where precio = 0; # No existe consistencia en la columna precio y cantidad ya que existen datos en 0 en precio cuando la cantidad tiene datos, y viceversa.
select * from productos where precio = 0;

set @@net_read_timeout = 5000;
SET SQL_SAFE_UPDATES = 0;

update venta v 
	join productos p
		on (v.IdProducto = p.IdProducto)
	set v.Precio = p.Precio
    where v.Precio = 0;

select * from venta;

# Punto 10 -- Identificación de ID Repetidos

select IdCliente, count(*) as conteo 
	from clientes 
    group by IdCliente
    having conteo > 1
    order by IdCliente; # No hay repetidos.
    
select IdCompra, count(*) as conteo 
	from compra 
    group by IdCompra
    having conteo > 1
    order by IdCompra; # No hay repetidos.

select IdEmpleado, count(*) as conteo 
	from empleados 
    group by IdEmpleado
    having conteo > 1
    order by IdEmpleado; # Existen varios repetidos. 1301, 1674, 1675, 1724, 1725, 
						# 1968, 1977, 3032, 3144, 3346, 3481, 3504, 3603, 3622, 
						# 3728, 3842, 3875

select IdProducto, count(*) as conteo 
	from productos 
    group by IdProducto
    having conteo > 1
    order by IdProducto; # No hay repetidos.
    
select IdProveedor, count(*) as conteo 
	from proveedores 
    group by IdProveedor
    having conteo > 1
    order by IdProveedor; # No hay repetidos.
    
select IdSucursal, count(*) as conteo 
	from sucursales
    group by IdSucursal
    having conteo > 1
    order by IdSucursal; # No hay repetidos.

# No hay repetidos en tipogasto ya que la tabla es fácilmente revisable
    
select IdVenta, count(*) as conteo 
	from venta
    group by IdVenta
    having conteo > 1
    order by IdVenta; # No hay repetidos.
    
-- Limpieza de la tabla empleados

select e.* 
	from empleados e
    join (
		select IdEmpleado, count(*) as conteo 
		from empleados 
		group by IdEmpleado
		having conteo > 1
		) c
        on (e.IdEmpleado = c.IdEmpleado)
	order by e.IdEmpleado; # Revisión de los datos repetidos de empleados.

-- se agrega el ID de la sucursal a la tabla empleado

alter table empleados add IdSucursal int null default 0 after Sucursal;
select * from empleados limit 5;
update empleados set Sucursal = "Mendoza1" where Sucursal = "Mendoza 1";
update empleados set Sucursal = "Mendoza2" where Sucursal = "Mendoza 2";
update empleados e 
	join sucursales s 
		on (e.Sucursal = s.Sucursal)
	set e.IdSucursal = s.IdSucursal;

select * from empleados;
select * from sucursales;

alter table empleados drop Sucursal;
select * from empleados;

-- Se crea un nuevo código para empleado usando el id de la sucursal

alter table empleados add CodigoEmpleado int null default 0 after IdEmpleado;
update empleados set CodigoEmpleado = ((IdSucursal * 1000000) + IdEmpleado);
select * from empleados;

-- Volvemos a revisar que no haya repetidos en la nueva nomenclatura

select CodigoEmpleado, count(*) as conteo 
	from empleados 
	group by CodigoEmpleado
	having conteo > 1
	order by CodigoEmpleado; -- No hay nuevos repetidos en la nueva nomenclatura 
    
-- Limpiamos la tabla empleados dejando la nueva nomenclatura como el ID y actualizamos en la tabla venta el Id de Empleados. 

alter table empleados drop IdEmpleado;
alter table empleados Change CodigoEmpleado IdEmpleado int not null;
select * from empleados;

update venta set IdEmpleado = ((IdSucursal * 1000000) + IdEmpleado);
select * from venta;

### Normalización

# 10) Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
select * from empleados;

drop table if exists sector;
create table sector(
	IdSector INT not null auto_increment,
    Sector varchar(50),
    primary key (IdSector)
    );
    
insert into sector (Sector) (select distinct Sector from empleados order by 1);
select * from sector;

-- Normalizamos tabla empleados antes de crear la tabla cargo

update empleados set Cargo = "Vendedor" where Cargo = "Vendedor ";

drop table if exists cargo;
create table cargo(
	IdCargo int not null auto_increment,
    Cargo varchar(50),
    primary key (IdCargo)
);

insert into cargo (Cargo) (select distinct Cargo from empleados order by 1);
select * from cargo;

-- Actualizamos la tabla empleados con los ID
select * from empleados;

alter table empleados add IdSector int null default 0;
update empleados e join sector s on (e.Sector = s.Sector) set e.IdSector = s.IdSector;
alter table empleados drop Sector;

alter table empleados add IdCargo int null default 0;
update empleados e join cargo c on (e.Cargo = c.Cargo) set e.IdCargo = c.IdCargo;
alter table empleados drop Cargo;

select * from empleados;

# 11) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.

select * from productos;

drop table if exists tipoproducto;
create table tipoproducto (
	IdTipoProducto int not null auto_increment,
    TipoProducto varchar(50),
    primary key (IdTipoProducto)
    );
    
insert into tipoproducto (TipoProducto) select distinct Tipo from productos;
select * from tipoproducto;
select * from productos;

alter table productos add IdTipoProducto int null default 0 after Tipo;
update productos p join tipoproducto t on (p.Tipo = t.TipoProducto) set p.IdTipoProducto = t.IdTipoProducto;
alter table productos drop Tipo;