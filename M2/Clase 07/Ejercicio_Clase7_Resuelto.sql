use clase_5;

## Homework

# 1. ¿Cuantas carreas tiene Henry?

select count(*) as n_carreras
	from carrera; #Respuesta es 2 carreras

# 2. ¿Cuantos alumnos hay en total?

select count(*) as n_alumnos 
	from alumnos; # Respuesta es 180 alumnos

# 3. ¿Cuantos alumnos tiene cada cohorte?

select idCohorte, count(*) as n_alumnos
	from alumnos
    group by idCohorte;

# 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.

select concat(nombre," ",apellido) as Nombre_Completo,fechaIngreso
	from alumnos
    order by fechaIngreso desc;

# 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?

select concat(nombre," ",apellido) as Nombre_Completo,fechaIngreso
	from alumnos
    order by fechaIngreso
    limit 1; # Respuesta es "Beverly Gardner"
    
# 6. ¿En que fecha ingreso?

# Respuesta es "2019-12-04".

# 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?

select concat(nombre," ",apellido) as Nombre_Completo,fechaIngreso
	from alumnos
    order by fechaIngreso desc
    limit 1; #El nombre del estudiante es "Jason Harmon"

# 8. La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.

select year(fechaIngreso) as año_ingreso, count(*) as n_Estudiantes
	from alumnos
    group by año_ingreso
    order by año_ingreso;

# 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()

select  year(fechaIngreso) as Año, weekofyear(fechaIngreso) as semana, count(*) as n_estudiantes
	from alumnos
    group by año, semana
    order by año;

# 10. ¿En que años ingresaron más de 20 alumnos?

select year(fechaIngreso) as año_ingreso, count(*) as n_Estudiantes
	from alumnos
    group by año_ingreso
    having n_Estudiantes > 20
    order by año_ingreso;

# 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().

select 
	timestampdiff(year,Fecha_Nacimiento,curdate()) as edad_instructor, Nombre,Apellido
	from instructor;

# 12. Cálcula:<br>
#            - La edad de cada alumno.<br>

select concat(nombre," ",apellido) as Nombre_Completo, timestampdiff(year,fechaNacimiento,curdate()) as Edad_estudiante
	from alumnos;

#            - La edad promedio de los alumnos de henry.<br>

select round(avg(timestampdiff(year,fechaNacimiento,curdate()))) as Promedio_Edad
	from alumnos;

#            - La edad promedio de los alumnos de cada cohorte.<br>

select idCohorte, round(avg(timestampdiff(year,fechaNacimiento,curdate()))) as Promedio_Edad
	from alumnos
    group by idCohorte;

# 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.

select 
	year(fechaNacimiento) as Año_Nacimiento, concat(nombre," ",apellido) as Nombre_Completo, timestampdiff(year,fechaNacimiento,curdate()) as Edad_Estudiante
	from alumnos
    where timestampdiff(year,fechaNacimiento,curdate()) > (select round(avg(timestampdiff(year,fechaNacimiento,curdate()))) as Promedio_Edad
		from alumnos)
	order by 1;