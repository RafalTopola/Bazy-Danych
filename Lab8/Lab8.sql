-- Pierwszym etapem było zrestartowanie tabeli po zmianach z Lab6 (czyli start pracy od bazy sklep, którą już mam domyślnie)


-- Zadanie 1
-- Tabela statusy_opinii
CREATE TABLE statusy_opinii (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL UNIQUE
);

-- Tabela opinie
CREATE TABLE opinie (
    id SERIAL PRIMARY KEY,
    klient_id INTEGER NOT NULL REFERENCES klienci(id),
    produkt_id INTEGER NOT NULL REFERENCES produkty(id),
    status_id INTEGER NOT NULL REFERENCES statusy_opinii(id),
    ocena INTEGER NOT NULL CHECK (ocena >= 1 AND ocena <= 5),
    komentarz TEXT,
    data_wstawienia DATE NOT NULL DEFAULT CURRENT_DATE
);


-- Zadanie 2
-- Dane do tabeli statusy_opinii
INSERT INTO statusy_opinii (nazwa) VALUES
    ('Oczekująca'),
    ('Do weryfikacji'),
    ('Zatwierdzona'),
    ('Odrzucona'),
    ('Zarchiwizowana');

-- Dane do tabeli opinie
INSERT INTO opinie (klient_id, produkt_id, status_id, ocena, komentarz, data_wstawienia) VALUES
    (1, 5, 3, 5, 'Świetny produkt, polecam każdemu!', '2026-05-10'),
    (2, 5, 3, 4, 'Całkiem ok, ale spodziewałem się lepszej jakości.', '2026-05-12'),
    (3, 12, 1, 3, 'Produkt zgodny z opisem, chociaż dostawa trwała długo.', '2026-06-01'),
    (4, 1, 3, 5, 'Najlepszy zakup w tym roku!', '2026-06-03'),
    (1, 15, 3, 2, 'Szybko się zepsuło, nie polecam.', '2026-06-05'),
    (5, 8, 4, 1, 'Tragedia, zupełnie niezgodne ze zdjęciem.', '2026-06-06'),
    (6, 22, 3, 4, 'Działa bez zarzutu.', '2026-06-07'),
    (7, 30, 3, 5, 'Super kontakt ze sklepem i szybka wysyłka.', '2026-06-10');


-- Zadanie 3
-- (Celowo wpisany nieistniejący klient)
INSERT INTO opinie (klient_id, produkt_id, status_id, ocena, komentarz) VALUES 
    (9999, 1, 3, 1, 'Ten produkt to jakiś żart!');

/* treść błędu:
ERROR:  insert or update on table "opinie" violates foreign key constraint "opinie_klient_id_fkey"
Key (klient_id)=(9999) is not present in table "klienci". 
SQL state: 23503
Detail: Key (klient_id)=(9999) is not present in table "klienci". */


-- Zadanie 4
SELECT k.imie, k.nazwisko, p.nazwa AS produkt, o.ocena, o.komentarz, so.nazwa AS status_opinii, o.data_wstawienia
FROM opinie o
JOIN klienci k ON k.id = o.klient_id
JOIN produkty p ON p.id = o.produkt_id
JOIN statusy_opinii so ON so.id = o.status_id
ORDER BY o.ocena DESC;