CREATE SCHEMA IF NOT EXISTS ObjBanco;

DROP TABLE IF EXISTS ObjBanco.Retirada;
DROP TABLE IF EXISTS ObjBanco.Ingreso;
DROP TABLE IF EXISTS ObjBanco.Transferencia;
DROP TABLE IF EXISTS ObjBanco.Operacion;
DROP TABLE IF EXISTS ObjBanco.cuentaAhorro;
DROP TABLE IF EXISTS ObjBanco.cuentaCorriente;
DROP TABLE IF EXISTS ObjBanco.Posee;
DROP TABLE IF EXISTS ObjBanco.Oficina;
DROP TABLE IF EXISTS ObjBanco.cuenta;
DROP TABLE IF EXISTS ObjBanco.cliente;

DROP TYPE IF EXISTS ObjBanco.operacionUDT;
DROP TYPE IF EXISTS ObjBanco.oficinaUDT;
DROP TYPE IF EXISTS ObjBanco.cuentaUDT;
DROP TYPE IF EXISTS ObjBanco.clienteUDT;

CREATE TYPE ObjBanco.clienteUDT AS (
    DNI varchar(10), 
    Telefono numeric,
    Nombre varchar(50),
    Apellidos varchar(50),
    Edad numeric,
    Direccion varchar(100),
    Email varchar(50)
);

CREATE TABLE IF NOT EXISTS ObjBanco.cliente OF ObjBanco.clienteUDT (
    DNI NOT NULL,
    Telefono NOT NULL,
    Nombre NOT NULL,
    Apellidos NOT NULL,
    Edad NOT NULL,
    Direccion NOT NULL,
    Email NOT NULL,
    -- Cuentas TEXT ARRAY,
    CONSTRAINT cliente_PK PRIMARY KEY(DNI),
    CHECK(char_length(Telefono::text)=9),
    CHECK(Edad>18)
);

CREATE TYPE ObjBanco.cuentaUDT AS (
    IBAN varchar(34),
    Saldo double precision,
    FechaCreacion date
);

CREATE TABLE IF NOT EXISTS ObjBanco.cuenta OF ObjBanco.cuentaUDT (
    IBAN NOT NULL,
    Saldo NOT NULL,
    FechaCreacion NOT NULL,
    -- Clientes TEXT ARRAY,
    CHECK(Saldo>=0),
    CONSTRAINT cuenta_PK PRIMARY KEY(IBAN)
);


CREATE TYPE ObjBanco.oficinaUDT AS (
    Codigo numeric,
    Direccion varchar(100),
    Telefono numeric
);

CREATE TABLE IF NOT EXISTS ObjBanco.Oficina OF ObjBanco.oficinaUDT (
    Codigo NOT NULL,
    Direccion NOT NULL,
    Telefono NOT NULL,
    CONSTRAINT oficina_PK PRIMARY KEY(Codigo),
    CHECK(char_length(Telefono::text)=9),
    CHECK(char_length(Codigo::text)=4)
);

CREATE TABLE IF NOT EXISTS ObjBanco.Posee (
    DNI varchar(10) NOT NULL,
    IBAN varchar(34) NOT NULL,
    CONSTRAINT cliente_cuenta_PK PRIMARY KEY(DNI, IBAN),
    CONSTRAINT cliente_cuenta_cliente_FK FOREIGN KEY (DNI) REFERENCES ObjBanco.cliente (DNI)
    -- CONSTRAINT cliente_cuenta_cuenta_FK FOREIGN KEY (IBAN) REFERENCES ObjBanco.cuenta (IBAN) DEFERRABLE INITIALLY DEFERRED
);


CREATE TABLE IF NOT EXISTS ObjBanco.cuentaCorriente(
    Oficina numeric NOT NULL,
    CHECK(char_length(Oficina::text)=4),
    CONSTRAINT Oficina_FK FOREIGN KEY(Oficina) REFERENCES ObjBanco.Oficina(Codigo)
) INHERITS (ObjBanco.cuenta);

