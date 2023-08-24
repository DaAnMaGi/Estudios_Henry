create database Clase_5;

use Clase_5;
create table Carrera
(
	IDCarrera int not null auto_increment,
    Nombre varchar(50) NOT NULL,
    primary key (IDCarrera)
);

create table Instructor
(
	ID_Inst int not null auto_increment,
    Cédula_Identidad int not null,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Fecha_Nacimiento date not null,
    Fecha_Incorporación date not null,
    primary key(ID_Inst)
);

create table Cohorte
(
	IDCohorte int not null auto_increment,
    Codigo_Cohorte varchar(50) not null,
    Carrera int not null,
    Fecha_inicio date,
    Fecha_Final date,
    Instructor int not null,
    primary key (IDCohorte),
    foreign key(Carrera) references carrera(IDCarrera),
    foreign key(Instructor) references Instructor(ID_Inst)
);


create table Alumnos
(
	ID_Alum int not null auto_increment,
    Cédula_Identidad int not null,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Fecha_Nacimiento date not null,
    Fecha_Ingreso date not null,
    Cohorte int not null,
    primary key (ID_Alum),
    foreign key (Cohorte) references Cohorte(IDCohorte)
)
