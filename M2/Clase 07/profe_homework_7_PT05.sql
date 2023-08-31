use henry;
-- 1. ¿Cuantas carreas tiene Henry?
select count(idCarrera) as 'Cantidad de carreras'
from carrera;



-- 2. ¿Cuantos alumnos hay en total?
select count(idAlumno) as 'Cantidad de alumnos'
from alumno;




-- 3. ¿Cuantos alumnos tiene cada cohorte?
select idCohorte, count(idAlumno) from alumno
group by idCohorte;

select 
	cohorte.codigo,
    count(idAlumno) 
from alumno
	join cohorte
	on cohorte.idCohorte = alumno.idCohorte
group by alumno.idCohorte;



-- 5. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, 
-- con nombre y apellido en un solo campo.
select 
concat(nombre, ' ', apellido) as 'Nombre completo',
fechaIngreso as 'Fecha de ingreso'
from alumno
order by fechaIngreso desc;






-- 6. ¿Cual es el nombre del primer alumno que ingreso a Henry?
-- ¿En que fecha ingreso?
select nombre, apellido, fechaIngreso 
from alumno 
order by fechaIngreso
limit 1;



-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
select nombre, apellido, fechaIngreso 
from alumno 
order by fechaIngreso desc
limit 1;




-- 8. La función YEAR le permite extraer el año de un campo date, 
-- utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.
select 
year(fechaIngreso) as 'Año de ingreso',
count(idAlumno) as 'Cantidad de alumnos'
from alumno
group by year(fechaIngreso)
order by year(fechaIngreso);




-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
select 
year(fechaIngreso) as 'Año',
weekofyear(fechaIngreso) as 'semana',
count(idAlumno) as 'Cantidad de alumnos'
from alumno
group by year(fechaIngreso), weekofyear(fechaIngreso)
order by year(fechaIngreso), weekofyear(fechaIngreso);



-- 10. ¿En que años ingresaron más de 20 alumnos?
select 
year(fechaIngreso) as 'Año de ingreso',
count(idAlumno) as 'Cantidad de alumnos'
from alumno
group by year(fechaIngreso)
having count(idAlumno) > 20
order by year(fechaIngreso);


-- 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE(). 
-- ¿Podría utilizarlas para saber cual es la edad de los instructores?
select 
nombre, 
apellido, 
fechaNacimiento as 'fecha nacimiento',
timestampdiff(year, fechaNacimiento, curdate()) as 'edad'
from instructor
order by edad;





-- 12. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().
select 
nombre, 
apellido, 
fechaNacimiento as 'fecha nacimiento',
timestampdiff(year, fechaNacimiento, curdate()) as edad,
date_add(fechaNacimiento, INTERVAL timestampdiff(year, fechaNacimiento, curdate()) YEAR)
from instructor
order by edad;

-- 13. Calcula:
-- La edad de cada alumno.
select
nombre,
apellido,
fechaNacimiento,
timestampdiff(year, fechaNacimiento, curdate()) as edad
from alumno;




    
-- 15. La edad promedio de los alumnos de henry.
select
avg(timestampdiff(year, fechaNacimiento, curdate())) as 'edad promedio'
from alumno
where fechaNacimiento not in 
(select min(fechaNacimiento) from alumno); -- Filtramos la fila con fechaNacimiento errónea

select * from alumno
where fechaNacimiento in 
(select min(fechaNacimiento) from alumno);


select max(timestampdiff(year, fechaNacimiento, curdate())) from alumno;

-- 16. La edad promedio de los alumnos de cada cohorte.
select
idCohorte,
round(avg(timestampdiff(year, fechaNacimiento, curdate())), 2) as 'edad promedio'
from alumno
where fechaNacimiento not in 
(select min(fechaNacimiento) from alumno)
group by idCohorte; 


-- 17. Elabora un listado de los alumnos que superan la edad promedio de Henry.
select 
	nombre,
	apellido,
timestampdiff(year, fechaNacimiento, curdate()) as edad
from alumno
where timestampdiff(year, fechaNacimiento, curdate()) > (
	select avg(timestampdiff(year, fechaNacimiento, curdate()) ) 
    from alumno
    where fechaNacimiento not in (
		select min(fechaNacimiento) from alumno
        )
)
and fechaNacimiento not in 
(select min(fechaNacimiento) from alumno);