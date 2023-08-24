# crear data bases
create database cohorte_DSPT05_modulo_2;

create database repaso;
drop database repaso;

# Crear tablas
use cohorte_DSPT05_modulo_2;

create table Alumno
(
	id int not Null auto_increment,
	nombre varchar(50),
    edad float,
    primary key (id)
);

show tables;

drop table Alumno

