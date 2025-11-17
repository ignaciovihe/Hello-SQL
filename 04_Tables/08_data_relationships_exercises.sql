/*

1. Asociar los generos "Comedia", "Acción" y "Ciencia Ficción" a la película "Avatar".

  SELECT movie_id FROM movies WHERE title = 'Avatar';
  SELECT * FROM genres WHERE genre_name in ('Comedia', 'Acción', 'Ciencia Ficción');
  INSERT INTO movie_genre (movie_id, genre_id) VALUES (19,8), (19,2), (19,1)

2. Relaciona a los actores Sam Worthington y Al Pacino con la película "Avatar".

  SELECT * FROM movies WHERE title = 'Avatar';
  SELECT * FROM people WHERE name IN ('Al Pacino', 'Sam Worthington');
  INSERT INTO movie_actor (movie_id, actor_id) VALUES (19, 2), (19,74)

3. Utilizando Subqueries, cambia el genero "Comedia" por "Aventura" en la película "Avatar".

  UPDATE movie_genre SET genre_id = (SELECT genre_id FROM genres WHERE genre_name = 'Aventura') 
  WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar') 
  AND genre_id = (SELECT genre_id FROM genres WHERE genre_name = 'Comedia')

4. Utilizando Subqueries, elimina al actor Al Pacino de la película "Avatar".

  DELETE FROM movie_actor 
  WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar')
  AND actor_id = (SELECT people_id FROM people WHERE name = 'Al Pacino')

5. Trata de eliminar "Avatar" de la tabla peliculas. Revisa que sucede.

  DELETE FROM movies WHERE title = 'Avatar' -- Error Foreign Key Constraint

6. Elimina todas las relaciones de la película "Avatar" (actores y generos).

  DELETE FROM movie_actor WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar');
  DELETE FROM movie_genre WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar')

7. Trata de eliminar nuevamente "Avatar" de la tabla peliculas.

  DELETE FROM movies WHERE title = 'Avatar' -- Se borra sin error.

8. Utilizando Subqueries, elimina la relación de los géneros "Infantil" y "Animación" de todas las películas.

  DELETE FROM movie_genre WHERE genre_id IN (SELECT genre_id FROM genres WHERE genre_name IN ('Infantil', 'Animación'))

9. Elimina todas las películas que no tengan actores y géneros asociados.

    DELETE FROM movies WHERE movie_id NOT IN (SELECT DISTINCT movie_id FROM movie_genre)
					  AND movie_id NOT IN (SELECT DISTINCT movie_id FROM movie_actor);

10. Inserta 2 reviews para la película "Gladiator" y 1 review para la película "Titanic".

  SELECT movie_id , title FROM movies WHERE title IN ('Gladiator', 'Titanic');
  INSERT INTO movie_review (movie_id, review_text, review_timestamp) 
  VALUES (16, 'Review 1','2000-07-16 14:45:00'),
	       (16, 'Review 2','2000-05-06 12:30:45'), 
         (6, 'Review 1','1998-04-14 17:15:00')

11. Inserta 3 reviews para la película "The Matrix" sin ingresar la fecha y hora de la review.

  SELECT movie_id , title FROM movies WHERE title = 'The Matrix';
  INSERT INTO movie_review (movie_id, review_text) 
  VALUES (18, 'Review 1 The Matrix'),
         (18, 'Review 2 The Matrix'), 
         (18, 'Review 3 The Matrix')

12. Inserta los siguientes premios:
    - Oscar Mejor Película
	- Oscar Mejor Director
    - Oscar Mejor Actor
    - Globo de Oro Mejor Película
    - Globo de Oro Mejor Director
    - Globo de Oro Mejor Actor

      INSERT INTO awards (award_name) 
      VALUES ('Oscar Mejor Película'),
            ('Oscar Mejor Director'),
            ('Oscar Mejor Actor'),
            ('Globo de Oro Mejor Película'),   
            ('Globo de Oro Mejor Director'),
            ('Globo de Oro Mejor Actor');

13. Asocia los siguientes premios a las películas:
	- Oscar Mejor Película:
		- Gladiator
		- Schindler’s List
		- Titanic
    - The Godfather
		- Alien
	- Oscar Mejor Director:
		- Titanic
    - The Matrix
  - Oscar Mejor Actor:
		- Barbie
    - Jurassic Park
	- Globo de Oro Mejor Película:
		- Fight Club
		- Gladiator
  - Globo de Oro Mejor Director:
		- The Dark Knight
		- Gladiator
		- Edward Scissorhands
  - Globo de Oro Mejor Actor:
		- The Irishman
		- Alien

    SELECT movie_id, title FROM movies WHERE title IN ('Gladiator', 'Schindler’s List', 'Titanic', 'The Godfather', 'Alien', 'The Matrix', 'Barbie', 'Jurassic Park', 'Fight Club', 'The Dark Knight', 'Edward Scissorhands', 'The Irishman');
    SELECT * FROM awards;
    INSERT INTO movie_award (movie_id, award_id) VALUES
        (16,1), (17,1), (6,1), (13,1), (7,1),
        (6,2), (18,2),
        (10,3), (5,3),
        (15,4), (16,4),
        (11,5), (16,5), (8,5),
        (3,6), (7,6)

*/        

