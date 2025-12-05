/*

1. Obtener las películas que tengan un director asociado. Mostrar el título de la pelicula, el año de estreno y el nombre del director. Ordena por película.

    SELECT m.title, m.release_year, p.name
    FROM movies m
    JOIN people p
    ON m.director_id = p.people_id
    ORDER BY m.title

2. Obtener las películas que tengan un estudio asociado. Mostrar el título de la película y el estudio. Ordena por nombre de estudio.

    SELECT m.title as Pelicula, s.studio_name AS Estudio
    FROM movies m
    JOIN studios s
    ON m.studio_id = s.studio_id
    ORDER BY s.studio_name

3. Obtener las películas junto con el estudio que las produjo (tengan o no un estudio asociado), ordenadas por nombre de película.

    SELECT m.title as Pelicula, s.studio_name AS Estudio
    FROM movies m
    LEFT JOIN studios s
    ON m.studio_id = s.studio_id
    ORDER BY m.title

4. Obtener los nombres de los actores y las películas en las que han participado. Ordena por actor y película.

    SELECT p.name, m.title
    FROM movie_actor ma
    JOIN people p ON ma.actor_id = p.people_id
    JOIN movies m ON ma.movie_id = m.movie_id
    ORDER BY p.name , m.title

5. Obtener la lista de las películas con sus géneros asociados. Ordena por película.

    SELECT m.title, g.genre_name
    FROM movies m
    JOIN movie_genre mg ON m.movie_id = mg.movie_id
    JOIN genres g ON g.genre_id = mg.genre_id
    ORDER BY m.title

6. Obtener todas las películas de un director específico (por ejemplo, "Christopher Nolan").

    SELECT m.title
    FROM movies m
    JOIN people p ON m.director_id = p.people_id
    WHERE p.name = 'Christopher Nolan'

7. Obtener los actores que han participado en películas de "Aventura" o "Terror".

    SELECT DISTINCT p.name AS Actor
    FROM movies m
    JOIN movie_genre mg ON m.movie_id = mg.movie_id
    JOIN genres g ON g.genre_id = mg.genre_id
    JOIN movie_actor ma ON m.movie_id = ma.movie_id
    JOIN people p ON ma.actor_id = p.people_id
    WHERE g.genre_name IN ('Aventura', 'Terror')

8. Obtener los estudios de cine y la cantidad de películas producidas por cada uno. Ordenado por cantidad descendente.

    SELECT s.studio_name, COUNT(m.movie_id) AS Cantidad_peliculas
    FROM studios s
    JOIN movies m ON s.studio_id = m.studio_id
    GROUP BY s.studio_name
    ORDER BY Cantidad_peliculas DESC

9. Obtener el total de películas por cada género (incluir los géneros que no tengan películas asociadas).

    SELECT g.genre_name AS Genero, COUNT(m.title) AS Numero_peliculas
    FROM genres g
    LEFT JOIN movie_genre mg ON g.genre_id = mg.genre_id
    LEFT JOIN movies m ON m.movie_id = mg.movie_id
    GROUP BY g.genre_name

10. Obtener las películas que ganaron el premio "Oscar" o "Globo de Oro" a "Mejor Película". 
	- Mostrar el nombre de la película, el director, el estudio y año de estreno. 
    - Ten en cuenta que las películas sin director o estudio asociado deben también mostrarse en el resultado.

    SELECT m.title As Pelicula, p.name AS Director,s.studio_name AS Estudio, m.release_year AS Año_Estreno, a.award_name AS Premio
    FROM movies m
    JOIN movie_award ma ON m.movie_id = ma.movie_id
    JOIN awards a ON ma.award_id = a.award_id
    LEFT JOIN people p ON m.director_id = p.people_id
    LEFT JOIN studios s ON m.studio_id = s.studio_id
    WHERE a.award_name IN ('Oscar Mejor Pelicula', 'Globo de Oro Mejor Pelicula')

11. Obtiene las películas que tienen reviews, mostrando nombre de la película y cantidad de reviews que tiene.

    SELECT DISTINCT m.title AS PELICULA, COUNT(mr.movie_id) AS Cantidad_reviews
    FROM movies m
    JOIN movie_review mr ON m.movie_id = mr.movie_id
    GROUP BY m.title

12. Obtiene la suma total de espectadores de películas producidas por "Warner Bros".

    SELECT SUM(m.total_viewers) AS Total_Viewers
    FROM movies m
    JOIN studios s ON m.studio_id = s.studio_id
    WHERE s.studio_name = 'Warner Bros'

13. Obtener todos los premios de cada película: 
	- Mostrar "nombre premio: título de la película (año estreno)" en la misma columna. 
    - Si el año de estreno es nulo, mostrar "Sin Especificar".
    - Ordenar por película.

    SELECT CONCAT(a.award_name, ': ', m.title, '(', IFNULL(m.release_year, 'Sin especificar'), ')') AS Peliculas_Premio
    FROM movies m
    JOIN movie_award ma ON m.movie_id = ma.movie_id
    JOIN awards a ON a.award_id = ma.award_id
    ORDER BY m.title

14. Obtener las películas que obtuvieron más de un premio.

    SELECT m.title AS Pelicula, COUNT(ma.award_id) AS Cantidad_premios
    FROM movies m
    JOIN movie_award ma ON m.movie_id = ma.movie_id
    GROUP BY m.title
    HAVING Cantidad_premios > 1

15. Obtener las películas que obtuvieron uno o ningun premio.

    SELECT m.title AS Pelicula, COUNT(ma.award_id) AS Cantidad_premios
    FROM movies m
    LEFT JOIN movie_award ma ON m.movie_id = ma.movie_id
    GROUP BY m.title
    HAVING Cantidad_premios < 2

16. Obtener los actores que participaron en ninguna o dos películas.

    SELECT p.name AS Nombre, COUNT(ma.movie_id) AS Total_peliculas
    FROM people p
    LEFT JOIN movie_actor ma ON p.people_id = ma.actor_id
    WHERE p.category = 'Actor'
    GROUP BY p.people_id
    HAVING Total_peliculas IN (0, 2)

17. Obtener las personas que no tienen películas asociadas.

    SELECT p.name AS Nombre, p.category AS Categoria, COUNT(ma.movie_id) AS Total_peliculas
    FROM people p
    LEFT JOIN movie_actor ma ON p.people_id = ma.actor_id
    LEFT JOIN movies m ON p.people_id = m.director_id
    GROUP BY p.people_id
    HAVING Total_peliculas = 0
    AND COUNT(m.movie_id) = 0

    ------- Otra solución menos eficiente

    SELECT p.name AS 'Actor / Director'
    FROM people p
    LEFT JOIN movies m ON m.director_id = p.people_id
    WHERE p.category = 'Director' AND m.director_id IS NULL
    UNION
    SELECT p.name AS 'Actor / Director'
    FROM people p
    LEFT JOIN movie_actor ma ON ma.actor_id = p.people_id
    WHERE p.category = 'Actor' AND ma.movie_id IS NULL    
    ORDER BY 1;



18. Obtener las reviews de las películas "Gladiator" y "The Matrix".

    SELECT m.title AS Pelicula, mr.review_text AS Review, mr.review_timestamp AS Fecha 
    FROM movie_review mr
    JOIN movies m ON mr.movie_id = m.movie_id
    WHERE m.title IN ('Gladiator', 'The Matrix')

19. Obtener los nombres de países que no estén asociados a ninguna persona.

    SELECT c.country_name
    FROM countries c
    LEFT JOIN people p ON c.country_id = p.country_of_birth_id
    WHERE p.people_id IS NULL

    Otra solución:

    SELECT c.country_name, COUNT(p.people_id)
    FROM countries c
    LEFT JOIN people p ON c.country_id = p.country_of_birth_id
    GROUP BY c.country_name
    HAVING COUNT(p.people_id) = 0

20. Obtener el país de nacimiento de todas las personas. Mostrar "No Especificado" si no hay datos. Ordena por nombre.

    SELECT p.name AS Nombre, IFNULL(c.country_name, 'No especificado') AS País
    FROM people p
    LEFT JOIN countries c ON c.country_id = p.country_of_birth_id
    ORDER BY p.name

*/ 

