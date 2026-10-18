CREATE TABLE goscie (
id SERIAL PRIMARY KEY,
imie VARCHAR(100) NOT NULL,
nazwisko VARCHAR(100) NOT NULL,
data_urodzenia DATE NOT NULL,
czy_zameldowany BOOL NOT NULL,
);


CREATE TABLE rezerwacje (
id SERIAL PRIMARY KEY,
numer_pokoju INT NOT NULL,
data_zameldowania DATE NOT NULL,
cena NUMERIC(6, 2) NOT NULL,
gosc_id INT REFERENCES goscie(id) NOT NULL
);


INSERT INTO goscie (imie, nazwisko, data_urodzenia, czy_zameldowany) VALUES
('Jan', 'Kowalski', '1985-04-12', TRUE),
('Anna', 'Nowak', '1992-08-23', TRUE),
('Piotr', 'Nowak', '1978-11-05', FALSE),
('Katarzyna', 'Wójcik', '1995-01-30', TRUE),
('Michał', 'Kowalczyk', '1988-06-17', FALSE),
('Agnieszka', 'Kamińska', '2000-03-25', TRUE),
('Tomasz', 'Lewandowski', '1982-09-14', FALSE),
('Magdalena', 'Zielińska', '1991-12-01', TRUE),
('Paweł', 'Szymański', '1975-07-19', FALSE),
('Ewa', 'Woźniak', '1998-02-10', TRUE),
('Marcin', 'Dąbrowski', '1986-10-28', FALSE),
('Karolina', 'Kozłowska', '1993-05-04', TRUE),
('Krzysztof', 'Jankowski', '1980-04-15', FALSE),
('Aleksandra', 'Mazur', '1997-11-20', TRUE),
('Adam', 'Kowalski', '1989-01-08', FALSE);


INSERT INTO rezerwacje (numer_pokoju, data_zameldowania, cena, gosc_id) VALUES
(101, '2026-10-01', 250.00, 1),
(102, '2026-10-02', 180.50, 2),
(103, '2026-10-03', 320.00, 3),
(201, '2026-10-05', 450.00, 4),
(202, '2026-10-06', 220.00, 5),
(203, '2026-10-07', 290.00, 6),
(301, '2026-10-10', 500.00, 7),
(302, '2026-10-12', 150.00, 8),
(303, '2026-10-14', 310.00, 9),
(104, '2026-10-15', 270.00, 10),
(105, '2026-10-16', 195.00, 11),
(204, '2026-10-18', 410.00, 12),
(205, '2026-10-20', 230.00, 13),
(304, '2026-10-22', 360.00, 14),
(305, '2026-10-25', 480.00, 15);


SELECT * FROM goscie;
SELECT * FROM rezerwacje;