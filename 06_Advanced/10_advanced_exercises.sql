/*

1. Crear una vista llamada "vw_movie" con la siguiente información de todas las películas:
   	- ID de película
    - Nombre de película
    - Año Estreno
    - ID y nombre del director
    - ID y nombre del Estudio 
    - Total de espectadores 
    - Total de recaudaciónm.

   CREATE VIEW vw_movie AS
   SELECT 	m.movie_id AS 'Id_Pelicula', m.title AS 'Pelicula', m.release_year AS 'Año_estreno', m.director_id AS 'Id_Director',
            p.name AS 'Nombre_Director', m.studio_id AS 'ID_Studio', s.studio_name AS 'Nombre_estudio',
            m.total_viewers AS 'Espectadores', m.total_revenue AS 'Recaudación'
   FROM movies m
   LEFT JOIN people p ON m.director_id = p.people_id
   LEFT JOIN studios s ON m.studio_id = s.studio_id

2. Crear una vista llamada "vw_movie_90" con la siguiente información de todas las películas estrenadas en la década del '90:
   	- ID de película
    - Nombre de película
    - Año Estreno
    - Total de espectadores 
    - Total de recaudación

   CREATE VIEW vw_movie_90 AS
   SELECT 	m.movie_id AS 'ID Pelicula', m.title AS Name, m.release_year AS 'Año Estreno', 
            m.total_viewers AS Expectadores, m.total_revenue AS Recaudación
   FROM movies m
   WHERE m.release_year BETWEEN 1990 AND 1999
    
3. Crear una vista llamada "vw_movie_actor" con las películas y sus actores correspondientes.

   CREATE VIEW vw_movie_actor AS
   SELECT 	m.title AS 'Nombre Pelicula', p.name AS Actor
   FROM movies m
   JOIN movie_actor ma ON m.movie_id = ma.movie_id
   JOIN people p ON p.people_id = ma.actor_id

4. Crear una vista llamada "vw_movie_director" con las películas y su correspondiente director.

   CREATE VIEW vw_movie_director AS
   SELECT 	m.title AS Pelicula, p.name AS Director
   FROM movies m
   JOIN people p ON p.people_id = m.director_id

5. Utilizando las vistas creadas en los ejercicios 3 y 4, y la sentencia "UNION", recupera los actores y director de la película "The Matrix":
	- Muestra los encabezados de columna como "Nombre" y "Rol"
    - En la columna "Rol", indica si es Actor o Director. 
    - Ordena los resultados por Nombre.

   SELECT `Actor` AS Nombre, 'Actor' AS Rol 
   FROM vw_movie_actor
   WHERE `Nombre pelicula` = "The Matrix"
   UNION
   SELECT `Director` AS Nombre, 'Director' AS Rol 
   FROM vw_movie_director
   WHERE `Pelicula` = "The Matrix"
   ORDER BY Nombre

6. Crear cinco procedimientos: 
	- "sp_insert_movie" para insertar una nueva película.

      DELIMITER //
      CREATE PROCEDURE sp_insert_movie(
      IN new_movie_title varchar(100),
      IN new_release_year int,
      IN new_director_id int,
      IN new_studio_id int,
      IN new_total_viewers bigint,
      IN new_total_revenue DECIMAL(15,2)
      )
      BEGIN
         INSERT INTO movies (title, release_year, director_id, studio_id, total_viewers, total_revenue) 
         VALUES (new_movie_title, new_release_year, new_director_id, new_studio_id, new_total_viewers, new_total_revenue);
      END
//

	- "sp_delete_movie" para eliminar una película.

      DELIMITER //
      CREATE PROCEDURE sp_delete_movie(
      IN movie_title varchar(100)
      )
      BEGIN
         DELETE FROM movies WHERE title = movie_title;
      END //

	- "sp_update_release_year" para actualizar el año de estreno de una película.

      DELIMITER //
      CREATE PROCEDURE sp_update_release_year(
      IN movie_title VARCHAR(100),
      IN new_release_year INT
      )
      BEGIN
         UPDATE movies SET release_year = new_release_year WHERE title = movie_title;
      END //

    - "sp_update_viewers" para actualizar la cantidad de espectadores de una película.

      DELIMITER //
      CREATE PROCEDURE sp_update_viewers(
      IN movie_title VARCHAR(100),
      IN new_total_viewers BIGINT
      )
      BEGIN
         UPDATE movies SET total_viewers = new_total_viewers WHERE title = movie_title;
      END //

    - "sp_update_revenue" para actualizar la recaudación de una película.

      DELIMITER //
      CREATE PROCEDURE sp_update_revenue(
      IN movie_title VARCHAR(100),
      IN new_total_revenue DECIMAL(15,2)
      )
      BEGIN
         UPDATE movies SET total_revenue = new_total_revenue WHERE title = movie_title;
      END //


7. Crear triggers para registrar inserciones, actualizaciones y eliminaciones en la tabla "movies".
   La información de la operación realizada se registrará en la tabla "audit_log":
	- nombre de la tabla impactada
    - el tipo de operación que se realizó (INSERT, UPDATE, DELETE)
    - el ID del registro impactado
    - el usuario y fecha y hora que se realizó
    - los datos impactados (usando la función JSON_OBJECT() para almacenar los datos previos y nuevos de manera estructurada).

    DELIMITER //
      CREATE TRIGGER tg_movies_after_insert
      AFTER INSERT ON movies
      FOR EACH ROW
      BEGIN
         INSERT INTO audit_log (table_name, operation_type, record_id, changed_by, change_timestamp, new_values)
         VALUES('movies', 'INSERT', NEW.movie_id, USER(), NOW(),
				JSON_OBJECT(
					'title', NEW.title,
					'release_year', NEW.release_year,
					'director_id', NEW.director_id,
					'studio_id', NEW.studio_id,
					'total_viewers', NEW.total_viewers,
					'total_revenue', NEW.total_revenue));		
      END 
      //

      DELIMITER //
      CREATE TRIGGER tg_movies_after_update
      AFTER UPDATE ON movies
      FOR EACH ROW
      BEGIN
         INSERT INTO audit_log (table_name, operation_type, record_id, changed_by, change_timestamp, old_values, new_values)
         VALUES('movies', 'UPDATE', OLD.movie_id, USER(), NOW(),
				JSON_OBJECT(
					'title', OLD.title,
					'release_year', OLD.release_year,
					'director_id', OLD.director_id,
					'studio_id', OLD.studio_id,
					'total_viewers', OLD.total_viewers,
					'total_revenue', OLD.total_revenue),
				JSON_OBJECT(
					'title', NEW.title,
					'release_year', NEW.release_year,
					'director_id', NEW.director_id,
					'studio_id', NEW.studio_id,
					'total_viewers', NEW.total_viewers,
					'total_revenue', NEW.total_revenue));		
      END 
      //

      DELIMITER //
      CREATE TRIGGER tg_movies_after_delete
      AFTER DELETE ON movies
      FOR EACH ROW
      BEGIN
         INSERT INTO audit_log (table_name, operation_type, record_id, changed_by, change_timestamp, old_values)
         VALUES('movies', 'DELETE', OLD.movie_id, USER(), NOW(),
				JSON_OBJECT(
					'title', OLD.title,
					'release_year', OLD.release_year,
					'director_id', OLD.director_id,
					'studio_id', OLD.studio_id,
					'total_viewers', OLD.total_viewers,
					'total_revenue', OLD.total_revenue));		
      END 
      //

8. Insertar la película "Avatar" utilizando el procedimiento creado en el ejercicio 6.
    - Nombre: Avatar
    - Año Estreno: 2009
    - ID Director: 6
    - ID Estudio: 6
    - Total Espectadores: 331000000
    - Total Recaudación: 2923706026

    CALL sp_insert_movie('Avatar', 2009, 6, 6, 331000000, 2923706026)

9. Utiliza la vista creada en el ejercicio 1 para recuperar la información de las películas "Titanic", "Gladiator" y "Avatar".

   SELECT * FROM vw_movie WHERE Pelicula IN ('Titanic', 'Gladiator', 'Avatar')

10. Utilizando los procedimientos creados en el ejercicio 6:
	- Actualiza a 26000300 la cantidad de espectadores de "The Godfather".
    - Actualiza a 1993 el año de estreno de "Schindler’s List".
    - Actualiza a 95000000.00 la recaudación de "Edward Scissorhands".
    - Elimina la película "Avatar".

   CALL sp_update_viewers('The Godfather' , 26000300);
   CALL sp_update_release_year('Schindler’s List', 1993);
   CALL sp_update_revenue('Edward Scissorhands' , 95000000.00);
   CALL sp_delete_movie('Avatar')
    
11. Revisa la tabla de auditoría y chequea que los triggers creados en el ejercicio 7 se ejecutaron correctamente.

   SELECT * FROM cinedb.audit_log;

12. Crear dos índices, llamados "idx_release_year" e "idx_revenue", en las columnas "release_year" y "total_revenue" de la tabla "movies". 

   CREATE INDEX idx_release_year ON movies(release_year);
   CREATE INDEX idx_revenue ON movies(total_revenue)

13. Crear un índice, llamado "idx_movie_actor", compuesto por las columnas "movie_id" y "actor_id" de la tabla "movie_actor".

   CREATE INDEX idx_movie_actor ON movie_actor(movie_id, actor_id);

14. Elimina el índice "idx_revenue" creado en el ejercicio 12.

   DROP INDEX idx_revenue ON movies;

15. Elimina la vista creada en el ejercicio 2.

   DROP VIEW vw_movie_90;

16. Elimina el procedimiento "sp_update_release_year" creado en el ejercicio 6.

   DROP PROCEDURE sp_update_release_year;

17. Usando "Transacciones", inserta una película con el procedimiento creado en el ejercicio 6 y luego confirma dicha operación. Verifica si la película fue insertada.

   START TRANSACTION;
   CALL sp_insert_movie('Toy Story', 1995, 64, 6, 331000000, 373000000);
   SELECT * FROM movies WHERE title = 'Toy Story'
   COMMIT;

18. Usando "Transacciones", inserta una película con el procedimiento creado en el ejercicio 6 y luego vuelve atrás dicha operación. Verifica si la película fue insertada.

   START TRANSACTION;
   CALL sp_insert_movie('Mad Max: Fury Road', 2015, 65, 8, 45200000, 280040050);
   SELECT * FROM movies WHERE title = 'Mad Max: Fury Road';
   ROLLBACK;
   SELECT * FROM movies WHERE title = 'Mad Max: Fury Road'
NOTA: para los ejercicios 17 y 18 asegúrate de tener la opción "Auto-Commit Transactions" (del menú "Query") desactivada.

*/

