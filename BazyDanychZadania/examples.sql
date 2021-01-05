----------------------------------------
-- JOIN --------------------------------
----------------------------------------

-- INNER JOIN
SELECT r.room_number, l.name
FROM room r
         JOIN lecture l
              ON r.id = l.room_id;


-- LEFT JOIN
SELECT r.room_number, l.name
FROM room r
         LEFT JOIN lecture l
                   ON r.id = l.room_id;

-- RIGHT JOIN
SELECT r.room_number, l.name
FROM room r
         RIGHT JOIN lecture l
                    ON r.id = l.room_id;

SELECT r.room_number, l.name
FROM lecture l
         LEFT JOIN room r
                   ON r.id = l.room_id;

-- LEFT (excluding) JOIN
SELECT r.room_number
FROM room r
         LEFT JOIN lecture l
                   ON r.id = l.room_id
WHERE l.room_id IS NULL;

-- CROSS JOIN

SELECT t.name, r.room_number
FROM room r
         CROSS JOIN teacher t
ORDER BY t.name, r.room_number;

----------------------------------------
-- Funkcje agregujące ------------------
----------------------------------------

SELECT COUNT(*)              AS number_of_rows,
       COUNT(title)          AS number_of_titles,
       COUNT(DISTINCT title) AS number_of_distinct_titles
FROM teacher;

SELECT MIN(number_of_seats)           AS min_n_of_seats,
       MAX(number_of_seats)           AS max_n_of_seats,
       AVG(number_of_seats)           AS avg_n_of_seats,
       ROUND(AVG(number_of_seats), 2) AS rounded_avg_n_of_seats,
       TRUNC(AVG(number_of_seats), 3)
FROM room;

SELECT SUM(number_of_seats) AS sum_of_seats
FROM room
WHERE building = 'B';

-- Sala (lub sale) z najmniejszą liczbą siedzeń
SELECT room_number, number_of_seats
FROM room
WHERE number_of_seats = (SELECT MIN(number_of_seats)
                         FROM room);

----------------------------------------
-- GROUP BY ----------------------------
----------------------------------------

-- Suma siedzeń w poszczególnych budynkach
SELECT building,
       SUM(number_of_seats) AS summary_n_of_lectures
FROM room
GROUP BY building;

-- Suma siedzeń w poszczególnych budynkach -- posortowana rosnąco
SELECT building,
       SUM(number_of_seats) AS summary_n_of_lectures
FROM room
GROUP BY building
ORDER BY SUM(number_of_seats);

-- Liczba zajęć dla każdej sali, ale tylko w przypadku sal
-- mających co najmniej 2 lekcje
SELECT l.room_id,
       COUNT(l.id) AS number_of_lectures
FROM lecture l
GROUP BY l.room_id
HAVING COUNT(l.id) >= 2;

-- To samo, co wyżej, ale używamy numerów sali -- co się stanie,
-- gdy spróbujemy po prostu dołączyć tabelę `room`?
SELECT l.room_id,
       r.room_number,
       COUNT(l.id) AS number_of_lectures
FROM lecture l
         JOIN room r
              ON l.room_id = r.id
GROUP BY l.room_id
HAVING COUNT(l.id) >= 2;

--

SELECT r.room_number,
       r.building,
       r.is_lab,
       subquery.room_id,
       subquery.number_of_lectures,
       subquery.min_start_time
FROM room r JOIN (SELECT l.room_id,
                         COUNT(l.id)       AS number_of_lectures,
                         MIN(l.start_time) AS min_start_time
                  FROM lecture l
                  GROUP BY l.room_id
                  HAVING COUNT(l.id) >= 2) AS subquery
                 ON subquery.room_id = r.id;

-- Widoki -- liczba zajęć dla każdej sali

CREATE VIEW number_of_lectures_v AS
SELECT room_id,
       COUNT(id) AS number_of_lectures
FROM lecture
GROUP BY room_id;

EXPLAIN ANALYSE
SELECT *
FROM number_of_lectures_v;

-- Widoki zmaterializowane

CREATE MATERIALIZED VIEW number_of_lectures_m AS
SELECT room_id,
       COUNT(id) AS number_of_lectures
FROM lecture
GROUP BY room_id;

EXPLAIN ANALYSE
SELECT *
FROM number_of_lectures_v;

REFRESH MATERIALIZED VIEW number_of_lectures_m;

-- CTEs

WITH cte AS (
    SELECT l.room_id,
           COUNT(l.id) AS number_of_lectures
    FROM lecture l
    GROUP BY l.room_id
    HAVING COUNT(l.id) >= 2
)
SELECT r.room_number,
       cte.room_id,
       cte.number_of_lectures
FROM room r JOIN cte
                 ON cte.room_id = r.id;

--

SELECT name,
       EXTRACT(EPOCH FROM (end_time - start_time)) / 60 AS duration
FROM lecture;

CREATE OR REPLACE FUNCTION get_minutes_between(TIMESTAMP, TIMESTAMP) RETURNS INTEGER
AS
'SELECT EXTRACT(EPOCH FROM ($2 - $1)) / 60'
    LANGUAGE sql
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;

--

CREATE OR REPLACE FUNCTION get_minutes_between(start_date TIMESTAMP, end_date TIMESTAMP) RETURNS INTEGER AS
$$
BEGIN
    RETURN EXTRACT(EPOCH FROM (end_date - start_date)) / 60;
END;
$$ LANGUAGE plpgsql;

SELECT name,
       get_minutes_between(start_time, end_time) AS duration
FROM lecture;

-- Wyzwalacze

ALTER TABLE lecture
    ADD COLUMN duration_in_minutes INTEGER CHECK ( duration_in_minutes > 0 );

UPDATE lecture
SET duration_in_minutes = EXTRACT(EPOCH FROM (end_time - start_time)) / 60;

ALTER TABLE lecture
    ALTER COLUMN duration_in_minutes SET NOT NULL;

CREATE FUNCTION set_duration_in_minutes()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (old.start_time IS NULL
        OR new.start_time != old.start_time
        OR new.end_time != old.end_time) THEN
        new.duration_in_minutes = EXTRACT(EPOCH FROM (new.end_time - new.start_time)) / 60;
    END IF;

    RETURN new;
END;
$$;

CREATE TRIGGER set_duration_in_minutes_trigger
    BEFORE INSERT OR UPDATE OF start_time, end_time
    ON lecture
    FOR EACH ROW
EXECUTE PROCEDURE set_duration_in_minutes();

UPDATE lecture
SET start_time = '2020-10-26 11:00'
WHERE id = 1;

INSERT INTO lecture ( teacher_id, room_id, start_time, end_time, name )
VALUES ( 2, 2, '2020-12-20 11:00', '2020-12-20 13:15', 'TEST 2' );

DROP TRIGGER set_duration_in_minutes_trigger ON lecture;
DROP FUNCTION set_duration_in_minutes;
ALTER TABLE lecture
    DROP COLUMN duration_in_minutes;