-- UAKTUALNIENIE TABELI
UPDATE teacher
SET title = 'dr'
WHERE name = 'Kasia Nowak';
-- SUWANIE ELEMENTU Z TABELI
DELETE FROM lecture
WHERE NAME = 'SQL';
-- dodanie nowej sali do tabeli
INSERT INTO room (room_number, building, is_lab, number_of_seats)
VALUES ('10', 'B', TRUE, 20);
-- ZMIANA SALI NA 10d BUDYNEK b MIEJSC 20 
UPDATE lecture
SET room_id = (
        SELECT id
        FROM room
        WHERE room_number = '10'
            AND building = 'B'
    )
WHERE name = 'Java';
-- zmiejszenie miejsc w salach o polowe 
UPDATE room
SET number_of_seats = number_of_seats / 2;