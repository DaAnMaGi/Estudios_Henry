DROP DATABASE IF EXISTS prueba_subir;
CREATE DATABASE IF NOT EXISTS prueba_subir;
USE prueba_subir;

-- SELECT @@global.secure_file_priv; 
SHOW VARIABLES LIKE 'secure_file_priv'; -- Para ver la ruta de origen donde poner los csv. 

/*Importacion de las tablas*/
DROP TABLE IF EXISTS `gasto`;
CREATE TABLE IF NOT EXISTS `gasto` (
  	`IdGasto` 		INTEGER,
  	`IdSucursal` 	INTEGER,
  	`IdTipoGasto` 	INTEGER,
    `Fecha`			DATE,
  	`Monto` 		DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gasto.csv'
INTO TABLE `gasto` 
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '' 
-- ESCAPED BY '' 
LINES TERMINATED BY '\n' 
IGNORE 1
LINES (IdGasto,IdSucursal,IdTipoGasto,Fecha,Monto);

select * from gasto;