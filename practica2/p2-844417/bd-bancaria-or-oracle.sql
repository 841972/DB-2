DROP TRIGGER validar_numero_operacion_ingreso;
DROP TRIGGER validar_numero_operacion_retirada;
DROP TRIGGER validar_numero_operacion_transferencia;
DROP TRIGGER actualizar_saldo_transferencia;
DROP TRIGGER actualizar_saldo_retirada;
DROP TRIGGER actualizar_saldo_ingreso;
DROP TRIGGER validar_IBAN_Ahorro;
DROP TRIGGER validar_IBAN_Corriente;

BEGIN
    DBMS_SCHEDULER.DROP_JOB('actualizar_saldoP');
END;
/

DROP TABLE Retirada;
DROP TABLE Ingreso;
DROP TABLE Transferencia;
DROP TABLE Operacion;
DROP TABLE Cuenta_Corriente;
DROP TABLE Oficina;
DROP TABLE Cuenta_Ahorro;
DROP TABLE Cuenta;
DROP TABLE Cliente;

DROP TYPE VRetiradaUDT force;
DROP TYPE VIngresoUDT force;
DROP TYPE VTransferenciaUDT force;
DROP TYPE VOperacionUDT force;
DROP TYPE VCuentaAhorroUDT force;
DROP TYPE VCuentaCorrienteUDT force;
DROP TYPE VClienteUDT force;
DROP TYPE VCuentaUDT force;
DROP TYPE RetiradaUDT force;
DROP TYPE IngresoUDT force;
DROP TYPE TransferenciaUDT force;
DROP TYPE OperacionUDT force;
DROP TYPE OficinaUDT force;
DROP TYPE Cuenta_CorrienteUDT force;
DROP TYPE Cuenta_AhorroUDT force;
DROP TYPE ClienteUDT force;
DROP TYPE CuentaUDT force;


CREATE TYPE CuentaUDT;
/
CREATE TYPE ClienteUDT;
/
CREATE TYPE Cuenta_AhorroUDT;
/
CREATE TYPE Cuenta_CorrienteUDT;
/
CREATE TYPE OficinaUDT;
/
CREATE TYPE OperacionUDT;
/
CREATE TYPE TransferenciaUDT;
/
CREATE TYPE IngresoUDT;
/
CREATE TYPE RetiradaUDT;
/

CREATE OR REPLACE TYPE VCuentaUDT AS VARRAY(100) of REF CuentaUDT;
/
CREATE OR REPLACE TYPE VClienteUDT AS VARRAY(100) of REF ClienteUDT;
/
CREATE OR REPLACE TYPE VCuentaCorrienteUDT AS VARRAY(100) of REF Cuenta_CorrienteUDT;
/
CREATE OR REPLACE TYPE VCuentaAhorroUDT AS VARRAY(100) of REF Cuenta_AhorroUDT;
/
CREATE OR REPLACE TYPE VOperacionUDT AS VARRAY(100) of REF OperacionUDT;
/
CREATE OR REPLACE TYPE VTransferenciaUDT AS VARRAY(100) of REF TransferenciaUDT;
/
CREATE OR REPLACE TYPE VIngresoUDT AS VARRAY(100) of REF IngresoUDT;
/
CREATE OR REPLACE TYPE VRetiradaUDT AS VARRAY(100) of REF RetiradaUDT;
/


CREATE OR REPLACE TYPE ClienteUDT AS OBJECT (
    DNI VARCHAR2(9),
    Telefono NUMBER(9),
    Nombre VARCHAR2(50),
    Apellidos VARCHAR2(50),
    Edad NUMBER(3),
    Direccion VARCHAR2(100),
    Email VARCHAR2(100),
    Cuentas VCuentaUDT
);
/

CREATE OR REPLACE TYPE OficinaUDT AS OBJECT (
    Codigo VARCHAR2(10),
    Direccion VARCHAR2(100),
    Telefono NUMBER(9),
    CuentasC VCuentaCorrienteUDT,
    Ingresos VIngresoUDT,
    Retiradas VRetiradaUDT
);
/

CREATE OR REPLACE TYPE CuentaUDT AS OBJECT (
    IBAN VARCHAR2(24),
    Num_cuenta NUMBER(20),
    Saldo NUMBER(20,2),
    Fecha_creacion DATE,
    Clientes VClienteUDT,
    Operaciones VOperacionUDT,
    Transferencias VTransferenciaUDT
) NOT FINAL;
/