CREATE TABLE IF NOT EXISTS ObjBanco.cuentaAhorro(
    Interes double precision NOT NULL
) INHERITS (ObjBanco.cuenta);


CREATE TYPE ObjBanco.operacionUDT AS (
    NumeroOperacion numeric,
    Fecha timestamp,
    Importe double precision,
    Descripcion varchar(100),
    CuentaOrigen varchar(34)
);

CREATE TABLE IF NOT EXISTS ObjBanco.Operacion OF ObjBanco.operacionUDT (
    NumeroOperacion NOT NULL,
    Fecha NOT NULL,
    Importe NOT NULL,
    Descripcion NOT NULL,
    CuentaOrigen NOT NULL,
    CONSTRAINT operacion_PK PRIMARY KEY(NumeroOperacion, CuentaOrigen)
);

CREATE TABLE IF NOT EXISTS ObjBanco.Transferencia(
    CuentaDestino varchar(34) NOT NULL
) INHERITS (ObjBanco.Operacion);

CREATE TABLE IF NOT EXISTS ObjBanco.Ingreso(
    Oficina numeric NOT NULL,
    CHECK(char_length(Oficina::text)=4),
    CONSTRAINT Ingreso_FK FOREIGN KEY(Oficina) REFERENCES ObjBanco.Oficina(Codigo)
) INHERITS (ObjBanco.Operacion);

CREATE TABLE IF NOT EXISTS ObjBanco.Retirada(
    Oficina numeric NOT NULL,
    CHECK(char_length(Oficina::text)=4),
    CONSTRAINT Retirada_FK FOREIGN KEY(Oficina) REFERENCES ObjBanco.Oficina(Codigo)
) INHERITS (ObjBanco.Operacion);

-- Trigger que comprueba que la operación no exista en Retirada ni en Transferencia
CREATE OR REPLACE FUNCTION check_disjunction_ingreso() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Retirada WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Retirada';
    END IF;
    IF EXISTS (SELECT 1 FROM Transferencia WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Transferencia';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_disjunction_ingreso_trigger
BEFORE INSERT ON Ingreso
FOR EACH ROW EXECUTE PROCEDURE check_disjunction_ingreso();

-- Trigger que comprueba que la operación no exista en Ingreso ni en Transferencia
CREATE OR REPLACE FUNCTION check_disjunction_retirada() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Ingreso WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Ingreso';
    END IF;
    IF EXISTS (SELECT 1 FROM Transferencia WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Transferencia';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_disjunction_retirada_trigger
BEFORE INSERT ON Retirada
FOR EACH ROW EXECUTE PROCEDURE check_disjunction_retirada();

-- Trigger que comprueba que la operación no exista en Ingreso ni en Retirada
CREATE OR REPLACE FUNCTION check_disjunction_transferencia() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Ingreso WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Ingreso';
    END IF;
    IF EXISTS (SELECT 1 FROM Retirada WHERE NumeroOperacion = NEW.NumeroOperacion and CuentaOrigen = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Disjunction violation: The operation already exists in Retirada';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_disjunction_transferencia_trigger
BEFORE INSERT ON Transferencia
FOR EACH ROW EXECUTE PROCEDURE check_disjunction_transferencia();

-- Checkea la existencia del IBAN en la cuenta
CREATE OR REPLACE FUNCTION check_existence_posee() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ObjBanco.Cuenta WHERE IBAN = NEW.IBAN) THEN
        RAISE EXCEPTION 'Existence violation: The IBAN does not exist in cuenta';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_existence_posee_trigger
BEFORE INSERT ON Posee
FOR EACH ROW EXECUTE PROCEDURE check_existence_posee();

-- Checkea la existencia del IBAN en la cuenta para una transferencia
CREATE OR REPLACE FUNCTION check_existence_transferencia() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ObjBanco.Cuenta WHERE IBAN = NEW.CuentaDestino) THEN
        RAISE EXCEPTION 'Existence violation: The IBAN does not exist in cuenta';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_existence_transferencia_trigger
BEFORE INSERT ON Transferencia
FOR EACH ROW EXECUTE PROCEDURE check_existence_transferencia();

-- Checkea la existencia del IBAN en la cuenta para una transferencia
CREATE OR REPLACE FUNCTION check_existence_cuenta() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ObjBanco.Cuenta WHERE IBAN = NEW.CuentaOrigen) THEN
        RAISE EXCEPTION 'Existence violation: The IBAN does not exist in cuenta';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_existence_transferencia_cuenta_trigger
