DROP TRIGGER validar_IBAN_Corriente;
DROP TRIGGER validar_IBAN_Ahorro;
DROP TRIGGER actualizar_saldo_ingreso;
DROP TRIGGER actualizar_saldo_retirada;
DROP TRIGGER actualizar_saldo_transferencia;
DROP TABLE CuentaCorriente;
DROP TABLE CuentaAhorro;
DROP TABLE Transferencia;
DROP TABLE Ingreso;
DROP TABLE Retirada;
DROP TABLE Operacion;
DROP TABLE Cliente;
DROP TABLE Cuenta;
DROP TABLE Oficina;
DROP TABLE Posee;

DROP TYPE RetiradaUDT;
DROP TYPE IngresoUDT;
DROP TYPE TransferenciaUDT;
DROP TYPE OperacionUDT;
DROP TYPE PoseeUDT;
DROP TYPE CuentaCorrienteUDT;
DROP TYPE CuentaAhorroUDT;
DROP TYPE CuentaUDT;
DROP TYPE ClienteUDT;
DROP TYPE OficinaUDT;


CREATE TYPE ClienteUDT AS (
    DNI VARCHAR(10),
    Telefono VARCHAR(12),
    Nombre VARCHAR(50),
    Apellidos VARCHAR(50),
    Edad INTEGER,
    Direccion VARCHAR(100),
    Email VARCHAR(100)
) INSTANTIABLE NOT FINAL REF USING INTEGER mode db2sql;

CREATE TYPE CuentaUDT AS (
    IBAN VARCHAR(24),
    NumeroCuenta VARCHAR(20),
    Saldo DECIMAL(20,2),
    Fecha_creacion DATE
) INSTANTIABLE NOT FINAL REF USING INTEGER mode db2sql;

CREATE TYPE OficinaUDT AS (
    Codigo VARCHAR(10),
    Direccion VARCHAR(100),
    Telefono VARCHAR(12)
) INSTANTIABLE NOT FINAL REF USING INTEGER mode db2sql;

CREATE TYPE CuentaAhorroUDT UNDER CuentaUDT AS (
    Interes DECIMAL(3,2)
) INSTANTIABLE NOT FINAL mode db2sql;

CREATE TYPE CuentaCorrienteUDT UNDER CuentaUDT AS (
    Oficina REF(OficinaUDT)
) INSTANTIABLE NOT FINAL mode db2sql;

CREATE TYPE PoseeUDT AS (
    DNI REF(ClienteUDT),
    IBAN REF(CuentaUDT)
) INSTANTIABLE NOT FINAL mode db2sql;


CREATE TYPE OperacionUDT AS (
    NumeroOperacion INTEGER,
    Momento DATE,
    Cantidad DECIMAL(20,2),
    Descripcion VARCHAR(100),
    CuentaOrigen REF(CuentaUDT)
) INSTANTIABLE NOT FINAL REF USING VARCHAR(16) mode db2sql;

CREATE TYPE TransferenciaUDT UNDER OperacionUDT AS (
    CuentaDestino REF(CuentaUDT)
) INSTANTIABLE NOT FINAL mode db2sql;

CREATE TYPE IngresoUDT UNDER OperacionUDT AS (
    CodigoOficina REF(OficinaUDT)
) INSTANTIABLE NOT FINAL mode db2sql;

CREATE TYPE RetiradaUDT UNDER OperacionUDT AS (
    CodigoOficina REF(OficinaUDT)
) INSTANTIABLE NOT FINAL mode db2sql;

CREATE TABLE Cliente OF ClienteUDT (
    REF IS oid USER GENERATED,
    DNI WITH OPTIONS NOT NULL CHECK(LENGTH(dni) = 9),
    Telefono WITH OPTIONS NOT NULL CHECK(LENGTH(telefono) > 8) CHECK(LENGTH(telefono) < 13),
    Nombre WITH OPTIONS NOT NULL,
    Apellidos WITH OPTIONS NOT NULL,
    Edad WITH OPTIONS NOT NULL,
    Direccion WITH OPTIONS NOT NULL,
    Email WITH OPTIONS NOT NULL
);
CREATE TABLE Cuenta OF CuentaUDT (
    REF IS oid USER GENERATED,
    IBAN WITH OPTIONS NOT NULL CHECK(LENGTH(IBAN) = 24) ,
    NumeroCuenta WITH OPTIONS NOT NULL UNIQUE,
    Saldo WITH OPTIONS NOT NULL DEFAULT 0 CHECK(Saldo >= 0),
    Fecha_creacion WITH OPTIONS NOT NULL
);
CREATE TABLE Oficina OF OficinaUDT (
    REF IS oid USER GENERATED,
    Codigo WITH OPTIONS NOT NULL CHECK(LENGTH(codigo) = 4) UNIQUE,
    Direccion WITH OPTIONS NOT NULL,
    Telefono WITH OPTIONS NOT NULL CHECK(LENGTH(telefono) > 8) CHECK(LENGTH(telefono) < 12)
);
CREATE TABLE Posee OF PoseeUDT (
    REF IS oid USER GENERATED,
    DNI WITH OPTIONS NOT NULL SCOPE Cliente,
    IBAN WITH OPTIONS NOT NULL SCOPE Cuenta
);
CREATE TABLE CuentaAhorro OF CuentaAhorroUDT UNDER Cuenta 
    INHERIT SELECT PRIVILEGES (
 Interes WITH OPTIONS NOT NULL
 );
