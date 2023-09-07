# Ejecutar el script AdventureWorks.sql para cargar las tablas y sus registros. (Recuerda que si recibes el triángulo de alerta en vez del tilde verde, el código se ejecutó.)<br>

USE adventureworks;
show tables;

# 1. Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en esa fecha.

select 
	* 
    from salesorderheader
    limit 10;

drop procedure ordenes;

DELIMITER $$
CREATE PROCEDURE ordenes (IN fecha DATE)
	BEGIN 
		select
			date(OrderDate) as "Fecha de ingreso órden", #Puede ser más eficiente un count(*)
            count(SalesOrderID) AS "Cantidad de órdenes"
            from salesorderheader
            where date(OrderDate) = fecha;
    END $$
    DELIMITER ;

CALL ordenes("2001-10-28");
CALL ordenes("2001-08-13");
CALL ordenes("2001-08-01");
CALL ordenes("2001-08-02");

# 2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.

select * from product;
select * from productlistpricehistory;

set global log_bin_trust_function_creators = ON; #Se puede usar esta o usar el determinsitic en la función.

drop function valor_nominal; 

DELIMITER $$
create function valor_nominal (precio float, margen float) returns float deterministic # PREGUNTAR POR EL MARGEN BRUTO Y EL VALOR NOMINAL VS MARGEN DE GANANCIA
# Agregar un "deterministic" permite que la función siempre regrese el mismo resultado.
	begin
		declare margen_bruto float;
        
        set margen_bruto = precio * margen;
		
        return margen_bruto;
	end $$;
DELIMITER ;
 

select valor_nominal(45.7,3.4);

SELECT valor_nominal(60.5,3.2);

SELECT valor_nominal(85.9,2.1);

# 3. Obtener un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.

SELECT 
	ProductID as "ID",
    Name as "Nombre producto",
    valor_nominal(StandardCost,1.2) as "Precio Lista Fórmula", #Por qué se coloca un "1.2" como parte de la fórmula. No entiendo la intención de fondo.
    ListPrice as "Precio Lista Original",
    ListPrice - valor_nominal(StandardCost,1.2) as "Diferencia"
    
    FROM product
    order by Name; 

# 4. Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, y muestre un listado con los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).

drop procedure if exists costo_transporte;

DELIMITER $$
CREATE PROCEDURE costo_transporte (IN fecha_desde DATE, IN fecha_hasta DATE)
BEGIN 
	SELECT 
		CustomerID AS id_Cliente,
        SUM(Freight) AS Costo
	FROM salesorderheader
    WHERE DATE(OrderDate) between fecha_desde and fecha_hasta
    group by id_Cliente
    ORDER BY Costo DESC
    LIMIT 10;
END $$;
DELIMITER ;

# Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'adventureworks.salesorderheader.OrderDate' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
 
CALL costo_transporte("2001-11-30","2001-12-31");

CALL costo_transporte("2001-07-25","2001-09-01");

CALL costo_transporte("2001-06-30","2001-07-05");



# 5. Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.

SELECT * FROM shipmethod;

drop procedure if exists inser_shipmethod;

DELIMITER $$
CREATE PROCEDURE inser_shipmethod (IN Name VARCHAR(50), in base double, in rate double)
	begin
		insert into shipmethod (Name,ShipBase,ShipRate,ModifiedDate)
			values (Name,base,rate,now());
	end $$
delimiter ;

# Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'into shipmethod (Name,ShipBase,ShipRate,ModifiedDate)    values (Name,base,rate,' at line 3

SELECT * FROM shipmethod;

call inser_shipmethod ("prueba",3.95,1.23);
call inser_shipmethod ("prueba 2",8.4,3.3);

SELECT * FROM shipmethod;

delete from  shipmethod where ShipMethodID > 5;