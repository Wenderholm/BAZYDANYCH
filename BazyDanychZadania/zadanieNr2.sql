SELECT l.name,
    r.room_number,
    t.name,
    l.start_time,
    EXTRACT (
        EPOCH
        FROM (l.end_time - l.start_time)
    ) / 60 AS duration
FROM lecture l
    JOIN teacher t on l.teacher_id = t.id
    JOIN room r on l.room_id = r.id
WHERE l.start_time BETWEEN '2020-10-01' and '2020-10-30'
order by l.start_time;