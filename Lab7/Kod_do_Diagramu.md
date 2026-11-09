// Tabele bazowe (baza sklep)
Table kategorie {
  id integer [primary key]
  nazwa varchar
  opis text
}

Table produkty {
  id integer [primary key]
  nazwa varchar
  kategoria_id integer
  cena numeric
  ilosc_magazyn integer
  data_dodania date
}

Table klienci {
  id integer [primary key]
  imie varchar
  nazwisko varchar
  email varchar
  data_rejestracji date
  miasto varchar
}

Table pracownicy {
  id integer [primary key]
  imie varchar
  nazwisko varchar
  stanowisko varchar
  data_zatrudnienia date
}

Table zamowienia {
  id integer [primary key]
  klient_id integer
  pracownik_id integer
  data_zamowienia date
  status varchar
}

Table pozycje_zamowien {
  id integer [primary key]
  zamowienie_id integer
  produkt_id integer
  ilosc integer
  cena_jednostkowa numeric
}


// Wybrany temat (opinie/recenzje)
// Tabela łączy relacją N:M klientów i produkty
Table opinie {
  id integer [primary key]
  klient_id integer
  produkt_id integer
  status_id integer
  ocena integer
  komentarz text
  data_wstawienia date
}

// Tabela pomocnicza
Table statusy_opinii {
  id integer [primary key]
  nazwa varchar
}


// Relacje instniejące w bazie sklep
Ref: produkty.kategoria_id > kategorie.id
Ref: zamowienia.klient_id > klienci.id
Ref: zamowienia.pracownik_id > pracownicy.id
Ref: pozycje_zamowien.zamowienie_id > zamowienia.id
Ref: pozycje_zamowien.produkt_id > produkty.id

// Relacje (FK) związane z nowymi tabelami
Ref: opinie.klient_id > klienci.id
Ref: opinie.produkt_id > produkty.id
Ref: opinie.status_id > statusy_opinii.id