-- Soluciones

-- 1. 
CREATE VIEW vw_movie AS
   SELECT m.movie_id AS 'ID Película', m.title AS Título, m.release_year AS 'Año Estreno', 
		  m.director_id AS 'ID Director', p.name AS Director, m.studio_id AS 'ID Estudio', s.studio_name AS Estudio, 
          m.total_viewers AS Espectadores, m.total_revenue as Recaudación
   FROM movies m
   LEFT JOIN people p ON m.director_id = p.people_id
   LEFT JOIN studios s ON m.studio_id = s.studio_id;

-- 2. 
CREATE VIEW vw_movie_90 AS
   SELECT m.movie_id AS 'ID Película', m.title AS Título, m.release_year AS 'Año Estreno', 
		  m.total_viewers AS Espectadores, m.total_revenue as Recaudación
   FROM movies m
   WHERE m.release_year between 1990 AND 1999;
   
-- 3. 
CREATE VIEW vw_movie_actor AS
   SELECT m.title AS Película, p.name AS Actor 
   FROM people p
   INNER JOIN movie_actor ma ON p.people_id = ma.actor_id
   INNER JOIN movies m ON ma.movie_id = m.movie_id;

-- 4. 
CREATE VIEW vw_movie_director AS
   SELECT m.title AS Película, p.name AS Director 
   FROM movies m
   INNER JOIN people p ON m.director_id = p.people_id;   
   
