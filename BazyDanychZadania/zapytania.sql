SELECT *
FROM teacher;
select *
FROM lecture;
SELECT *
FROM room;
SELECT datediff(MINUTE, start_time, end_time) as nowa
from lecture
where id = '1';