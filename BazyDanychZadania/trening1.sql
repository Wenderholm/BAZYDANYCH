SELECT teacher.name,
    teacher.title,
    room.room_number,
    lecture.start_time,
    lecture.name
FROM lecture
    JOIN room ON lecture.room_id = room.id
    JOIN teacher ON lecture.teacher_email = teacher.email
WHERE room.room_number IN ('1', '3')
    AND lecture.name IN ('SQL', 'CSS')