-- Soluciones

-- 1. 
SELECT m.title AS Película, m.release_year AS 'Año Estreno', p.name AS Director
FROM movies m
INNER JOIN people p ON m.director_id = p.people_id
ORDER BY m.title;
   
-- 2. 
SELECT m.title AS Película, s.studio_name AS Estudio
FROM movies m
INNER JOIN studios s ON m.studio_id = s.studio_id
ORDER BY s.studio_name;

-- 3. 
SELECT m.title AS Película, s.studio_name AS Estudio
FROM movies m
LEFT JOIN studios s ON m.studio_id = s.studio_id
ORDER BY m.title;
   
-- 4. 
SELECT p.name AS Actor, m.title AS Película
FROM people p
INNER JOIN movie_actor ma ON p.people_id = ma.actor_id
INNER JOIN movies m ON ma.movie_id = m.movie_id
ORDER BY p.name, m.title; 

-- 5. 
SELECT m.title AS Película, g.genre_name AS Genero
FROM movies m
INNER JOIN movie_genre mg ON m.movie_id = mg.movie_id
INNER JOIN genres g ON mg.genre_id = g.genre_id
ORDER BY m.title;

-- 6. 
SELECT m.title AS Película
FROM movies m
INNER JOIN people p ON m.director_id = p.people_id
WHERE p.name = 'Christopher Nolan';

