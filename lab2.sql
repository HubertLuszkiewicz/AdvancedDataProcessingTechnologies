-- zad1
CREATE TABLE movies AS
SELECT * FROM ztpd.movies

-- zad 3
SELECT title FROM movies WHERE cover IS NULL;

-- zad 4
SELECT id, title, DBMS_LOB.getlength(cover) AS FILESIZE FROM movies
WHERE cover IS NOT null;

-- zad 5
SELECT id, title, DBMS_LOB.getlength(cover) AS FILESIZE FROM movies
WHERE cover IS null;

-- zad 6
SELECT directory_name, directory_path FROM all_directories;

-- zad 7
UPDATE movies
SET cover = EMPTY_BLOB(),
	mime_type = 'image/jpeg'
WHERE id = 66;

COMMIT;

-- zad 8
SELECT id, title, DBMS_LOB.getlength(cover) AS FILESIZE FROM MOVIES WHERE id IN ('65', '66')

-- zad 9
DECLARE
	v_bfile BFILE;
	v_blob  BLOB;
BEGIN
	v_bfile := BFILENAME('TPD_DIR', 'escape.jpg');
	
	SELECT cover
	INTO v_blob
	FROM movies
	WHERE id = 66
	FOR UPDATE;
	
	DBMS_LOB.FILEOPEN(v_bfile);
	DBMS_LOB.LOADFROMFILE(
        v_blob,v_bfile,DBMS_LOB.GETLENGTH(v_bfile)
	);
	DBMS_LOB.FILECLOSE(v_bfile);
	
	COMMIT;
END;

-- zad 10
CREATE TABLE TEMP_COVERS (
	movie_id NUMBER(12),
	image BFILE,
	mime_type VARCHAR(50)
)

SELECT * FROM TEMP_COVERS;

-- zad 11
INSERT INTO TEMP_COVERS
VALUES(
	65, BFILENAME('TPD_DIR', 'escape.jpg'), 'image/jpeg'
);

COMMIT;

SELECT * FROM TEMP_COVERS;

-- zad 12
SELECT movie_id, DBMS_LOB.getlength(image) FROM TEMP_COVERS;

-- zad 13

DECLARE
	v_bfile BFILE;
	v_type VARCHAR(50);
	a blob;
BEGIN
	SELECT image
	INTO v_bfile
	FROM TEMP_COVERS
	WHERE movie_id = 65
	FOR UPDATE;

	SELECT mime_type
	INTO v_type
	FROM TEMP_COVERS
	WHERE movie_id = 65
	FOR UPDATE;
	
	DBMS_LOB.createtemporary(a, TRUE);
	DBMS_LOB.FILEOPEN(v_bfile);
	DBMS_LOB.LOADFROMFILE(
        a, v_bfile, DBMS_LOB.GETLENGTH(v_bfile)
	);
	DBMS_LOB.FILECLOSE(v_bfile);
	
	UPDATE movies
	SET cover = a,
		mime_type = v_type
	WHERE id = 65;
	DBMS_LOB.freetemporary(a);
	
	COMMIT;
END;

SELECT * FROM movies;

-- zad 14
SELECT id AS movie_id, DBMS_LOB.getlength(cover) AS FILESIZE FROM MOVIES WHERE id IN ('65', '66')

-- zad 15
DROP TABLE movies;