BEFORE INSERT ON Transferencia
FOR EACH ROW EXECUTE PROCEDURE check_existence_cuenta();

CREATE TRIGGER check_existence_ingreso_cuenta_trigger
BEFORE INSERT ON Ingreso
FOR EACH ROW EXECUTE PROCEDURE check_existence_cuenta();

CREATE TRIGGER check_existence_retirada_cuenta_trigger
BEFORE INSERT ON Retirada
FOR EACH ROW EXECUTE PROCEDURE check_existence_cuenta();

-- Trigger que comprueba la cobertura total de la tabla Operacion y sus hijas
CREATE OR REPLACE FUNCTION check_cobertura_total() RETURNS TRIGGER AS $$
DECLARE
    total_operacion INTEGER;
    total_others INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_operacion FROM Operacion;
    SELECT SUM(count) INTO total_others FROM (SELECT COUNT(*) FROM Retirada UNION ALL SELECT COUNT(*) FROM Transferencia UNION ALL SELECT COUNT(*) FROM Ingreso);
    IF total_operacion != total_others THEN
        RAISE EXCEPTION 'Coverage violation: The total number of operations is not equal to the sum of Retirada, Transferencia, and Ingreso';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_total_coverage_trigger
BEFORE INSERT OR UPDATE OR DELETE ON Retirada
FOR EACH STATEMENT EXECUTE PROCEDURE check_cobertura_total();

CREATE TRIGGER check_total_coverage_trigger
BEFORE INSERT OR UPDATE OR DELETE ON Ingreso
FOR EACH STATEMENT EXECUTE PROCEDURE check_cobertura_total();


CREATE TRIGGER check_total_coverage_trigger
BEFORE INSERT OR UPDATE OR DELETE ON Transferencia
FOR EACH STATEMENT EXECUTE PROCEDURE check_cobertura_total();


-- Trigger que comprueba que la cuenta no exista en cuentaCorriente 
CREATE OR REPLACE FUNCTION check_disjunction_ahorro() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM cuentaCorriente WHERE IBAN = NEW.IBAN) THEN
        RAISE EXCEPTION 'Disjunction violation: The account already exists in Ahorro';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_disjunction_retirada_trigger
BEFORE INSERT ON cuentaAhorro
FOR EACH ROW EXECUTE PROCEDURE check_disjunction_ahorro();

-- Trigger que comprueba que la cuenta no exista en cuentaAhorro
CREATE OR REPLACE FUNCTION check_disjunction_corriente() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM cuentaAhorro WHERE IBAN = NEW.IBAN) THEN
        RAISE EXCEPTION 'Disjunction violation: The account already exists in Corriente';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_disjunction_retirada_trigger
BEFORE INSERT ON cuentaCorriente
FOR EACH ROW EXECUTE PROCEDURE check_disjunction_corriente();


-- Trigger que comprueba la cobertura total de la tabla Operacion y sus hijas
CREATE OR REPLACE FUNCTION check_cobertura_total_cuenta() RETURNS TRIGGER AS $$
DECLARE
    total_operacion INTEGER;
    total_others INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_operacion FROM Cuenta;
    SELECT SUM(count) INTO total_others FROM (SELECT COUNT(*) FROM cuentaAhorro UNION ALL SELECT COUNT(*) FROM cuentaCorriente);
    IF total_operacion != total_others THEN
        RAISE EXCEPTION 'Coverage violation: The total number of operations is not equal to the sum of cuentaCorriente and cuentaAhorro';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_total_coverage_account_trigger
AFTER INSERT OR UPDATE OR DELETE ON cuentaCorriente
FOR EACH STATEMENT EXECUTE PROCEDURE check_cobertura_total_cuenta();

