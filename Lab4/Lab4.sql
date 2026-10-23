-- Zadanie 1
SELECT z.id AS zamowienie_id, z.data_zamowienia, z.status, k.imie, k.nazwisko 
FROM zamowienia z
INNER JOIN klienci k ON z.klient_id  = k.id;


-- Zadanie 2
SELECT k.nazwa AS kategoria, AVG(p.cena) AS srednia_cena
FROM kategorie k
INNER JOIN produkty p ON p.kategoria_id = k.id
GROUP BY k.nazwa;


-- Zadanie 3
SELECT k.id, k.imie, k.nazwisko, SUM(pz.ilosc * pz.cena_jednostkowa) AS laczny_wydatek
FROM klienci k
INNER JOIN zamowienia z ON z.klient_id = k.id
INNER JOIN pozycje_zamowien pz ON pz.zamowienie_id = z.id
GROUP BY k.id, k.imie, k.nazwisko
ORDER BY laczny_wydatek DESC 
LIMIT 5;


-- Zadanie 4
SELECT k.nazwa AS kategoria, COUNT(p.id) AS liczba_produktow
FROM kategorie k 
INNER JOIN produkty p ON p.kategoria_id = k.id
GROUP BY k.nazwa
HAVING COUNT (p.id) > 5;


-- Zadanie 5
SELECT p.nazwa AS niezamowiony_produkt
FROM produkty p
LEFT JOIN pozycje_zamowien pz ON pz.produkt_id = p.id
WHERE pz.produkt_id IS NULL;


-- Zadanie 6
SELECT status, COUNT(id) AS liczba_zamowien
FROM zamowienia
GROUP BY status;


-- Zadanie 7
SELECT p.imie, p.nazwisko, COUNT(z.id) AS liczba_zamowien
FROM pracownicy p
INNER JOIN zamowienia z ON z.pracownik_id = p.id
GROUP BY p.id, p.imie, p.nazwisko
ORDER BY liczba_zamowien DESC
LIMIT 1;


-- Zadanie 8
SELECT k.imie, k.nazwisko, COUNT(z.id) AS liczba_zamowien 
FROM klienci k
LEFT JOIN zamowienia z ON z.klient_id = k.id
GROUP BY k.id, k.imie, k.nazwisko;


-- Zadanie 9
SELECT k.nazwa AS kategoria, SUM(pz.ilosc * pz.cena_jednostkowa) AS laczna_wartosc_sprzedazy
FROM pozycje_zamowien pz
INNER JOIN produkty p ON pz.produkt_id = p.id
INNER JOIN kategorie k ON p.kategoria_id = k.id
GROUP BY k.id, k.nazwa
ORDER BY laczna_wartosc_sprzedazy DESC
LIMIT 5;


-- Zadanie 10
SELECT p1.nazwa, p1.cena
FROM produkty p1
WHERE p1.cena > (
	SELECT AVG(p2.cena)
	FROM produkty p2
	WHERE p2.kategoria_id = p1.kategoria_id 
	);


-- Zadanie 11
SELECT k.imie, k.nazwisko 
FROM klienci k
LEFT JOIN zamowienia z ON z.klient_id = k.id
WHERE z.id IS NULL;


-- Zadanie 12
SELECT k.nazwa AS kategoria, SUM(pz.ilosc) AS laczna_liczba_sztuk
FROM pozycje_zamowien pz
INNER JOIN produkty p ON pz.produkt_id = p.id
INNER JOIN kategorie k ON p.kategoria_id = k.id
GROUP BY k.id, k.nazwa;


-- Zadanie 13
SELECT p.imie, p.nazwisko, COUNT(z.id) AS liczba_obsluzonych_zamowien
FROM pracownicy p 
LEFT JOIN zamowienia z ON z.pracownik_id = p.id
GROUP BY p.id, p.imie, p.nazwisko
HAVING COUNT(z.id) < (
	SELECT AVG(x.ile_zamowien)
	FROM (
		SELECT COUNT(z2.id) AS ile_zamowien
		FROM pracownicy p2
		LEFT JOIN zamowienia z2 ON z2.pracownik_id = p2.id
		GROUP BY p2.id
		) 
		x
	)


-- Zadanie 14
SELECT p.nazwa AS produkt, COUNT(pz.id) AS liczba_wystapien
FROM produkty p
INNER JOIN pozycje_zamowien pz ON pz.produkt_id = p.id
GROUP BY p.id, p.nazwa
ORDER BY liczba_wystapien DESC
LIMIT 3;