-- 5. 
SELECT Actor AS Nombre, 'Actor' AS Rol FROM vw_movie_actor WHERE Película = 'The Matrix'
   UNION
   SELECT Director  AS Nombre, 'Director' AS Rol FROM vw_movie_director WHERE Película = 'The Matrix'
   ORDER BY Nombre;

-- 6. 
DELIMITER //

CREATE PROCEDURE sp_insert_movie(
   IN new_movie_title VARCHAR(255), 
   IN new_release_year INT, 
   IN new_director_id INT, 
   IN new_studio_id INT, 
   IN new_total_viewers BIGINT,
   IN new_total_revenue DECIMAL(15,2)
)
BEGIN
   INSERT INTO movies (title, release_year, director_id, studio_id, total_viewers, total_revenue)
   VALUES (new_movie_title, new_release_year, new_director_id, new_studio_id, new_total_viewers, new_total_revenue);
END //

CREATE PROCEDURE sp_delete_movie(
   IN movie_title VARCHAR(255) 
)
BEGIN
   DELETE FROM movies WHERE title = movie_title;
END //

CREATE PROCEDURE sp_update_release_year(
   IN movie_title VARCHAR(100), 
   IN new_release_year INT
)
BEGIN
   UPDATE movies 
   SET release_year = new_release_year 
   WHERE title = movie_title;
