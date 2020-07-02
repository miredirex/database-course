-- 1. INSERT
--  1. Без указания списка полей

    INSERT INTO director VALUES (DEFAULT, 'Bogdan', 'Elochkin', '1979-03-08', 'Russia');
    INSERT INTO director VALUES (DEFAULT, 'Noah', 'Jensen', '1981-04-12', 'Denmark');

    INSERT INTO movie VALUES (DEFAULT, 'Shrek 2', 'Shrek''s adventures', 75, '2001-04-03', '7200', 1);
    INSERT INTO movie VALUES (DEFAULT, 'Another Movie 1', 'A sample movie', 40, '2001-04-03', '3950', 1);
    INSERT INTO movie VALUES (DEFAULT, 'Another Movie 1', 'A sample movie but another', 84, '2002-04-03', '3830', 1);
    INSERT INTO movie VALUES (DEFAULT, 'Movie One', 'A sample movie but another', 80, '1998-04-03', '3230', 1);
    INSERT INTO movie VALUES (DEFAULT, 'Movie Two', 'A sample movie but another', 81, '2002-04-03', '3830', 1);

    INSERT INTO actor VALUES (DEFAULT, 'Sergey', 'Liferov', '1999-12-01', 201, 'Belarus');
    INSERT INTO actor VALUES (DEFAULT, 'Alexandr', 'Belov', '1989-01-05', 185, 'Ukraine');
    INSERT INTO actor VALUES (DEFAULT, 'Alexey', 'Sakharov', '1993-05-05', 188, 'Latvia');
    INSERT INTO actor VALUES (DEFAULT, 'William', 'Robertson', '1998-11-12', 172, 'USA');
    INSERT INTO actor VALUES (DEFAULT, 'Joe', 'White', '1994-07-07', 174, 'Mexico');

    INSERT INTO role VALUES (DEFAULT, 'Puss in Boots', 'secondary', 'neutral', 'Puss in Boots is a Shrek''s friend');
    INSERT INTO role VALUES (DEFAULT, 'Shrek', 'primary', 'protagonist', '');

    INSERT INTO genre VALUES (DEFAULT, 'Animation');
    INSERT INTO genre VALUES (DEFAULT, 'Fantasy');
    INSERT INTO genre VALUES (DEFAULT, 'Romance');

    INSERT INTO movie_actor VALUES (1, 1, 1);
    INSERT INTO movie_actor VALUES (2, 1, 2);

    -- Таблицы пересечения
    INSERT INTO movie_actor VALUES (1, 1);
    INSERT INTO movie_genre VALUES (1, 1);
    INSERT INTO movie_genre VALUES (2, 2);
    INSERT INTO movie_genre VALUES (3, 3);
--  2. С указанием списка полей
    INSERT INTO role (name, significance, hostility, description)
    VALUES ('Donkey', 'secondary', 'neutral', 'Donkey is a fictional fast-talking donkey created by William Steig and adapted by DreamWorks Animation for the Shrek franchise');
--  3. С чтением значения из другой таблицы
    INSERT INTO actor (first_name, last_name) SELECT first_name, last_name FROM director;

-- 2. DELETE
--  1. Всех записей
    DELETE FROM movie_actor;
--  2. По условию
    DELETE FROM role WHERE significance = 'secondary';
--  3. Очистить таблицу
    TRUNCATE TABLE actor CASCADE;

-- 3. UPDATE
--  1. Всех записей
    UPDATE actor SET first_name = 'Artem';
--  2. По условию обновляя один атрибут
    UPDATE role SET significance = 'primary' WHERE significance = 'secondary';
--  3. По условию обновляя несколько атрибутов
    UPDATE actor SET first_name = 'Oleksandr', last_name = 'Belovko' WHERE country_of_residence = 'Ukraine';

-- 4. SELECT
--  1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
    SELECT first_name, last_name FROM actor;
--  2. Со всеми атрибутами (SELECT * FROM...)
    SELECT * FROM genre;
