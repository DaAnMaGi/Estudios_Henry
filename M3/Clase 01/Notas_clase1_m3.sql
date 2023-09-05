use clase_5;

## Variables definidas por el usuario

	-- SET @Nombre_variable = valor

	select * from alumnos;

	set @nombre = "Carlos";

	SELECT * FROM alumnos
		where nombre = @nombre;
		
	SELECT @nombre;

## Variables locales -- Solo en funciones y stored procedures.

	-- DECLARE variable_name DATATYPE [Default value]

## VARIABLES del SISTEMA

	SHOW variables; -- Muestra una lista de variables
	show variables like "%global%";
	show variables like "%Version%";
    show variables like "%datadir";
    
    -- set @@datadir = "Nueva dirección de dirección".

## FUNCIONES 
	GRANT INSERT, DELETE 
		ON alumnos 
        TO "root"@"localhost";
	
    -- DELIMITER $$
    -- CREATE FUNCTION nombre_funcion(parametros) returns tipo_retorno
		-- BEGIN
			-- Cuerpo de la función
            -- DECLARE variable INT DEFAULT 0;
		
        -- END$$
	-- DELIMITER $$
    
    DELIMITER $$
    CREATE FUNCTION antiguedad_meses(FechaNacimiento date) RETURNS INT
		BEGIN 
			DECLARE anios INT DEFAULT 0;
            
            SET anios = TIMESTAMPDIFF(year, FechaNacimiento, curdate());
            
            RETURN anios;
		END$$
	DELIMITER ;
-- Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)	0.125 sec

    SHOW VARIABLES LIKE "log_bin_trust_function_creators";
    set global log_bin_trust_function_creators = ON;
    
    select 
		concat(nombre," ",apellido) as "Nombre completo",
		antiguedad_meses(FechaNacimiento) as "Edad"
		from alumnos;
        
# Procedimientos almacenados

	# DELIMITER %%
	# CREATE PROCEDURE nombre(IN anios DATE, OUT anios DATE, INOUT nombre DATATYPE)
		## BEGIN
			-- PUEDEN HACER SELECT, INSERT, UPDATE, DELETE
		## END$$
        ## DELIMITER ;
	
    -- Se llama con: CALL nombre_procedimiento()

	DELIMITER $$
	CREATE PROCEDURE listar_carrera(IN nombre_carrera VARCHAR(50))
		BEGIN
			SELECT 
				concat(a.nombre," ",a.apellido) "Alumno", 
                a.idCohorte "Cohorte",
                ca.Nombre as "Nombre carrera"
				from alumnos a
                join cohorte co
					on (a.idCohorte = co.idCohorte)
                join carrera ca
					on (ca.idCarrera = co.idCarrera)
				
                where ca.Nombre = nombre_carrera;
		END $$
        
        DELIMITER ;
	
    CALL listar_carrera("Data Science");
    CALL listar_carrera("Full Stack Developer");
    
    # drop procedure nombre_procedimiento;
    
    