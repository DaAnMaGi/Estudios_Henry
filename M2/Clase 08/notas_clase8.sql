use clase_5;
select * from alumnos;

create database prueba_clase8;
use prueba_clase8;

drop table prueba;

create table prueba (
	idPersona int not null auto_increment,
    nombre varchar(50) not null,
    edad varchar(10) not null,
    primary key(idPersona)
    );
    
    select * from prueba;