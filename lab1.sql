-- zad 1
CREATE TYPE samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

DESC samochod;

CREATE TABLE samochody OF samochod;
INSERT INTO samochody VALUES(NEW samochod('Renault', 'Clio', 180000, DATE '2010-01-01', 5000));
INSERT INTO samochody VALUES(NEW samochod('Fiat', 'Brava', 60000, DATE '1999-11-30', 25000));
INSERT INTO samochody VALUES(NEW samochod('Ford', 'Mondeo', 10000, DATE '2016-05-01', 12000));

SELECT * FROM samochody;

-- zad 2
CREATE TABLE wlasciciele (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100),
    auto samochod
);

DESC wlasciciele;

INSERT INTO wlasciciele VALUES('Jan', 'Kowalski', NEW samochod('Renault', 'Clio', 180000, DATE '2010-01-01', 5000));
INSERT INTO wlasciciele VALUES('Dawid', 'Nowak', NEW samochod('Fiat', 'Brava', 60000, DATE '1999-11-30', 25000));

SELECT * FROM wlasciciele;

-- zad 3
ALTER TYPE samochod REPLACE AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN
            RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
        END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM samochody s;

-- zad 4
ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN
            RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
        END wartosc;
        
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN ROUND(kilometry / 10000) + (EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
    END odwzoruj;
END;

SELECT * FROM samochody s ORDER BY VALUE(s);

-- zad 5
CREATE TYPE wlasciciel AS OBJECT (
    imie VARCHAR2(20),
    nazwisko VARCHAR2(20)
);

CREATE TABLE wlasciciele_obj OF wlasciciel;

INSERT INTO wlasciciele_obj VALUES (NEW wlasciciel('Jan', 'Kowalski'));
INSERT INTO wlasciciele_obj VALUES (NEW wlasciciel('Dawid', 'Nowak'));
INSERT INTO wlasciciele_obj VALUES (NEW wlasciciel('Anna', 'Wiśniewska'));

CREATE OR REPLACE TYPE samochod_new AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2),
    wlasciciel_ref REF wlasciciel,
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER
);

CREATE TABLE samochody_new OF samochod_new;

INSERT INTO samochody_new
SELECT 'Renault', 'Clio', 180000, DATE '2010-01-01', 5000,
       REF(w)
FROM wlasciciele_obj w
WHERE w.imie = 'Jan' AND w.nazwisko = 'Kowalski';

SELECT * FROM samochody_new;

-- zad 6
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zad 7
DECLARE
 TYPE t_tytuly IS VARRAY(15) OF VARCHAR2(20);
 moje_tytuly t_tytuly := t_tytuly('','');
BEGIN
 moje_tytuly(1) := 'Dzieci z Bullerbyn';
 moje_tytuly(2) := 'Harry Potter';
 moje_tytuly.EXTEND(13);
 FOR i IN 3..15 LOOP
 moje_tytuly(i) := 'KSIAZKA ' || i;
 END LOOP;
 FOR i IN moje_tytuly.FIRST()..moje_tytuly.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_tytuly(i));
 END LOOP;
 moje_tytuly.TRIM(10);
 FOR i IN moje_tytuly.FIRST()..moje_tytuly.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_tytuly(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_tytuly.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_tytuly.COUNT());
END;

-- zad 8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- zad 9
DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(20);
 miesiace t_miesiace := t_miesiace();
BEGIN
 miesiace.EXTEND(12);
    miesiace(1) := 'STYCZEŃ';
    miesiace(2) := 'LUTY';
    miesiace(3) := 'MARZEC';
    miesiace(4) := 'KWIECIEŃ';
    miesiace(5) := 'MAJ';
    miesiace(6) := 'CZERWIEC';
    miesiace(7) := 'LIPIEC';
    miesiace(8) := 'SIERPIEŃ';
    miesiace(9) := 'WRZESIEŃ';
    miesiace(10) := 'PAŹDZIERNIK';
    miesiace(11) := 'LISTOPAD';
    miesiace(12) := 'GRUDZIEŃ';
 FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
 IF miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(miesiace(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
 
 miesiace.DELETE(1);
 miesiace.DELETE(5);
 FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
 IF miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(miesiace(i));
 END IF;
 END LOOP;
END;

-- zad 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE stypendia
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- zad 11
CREATE TYPE produkt AS OBJECT (
    nazwa VARCHAR2(50),
    cena  NUMBER(8,2)
);
/
CREATE TYPE koszyk_produktow AS TABLE OF produkt;
/
CREATE TABLE zakupy (
    id_zakupu NUMBER PRIMARY KEY,
    data_zakupu DATE,
    koszyk koszyk_produktow
)
NESTED TABLE koszyk STORE AS koszyk_tabela;
/
INSERT INTO zakupy VALUES (
    1,
    DATE '2025-10-10',
    koszyk_produktow(
        produkt('Chleb', 5.50),
        produkt('Masło', 8.20),
        produkt('Mleko', 4.00)
    )
);

INSERT INTO zakupy VALUES (
    2,
    DATE '2025-10-11',
    koszyk_produktow(
        produkt('Jajka', 12.00),
        produkt('Chleb', 5.50),
        produkt('Kawa', 25.00)
    )
);

INSERT INTO zakupy VALUES (
    3,
    DATE '2025-10-12',
    koszyk_produktow(
        produkt('Herbata', 10.00),
        produkt('Cukier', 6.50)
    )
);
SELECT z.id_zakupu,
       z.data_zakupu,
       p.nazwa AS produkt,
       p.cena
FROM zakupy z,
     TABLE(z.koszyk) p
ORDER BY z.id_zakupu;
DELETE FROM zakupy z
WHERE EXISTS (
    SELECT 1
    FROM TABLE(z.koszyk) p
    WHERE p.nazwa = 'Chleb'
);
SELECT z.id_zakupu,
       z.data_zakupu,
       p.nazwa AS produkt
FROM zakupy z,
     TABLE(z.koszyk) p
ORDER BY z.id_zakupu;

-- zad 12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
/
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
/
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
/
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
 BEGIN
 DBMS_OUTPUT.PUT_LINE(tamburyn.graj);
 DBMS_OUTPUT.PUT_LINE(trabka.graj);
 DBMS_OUTPUT.PUT_LINE(trabka.graj('glosno'));
 DBMS_OUTPUT.PUT_LINE(fortepian.graj);
END;

-- zad 13
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
/
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
/
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
/
DECLARE
 KrolLew lew := lew('LEW',4);
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- zad 14
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
END;

-- zad 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;