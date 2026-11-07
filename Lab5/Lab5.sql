-- Część 1 DDL (5 podpunktów)


-- 1)
CREATE TABLE recenzje (
	id SERIAL PRIMARY KEY,
	produkt_id INTEGER NOT NULL REFERENCES produkty(id),
	klient_id INTEGER NOT NULL REFERENCES klienci(id),
	ocena INTEGER NOT NULL,
	tresc TEXT
);


-- 2)
ALTER TABLE recenzje ADD CONSTRAINT ocena_zakres CHECK (ocena BETWEEN 1 AND 5);


-- 3)
ALTER TABLE recenzje ADD CONSTRAINT jedna_recenzja_na_produkt UNIQUE (klient_id, produkt_id);


-- 4)
ALTER TABLE recenzje ADD COLUMN data_dodania DATE NOT NULL DEFAULT CURRENT_DATE; -- (data dodania recenzji)

ALTER TABLE recenzje ALTER COLUMN tresc TYPE VARCHAR(1000); -- (zmiana typu kolumny tresc)

ALTER TABLE recenzje RENAME COLUMN tresc TO komentarz; -- (zmiana nazwy kolumny "tresc" na "komenatarz")

ALTER TABLE recenzje DROP COLUMN IF EXISTS data_dodania; -- (usunięcie kolumny data_dodania jeśli istnieje)


-- 5)
-- Sprawdzenie ograniczenia CHECK
INSERT INTO recenzje (produkt_id, klient_id, ocena, komentarz) VALUES 
(1, 1, 6, 'Polecam cieplutko');

/* treść błędu:
ERROR:  new row for relation "recenzje" violates check constraint "ocena_zakres"
Failing row contains (1, 1, 1, 6, Polecam cieplutko). 

SQL state: 23514
Detail: Failing row contains (1, 1, 1, 6, Polecam cieplutko).
*/


-- Sprawdzenie ograniczenia UNIQUE
INSERT INTO recenzje (produkt_id, klient_id, ocena, komentarz) VALUES 
(1, 1, 5, 'Polecam cieplutko');  -- (ta przeszła)

INSERT INTO recenzje (produkt_id, klient_id, ocena, komentarz) VALUES 
(1, 1, 5, 'Polecam bardzo!'); -- (ta już nie)

/* treść błędu:
ERROR:  duplicate key value violates unique constraint "jedna_recenzja_na_produkt"
Key (klient_id, produkt_id)=(1, 1) already exists. 

SQL state: 23505
Detail: Key (klient_id, produkt_id)=(1, 1) already exists.
------------------------------------------------------------------------------------------------------------- */


-- Cześć 2 Normalizacja (4 podpunkty)


-- 1)
-- Tabela przechowująca unikalne dane klientów
CREATE TABLE klienci_norm (
	id SERIAL PRIMARY KEY,
	imie VARCHAR(50),
	nazwisko VARCHAR(50),
	email VARCHAR(150) UNIQUE,
	miasto VARCHAR(100)
);


-- Tabela przechowująca unikalne dane produktów
CREATE TABLE produkty_norm (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(150),
    kategoria VARCHAR(100),
    cena NUMERIC(10,2)
);


-- Tabela faktów sprzedaży łącząca klientów i produkty 
CREATE TABLE sprzedaz_norm (
    id SERIAL PRIMARY KEY,
    klient_id INTEGER REFERENCES klienci_norm(id),
    produkt_id INTEGER REFERENCES produkty_norm(id),
    data_sprzedazy DATE,
    ilosc INTEGER
);


-- 2)
-- Migracja unikalnych klientów
INSERT INTO klienci_norm (imie, nazwisko, email, miasto) 
SELECT DISTINCT klient_imie, klient_nazwisko, klient_email, klient_miasto
FROM sprzedaz_flat;


-- Migracja unikalnych produktów
INSERT INTO produkty_norm (nazwa, kategoria, cena) 
SELECT DISTINCT produkt_nazwa, produkt_kategoria, produkt_cena
FROM sprzedaz_flat;


-- 3)
-- Migracja faktów sprzedaży
INSERT INTO sprzedaz_norm (klient_id, produkt_id, data_sprzedazy, ilosc)
SELECT k.id, p.id, sf.data_sprzedazy, sf.ilosc
FROM sprzedaz_flat sf
JOIN klienci_norm k ON sf.klient_email = k.email
JOIN produkty_norm p ON sf.produkt_nazwa = p.nazwa AND sf.produkt_cena = p.cena;


-- 4)
SELECT COUNT(*) FROM sprzedaz_norm; -- Wynik: 500 (co oznacza, że wszystko przebiegło prawidłowo)


/* 
Uzasadnienie normalizacji do postaci 3NF:
Normalizacja tabeli do postaci 3NF pozwoliła na wyeliminowanie redundancji danych oraz uciążliwych anomalii:
- anomalia wstawiania: (umożliwia dodawanie nowych klientów lub produktów niezależnie od rejestracji transakcji sprzedaży),
- anomalia aktualizacji: (zmiana danych klienta lub produktu (np. ceny czy adresu) wymaga edycji tylko w jednym miejscu, co zapobiega niespójności),
- anomalia usuwania: (usunięcie historii konkretnej transakcji nie powoduje bezpowrotnej utraty informacji o samym kliencie lub produkcie).
*/