CREATE TABLE CuentaCorriente OF CuentaCorrienteUDT UNDER Cuenta 
    INHERIT SELECT PRIVILEGES (
    Oficina WITH OPTIONS SCOPE Oficina
);
CREATE TABLE Operacion OF OperacionUDT (
    REF IS oid USER GENERATED,
    NumeroOperacion WITH OPTIONS NOT NULL UNIQUE,
    Momento WITH OPTIONS NOT NULL,
    Cantidad WITH OPTIONS NOT NULL CHECK(Cantidad > 0),
    Descripcion WITH OPTIONS NOT NULL,
    CuentaOrigen WITH OPTIONS SCOPE Cuenta
);
CREATE TABLE Transferencia OF TransferenciaUDT UNDER Operacion 
    INHERIT SELECT PRIVILEGES (
    CuentaDestino WITH OPTIONS NOT NULL SCOPE Cuenta
);
CREATE TABLE Ingreso OF IngresoUDT UNDER Operacion 
    INHERIT SELECT PRIVILEGES (
    CodigoOficina WITH OPTIONS NOT NULL SCOPE Oficina
);
CREATE TABLE Retirada OF RetiradaUDT UNDER Operacion 
    INHERIT SELECT PRIVILEGES (
    CodigoOficina WITH OPTIONS NOT NULL SCOPE Oficina
);


--#SET TERMINATOR @
CREATE OR REPLACE TRIGGER validar_IBAN_Corriente
BEFORE INSERT OR UPDATE ON CuentaCorriente
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
    DECLARE cuenta_ahorro_count INTEGER;
    SET cuenta_ahorro_count = (SELECT COUNT(*)
                               FROM CuentaAhorro
                               WHERE IBAN = N.IBAN);

    IF cuenta_ahorro_count > 0 THEN
        SIGNAL SQLSTATE '75001' SET MESSAGE_TEXT = 'El IBAN pertenece a una cuenta de ahorro y no puede ser utilizado para una cuenta corriente';
    END IF;
END
@

--#SET TERMINATOR @
CREATE OR REPLACE TRIGGER validar_IBAN_Ahorro
BEFORE INSERT OR UPDATE ON CuentaAhorro
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
    DECLARE cuenta_corriente_count INTEGER;
    SET cuenta_corriente_count = (SELECT COUNT(*)
                                 FROM CuentaCorriente
                                 WHERE IBAN = N.IBAN);

    IF cuenta_corriente_count > 0 THEN
        SIGNAL SQLSTATE '75001' SET MESSAGE_TEXT = 'El IBAN pertenece a una cuenta corriente y no puede ser utilizado para una cuenta de ahorro';
    END IF;
END
@

CREATE OR REPLACE TRIGGER actualizar_saldo_ingreso
AFTER INSERT OR UPDATE ON Ingreso
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
    DECLARE iban_operacion VARCHAR(24);
    
    SET iban_operacion = (SELECT cu.IBAN
                 FROM Cuenta cu
                 JOIN Operacion ON Cu.oid = Operacion.CuentaOrigen
                  WHERE NumeroOperacion = N.NumeroOperacion);
    
    UPDATE Cuenta 
    SET Saldo = Saldo + N.Cantidad
    WHERE IBAN = iban_operacion;
END;

@
CREATE OR REPLACE TRIGGER actualizar_saldo_retirada
AFTER INSERT OR UPDATE ON Retirada
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
    DECLARE iban_operacion VARCHAR(24);
    
    SET iban_operacion = (SELECT cu.IBAN
                 FROM Cuenta cu
                 JOIN Operacion ON Cu.oid = Operacion.CuentaOrigen
                  WHERE NumeroOperacion = N.NumeroOperacion);
    
    UPDATE Cuenta 
    SET Saldo = Saldo - N.Cantidad
    WHERE IBAN = iban_operacion;
END;
@
CREATE OR REPLACE TRIGGER actualizar_saldo_transferencia
AFTER INSERT OR UPDATE ON Transferencia
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
    DECLARE iban_operacion_dest VARCHAR(24);
    DECLARE iban_operacion_or VARCHAR(24);
        --restamos el dinero de la cuneta origen
    SET iban_operacion_or = (SELECT cu.IBAN
                 FROM Cuenta cu
                 JOIN Operacion ON Cu.oid = Operacion.CuentaOrigen
                  WHERE NumeroOperacion = N.NumeroOperacion);
    UPDATE Cuenta
    SET Saldo = Saldo - N.Cantidad
    WHERE IBAN = iban_operacion_or;
    --Añadimos el dinero a la cuenta destino
    SET iban_operacion_dest = (SELECT cu.IBAN
                 FROM Cuenta cu
                 JOIN Transferencia ON Cu.oid = Transferencia.CuentaDestino
                  WHERE NumeroOperacion = N.NumeroOperacion);
    
    UPDATE Cuenta 
    SET Saldo = Saldo + N.Cantidad
    WHERE IBAN = iban_operacion_dest;
END;
@
-- Creación o reemplazo de un trigger para asignar un código único a las operaciones antes de la inserción
CREATE OR REPLACE TRIGGER numero_operaciones_trigger
BEFORE INSERT ON Operacion
REFERENCING NEW AS new_operacion
FOR EACH ROW
BEGIN
    DECLARE num_operaciones INTEGER;

    SET num_operaciones = (
        SELECT COUNT(*)
        FROM Operacion
        WHERE CuentaOrigen = new_operacion.CuentaOrigen
    );

    SET new_operacion.NumeroOperacion = COALESCE(num_operaciones, 0) + 1000;
END;
@