CREATE TRIGGER check_total_coverage_account_trigger
AFTER INSERT OR UPDATE OR DELETE ON cuentaAhorro
FOR EACH STATEMENT EXECUTE PROCEDURE check_cobertura_total_cuenta();


-- Trigger para Transferencia
CREATE OR REPLACE FUNCTION actualizar_saldo_transferencia() RETURNS TRIGGER AS $$
BEGIN
    UPDATE ObjBanco.cuentaCorriente SET Saldo = Saldo - NEW.Importe WHERE IBAN = NEW.CuentaOrigen;
    UPDATE ObjBanco.cuentaCorriente SET Saldo = Saldo + NEW.Importe WHERE IBAN = NEW.CuentaDestino;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_saldo_transferencia_trigger
AFTER INSERT ON ObjBanco.Transferencia
FOR EACH ROW EXECUTE PROCEDURE actualizar_saldo_transferencia();

-- Trigger para Retirada
CREATE OR REPLACE FUNCTION actualizar_saldo_retirada() RETURNS TRIGGER AS $$
BEGIN
    UPDATE ObjBanco.cuentaCorriente SET Saldo = Saldo - NEW.Importe WHERE IBAN = NEW.CuentaOrigen;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_saldo_retirada_trigger
AFTER INSERT ON ObjBanco.Retirada
FOR EACH ROW EXECUTE PROCEDURE actualizar_saldo_retirada();

-- Trigger para Ingreso
CREATE OR REPLACE FUNCTION actualizar_saldo_ingreso() RETURNS TRIGGER AS $$
BEGIN
    UPDATE ObjBanco.cuentaCorriente SET Saldo = Saldo + NEW.Importe WHERE IBAN = NEW.CuentaOrigen;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_saldo_ingreso_trigger
AFTER INSERT ON ObjBanco.Ingreso
FOR EACH ROW EXECUTE PROCEDURE actualizar_saldo_ingreso();

-- Trigger que se activa antes de cada INSERT en la tabla cuenta
-- Es un trigger opcional, por lo que se puede quitar, pero se ha decidido dejarlo para 
-- evitar que se inserten datos directamente en la tabla cuenta
CREATE OR REPLACE FUNCTION error_insert_cuenta() RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Insertion error: cannot insert directly into the table cuenta';
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER error_insert_cuenta_trigger
BEFORE INSERT ON ObjBanco.cuenta
FOR EACH ROW EXECUTE PROCEDURE error_insert_cuenta();

-- Trigger que se activa antes de cada INSERT en la tabla operación
-- Es un trigger opcional, por lo que se puede quitar, pero se ha decidido dejarlo para 
-- evitar que se inserten datos directamente en la tabla operación
CREATE OR REPLACE FUNCTION error_insert_operacion() RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Insertion error: cannot insert directly into the table operacion';
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER error_insert_operacion_trigger
BEFORE INSERT ON ObjBanco.Operacion
FOR EACH ROW EXECUTE PROCEDURE error_insert_operacion();


-- Trigger que cambia el número de operación al correcto realizado por una cuenta
CREATE OR REPLACE FUNCTION cambio_numero_operacion() RETURNS TRIGGER AS $$
BEGIN
    NEW.NumeroOperacion = (SELECT count(*) FROM ObjBanco.Operacion WHERE NEW.CuentaOrigen = CuentaOrigen) + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cambio_numero_operacion_trigger
BEFORE INSERT ON ObjBanco.Ingreso
FOR EACH ROW EXECUTE PROCEDURE cambio_numero_operacion();


CREATE TRIGGER cambio_numero_operacion_trigger2
BEFORE INSERT ON ObjBanco.Retirada
FOR EACH ROW EXECUTE PROCEDURE cambio_numero_operacion();


CREATE TRIGGER cambio_numero_operacion_trigger3
BEFORE INSERT ON ObjBanco.Transferencia
FOR EACH ROW EXECUTE PROCEDURE cambio_numero_operacion();

