
-- Comandos de IBM DB2
-- El nombre de la base de datos debe comenzar con una letra (A-Z) o un guion bajo (_) y puede contener letras, números y guiones bajos.
CREATE DATABASE Base1
ACTIVATE DATABASE Base1
connect to Base1
-- Crear un esquema
CREATE SCHEMA inventario AUTHORIZATION DB2ADMIN

CREATE TABLESPACE t1;

SET SCHEMA inventario;
--Para su correcto funcionamientto hay que ponerlo todo en una sola linea
CREATE TABLE inventario.Base1
 (cantidad INT NOT NULL,
 nombre VARCHAR(50) NOT NULL,
 id VARCHAR(50) NOT NULL,
 detalles VARCHAR(100) NOT NULL,
  PRIMARY KEY(id)) 
  IN Base1.t1;
CREATE TABLE inventario.Comida
  (cantidad INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  PRIMARY KEY(nombre))
  IN Base1.t1;


INSERT INTO inventario.Base1 (cantidad, nombre, id, detalles) VALUES (123456, 'papel', '158481', 'blanco');

INSERT INTO inventario.Base1 (cantidad, nombre, id, detalles) VALUES (100, 'bolis', '987654', 'azules');

INSERT INTO inventario.Comida (cantidad, nombre) VALUES (100, 'manzanas');


-- Sentencias UPDATE
UPDATE inventario.Base1 SET cantidad = 100 WHERE id = '987654';
UPDATE inventario.Comida SET cantidad = 200 WHERE nombre = 'manzanas';

-- Sentencias DELETE

DELETE FROM inventario.Base1 WHERE id = 987654;


-- Sentencias SELECT

SELECT * FROM inventario.Base1;

SELECT * FROM inventario.Comida;



CREATE ROLE leer;

GRANT CONNECT ON DATABASE TO ROLE leer;

GRANT SELECTIN ON SCHEMA inventario TO ROLE leer;

GRANT USE OF TABLESPACE t1 TO ROLE leer;

SET SCHEMA inventario;

GRANT SELECT ON TABLE Base1 TO ROLE leer;

GRANT SELECT ON TABLE Comida TO ROLE leer;

-- borrar.sql

CONNECT RESET

DROP DATABASE Base1




