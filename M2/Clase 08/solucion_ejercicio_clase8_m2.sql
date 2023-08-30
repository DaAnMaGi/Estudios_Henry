create database homework_c8;
use homework_c8;

drop table restaurante;

create table restaurante(
	id_local int not null auto_increment,
    nombre varchar(100) not null,
    categoria varchar(100),
    direccion varchar(100),
    barrio varchar(100),
    comuna varchar (100),
    
    primary key (id_local)
);

select * from restaurante;

# 3) A partir de tener los datos disponibles, responder a las siguientes preguntas:
   # a) ¿Cuál es el barrio con mayor cantidad de Pubs?
   
   select barrio, categoria, count(*) as cantidad
	from restaurante
    group by barrio, categoria
    having categoria = "pub"
    order by cantidad desc
    limit 1;
    
    # La respuesta es Recoleta
   
   # b) Obtener la cantidad de locales por categoría
   
   select categoria, count(*) as cantidad_locales
   from restaurante
   group by categoria
   order by cantidad_locales;
   
   # c) Obtener la cantidad de restaurantes por comuna
   
   select comuna, categoria, count(*) as cantidad
   from restaurante
   group by comuna,categoria
   having categoria = "restaurante"
   order by comuna;