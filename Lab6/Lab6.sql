-- Zadanie 1
UPDATE produkty
SET ilosc_magazyn = ilosc_magazyn + 50
WHERE kategoria_id = 1;


-- Zadanie 2
DELETE FROM pozycje_zamowien 
WHERE ilosc = 1 AND zamowienie_id IN (
	SELECT id
	FROM zamowienia
	WHERE data_zamowienia < CURRENT_DATE - INTERVAL '180 days'
	);


-- Zadanie 3
BEGIN;

WITH nowe AS (
    INSERT INTO zamowienia (klient_id, status, data_zamowienia) VALUES 
    (1, 'nowe', CURRENT_DATE)
    RETURNING id
)

INSERT INTO pozycje_zamowien (zamowienie_id, produkt_id, ilosc, cena_jednostkowa)
SELECT id, 1, 2, 34.99 FROM nowe
UNION ALL
SELECT id, 2, 5, 99.99 FROM nowe;

COMMIT;


-- Zadanie 4
DELETE FROM klienci 
WHERE id = 137;

/* treść błędu:
ERROR:  update or delete on table "klienci" violates foreign key constraint "zamowienia_klient_id_fkey" on table "zamowienia"
Key (id)=(137) is still referenced from table "zamowienia". 
SQL state: 23503
Detail: Key (id)=(137) is still referenced from table "zamowienia". 


Dlaczego tak się stało?
Baza danych nie pozwoliła usunąć klienta (o id 137), ponieważ wciąż ma powiązane zamówienia w sklepie. 
To zabezpieczenie chroni przed powstawaniem zamówień, które zostałyby w systemie bez przypisanego właściciela. 
Dzięki temu baza dba o porządek i zachowuje spójność danych. */


-- Zadanie 5
-- ON DELETE CASCADE 
CREATE TABLE tworcy_test1 (
id SERIAL PRIMARY KEY,
pseudonim VARCHAR(100) NOT NULL
);

CREATE TABLE gry_fnaf_test1 (
id SERIAL PRIMARY KEY,
tytul_gry VARCHAR(200) NOT NULL,
tworca_id INT REFERENCES tworcy_test1(id) ON DELETE CASCADE
);

INSERT INTO tworcy_test1 (pseudonim) VALUES 
('Scott Cawthon');

INSERT INTO gry_fnaf_test1 (tytul_gry, tworca_id) VALUES 
('Five Nights at Freddy 1', 1), 
('Five Nights at Freddy 2', 1),
('Five Nights at Freddy 3', 1);

DELETE FROM tworcy_test1 
WHERE id = 1;

SELECT * FROM gry_fnaf_test1;

/* Wniosek: 
Usunięcie twórcy spowodowało automatyczne skasowanie związanych z nim gier. 
Tabela gry_fnaf_test1 jest teraz pusta. */


-- ON DELETE SET NULL
CREATE TABLE tworcy_test2 (
id SERIAL PRIMARY KEY,
pseudonim VARCHAR(100) NOT NULL
);

CREATE TABLE gry_fnaf_test2 (
id SERIAL PRIMARY KEY,
tytul_gry VARCHAR(200) NOT NULL,
tworca_id INT REFERENCES tworcy_test2(id) ON DELETE SET NULL
);

INSERT INTO tworcy_test2 (pseudonim) VALUES 
('Scott Cawthon');

INSERT INTO gry_fnaf_test2 (tytul_gry, tworca_id) VALUES 
('Five Nights at Freddy 1', 1), 
('Five Nights at Freddy 2', 1),
('Five Nights at Freddy 3', 1);

DELETE FROM tworcy_test2
WHERE id = 1;

SELECT * FROM gry_fnaf_test2;

/* Wniosek: 
Usunięcie twórcy nie spowodowało usunięcia tytułów gier. 
Tabela gry_fnaf_test2 dalej ma swoje tytuły gier ale kolumna tworca_id ma null. */


-- Zadanie 6
UPDATE zamowienia
SET status = 'w realizacji' 
WHERE status = 'nowe' AND data_zamowienia < CURRENT_DATE - INTERVAL '7 days';


-- Zadanie 7
/* Odpowiedź: Nie jest to bezpieczne działanie.
Usuwanie historycznych pozycji zamówień na podstawie bieżącego stanu magazynu jest niebezpieczne, 
ponieważ niszczy wiarygodność danych analitycznych i finansowych dotyczących faktycznie zrealizowanej w przeszłości sprzedaży. */


DELETE FROM pozycje_zamowien
WHERE produkt_id IN (
	SELECT id
	FROM produkty
	WHERE ilosc_magazyn < 5
	);


-- Zadanie 8
-- Wariant (a)
BEGIN;

INSERT INTO zamowienia (klient_id, data_zamowienia, status) VALUES
(1, CURRENT_DATE, 'nowe')
RETURNING id; 

INSERT INTO pozycje_zamowien (zamowienie_id, produkt_id, ilosc, cena_jednostkowa) VALUES 
((SELECT MAX(id) FROM zamowienia), 1, 2, 50.00);

COMMIT;


-- Wariant (b)
BEGIN;

INSERT INTO zamowienia (klient_id, data_zamowienia, status) VALUES 
(1, CURRENT_DATE, 'nowe');

INSERT INTO pozycje_zamowien (zamowienie_id, produkt_id, ilosc, cena_jednostkowa) VALUES 
((SELECT MAX(id) FROM zamowienia), 999999, 1, 100.00);

ROLLBACK;

/* treść błędu:
ERROR:  insert or update on table "pozycje_zamowien" violates foreign key constraint "pozycje_zamowien_produkt_id_fkey"
Key (produkt_id)=(999999) is not present in table "produkty". 
SQL state: 23503
Detail: Key (produkt_id)=(999999) is not present in table "produkty". */


/* Obserwacje: 
Mechanizm transakcji (COMMIT/ROLLBACK) zapewnia atomowość, pozwalając na trwały zapis lub całkowite wycofanie zmian w razie błędu. 
Z kolei reguły integralności referencyjnej (CASCADE/SET NULL) skutecznie chronią spójność relacji między tabelami, automatycznie usuwając powiązane dane lub aktualizując klucze obce. */