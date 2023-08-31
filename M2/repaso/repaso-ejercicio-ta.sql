use sakila;

select * from actor;
select * from address;
select * from category;
select * from city;
select * from country;
select * from customer;
select * from film;
select * from film_actor;
select * from film_category;
select * from film_text;
select * from inventory;
select * from language;
select * from payment;
select * from rental;
select * from staff;
select * from store;

# 1) ¿Cuántos nombres distintos hay en la columna first_name en la tabla customer?

select 
	distinct count(first_name)
	from customer; -- 599

# 2) ¿Cuál es el título de la película mas larga en la tabla film?

select 
	title as nombre,
    length as duracion
    from film
    order by duracion desc
    limit 10;

# 3) ¿Qué store tiene mas clientes?

select 
	store.store_id as "Tienda" , 
    count(customer.first_name) as "Número de clientes"
    from store
    join customer
    on store.store_id = customer.store_id
	group by store.store_id
    order by store.store_id;
    
# 4) ¿Cuál es el nombre del actor/actriz que salió en más películas durante el año 2006?

select 
	concat(actor.first_name," ",actor.last_name) as "Nombre actor/actriz",
    count(film_actor.film_id) as "Número de películas"
    from actor
    join film_actor
    on actor.actor_id = film_actor.actor_id
	group by actor.actor_id
    order by count(film_actor.film_id) desc
    limit 1;
    
# 5) ¿Cuál es la categoría de la película HAWK CHILL y su duración?
	
    select * from film where title like "%HAWK CHILL%"; -- 407
    
    select 
		film.film_id as "ID", 
        film.title as "Nombre película",
        film.length as "Duración",
        category.name as "Categoría"
        
        from film 
        join film_category
        on film.film_id = film_category.film_id
        join category
        on film_category.category_id = category.category_id
        where film.title like "%HAWK CHILL%";

# Bonus) ¿En que películas participo KIM ALLEN y cuál es su promedio de duración?

select * from actor where first_name like "%KIM%"; -- 145

select 
	actor.actor_id as "ID",
    concat(actor.first_name," ",actor.last_name) as "Nombre completo",
    film.title as "Nombre película",
    film.length as "Duración"
	
    from actor
    join film_actor
    on film_actor.actor_id = actor.actor_id
    join film
    on film.film_id = film_actor.film_id
    where actor.actor_id = 145;
    
select 
	actor.actor_id as "ID",
    concat(actor.first_name," ",actor.last_name) as "Nombre completo",
    count(film_actor.film_id) as "Número de películas"
    from actor
    join film_actor
    on film_actor.actor_id = actor.actor_id
    where actor.actor_id = 145;
    
select 
	actor.actor_id as "ID",
    concat(actor.first_name," ",actor.last_name) as "Nombre completo",
    round(avg(film.length),2) as "Promedio duración películas"
	
    from actor
    join film_actor
    on film_actor.actor_id = actor.actor_id
    join film
    on film.film_id = film_actor.film_id
    where actor.actor_id = 145;