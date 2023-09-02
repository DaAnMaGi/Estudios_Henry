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
	count(distinct first_name) #El distinct se coloca al lado de aquello que queremos señalar como único.
	from customer; -- 591 distinct counts

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
	concat(A.first_name," ",A.last_name) as "Nombre actor/actriz",
    count(FA.film_id) as "Número de películas"
    from actor A
    
    join film_actor FA
		on A.actor_id = FA.actor_id
    join film F
		on FA.film_id = F.film_id
	where f.release_year = 2006
    group by A.actor_id
    order by count(FA.film_id) desc
    limit 1;
    
# 5) ¿Cuál es la categoría de la película HAWK CHILL y su duración?
	
    select * from film where title like "%HAWK CHILL%"; -- 407
    
    select 
		f.film_id as "ID", 
        f.title as "Nombre película",
        f.length as "Duración",
        c.name as "Categoría"
        
        from film f
        join film_category fc
        on f.film_id = fc.film_id
        join category c
        on fc.category_id = c.category_id
        where f.title like "HAWK CHILL";

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