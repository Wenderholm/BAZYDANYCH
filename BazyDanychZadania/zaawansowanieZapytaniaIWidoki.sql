-- sortowanie po zliczonym czasie nauczycieli 
-- 1 rozwiązanie zadania
-- SELECT name AS Czas_pracy,
--     (
--         select extract (
--                 EPOCH
--                 FROM sum((l.end_time - l.start_time)) / 60
--             ) as ilosc
--         from lecture l
--         where l.teacher_id = teacher.id
--     ) AS czas
-- from teacher
-- order by czas DESC NULLS last;
-- 2 rozwiązanie zadania 
--
-- SELECT t.name,
--     sum(
--         extract(
--             EPOCH
--             FROM (l.end_time - l.start_time)
--         ) / 60
--     ) AS sum_of_minutes
-- FROM lecture l
--     RIGHT JOIN teacher t ON l.teacher_id = t.id
-- GROUP BY t.name
-- ORDER BY sum_of_minutes DESC NULLS last;
-- select *
-- from room;
--
--zadanie 2 z zajęć 
DROP FUNCTION if exists get_room_label;
CREATE or REPLACE FUNCTION get_room_label(room_number VARCHAR, building VARCHAR) returns VARCHAR AS $$ BEGIN RETURN room_number || '(' || building || ')';
END $$ LANGUAGE plpgsql;
-- -- mozna zrobić 2 zadanie z $1 i $2
-- DROP FUNCTION if exists get_room_label;
-- CREATE or REPLACE FUNCTION get_room_label(room_number VARCHAR, building VARCHAR) returns VARCHAR AS $$ BEGIN RETURN $1 || '(' || $2 || ')';
-- END $$ LANGUAGE plpgsql;
select get_room_label(room_number, building) as LABEL
from room;