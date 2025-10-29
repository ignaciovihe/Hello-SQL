/*

1. Insertar tres nuevos géneros de película llamados "Musical", "Bélico", "Infantil".

    INSERT INTO genres (genre_name) VALUES ('Musical'), ('Bélico'), ('Infantil')

2. Insertar un nuevo estudio de cine llamado "Pixar Animation".

    INSERT INTO studios (studio_name) VALUES ('Pixar Animation')

3. Inserta cuatro nuevos países (Argentina, Uruguay, Chile y España).

    INSERT INTO countries (country_name) VALUES ('Argentina'), ('Uruguay'), ('Chile'), ('España')

4. Insertar una nueva película:
    - Nombre: Avatar
    - Año Estreno: 2009
    - Director: Steven Spielberg
    - Estudio: 20th Century Fox
    - Total Espectadores: 331000000
    - Total Recaudación: 2923706026

    SELECT people_id FROM people WHERE name = "Steven Spielberg";
    SELECT studio_id FROM studios WHERE studio_name = "20th Century Fox";
    INSERT INTO movies (title, release_year, director_id, studio_id, total_viewers, total_revenue) 
    VALUES ('Avatar', 2009, 63, 6, 331000000, 2923706026)

5. Insertar un nuevo actor:
    - Nombre: Sam Worthington
    - Fecha Nacimiento: 22 de Agosto de 1976
    - Pais: Reino Unido

    SELECT country_id FROM countries WHERE country_name = "Reino Unido";
    INSERT INTO people (name, birth_date, country_of_birth_id, category) 
    VALUES ('Sam Worthington', '1976-08-22', 14, 'Actor')  

6. Actualiza el nombre del estudio "Pixar Animation" a "Disney Studios".

7. Aumentar en 10% la taquilla de todas las películas con recaudación menor a 100 millones.

8. Actualiza la cantidad de espectadores de la película "Fight Club" a 30 millones.

9. Utilizando subqueries, asocia el estudio "Warner Bros" a las películas "Interstellar" y "The Dark Knight".

10. Utilizando subqueries, actualiza el director de la película "Avatar" a James Cameron.

11. Actualiza la fecha de nacimiento de Sam Worthington a 02/08/1976.

12. Actualiza la cantidad de espectadores a 50000000 y la recaudación a 425368238.50 de la película "Django Unchained".

13. Elimina el estudio "Netflix Originals".

14. Elimina Argentina y Uruguay de la tabla de países.

15. Elimina el director "Anthony Russo".

16. Elimina las películas estrenadas en 2017 que hayan tenido menos de 18500000 espectadores.

*/

-- Soluciones

-- 1.
INSERT INTO genres (genre_name) VALUES ('Musical'), ('Bélico'), ('Infantil');

-- 2.
INSERT INTO studios (studio_name) VALUES ('Pixar Animation');

-- 3.
INSERT INTO countries (country_name) VALUES ('Argentina'), ('Uruguay'), ('Chile'), ('España');

-- 4.
SELECT people_id FROM people WHERE name = 'Steven Spielberg';
SELECT studio_id FROM studios WHERE studio_name = '20th Century Fox';
INSERT INTO movies (title, release_year, director_id, studio_id, total_viewers, total_revenue) 
     VALUES ('Avatar', 2009, 63, 6, 331000000, 2923706026);

-- 5. 
SELECT country_id FROM countries WHERE country_name = 'Reino Unido';
INSERT INTO people (name, birth_date, country_of_birth_id, category) 
     VALUES ('Sam Worthington', '1976-08-22', 14, 'Actor');     

-- 6.
UPDATE studios SET studio_name = 'Disney Studios' WHERE studio_name = 'Pixar Animation';

-- 7. 
UPDATE movies SET total_revenue = total_revenue * 1.10 WHERE total_revenue < 100000000;

-- 8. 
UPDATE movies SET total_viewers = 30000000 WHERE title = 'Fight Club';

-- 9. 
UPDATE movies SET studio_id = (SELECT studio_id FROM studios WHERE studio_name = 'Warner Bros') WHERE title in ('Interstellar', 'The Dark Knight');

-- 10. 
UPDATE movies SET director_id = (SELECT people_id FROM people WHERE name = 'James Cameron') WHERE title = 'Avatar';

-- 11. 
UPDATE people SET birth_date = '1976-08-02' WHERE name = 'Sam Worthington';

-- 12. 
UPDATE movies SET total_viewers = 50000000, total_revenue = 425368238.50 WHERE title = 'Django Unchained';

-- 13. 
DELETE FROM studios WHERE studio_name = 'Netflix Originals';

-- 14. 
DELETE FROM countries WHERE country_name IN ('Argentina', 'Uruguay');

-- 15. 
DELETE FROM people WHERE name = 'Anthony Russo' AND category = 'Director';

-- 16. 
DELETE FROM movies WHERE release_year = 2017 AND total_viewers < 18500000;