CREATE OR REPLACE TYPE Cuenta_AhorroUDT UNDER CuentaUDT (
    Interes NUMBER(12,2)
) FINAL;
/

CREATE OR REPLACE TYPE Cuenta_CorrienteUDT UNDER CuentaUDT (
    Oficina REF OficinaUDT
) FINAL;
/


CREATE OR REPLACE TYPE OperacionUDT AS OBJECT (
    Numero_Operacion NUMBER(10),
    Momento DATE,
    Cantidad NUMBER(20,2),
    Descipcion VARCHAR2(250),
    Cuenta_Origen REF CuentaUDT
) NOT FINAL;
/

CREATE OR REPLACE TYPE TransferenciaUDT UNDER OperacionUDT (
    Cuenta_Destino REF CuentaUDT
) FINAL;
/

CREATE OR REPLACE TYPE IngresoUDT UNDER OperacionUDT (
    Oficina REF OficinaUDT
) FINAL;
/

CREATE OR REPLACE TYPE RetiradaUDT UNDER OperacionUDT (
    Oficina REF OficinaUDT
) FINAL;
/

CREATE TABLE Cliente OF ClienteUDT(
    DNI PRIMARY KEY,
    Edad NOT NULL,
    Nombre NOT NULL,
    Apellidos NOT NULL,
    Telefono NOT NULL,
    Direccion NOT NULL
);

CREATE TABLE Cuenta OF CuentaUDT(
    IBAN PRIMARY KEY,
    Num_cuenta NOT NULL,
    Saldo DEFAULT 0 NOT NULL CHECK (Saldo >= 0),
    Fecha_creacion NOT NULL,
    Clientes NOT NULL
);

CREATE TABLE Cuenta_Ahorro OF Cuenta_AhorroUDT(
    Interes NOT NULL
);

CREATE TABLE Oficina OF OficinaUDT(
    Codigo PRIMARY KEY,
    Direccion NOT NULL,
    Telefono NOT NULL
);

CREATE TABLE Cuenta_Corriente OF Cuenta_CorrienteUDT(
    Oficina REFERENCES Oficina
);

CREATE TABLE Operacion OF OperacionUDT(
    Numero_Operacion PRIMARY KEY,
    Momento NOT NULL,
    Cantidad NOT NULL,
    Cuenta_Origen REFERENCES Cuenta
);

CREATE TABLE Transferencia OF TransferenciaUDT(
    Cuenta_Destino REFERENCES Cuenta
);

CREATE TABLE Ingreso OF IngresoUDT(
    Oficina REFERENCES Oficina
);

CREATE TABLE Retirada OF RetiradaUDT(
    Oficina REFERENCES Oficina
);


--Triggers

-- Trigger para comprobar que el IBAN de una cuenta corriente no pertenezca a una cuenta de ahorro
CREATE OR REPLACE TRIGGER validar_IBAN_Corriente
BEFORE INSERT OR UPDATE ON Cuenta_Corriente
FOR EACH ROW
DECLARE
    cuenta_ahorro_count NUMBER;
BEGIN
    -- Comprobar si el IBAN que se va a insertar pertenece a una cuenta de ahorro
    SELECT COUNT(*)
    INTO cuenta_ahorro_count
    FROM Cuenta_Ahorro
    WHERE IBAN = :NEW.IBAN;

    -- Si se encuentra el IBAN en la tabla de cuentas de ahorro, lanzar un error
    IF cuenta_ahorro_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El IBAN pertenece a una cuenta de ahorro y no puede ser utilizado para una cuenta corriente.');
    END IF;
END;
/


-- Trigger para comprobar que el IBAN de una cuenta de ahorro no pertenezca a una cuenta corriente
CREATE OR REPLACE TRIGGER validar_IBAN_Ahorro
BEFORE INSERT OR UPDATE ON Cuenta_Ahorro
FOR EACH ROW
DECLARE
    cuenta_corriente_count NUMBER;
BEGIN
    -- Comprobar si el IBAN que se va a insertar pertenece a una cuenta corriente
    SELECT COUNT(*)
    INTO cuenta_corriente_count
    FROM Cuenta_Corriente
    WHERE IBAN = :NEW.IBAN;

    -- Si se encuentra el IBAN en la tabla de cuentas corrientes, lanzar un error
    IF cuenta_corriente_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El IBAN pertenece a una cuenta corriente y no puede ser utilizado para una cuenta de ahorro.');
    END IF;
END;
/

