Zaprojektowane rozszerzenie wprowadza system opinii, który realizuje relację wiele do wielu (N:M) pomiędzy tabelą klienci, a tabelą produkty za pomocą dedykowanej tabeli łączącej (opinie).
Klienci mogą wystawiać opinie w postaci ocen i komenatrzy zakupionym produktom, a tabela pomocnicza (statusy_opinii) umożliwia sprawną moderację wpisów przy zachowaniu spójności bazy danych.

Pytania:
1) Ilu różnych produktów może dotyczyć opinia wystawiona przez jednego klienta? Odpowiedź: Wielu (klient może ocenić wiele produktów).
2) Ilu różnych klientów może wystawić opinię dla jednego produktu? Odpowiedź: Wielu (produkt może zebrać oceny od różnych klientów).
To daje relacje wiele do wielu (N:M).