END //

CREATE PROCEDURE sp_update_viewers(
   IN movie_title VARCHAR(100), 
   IN new_viewers BIGINT
)
BEGIN
   UPDATE movies 
   SET total_viewers = new_viewers
   WHERE title = movie_title;
END //

CREATE PROCEDURE sp_update_revenue(
   IN movie_title VARCHAR(100), 
   IN new_revenue DECIMAL(15,2)
)
BEGIN
   UPDATE movies 
   SET total_revenue = new_revenue
   WHERE title = movie_title;
END //

DELIMITER ;

-- 7. 
DELIMITER //

CREATE TRIGGER after_insert
AFTER INSERT ON movies
FOR EACH ROW
BEGIN
	INSERT INTO audit_log (table_name, operation_type, record_id, changed_by, change_timestamp, new_values)
	VALUES ('movies', 'INSERT', NEW.movie_id, USER(), NOW(), 
			JSON_OBJECT('title', NEW.title, 
						'release_year', NEW.release_year, 
						'director_id', NEW.director_id, 
						'studio_id', NEW.studio_id, 
						'total_viewers', NEW.total_viewers, 
						'total_revenue', NEW.total_revenue));
END;
//

CREATE TRIGGER after_update
AFTER UPDATE ON movies
FOR EACH ROW
BEGIN
	INSERT INTO Audit_Log (table_name, operation_type, record_id, changed_by, change_timestamp, old_values, new_values)
	VALUES ('movies', 'UPDATE', OLD.movie_id, USER(), NOW(), 
			JSON_OBJECT('title', OLD.title, 
						'release_year', OLD.release_year, 
						'director_id', OLD.director_id, 
						'studio_id', OLD.studio_id, 
						'total_viewers', OLD.total_viewers, 
						'total_revenue', OLD.total_revenue),
			JSON_OBJECT('title', NEW.title, 
						'release_year', NEW.release_year, 
						'director_id', NEW.director_id, 
						'studio_id', NEW.studio_id, 
						'total_viewers', NEW.total_viewers, 
						'total_revenue', NEW.total_revenue));
END;
//

CREATE TRIGGER after_delete
AFTER DELETE ON movies
FOR EACH ROW
BEGIN
	INSERT INTO Audit_Log (table_name, operation_type, record_id, changed_by, change_timestamp, old_values)
	VALUES ('movies', 'DELETE', OLD.movie_id, USER(), NOW(), 
			JSON_OBJECT('title', OLD.title, 
						'release_year', OLD.release_year, 
						'director_id', OLD.director_id, 
						'studio_id', OLD.studio_id, 
						'total_viewers', OLD.total_viewers, 
						'total_revenue', OLD.total_revenue));
END;
//

DELIMITER ;
    
-- 8. 
CALL sp_insert_movie('Avatar', 2009, 64, 6, 331000000, 2923706026);

-- 9. 
SELECT * FROM vw_movie WHERE Título IN ('Titanic', 'Gladiator', 'Avatar');

-- 10. 
CALL sp_update_viewers('The Godfather', 26000300); 
CALL sp_update_release_year('Schindler’s List', 1993); 
CALL sp_update_revenue('Edward Scissorhands', 95000000.00); 
CALL sp_delete_movie('Avatar');

-- 11. 
SELECT * FROM audit_log;
    
-- 12. 
CREATE INDEX idx_release_year ON movies (release_year);
CREATE INDEX idx_revenue ON movies (total_revenue);
    
-- 13. 
CREATE INDEX idx_movie_actor ON movie_actor (movie_id, actor_id);

-- 14. 
DROP INDEX idx_revenue ON movies;

-- 15. 
DROP VIEW vw_movie_90;

-- 16. 
DROP PROCEDURE sp_update_release_year;

-- 17. 
START TRANSACTION;
CALL sp_insert_movie('Toy Story', 1995, 64, 6, 331000000, 373000000);
SELECT * FROM vw_movie WHERE Título = 'Toy Story';
COMMIT;
SELECT * FROM vw_movie WHERE Título = 'Toy Story';    
    
-- 18. 
START TRANSACTION;    
CALL sp_insert_movie('Mad Max: Fury Road', 2015, 65, 8, 45200000, 280040050);
SELECT * FROM vw_movie WHERE Título = 'Mad Max: Fury Road'; 
ROLLBACK;
SELECT * FROM vw_movie WHERE Título = 'Mad Max: Fury Road'; 

