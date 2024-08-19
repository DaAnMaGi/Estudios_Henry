# DROP database henry;
# create database henry;

USE henry;

DELETE FROM cohorte
	WHERE idCohorte IN (1245, 1246);
    
UPDATE cohorte
	SET fechaInicio = "2022-05-16"
    WHERE idCohorte = 1243;

SELECT * FROM alumno WHERE idAlumno = 165;
UPDATE alumno
		SET apellido = "Ramirez"
        WHERE idAlumno = 165;
        
# El área de Learning le solicita un listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso.

SELECT * FROM alumno WHERE idCohorte = 1243; -- VERSIÓN 1 
SELECT idAlumno, cedulaIdentidad, nombre, apellido, fechaIngreso FROM alumno WHERE idCohorte = 1243;

# Como parte de un programa de actualización, el área de People le solicita un listado de los instructores que dictan la carrera de Full Stack Developer.

SELECT DISTINCT idInstructor FROM cohorte WHERE idCarrera = 1;

SELECT DISTINCT i.idInstructor, i.cedulaIdentidad, i.nombre, i.apellido, i.fechaNacimiento, i.fechaIncorporacion, h.idCarrera
	FROM instructor i
    JOIN cohorte h ON h.idInstructor = i.idInstructor
    WHERE h.idCarrera = 1;

# Se desea saber que alumnos formaron parte de la cohorte N° 1235. Elabore un listado.

SELECT DISTINCT * FROM alumno WHERE idCohorte = 1235;

# Del listado anterior se desea saber quienes ingresaron en el año 2019.
SELECT DISTINCT * FROM alumno WHERE idCohorte = 1235 AND YEAR(fechaIngreso) = 2019;

# ¿Cuantas carreas tiene Henry? 

SELECT COUNT(*) FROM carrera;

# ¿Cuantos alumnos hay en total?
SELECT distinct count(*) FROM alumno;

# Cuantos alumnos tiene cada cohorte?
select count(*) as "Conteo", idCohorte from alumno group by idCohorte;

# Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.

select idAlumno, concat(nombre," ",apellido) as "Nombre", cedulaIdentidad, fechaNacimiento, fechaIngreso, IdCohorte
from alumno 
order by FechaIngreso desc;

# ¿Cual es el nombre del primer alumno que ingreso a Henry? // ¿En que fecha ingreso?
select concat(nombre, " ", apellido) as "Nombre", fechaIngreso
from alumno 
order by FechaIngreso asc
limit 1;

# ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
select concat(nombre, " ", apellido) as "Nombre", fechaIngreso
from alumno 
order by FechaIngreso desc
limit 1;

# La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.

select count(*) as "Ingresos", year(fechaIngreso) as año
from alumno
group by year(fechaIngreso)
order by año;

# ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
select count(*) as "Ingresos", year(fechaIngreso) as año, weekofyear(fechaIngreso) as semana
from alumno
group by año, semana
order by año, semana;

# ¿En que años ingresaron más de 20 alumnos?
select count(*) as ingresos, year(fechaIngreso) as año
from alumno
group by año
having ingresos > 20
order by año;

# Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().

select nombre, apellido, fechaNacimiento, timestampdiff(YEAR,fechaNacimiento,curdate()) as edad 
from instructor;

# Cálcula:
-- La edad de cada alumno.

select nombre, apellido, fechaNacimiento, timestampdiff(YEAR,fechaNacimiento,curdate()) as edad 
from alumno;

-- La edad promedio de los alumnos de henry.

select round(avg(timestampdiff(YEAR,fechaNacimiento,curdate())),0) from alumno;

-- La edad promedio de los alumnos de cada cohorte.
select idCohorte, round(avg(timestampdiff(YEAR,fechaNacimiento,curdate())),0) as edadPromedio
from alumno
group by idCohorte
order by idCohorte;

# Elabora un listado de los alumnos que superan la edad promedio de Henry.
select nombre, apellido, fechaNacimiento, timestampdiff(YEAR,fechaNacimiento,curdate()) as edad 
from alumno
having edad > 34;
