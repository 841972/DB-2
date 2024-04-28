ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- Eliminar restricciones y tablas en cascada
DROP TRIGGER verificar_iban;
DROP TRIGGER verificar_iban_ahorro;
DROP TRIGGER verificar_retirada_ingreso_transferencia;
DROP TRIGGER verificar_transferencia_ingreso_retirada;
DROP TRIGGER verificar_transferencia_retirada_ingreso;

DROP TABLE Retirada CASCADE CONSTRAINTS;
DROP TABLE Ingreso CASCADE CONSTRAINTS;
DROP TABLE Transferencia CASCADE CONSTRAINTS;
DROP TABLE Operacion CASCADE CONSTRAINTS;
DROP TABLE Cuenta_Corriente CASCADE CONSTRAINTS;
DROP TABLE Oficina CASCADE CONSTRAINTS;
DROP TABLE Cuenta_Ahorro CASCADE CONSTRAINTS;
DROP TABLE Posee CASCADE CONSTRAINTS;
DROP TABLE Cuenta CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;

-- Eliminar tablespace
DROP TABLESPACE pr2 INCLUDING CONTENTS AND DATAFILES;


-- Crear Tablespace
CREATE TABLESPACE pr2
DATAFILE 'pr2.dbf'
SIZE 10M;

CREATE TABLE Cliente (
    DNI VARCHAR(10) PRIMARY KEY,
    Telefono NUMBER(12) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Edad NUMBER(3) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
) TABLESPACE pr2;

CREATE TABLE Cuenta (
    IBAN VARCHAR(24) PRIMARY KEY,
    Num_cuenta NUMBER(20) NOT NULL,
    Saldo NUMBER(20,2) DEFAULT 0 NOT NULL,
    Fecha_creacion DATE NOT NULL
) TABLESPACE pr2;

CREATE TABLE Posee (
    DNI VARCHAR(10),
    IBAN VARCHAR(24),
    PRIMARY KEY (DNI, IBAN),
    FOREIGN KEY (DNI) REFERENCES Cliente(DNI),
    FOREIGN KEY (IBAN) REFERENCES Cuenta(IBAN)
) TABLESPACE pr2;

CREATE TABLE Cuenta_Ahorro (
    IBAN VARCHAR(24),
    Interes NUMBER(12,2) NOT NULL CHECK (Interes >= 0),
    PRIMARY KEY (IBAN),
    FOREIGN KEY (IBAN) REFERENCES Cuenta(IBAN)
) TABLESPACE pr2;


CREATE TABLE Oficina (
    Codigo VARCHAR(10) PRIMARY KEY,
    Direccion VARCHAR(100) NOT NULL,
    Telefono NUMBER(12) NOT NULL
) TABLESPACE pr2;

CREATE TABLE Cuenta_Corriente (
    IBAN VARCHAR(24),
    Oficina VARCHAR(10) NOT NULL,
    PRIMARY KEY (IBAN),
    FOREIGN KEY (Oficina) REFERENCES Oficina(Codigo),
    FOREIGN KEY (IBAN) REFERENCES Cuenta(IBAN)
) TABLESPACE pr2;

CREATE TABLE Operacion (
    Numero_Operacion NUMBER(10) PRIMARY KEY,
    Momento DATE NOT NULL,
    Cantidad NUMBER(20,2) NOT NULL,
    Descipcion VARCHAR(100),
    Cuenta_Origen VARCHAR(34) NOT NULL,
    FOREIGN KEY (Cuenta_Origen) REFERENCES Cuenta(IBAN)
) TABLESPACE pr2;

CREATE TABLE Transferencia (
    Numero_Operacion NUMBER(10),
    Cuenta_Destino VARCHAR(24) NOT NULL,
    PRIMARY KEY (Numero_Operacion),
    FOREIGN KEY (Numero_Operacion) REFERENCES Operacion(Numero_Operacion),
    FOREIGN KEY (Cuenta_Destino) REFERENCES Cuenta(IBAN)
) TABLESPACE pr2;

CREATE TABLE Ingreso (
    Numero_Operacion NUMBER(10),
    Codigo_Oficina VARCHAR(10) NOT NULL,
    PRIMARY KEY (Numero_Operacion),
    FOREIGN KEY (Codigo_Oficina) REFERENCES Oficina(Codigo),
    FOREIGN KEY (Numero_Operacion) REFERENCES Operacion(Numero_Operacion)
) TABLESPACE pr2;

CREATE TABLE Retirada (
    Numero_Operacion NUMBER(10),
    Codigo_Oficina VARCHAR(10) NOT NULL,
    PRIMARY KEY (Numero_Operacion),
    FOREIGN KEY (Codigo_Oficina) REFERENCES Oficina(Codigo),
    FOREIGN KEY (Numero_Operacion) REFERENCES Operacion(Numero_Operacion)
) TABLESPACE pr2;


-- Trigger para verificar si una cuenta corriente está asociada a un IBAN que ya tiene una cuenta de ahorro
CREATE OR REPLACE TRIGGER verificar_iban
BEFORE INSERT OR UPDATE ON Cuenta_Corriente
FOR EACH ROW
DECLARE
    cuenta_ahorro_existente NUMBER;
