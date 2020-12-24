--------------------------------------------------------------
-- Stan danych po wykonaniu ćwiczenia nr 1 -------------------
--------------------------------------------------------------
DROP TABLE IF EXISTS lecture;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS teacher;
-- Nauczyciele
CREATE TABLE teacher (
    email VARCHAR(100) PRIMARY KEY,
    name VARCHAR(150),
    title VARCHAR(15)
);
INSERT INTO teacher (email, name, title)
VALUES ('knowak@db.pl', 'Kasia Nowak', 'mgr inż.'),
    ('jkowalski@db.pl', 'Jan Kowalski', 'mgr'),
    ('ekot@db.pl', 'Emilia Kot', 'prof. nadzw.'),
    ('emazur@db.pl', 'Ewa Mazur', NULL);
-- Sale
CREATE TABLE room (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    room_number VARCHAR(4),
    building VARCHAR(20),
    is_lab BOOLEAN,
    number_of_seats INTEGER
);
INSERT INTO room (room_number, building, is_lab, number_of_seats)
VALUES ('1', 'A', TRUE, 10),
    ('2B', 'A', FALSE, 50),
    ('3', 'B', FALSE, 30),
    ('4', 'A', FALSE, 30);
-- Zajęcia
CREATE TABLE lecture (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    teacher_email VARCHAR(100) REFERENCES teacher (email),
    room_id INTEGER REFERENCES room (id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    name VARCHAR(255)
);
INSERT INTO lecture (
        teacher_email,
        room_id,
        start_time,
        end_time,
        name
    )
VALUES (
        'knowak@db.pl',
        1,
        '2020-10-26 11:30',
        '2020-10-26 12:30',
        'SQL'
    ),
    (
        'jkowalski@db.pl',
        2,
        '2020-10-27 11:30',
        '2020-10-27 13:30',
        'Java'
    ),
    (
        'ekot@db.pl',
        3,
        '2020-10-27 14:00',
        '2020-10-27 16:30',
        'CSS'
    ),
    (
        'jkowalski@db.pl',
        4,
        '2020-10-29 07:00',
        '2020-10-29 11:00',
        'HTML'
    ),
    (
        'knowak@db.pl',
        1,
        '2020-10-26 11:00',
        '2020-10-26 11:30',
        'Testy'
    );
-- select teacher.name AS Prowadzący,
--     teacher.title AS Stopień,
--     room.room_number AS Sala,
--     lecture.start_time AS Rozpoczęcie,
--     lecture.name AS Przedmiot
-- from lecture
--     join room on room.id = lecture.room_id
--     join teacher on teacher.email = lecture.teacher_email
-- where room.room_number in ('1', '3')
--     and lecture.name != 'Testy';
-- SELECT teacher.name, teacher.title, room.room_number, lecture.start_time, lecture.name
-- FROM lecture 
-- 	JOIN teacher ON lecture.teacher_email=teacher.email 
-- 	JOIN room ON lecture.room_id=room.id 
-- WHERE room.room_number IN ('1', '3') 
-- AND lecture.name != 'Testy' 
-- SELECT teacher.name,
--     teacher.title,
--     room.room_number,
--     lecture.start_time,
--     lecture.name
-- FROM lecture
--     JOIN room ON lecture.room_id = room.id
--     JOIN teacher ON lecture.teacher_email = teacher.email
-- WHERE room.room_number IN ('1', '3')
--     AND lecture.name IN ('SQL', 'CSS');