-- Zadanie 1
SELECT nazwa, cena 
FROM produkty
WHERE cena > 200 
ORDER BY cena DESC ;


-- Zadanie 2
SELECT imie, nazwisko, miasto
FROM klienci
WHERE miasto IN ('Wroclaw', 'Poznan');


-- Zadanie 3
SELECT nazwa, cena 
FROM produkty 
ORDER BY cena ASC
LIMIT 10;


-- Zadanie 4
SELECT * 
FROM zamowienia
WHERE status = 'anulowane'
ORDER BY data_zamowienia DESC;


-- Zadanie 5
SELECT * 
FROM produkty
WHERE nazwa LIKE 'P%';


-- Zadanie 6
SELECT * 
FROM produkty
WHERE ilosc_magazyn < 5;


-- Zadanie 7
SELECT * 
FROM klienci
WHERE data_rejestracji > CURRENT_DATE - INTERVAL '500 days';


-- Zadanie 8
(SELECT * FROM produkty ORDER BY cena DESC LIMIT 5)
UNION ALL
(SELECT * FROM produkty ORDER BY cena ASC LIMIT 5);


-- Zadanie 9
SELECT * 
FROM produkty
WHERE data_dodania >= CURRENT_DATE - INTERVAL '30 days';


-- Zadanie 10
SELECT DISTINCT miasto 
FROM klienci;


-- Zadanie 11
SELECT nazwisko, UPPER(nazwisko) AS nazwisko_wielkie_litery
FROM klienci;


-- Zadanie 12
SELECT * 
FROM produkty
WHERE ROUND(cena) BETWEEN 90 AND 110;


-- Zadanie 13
SELECT * 
FROM klienci
WHERE nazwisko LIKE '%ski' OR imie LIKE 'A%';


-- Zadanie 14
SELECT * 
FROM zamowienia
ORDER BY data_zamowienia ASC
LIMIT 5;


-- Zadanie 15
SELECT * 
FROM produkty
WHERE cena NOT BETWEEN 100 AND 300;


-- Zadanie 16
SELECT nazwa, CURRENT_DATE - data_dodania AS dni_od_dodania
FROM produkty
ORDER BY dni_od_dodania DESC;