-- Trigger para actualizar el saldo después de un ingreso
CREATE OR REPLACE TRIGGER actualizar_saldo_ingreso
AFTER INSERT OR UPDATE ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Cuenta
    SET Saldo = Saldo + :NEW.Cantidad
    WHERE IBAN = (SELECT IBAN FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
END;
/


-- Trigger para actualizar el saldo después de una retirada
CREATE OR REPLACE TRIGGER actualizar_saldo_retirada
AFTER INSERT OR UPDATE ON Retirada
FOR EACH ROW
BEGIN
    UPDATE Cuenta
    SET Saldo = Saldo - :NEW.Cantidad
    WHERE IBAN = (SELECT IBAN FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
END;
/


-- Trigger para actualizar el saldo después de una transferencia
CREATE OR REPLACE TRIGGER actualizar_saldo_transferencia
AFTER INSERT OR UPDATE ON Transferencia
FOR EACH ROW
BEGIN
    UPDATE Cuenta
    SET Saldo = Saldo - :NEW.Cantidad
    WHERE IBAN = (SELECT IBAN FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
    
    UPDATE Cuenta
    SET Saldo = Saldo + :NEW.Cantidad
    WHERE IBAN = (SELECT IBAN FROM Operacion WHERE Numero_Operacion = :NEW.Numero_Operacion);
END;
/


-- Trigger para asegurarse de que no haya una retirada o un ingreso con el mismo número de operación antes de insertar o actualizar una transferencia
CREATE OR REPLACE TRIGGER validar_numero_operacion_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW
DECLARE
    num_retirada NUMBER;
    num_ingreso NUMBER;
BEGIN
    -- Comprobar si hay una retirada con el mismo número de operación
    SELECT COUNT(*)
    INTO num_retirada
    FROM Retirada
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Comprobar si hay un ingreso con el mismo número de operación
    SELECT COUNT(*)
    INTO num_ingreso
    FROM Ingreso
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Si se encuentra una retirada o un ingreso con el mismo número de operación, lanzar un error
    IF num_retirada > 0 OR num_ingreso > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Ya existe una retirada o un ingreso con el mismo número de operación.');
    END IF;
END;
/


-- Trigger para asegurarse de que no haya una transferencia o un ingreso con el mismo número de operación antes de insertar o actualizar una retirada
CREATE OR REPLACE TRIGGER validar_numero_operacion_retirada
BEFORE INSERT OR UPDATE ON Retirada
FOR EACH ROW
DECLARE
    num_transferencia NUMBER;
    num_ingreso NUMBER;
BEGIN
    -- Comprobar si hay una transferencia con el mismo número de operación
    SELECT COUNT(*)
    INTO num_transferencia
    FROM Transferencia
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Comprobar si hay un ingreso con el mismo número de operación
    SELECT COUNT(*)
    INTO num_ingreso
    FROM Ingreso
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Si se encuentra una transferencia o un ingreso con el mismo número de operación, lanzar un error
    IF num_transferencia > 0 OR num_ingreso > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ya existe una transferencia o un ingreso con el mismo número de operación.');
    END IF;
END;
/


-- Trigger para asegurarse de que no haya una retirada o una transferencia con el mismo número de operación antes de insertar o actualizar un ingreso
CREATE OR REPLACE TRIGGER validar_numero_operacion_ingreso
BEFORE INSERT OR UPDATE ON Ingreso
FOR EACH ROW
DECLARE
    num_retirada NUMBER;
    num_transferencia NUMBER;
BEGIN
    -- Comprobar si hay una retirada con el mismo número de operación
    SELECT COUNT(*)
    INTO num_retirada
    FROM Retirada
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Comprobar si hay una transferencia con el mismo número de operación
    SELECT COUNT(*)
    INTO num_transferencia
    FROM Transferencia
    WHERE Numero_Operacion = :NEW.Numero_Operacion;

    -- Si se encuentra una retirada o una transferencia con el mismo número de operación, lanzar un error
    IF num_retirada > 0 OR num_transferencia > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Ya existe una retirada o una transferencia con el mismo número de operación.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE actualizar_saldo AS
BEGIN 
    UPDATE Cuenta_Ahorro
    SET Saldo = Saldo + (1 + Interes / 12);
END;
/

BEGIN
    -- Crear un trabajo programado para ejecutar el procedimiento almacenado cada noche
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'actualizar_saldoP',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN actualizar_saldo(); END;',
        start_date      => SYSTIMESTAMP + INTERVAL '1' DAY,
        repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
        enabled         => TRUE
    );
END;
/


