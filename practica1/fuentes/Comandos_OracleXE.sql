ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- Crear Tablespace
CREATE TABLESPACE tb2
DATAFILE 'tb2.dbf'
SIZE 10M;

-- Crear tabla de Corredor
CREATE TABLE Corredor (
    id_corredor INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(50),
    equipo VARCHAR(50)
) TABLESPACE tb2;

-- Crear tabla de Carrera
CREATE TABLE Carrera (
    id_carrera INT PRIMARY KEY,
    ubicacion VARCHAR(100)
) TABLESPACE tb2;

-- Crear tabla de Resultados de Carreras
CREATE TABLE Resultados_Carreras (
    id_resultado INT PRIMARY KEY,
    id_carrera INT,
    id_corredor INT,
    posicion_final INT,
    FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera),
    FOREIGN KEY (id_corredor) REFERENCES Corredor(id_corredor)
) TABLESPACE tb2;

 ALTER SESSION SET "_ORACLE_SCRIPT"=true;
 ALTER SESSION SET current_schema=system;

-- Insertar datos de ejemplo en la tabla de Corredores
INSERT INTO Corredor (id_corredor, nombre, nacionalidad, equipo) VALUES
(1, 'Lewis Hamilton', 'Británico', 'Mercedes');

-- Insertar datos de ejemplo en la tabla de Carreras
INSERT INTO Carrera (id_carrera, ubicacion) VALUES
(1, 'Monaco');

-- Insertar datos de ejemplo en la tabla de Resultados de Carreras
INSERT INTO Resultados_Carreras (id_resultado, id_carrera, id_corredor, posicion_final) VALUES (1, 1, 1, 1);

--Actualizamos algunas entradas

UPDATE Corredor
SET nombre = 'Fernando Alonso'
WHERE nombre = 'Valtteri Bottas';

UPDATE Resultados_Carreras
SET posicion_final = 4
WHERE id_resultado = 5;

-- Deletes
DELETE FROM Corredor
WHERE nombre = 'Charles Leclerc';


DELETE FROM Resultados_Carreras
WHERE id_resultado = 7;

-- Selects
SELECT * FROM Corredor;

SELECT * FROM Carrera;

SELECT * FROM Resultados_Carreras;



ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER escritor IDENTIFIED BY escribir DEFAULT TABLESPACE tb2;
CREATE USER lector IDENTIFIED BY leer DEFAULT TABLESPACE tb2;

CREATE ROLE escribir;
GRANT CREATE SESSION TO escribir;
GRANT SELECT, INSERT, DELETE, UPDATE ON Corredor TO escribir;
GRANT SELECT, INSERT, DELETE, UPDATE ON Carrera TO escribir;
GRANT SELECT, INSERT, DELETE, UPDATE ON Resultados_Carreras TO escribir;
GRANT escribir TO escritor ;

CREATE ROLE leer;
GRANT CREATE SESSION TO leer;
GRANT SELECT ON Corredor TO leer;
GRANT SELECT ON Carrera TO leer;
GRANT SELECT ON Resultados_Carreras TO leer;
GRANT leer TO lector ;

-- De cara a crear un superusuario con credenciales seguras, podemos ejecutar los siguientes comandos:

CREATE USER nombre_superusuario IDENTIFIED BY contrasenya_a_elegir;
GRANT DBA TO superusuario;


-- Eliminar todas las tablas
DROP TABLE Resultados_Carreras;
DROP TABLE Carrera;
DROP TABLE Corredor;

DROP USER escritor;
DROP USER lector; 
DROP ROLE escribir; 
DROP ROLE leer; 

DROP USER nombre_superusuario;

-- Eliminar el tablespace
DROP TABLESPACE tb2 INCLUDING CONTENTS AND DATAFILES;