BEGIN
    SELECT COUNT(*) INTO cuenta_ahorro_existente
    FROM Cuenta_Ahorro
    WHERE IBAN = :NEW.IBAN;

    IF cuenta_ahorro_existente > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede asociar una cuenta corriente a un IBAN que ya tiene una cuenta de ahorro.');
    END IF;
END;
/

-- Trigger para verificar si una cuenta de ahorro está asociada a un IBAN que ya tiene una cuenta corriente
CREATE OR REPLACE TRIGGER verificar_iban_ahorro
BEFORE INSERT OR UPDATE ON Cuenta_Ahorro
FOR EACH ROW
DECLARE
    cuenta_corriente_existente NUMBER;
BEGIN
    SELECT COUNT(*) INTO cuenta_corriente_existente
    FROM Cuenta_Corriente
    WHERE IBAN = :NEW.IBAN;

    IF cuenta_corriente_existente > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se puede asociar una cuenta de ahorro a un IBAN que ya tiene una cuenta corriente.');
    END IF;
END;
/


-- Trigger para asegurarse de que no haya una retirada o un ingreso con el mismo número de operación antes de insertar o actualizar una transferencia
CREATE OR REPLACE TRIGGER verificar_retirada_ingreso_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW
DECLARE
    ingreso_existente NUMBER;
    retirada_existente NUMBER;
BEGIN
    SELECT COUNT(*) INTO ingreso_existente
    FROM Ingreso
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    SELECT COUNT(*) INTO retirada_existente
    FROM Retirada
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    IF ingreso_existente > 0 OR retirada_existente > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No se puede asociar una transferencia con una operación de ingreso o retirada con el mismo número de operación.');
    END IF;
END;
/


-- Trigger para asegurarse de que no haya una transferencia o un ingreso con el mismo número de operación antes de insertar o actualizar una retirada
CREATE OR REPLACE TRIGGER verificar_transferencia_ingreso_retirada
BEFORE INSERT OR UPDATE ON Retirada
FOR EACH ROW
DECLARE
    ingreso_existente NUMBER;
    transferencia_existente NUMBER;
BEGIN
    SELECT COUNT(*) INTO ingreso_existente
    FROM Ingreso
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    SELECT COUNT(*) INTO transferencia_existente
    FROM Transferencia
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    IF ingreso_existente > 0 OR transferencia_existente > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No se puede asociar una retirada con una operación de ingreso o transferencia con el mismo número de operación.');
    END IF;
END;
/


-- Trigger para asegurarse de que no haya una transferencia o una retirada con el mismo número de operación antes de insertar o actualizar un ingreso
CREATE OR REPLACE TRIGGER verificar_transferencia_retirada_ingreso
BEFORE INSERT OR UPDATE ON Ingreso
FOR EACH ROW
DECLARE
    transferencia_existente NUMBER;
    retirada_existente NUMBER;
BEGIN
    SELECT COUNT(*) INTO transferencia_existente
    FROM Transferencia
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    SELECT COUNT(*) INTO retirada_existente
    FROM Retirada
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    IF transferencia_existente > 0 OR retirada_existente > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'No se puede asociar un ingreso con una operación de transferencia o retirada con el mismo número de operación.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER actualizar_saldo_ingreso
AFTER INSERT ON Ingreso
FOR EACH ROW
DECLARE
    v_cantidad NUMBER(10); -- Variable para almacenar la cantidad de la operación
BEGIN
    -- Obtiene la cantidad de la operación correspondiente al nuevo ingreso
    SELECT Cantidad INTO v_cantidad
    FROM Operacion
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Actualiza el saldo sumando la cantidad ingresada a la cuenta asociada a la operación
    UPDATE Cuenta
    SET Saldo = Saldo + v_cantidad
    WHERE IBAN = (SELECT Cuenta_Origen FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
END;
/


CREATE OR REPLACE TRIGGER actualizar_saldo_retirada
AFTER INSERT ON Retirada
FOR EACH ROW
DECLARE
    v_cantidad NUMBER(10); -- Variable para almacenar la cantidad de la operación
BEGIN
    -- Obtiene la cantidad de la operación correspondiente a la nueva retirada
    SELECT Cantidad INTO v_cantidad
    FROM Operacion
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Actualiza el saldo restando la cantidad retirada de la cuenta asociada a la operación
    UPDATE Cuenta
    SET Saldo = Saldo - v_cantidad
    WHERE IBAN = (SELECT Cuenta_Origen FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
END;
/


CREATE OR REPLACE TRIGGER actualizar_saldo_transferencia
AFTER INSERT ON Transferencia
FOR EACH ROW
DECLARE
    v_cantidad NUMBER(10); -- Variable para almacenar la cantidad de la operación
BEGIN
    -- Obtiene la cantidad de la operación correspondiente a la nueva transferencia
    SELECT Cantidad INTO v_cantidad
    FROM Operacion
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Actualiza el saldo restando la cantidad transferida de la cuenta origen
    UPDATE Cuenta
    SET Saldo = Saldo - v_cantidad
    WHERE IBAN = (SELECT Cuenta_Origen FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);

    -- Actualiza el saldo sumando la cantidad transferida a la cuenta destino
    UPDATE Cuenta
    SET Saldo = Saldo + v_cantidad
    WHERE IBAN = :NEW.Cuenta_Destino;
END;
/

