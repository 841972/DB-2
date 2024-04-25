
-- Elimina el usuario 'superusuario' si existe.
DROP USER IF EXISTS superusuario;

-- Crea un nuevo usuario llamado 'root' con permisos de superusuario, la capacidad de crear nuevas bases de datos y roles, y la contraseña 'root'.
CREATE USER root WITH SUPERUSER CREATEDB CREATEROLE PASSWORD 'root';

-- Elimina la base de datos 'mi_base_de_datos' si existe.
DROP DATABASE IF EXISTS mi_base_de_datos;

-- Crea una nueva base de datos llamada 'mi_base_de_datos'.
CREATE DATABASE mi_base_de_datos;

-- Establece la conexión con la base de datos recién creada ('mi_base_de_datos').
\c mi_base_de_datos;

-- Crea una tabla llamada 'usuarios' con dos columnas: 'id' y 'nombre'.
CREATE TABLE usuarios (id SERIAL PRIMARY KEY,nombre VARCHAR(100));

-- Inserta tres filas en la tabla 'usuarios' con nombres 'Usuario1', 'Usuario2' y 'Usuario3'.
INSERT INTO usuarios (nombre) VALUES ('Usuario1'), ('Usuario2'), ('Usuario3');

-- Crea una tabla llamada 'productos' con tres columnas: 'id', 'nombre' y 'precio'.
CREATE TABLE productos (id SERIAL PRIMARY KEY,nombre VARCHAR(100),precio NUMERIC);

-- Inserta tres filas en la tabla 'productos' con nombres de producto y precios específicos.
INSERT INTO productos (nombre, precio) VALUES ('Producto1', 10.99), ('Producto2', 20.49), ('Producto3', 5.99);

-- Realiza una consulta para seleccionar todas las filas y columnas de la tabla 'productos' e imprime los resultados.
SELECT * FROM productos;

-- Elimina la tabla 'productos' si existe.
DROP TABLE IF EXISTS productos;

