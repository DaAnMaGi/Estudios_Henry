create database Clase_5;

use Clase_5;
drop table alumnos;
drop table cohorte;
drop table instructor;
drop table carrera;

create table Carrera
(
	idCarrera int not null auto_increment,
    Nombre varchar(50) NOT NULL,
    primary key (idCarrera)
);

create table Instructor
(
	idInstructor int not null auto_increment,
    cedulaIdentidad int not null,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Fecha_Nacimiento date not null,
    Fecha_Incorporación date,
    primary key(idInstructor)
);

create table cohorte
(
	idCohorte int not null auto_increment,
    codigo varchar(50) not null,
    idCarrera int not null,
    idInstructor int not null,
    fechainicio date,
    fechaFinal date,
    
    primary key (idCohorte),
    foreign key(idCarrera) references carrera(idCarrera),
    foreign key(idInstructor) references Instructor(idInstructor)
);


create table alumnos
(
	idAlumno int not null auto_increment,
    cedulaIdentidad int not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    fechaNacimiento date not null,
    fechaIngreso date,
    idCohorte int,
    
    primary key (idAlumno),
    foreign key (idCohorte) references cohorte(idCohorte)
)