-- Soluciones

-- 1. 
SELECT movie_id FROM movies WHERE title = 'Avatar'; 
SELECT genre_id, genre_name FROM genres WHERE genre_name IN ('Comedia', 'Acción', 'Ciencia Ficción'); 
INSERT INTO movie_genre (movie_id, genre_id) VALUES (19, 8), (19, 2), (19, 1);

-- 2. 
SELECT people_id, name FROM people WHERE name IN ('Sam Worthington', 'Al Pacino');
INSERT INTO movie_actor (movie_id, actor_id) VALUES (19, 74), (19, 2);

-- 3. 
UPDATE movie_genre SET genre_id = (SELECT genre_id FROM genres WHERE genre_name = 'Aventura') 
 WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar') 
   AND genre_id = (SELECT genre_id FROM genres WHERE genre_name = 'Comedia');

-- 4. 
DELETE FROM movie_actor WHERE actor_id = (SELECT people_id FROM people WHERE name = 'Al Pacino') AND movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar');

-- 5. 
DELETE FROM movies WHERE title = 'Avatar'; -- Error Foreign Key Constraint

-- 6. 
DELETE FROM movie_actor WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar');
DELETE FROM movie_genre WHERE movie_id = (SELECT movie_id FROM movies WHERE title = 'Avatar');

-- 7. 
DELETE FROM movies WHERE title = 'Avatar';      

-- 8. 
DELETE FROM movie_genre WHERE genre_id IN (SELECT genre_id FROM genres WHERE genre_name IN ('Infantil', 'Animación'));

-- 9. 
DELETE FROM movies WHERE movie_id NOT IN (SELECT DISTINCT movie_id FROM movie_actor) AND movie_id NOT IN (SELECT DISTINCT movie_id FROM movie_genre);

-- 10. 
SELECT movie_id, title FROM movies WHERE title IN ('Gladiator','Titanic');
INSERT INTO movie_review (movie_id, review_text, review_timestamp) 
VALUES (16, 'Review 1 de Gladiador', '2000-07-16 14:45:00'),
       (16, 'Review 2 de Gladiador', '2000-05-06 12:30:45'),
       (6, 'Review 1 de Titanic', '1998-04-14 17:15:00'); 

-- 11. 
SELECT movie_id FROM movies WHERE title = 'The Matrix'; 
INSERT INTO movie_review (movie_id, review_text) 
VALUES (18, 'Review 1 de Matrix'),
       (18, 'Review 2 de Matrix'),
       (18, 'Review 3 de Matrix');     

-- 12. 
INSERT INTO awards (award_name) 
VALUES ('Oscar Mejor Película'),
   	   ('Oscar Mejor Director'),
       ('Oscar Mejor Actor'),
       ('Globo de Oro Mejor Película'),   
       ('Globo de Oro Mejor Director'),
       ('Globo de Oro Mejor Actor');

-- 13. 
SELECT movie_id, title FROM movies WHERE title IN ('Gladiator', 'Titanic', 'Schindler’s List', 'The Godfather', 'Fight Club', 'The Matrix', 'The Dark Knight', 'Alien', 'Barbie', 'Jurassic Park', 'The Irishman');
SELECT * FROM awards;
INSERT INTO movie_award (movie_id, award_id) 
VALUES (16, 1), (17, 1), (6, 1), (13, 1), (7, 1), 
       (6, 2), (18, 2),
       (10, 3), (5, 3),
       (15, 4), (16, 4),
       (11, 5), (8, 5), (16, 5),
       (3, 6), (7, 6);