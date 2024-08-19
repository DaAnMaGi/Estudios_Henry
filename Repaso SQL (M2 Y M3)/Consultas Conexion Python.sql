use gastronomia;

# A partir de tener los datos disponibles, responder a las siguientes preguntas: 
# a) ¿Cuál es el barrio con mayor cantidad de Pubs? 
select count(idRest) as numero, barrio
from restaurantes
where categoria = "PUB"
group by barrio
order by numero desc;

# b) Obtener la cantidad de locales por categoría 
select count(idRest) as numero, categoria
from restaurantes
group by categoria
order by numero asc;

# c) Obtener la cantidad de restaurantes por comuna
select count(idRest) as numero, comuna
from restaurantes
group by comuna
order by numero desc;