--  3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
    SELECT * FROM director WHERE country_of_residence = 'USA';

-- 5. SELECT ORDER BY + TOP (LIMIT)
--  1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
    SELECT * FROM genre ORDER BY name LIMIT 1;
--  2. С сортировкой по убыванию DESC
    SELECT * FROM genre ORDER BY name DESC;
--  3. С сортировкой по двум атрибутам + ограничение вывода количества записей
    SELECT * FROM actor ORDER BY country_of_residence, height_cm DESC LIMIT 2;
--  4. С сортировкой по первому атрибуту, из списка извлекаемых
    SELECT * FROM movie ORDER BY id;

-- 6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
--  1. WHERE по дате
    SELECT * FROM actor WHERE birth_date > '1990-01-01';
--  2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
    SELECT EXTRACT(YEAR FROM birth_date) FROM actor;

-- 7. SELECT GROUP BY с функциями агрегации
--  1. MIN
    SELECT title, MIN(rating) AS min_rating FROM movie GROUP BY title;
--  2. MAX
    SELECT title, MAX(rating) AS max_rating FROM movie GROUP BY title;
--  3. AVG
    SELECT director_id, AVG(rating) AS avg_all_movies_rating FROM movie GROUP BY director_id;
--  4. SUM
    SELECT director_id, SUM(rating) AS all_movies_rating FROM movie GROUP BY director_id;
--  5. COUNT
    SELECT director_id, COUNT(director_id) AS movies_produced FROM movie GROUP BY director_id;

-- 8. SELECT GROUP BY + HAVING
--  1. Написать 3 разных запроса с использованием GROUP BY + HAVING

    SELECT country_of_residence, (DATE_PART('year', NOW()) - DATE_PART('year', MIN(birth_date))) as age
    FROM actor
    GROUP BY country_of_residence
    HAVING (DATE_PART('year', NOW()) - DATE_PART('year', MIN(birth_date))) > 60;

    SELECT birth_date, COUNT(*) AS actors_born_in_year
    FROM actor
    GROUP BY birth_date
    HAVING COUNT(*) > 1;

    SELECT director_id, AVG(rating) AS average_movie_rating
    FROM movie
    GROUP BY director_id
    HAVING AVG(rating) > 60;

-- 9. SELECT JOIN
--  1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
    SELECT
        movie.title, role.name
    FROM
        movie_actor
    LEFT JOIN
        movie
    ON
        movie_actor.movie_id = movie.id
    LEFT JOIN
        role
    ON
        movie_actor.role_id = role.id
    WHERE
        movie_actor.actor_id = 1;

--  2. RIGHT JOIN. Получить такую же выборку, как и в 5.1
    SELECT
        genre.id, genre.name
    FROM
        genre
    RIGHT JOIN
        movie_genre
    ON genre.id = movie_genre.movie_id
    LIMIT 1;

--  3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
    SELECT
        movie.title, movie.rating, director.first_name AS director_first_name, director.last_name AS director_last_name, genre.name AS genre
    FROM
        movie
    LEFT JOIN
        director
    ON
        movie.director_id = director.id
    LEFT JOIN
        movie_genre
    ON
        movie.id = movie_genre.movie_id
    LEFT JOIN
        genre
    ON
        genre.id = movie_genre.genre_id
    WHERE
        director.country_of_residence = 'Denmark'
    AND
        movie.rating >= 75
    AND
        genre.name LIKE 'F%';

--  4. FULL OUTER JOIN двух таблиц
    SELECT
        movie.title, movie_genre.genre_id
    FROM
        movie
    FULL OUTER JOIN movie_genre ON movie.id = movie_genre.movie_id
    ORDER BY movie.title;

-- 10. Подзапросы
--  1. Написать запрос с WHERE IN (подзапрос)
    SELECT first_name, last_name
    FROM actor
    WHERE first_name IN ('Artem', 'Joe');
--  2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
    SELECT name, significance, (SELECT LENGTH(description) > 0) as has_description
    FROM role