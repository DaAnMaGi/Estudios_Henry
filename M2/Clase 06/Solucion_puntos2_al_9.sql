use clase_5;

select * from alumnos;
select * from carrera;
select * from cohorte;
select * from instructor;

# Ejercicio 2

delete from cohorte
	where idCohorte = 1245 or idCohorte = 1246;

select * from cohorte;    
    
# Ejercicio 3

select * from cohorte
	where idCohorte = 1243;

update cohorte
	set fechainicio = "2022-05-16"
    where idCohorte = 1243;


# Ejercicio 4
select * from alumnos
	where idAlumno = 165;

update alumnos
	set apellido = "Ramirez"
    where idAlumno = 165;

# Ejercicio 5

select * from alumnos
	where idCohorte = 1243;

# Ejercicio 6

select * from carrera;
select * from instructor;
select * from cohorte;

select idInstructor from cohorte
	where idCarrera = 1;
    
#Traer información específica sin repetidos.
select distinct idInstructor from cohorte
	where idCarrera = 1;

# Traer información conjunta
select distinct # Se establece primero la tabla de la que se va a obtener la información a mostrar
	instructor.idInstructor,
    instructor.nombre,
    instructor.apellido,
    carrera.nombre
    from cohorte # La tabla de la que quiero traer la información
		join instructor # La tabla de la que quiero hacer el join.
		on instructor.idInstructor = cohorte.idInstructor # La caracterísitca en la que quiero hacer el join
        
        join carrera #Segunda tabla que quiero traer.
        on cohorte.idCarrera = carrera.idCarrera # Segundo join que realizo.
    where carrera.idCarrera = 1; # Filtro que realizo.
    
# Ejercicio 7
select * from alumnos
	where idCohorte = 1235;

# Práctica recomendada --> SI consultas de la tabla, puede ser recomendado usar el nombre de las columnas; o limitar el resultado si es la primera vez que se entra a la tabla.
select 
	idAlumno,
    nombre,
    apellido
    from alumnos
    where idCohorte = 1235;

select 
	idAlumno,
    nombre,
    apellido
    from alumnos
    where idCohorte = 1235
    limit 2;

# Ejercicio 8
select * from alumnos
	where idCohorte = 1235 AND year(fechaIngreso) = 2019;

select 
	idAlumno,
    nombre,
    apellido,
    fechaIngreso
    from alumnos
    where idCohorte = 1235 AND year(fechaIngreso) = 2019;

# Ejercicio 9
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
	FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera;

# Conteste la siguientes interrogantes:
#  a. ¿Qué campos permiten que se puedan acceder al nombre de la carrera? --> El ID de la cohorte y el ID de la carrera idCarrera
#  b. ¿Qué tipo de relación existe entre el nombre la tabla cohortes y alumnos? 
	# --> Una relación dada por foreign keys / primary key en id del cohorte. 
	# --> Respuesta 2: Cada cohorte puede tener muchos alumnos, pero un alumno sólo puede estar en una cohorte.
#  c. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando LIKE y NOT LIKE?, ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por qué? --> El código iría tal que

	# Opción 1 
	# ... where carrera.Nombre like "Full%"
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
    FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera
    where carrera.Nombre like "Full%";

#		Opción 2:
#		... where carrera.Nombre not like "Data%"
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
    FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera
    where carrera.Nombre not like "Data%";
	
#		Cualquiera de las dos opciones nos puede dar el resultado, sin embargo, considero que la opción más adecuada es la primera, ya que nos permite encontrar con mayor exactitud lo que queremos.

#  d. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando " = " y " != "?  ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por que? -->
# 		Opción 1: 
# 		... where carrera.Nombre = "Full Stack Developer"
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
    FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera
    where carrera.Nombre = "Full Stack Developer";
#		Opción 2:
#		... where carrera.Nombre != "Data Science"
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
    FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera
    where carrera.Nombre != "Data Science";

#		Cualquiera de las dos opciones nos puede dar el resultado, sin embargo, considero que la opción más adecuada es la primera, ya que nos permite encontrar con mayor exactitud lo que queremos.

#  e. ¿Como emplearía el filtrado utilizando el campo idCarrera? --> 
# 		... where carrera.idCarrera = 1 -- para Full Stack Developer.
SELECT alumnos.nombre, alumnos.apellido, alumnos.fechaNacimiento, carrera.Nombre as "Nombre carrrera" # Se genera un alias para una columna en la consulta
    FROM alumnos
	INNER JOIN cohorte
	ON cohorte.idCohorte = alumnos.idCohorte
	
    INNER JOIN carrera
	ON carrera.idCarrera = cohorte.idCarrera
    where carrera.idCarrera = 1;