use adventureworks;

# Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en esa fecha.

SELECT SalesOrderID, OrderDate, DueDate, CustomerID, SalesPersonID, TotalDue
	FROM salesorderheader
    WHERE DATE(OrderDate) = "2001-10-18";
    
DROP PROCEDURE IF EXISTS ordenDia; -- Se elimina el procedimiento en caso de existir.
DELIMITER $$
CREATE PROCEDURE ordenDia (in fecha date, inout ordenes INT) -- Se crea el procedimiento
BEGIN 
    DECLARE n_ordenes INT;
    SELECT count(SalesOrderID) INTO n_ordenes
    FROM salesorderheader 
    WHERE DATE(OrderDate) = fecha;
    set ordenes = n_ordenes;
END $$
DELIMITER ; 

SET @orden = 0; 
CALL ordenDia("2001-10-18",@orden); -- Se prueba el procedimiento.
SELECT @orden;

# Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.

SET GLOBAL log_bin_trust_function_creators = 1; -- > Se usa en caso de no querer especificar las funciones en cada ocasión.

drop function if exists margenBruto;

DELIMITER $$
CREATE FUNCTION margenBruto (precio DECIMAL (15,3), margen DECIMAL (15,3)) 
RETURNS DECIMAL (15,3)
DETERMINISTIC
NO SQL
BEGIN 
    RETURN precio * margen;
END $$
DELIMITER ;

select margenBruto (156.54,1.1);

# Obtner un listado de productos en orden alfabético que muestre cuál debería ser el valor de precio de lista, si se quiere aplicar un margen bruto del 20%, utilizando la función creada en el punto 2, sobre el campo StandardCost. Mostrando tambien el campo ListPrice y la diferencia con el nuevo campo creado.

-- product --> StandardCost, ProductID, Name, ListPrice

SELECT ProductID, Name, StandardCost, ListPrice, margenBruto(StandardCost,1.20) as nuevoPrecio, ListPrice - margenBruto(StandardCost,1.20) as diferencia
from product
order by Name;

# Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, y muestre un listado con los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).

DROP PROCEDURE IF EXISTS costoEnvio;

DELIMITER $$
CREATE PROCEDURE costoEnvio (in fechaInicio DATE, in fechaFinal Date)
BEGIN 
	SELECT CustomerID, sum(Freight) as costoEnvio
    FROM salesorderheader
    WHERE DATE(OrderDate) BETWEEN fechaInicio AND fechaFinal
    GROUP BY CustomerID
    ORDER BY costoEnvio DESC;
END $$
DELIMITER ;

CALL costoEnvio ("2001-10-1","2001-10-31");

# Crear un procedimiento que permita realizar la insercción de datos en la tabla shipmethod.

DROP PROCEDURE IF EXISTS agregarEnvio;

DELIMITER $$ 
CREATE PROCEDURE agregarEnvio (in nombre VARCHAR(50), in shipBase DECIMAL (15,3), in shipRate DECIMAL (15,3))
BEGIN
	INSERT INTO shipmethod (Name, ShipBase, ShipRate, rowguid, ModifiedDate)
		VALUES (nombre, shipBase, shipRate, "BLOB", CURDATE());
END $$
DELIMITER ;

CALL agregarEnvio ("Nuevo Envio",15.4,1.54);

DELETE FROM shipmethod
	WHERE ShipMethodID = 6; 
