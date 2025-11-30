-- zad 1
CREATE TABLE DOKUMENTY(
	ID NUMBER(12) PRIMARY KEY,
	DOKUMENT CLOB
);

SELECT * FROM DOKUMENTY;

-- zad 2
DECLARE
	v_clob CLOB;
	v_text VARCHAR(10) := 'Oto tekst.';
	i NUMBER;
BEGIN
	DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);
    FOR i IN 1..10000 LOOP
        DBMS_LOB.APPEND(v_clob, v_text);
    END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Długość CLOB: ' || DBMS_LOB.GETLENGTH(v_clob));
	
	INSERT INTO DOKUMENTY
	VALUES(1, v_clob);
	
	COMMIT;
	
	DBMS_LOB.FREETEMPORARY(v_clob);
END;

SELECT * FROM DOKUMENTY;

-- zad 3
SELECT * FROM DOKUMENTY;

SELECT UPPER(dokument) FROM DOKUMENTY;

SELECT LENGTH(dokument) FROM DOKUMENTY;

SELECT DBMS_LOB.GETLENGTH(dokument) FROM DOKUMENTY;

SELECT SUBSTR(dokument, 5, 1000) FROM DOKUMENTY;

SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM DOKUMENTY;

-- zad 4
INSERT INTO DOKUMENTY
VALUES(2, EMPTY_CLOB());

SELECT * FROM DOKUMENTY;

-- zad 5
INSERT INTO DOKUMENTY
VALUES(3, NULL);

SELECT * FROM DOKUMENTY;

COMMIT;

--zad 6
SELECT * FROM DOKUMENTY;

SELECT UPPER(dokument) FROM DOKUMENTY;

SELECT LENGTH(dokument) FROM DOKUMENTY;

SELECT DBMS_LOB.GETLENGTH(dokument) FROM DOKUMENTY;

SELECT SUBSTR(dokument, 5, 1000) FROM DOKUMENTY;

SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM DOKUMENTY;

-- zad 7
DECLARE
	v_bfile BFILE;
	v_clob  CLOB;
	doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
	warn integer := null;
BEGIN
	v_bfile := BFILENAME('TPD_DIR', 'dokument.txt');
	SELECT dokument
	INTO v_clob
	FROM DOKUMENTY
	WHERE id = 2
	FOR UPDATE;

	DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.LOB_READONLY);
	DBMS_LOB.LOADCLOBFROMFILE(v_clob, v_bfile, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 873, langctx, warn);
	DBMS_LOB.FILECLOSE(v_bfile);
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('Transakcja zatwierdzona. Kopiowanie zakończone pomyślnie.');
END;

SELECT * FROM DOKUMENTY;

-- zad 8

UPDATE DOKUMENTY
SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'), 873, 'text/xml')
WHERE id = 3;

-- zad 9
SELECT * FROM DOKUMENTY;

-- zad 10
SELECT LENGTH(dokument) FROM DOKUMENTY;

-- zad 11
CREATE OR REPLACE FUNCTION CLOB_CENSOR (
    p_clob IN OUT CLOB,
    p_text IN VARCHAR2
) RETURN CLOB IS
    position INTEGER := 1;
    v_len INTEGER := LENGTH(p_text);
    v_replacement VARCHAR2(4000);
BEGIN
    v_replacement := RPAD('.', v_len, '.');
    
    LOOP
        position := INSTR(p_clob, p_text, position);
        EXIT WHEN position = 0;

        DBMS_LOB.WRITE(p_clob, v_len, position, v_replacement);
        position := position + v_len;
    END LOOP;

    RETURN p_clob;
END CLOB_CENSOR;

-- zad 13
CREATE TABLE biographies AS(
	SELECT * FROM ZTPD.biographies
);

DECLARE
	v_clob CLOB;
BEGIN
	SELECT BIO INTO v_clob FROM biographies WHERE ID = 1 FOR UPDATE;
	
	v_clob := CLOB_CENSOR(v_clob, 'Cimrman');
	
	UPDATE biographies SET bio = v_clob WHERE ID = 1;
	
	COMMIT;
END;

SELECT BIO FROM biographies;



