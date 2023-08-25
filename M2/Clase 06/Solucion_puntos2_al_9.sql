use clase_5;

select * from alumnos;
select * from carrera;
select * from cohorte;
select * from instructor;

# Ejercicio 2

delete from cohorte
	where idCohorte = 1245 or idCohorte = 1246;
    
delete from alumnos
	where idCohorte = 1245 or idCohorte =  1246;
    
# Ejercicio 3

select * from alumnos
	where idCohorte = 1243;

update alumnos
	set fechaIngreso = "2022-05-16"
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
select idInstructor from cohorte
	where idCarrera = 1;

select * from instructor
	where idInstructor = 1 or idInstructor = 2 or idInstructor = 3 or idInstructor = 4 or idInstructor = 5;
    
# Ejercicio 7
select * from alumnos
	where idCohorte = 1235;

# Ejercicio 8
select * from alumnos
	where idCohorte = 1235 AND year(fechaIngreso) = 2019;

# Ejercicio 9
SELECT alumnos.nombre, apellido, fechaNacimiento, carrera.Nombre 
	FROM alumnos
	INNER JOIN cohorte
	ON cohorte = idCohorte
	INNER JOIN carrera
	ON carrera = idCarrera;

# Conteste la siguientes interrogantes:
#  a. ¿Qué campos permiten que se puedan acceder al nombre de la carrera? --> El ID de la cohorte y el ID de la carreraidCarrera
#  b. ¿Qué tipo de relación existe entre el nombre la tabla cohortes y alumnos? --> Una relación dada por foreign keys en id del cohorte y posteriormente en id de carrera.
#  c. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando LIKE y NOT LIKE?, ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por qué? --> El código iría tal que
select * from carrera;
# 		Opción 1: 
# 		... where carrera.Nombre like "Full%"
#		Opción 2:
#		... where carrera.Nombre not like "Data%"

#		Cualquiera de las dos opciones nos puede dar el resultado, sin embargo, considero que la opción más adecuada es la primera, ya que nos permite encontrar con mayor exactitud lo que queremos.

#  d. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando " = " y " != "?  ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por que? -->
# 		Opción 1: 
# 		... where carrera.Nombre = "Full Stack Developer"
#		Opción 2:
#		... where carrera.Nombre != "Data Science"

#		Cualquiera de las dos opciones nos puede dar el resultado, sin embargo, considero que la opción más adecuada es la primera, ya que nos permite encontrar con mayor exactitud lo que queremos.

#  e. ¿Como emplearía el filtrado utilizando el campo idCarrera? --> 
# 		... where carrera.idCarrera = 1 -- para Full Stack Developer.