-- 7. 
SELECT DISTINCT p.name AS Actor
FROM people p
INNER JOIN movie_actor ma ON p.people_id = ma.actor_id
INNER JOIN movies m ON ma.movie_id = m.movie_id
INNER JOIN movie_genre mg ON m.movie_id = mg.movie_id
INNER JOIN genres g ON mg.genre_id = g.genre_id
WHERE g.genre_name IN ('Aventura', 'Terror');

-- 8. 
SELECT s.studio_name AS Estudio, COUNT(m.movie_id) AS Cantidad_peliculas
FROM studios s
LEFT JOIN movies m ON s.studio_id = m.studio_id
GROUP BY s.studio_name
ORDER BY Cantidad_peliculas DESC;

-- 9. 
SELECT g.genre_name AS Género, COUNT(movie_id) AS Total_películas
FROM movie_genre mg
RIGHT JOIN genres g ON mg.genre_id = g.genre_id
GROUP BY g.genre_name;

-- 10. 
SELECT m.title AS Película, p.name AS Director, s.studio_name AS Estudio, m.release_year AS 'Año Estreno' 
FROM movies m  
LEFT JOIN people p ON m.director_id = p.people_id  
LEFT JOIN studios s ON m.studio_id = s.studio_id  
INNER JOIN movie_award maw ON m.movie_id = maw.movie_id  
INNER JOIN awards a ON maw.award_id = a.award_id  
WHERE a.award_name = 'Globo de Oro Mejor Actor';

-- 11. 
SELECT m.title AS Película, COUNT(mr.movie_id) as 'Cantidad reviews'
FROM movies m
INNER JOIN movie_review mr 
ON m.movie_id = mr.movie_id
GROUP BY m.title;   

-- 12. 
SELECT SUM(m.total_viewers) AS 'Total Espectadores'
FROM movies m
INNER JOIN studios s ON m.studio_id = s.studio_id
WHERE s.studio_name = 'Warner Bros';
    
-- 13. 
SELECT CONCAT(a.award_name, ': ', m.title, ' (', IFNULL(m.release_year, 'Sin especificar'), ')') AS Premio  
FROM movies m  
INNER JOIN movie_award maw ON m.movie_id = maw.movie_id
INNER JOIN awards a ON maw.award_id = a.award_id
ORDER BY m.title;
    
-- 14. 
SELECT m.title AS Película, COUNT(maw.award_id) AS Total_premios  
FROM movies m  
INNER JOIN movie_award maw ON m.movie_id = maw.movie_id  
GROUP BY m.title  
HAVING COUNT(maw.award_id) > 1;

-- 15. 
SELECT m.title AS Película, COUNT(maw.award_id) AS Total_premios  
FROM movies m  
LEFT JOIN movie_award maw ON m.movie_id = maw.movie_id  
GROUP BY m.title  
HAVING COUNT(maw.award_id) <= 1;

-- 16. 
SELECT p.name AS Actor, COUNT(ma.movie_id) AS Cantidad_peliculas  
FROM people p  
LEFT JOIN movie_actor ma ON p.people_id = ma.actor_id  
WHERE p.category = 'Actor'
GROUP BY p.name  
HAVING COUNT(ma.movie_id) = 0 OR COUNT(ma.movie_id) = 2;     

-- 17. 
SELECT p.name AS 'Actor / Director'
FROM people p
LEFT JOIN movies m ON m.director_id = p.people_id
WHERE p.category = 'Director' AND m.director_id IS NULL
UNION
SELECT p.name AS 'Actor / Director'
FROM people p
LEFT JOIN movie_actor ma ON ma.actor_id = p.people_id
WHERE p.category = 'Actor' AND ma.movie_id IS NULL    
ORDER BY 1;

-- 18. 
SELECT m.title, mr.review_text, mr.review_timestamp
FROM movies m
INNER JOIN movie_review mr ON m.movie_id = mr.movie_id
WHERE m.title IN ('Gladiator', 'The Matrix');   

-- 19. 
SELECT c.country_name AS País
FROM countries c
LEFT JOIN people p ON c.country_id = p.country_of_birth_id
WHERE p.country_of_birth_id IS NULL
ORDER BY c.country_name;

-- 20. 
SELECT p.name AS Nombre, 
IFNULL(c.country_name, 'No Especificado') AS País_nacimiento
FROM people p  
LEFT JOIN countries c ON p.country_of_birth_id = c.country_id
ORDER BY p.name;