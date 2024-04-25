TRUNCATE TABLE Retirada;
TRUNCATE TABLE Ingreso;
TRUNCATE TABLE Transferencia;
TRUNCATE TABLE Operacion;
TRUNCATE TABLE Cuenta_Corriente;
TRUNCATE TABLE Oficina;
TRUNCATE TABLE Cuenta_Ahorro;
TRUNCATE TABLE Cuenta;
TRUNCATE TABLE Cliente;

INSERT INTO Cliente VALUES ('12345678G', 111111111, 'Juan', 'Perez Martinez', 30, 'Calle Falsa 123', 'juan@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('87654321H', 222222222, 'Maria', 'Lopez Garcia', 25, 'Calle Falsa 22', 'maria@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('11111111I', 333333333, 'Pedro', 'Gonzalez Rodriguez', 40, 'Calle Falsa 33', 'madaria@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('22222222J', 444444444, 'Ana', 'Gutierrez Fernandez', 35, 'Calle Falsa 1', 'msdaria@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('33333333K', 555555555, 'Luis', 'Sanchez Perez', 50, 'Calle Falsa 1243', 'daew@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('44444444L', 666666666, 'Carmen', 'Torres Lopez', 45, 'Calle Falsa 1273', 'daseda@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('55555555M', 777777777, 'Javier', 'Diaz Sanchez', 60, 'Calle Falsa 12433', 'loki@gmail.com', VCuentaUDT());
INSERT INTO Cliente VALUES ('66666666N', 888888888, 'Rosa', 'Martin Perez', 55, 'Calle Falsa 1232', 'mitus@gmail.com', VCuentaUDT());

INSERT INTO Oficina VALUES ('1234567890', 'Calle Falsa 123', 123456789, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('0987654321', 'Calle Falsa 1234', 987654321, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('1234567891', 'Calle Falsa 1235', 123456789, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('0987654322', 'Calle Falsa 1236', 987654321, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('1234567892', 'Calle Falsa 1237', 123456789, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('0987654323', 'Calle Falsa 1238', 987654321, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());
INSERT INTO Oficina VALUES ('1234567893', 'Calle Falsa 1239', 123456789, VCuentaCorrienteUDT(), VIngresoUDT(), VRetiradaUDT());

INSERT INTO Cuenta VALUES ('ES1234567890123456789012', 123456789, 1000, TO_DATE('01/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT()); 
INSERT INTO Cuenta VALUES ('ES0987654321098765432109', 987654321, 2000, TO_DATE('02/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT()); 
INSERT INTO Cuenta VALUES ('ES1234567891123456789123', 123456789, 3000, TO_DATE('01/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES0987654322109876543210', 987654321, 4000, TO_DATE('04/12/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES1234567893123456756466', 123456789, 5000, TO_DATE('05/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES0987654323109876431111', 423424234, 6000, TO_DATE('06/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES1234567894123456645664', 123456789, 7000, TO_DATE('07/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES0987658758876867854678', 423432444, 8000, TO_DATE('08/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());
INSERT INTO Cuenta VALUES ('ES1234567895123456876886', 645646452, 9000, TO_DATE('09/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT());

INSERT INTO Cuenta_Ahorro VALUES ('ES1234567890123456789012', 123456789, 1000, TO_DATE('01/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), 0.6);
INSERT INTO Cuenta_Ahorro VALUES ('ES0987654321098765432109', 987654321, 2000, TO_DATE('02/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), 0.7);
INSERT INTO Cuenta_Ahorro VALUES ('ES1234567891123456789123', 123456789, 3000, TO_DATE('01/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), 0.9);

DECLARE
    ref_oficina1 REF OFICINAUDT;
    ref_oficina2 REF OFICINAUDT;
    ref_oficina3 REF OFICINAUDT;
BEGIN
    SELECT REF(o) INTO ref_oficina1 FROM Oficina o WHERE o.Codigo = '1234567890';
    SELECT REF(o) INTO ref_oficina2 FROM Oficina o WHERE o.Codigo = '0987654321';
    SELECT REF(o) INTO ref_oficina3 FROM Oficina o WHERE o.Codigo = '1234567891';
    
    INSERT INTO Cuenta_Corriente VALUES ('ES0987654322109876543210', 987654321, 4000, TO_DATE('04/12/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), ref_oficina1);
    INSERT INTO Cuenta_Corriente VALUES ('ES1234567893123456756466', 123456789, 5000, TO_DATE('05/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), ref_oficina2);
    INSERT INTO Cuenta_Corriente VALUES ('ES0987654323109876431111', 423424234, 6000, TO_DATE('06/01/2020', 'DD/MM/YYYY'), VClienteUDT(), VOperacionUDT(), VTransferenciaUDT(), ref_oficina3);
END;
/

DECLARE
    ref_cuenta1 REF CUENTAUDT;
    ref_cuenta2 REF CUENTAUDT;
    ref_cuenta3 REF CUENTAUDT;
    ref_cuenta4 REF CUENTAUDT;
    ref_cuenta5 REF CUENTAUDT;
    ref_cuenta6 REF CUENTAUDT;
    ref_cuenta7 REF CUENTAUDT;
    ref_cuenta8 REF CUENTAUDT;
    ref_cuenta9 REF CUENTAUDT;
BEGIN
    SELECT REF(c) INTO ref_cuenta1 FROM Cuenta c WHERE c.IBAN = 'ES1234567890123456789012';
    SELECT REF(c) INTO ref_cuenta2 FROM Cuenta c WHERE c.IBAN = 'ES0987654321098765432109';
    SELECT REF(c) INTO ref_cuenta3 FROM Cuenta c WHERE c.IBAN = 'ES1234567891123456789123';
    SELECT REF(c) INTO ref_cuenta4 FROM Cuenta c WHERE c.IBAN = 'ES0987654322109876543210';
    SELECT REF(c) INTO ref_cuenta5 FROM Cuenta c WHERE c.IBAN = 'ES1234567893123456756466';
    SELECT REF(c) INTO ref_cuenta6 FROM Cuenta c WHERE c.IBAN = 'ES0987654323109876431111';
    SELECT REF(c) INTO ref_cuenta7 FROM Cuenta c WHERE c.IBAN = 'ES1234567894123456645664';
    SELECT REF(c) INTO ref_cuenta8 FROM Cuenta c WHERE c.IBAN = 'ES0987658758876867854678';
    SELECT REF(c) INTO ref_cuenta9 FROM Cuenta c WHERE c.IBAN = 'ES1234567895123456876886';
    
    INSERT INTO Operacion VALUES (1, TO_DATE('01/01/2020', 'DD/MM/YYYY'), 100, 'Transferencia de dinero para Juan', ref_cuenta1);
    INSERT INTO Operacion VALUES (2, TO_DATE('02/01/2020', 'DD/MM/YYYY'), 200, 'Transferencia de dinero para Maria', ref_cuenta2);
    INSERT INTO Operacion VALUES (3, TO_DATE('03/01/2020', 'DD/MM/YYYY'), 300, 'Ingreso de dinero para Pedro', ref_cuenta3);
    INSERT INTO Operacion VALUES (4, TO_DATE('04/01/2020', 'DD/MM/YYYY'), 400, 'Ingreso de dinero para Ana', ref_cuenta4);
    INSERT INTO Operacion VALUES (5, TO_DATE('05/01/2020', 'DD/MM/YYYY'), 500, 'Ingreso de dinero para Luis', ref_cuenta5);
    INSERT INTO Operacion VALUES (6, TO_DATE('06/01/2020', 'DD/MM/YYYY'), 600, 'Ingreso de dinero para Carmen', ref_cuenta6);
    INSERT INTO Operacion VALUES (7, TO_DATE('07/01/2020', 'DD/MM/YYYY'), 700, 'Ingreso de dinero para Javier', ref_cuenta7);
    INSERT INTO Operacion VALUES (8, TO_DATE('08/01/2020', 'DD/MM/YYYY'), 800, 'Ingreso de dinero para Rosa', ref_cuenta8);
    INSERT INTO Operacion VALUES (9, TO_DATE('09/01/2020', 'DD/MM/YYYY'), 900, 'Ingreso de dinero para Sara', ref_cuenta9);
END;
/


DECLARE
    ref_cuenta1 REF CUENTAUDT;
    ref_cuenta2 REF CUENTAUDT;
    ref_cuenta3 REF CUENTAUDT;
    ref_cuenta4 REF CUENTAUDT;
BEGIN
    SELECT REF(c) INTO ref_cuenta1 FROM Cuenta c WHERE c.IBAN = 'ES0987654321098765432109';
    SELECT REF(c) INTO ref_cuenta2 FROM Cuenta c WHERE c.IBAN = 'ES0987658758876867854678';
    SELECT REF(c) INTO ref_cuenta3 FROM Cuenta c WHERE c.IBAN = 'ES1234567891123456789123';
    SELECT REF(c) INTO ref_cuenta4 FROM Cuenta c WHERE c.IBAN = 'ES1234567895123456876886';
    
    INSERT INTO Transferencia VALUES (1, TO_DATE('01/01/2020', 'DD/MM/YYYY'), 100, 'Transferencia de dinero para Juan', ref_cuenta1, ref_cuenta2);
    INSERT INTO Transferencia VALUES (2, TO_DATE('02/01/2020', 'DD/MM/YYYY'), 200, 'Transferencia de dinero para Maria', ref_cuenta3, ref_cuenta4);
END;
/

DECLARE
    ref_oficina1 REF OFICINAUDT;
    ref_oficina2 REF OFICINAUDT;
    ref_cuenta1 REF CUENTAUDT;
    ref_cuenta2 REF CUENTAUDT;
BEGIN
    SELECT REF(o) INTO ref_oficina1 FROM Oficina o WHERE o.Codigo = '0987654322';
    SELECT REF(o) INTO ref_oficina2 FROM Oficina o WHERE o.Codigo = '1234567892';
    SELECT REF(c) INTO ref_cuenta1 FROM Cuenta c WHERE c.IBAN = 'ES1234567891123456789123';
    SELECT REF(c) INTO ref_cuenta2 FROM Cuenta c WHERE c.IBAN = 'ES0987654322109876543210';
    
    INSERT INTO Ingreso VALUES (3, TO_DATE('03/01/2020', 'DD/MM/YYYY'), 300, 'Ingreso de dinero para Pedro', ref_cuenta1, ref_oficina1);
    INSERT INTO Ingreso VALUES (4, TO_DATE('04/01/2020', 'DD/MM/YYYY'), 400, 'Ingreso de dinero para Ana', ref_cuenta2, ref_oficina2);
END;
/

DECLARE
    ref_oficina1 REF OFICINAUDT;
    ref_oficina2 REF OFICINAUDT;
    ref_cuenta1 REF CUENTAUDT;
    ref_cuenta2 REF CUENTAUDT;
BEGIN
    SELECT REF(o) INTO ref_oficina1 FROM Oficina o WHERE o.Codigo = '0987654323';
    SELECT REF(o) INTO ref_oficina2 FROM Oficina o WHERE o.Codigo = '1234567893';
    SELECT REF(c) INTO ref_cuenta1 FROM Cuenta c WHERE c.IBAN = 'ES1234567893123456756466';
    SELECT REF(c) INTO ref_cuenta2 FROM Cuenta c WHERE c.IBAN = 'ES0987654323109876431111';
    
    INSERT INTO Retirada VALUES (5, TO_DATE('05/01/2020', 'DD/MM/YYYY'), 500, 'Ingreso de dinero para Luis', ref_cuenta1, ref_oficina1);
    INSERT INTO Retirada VALUES (6, TO_DATE('06/01/2020', 'DD/MM/YYYY'), 600, 'Ingreso de dinero para Carmen', ref_cuenta2, ref_oficina2);
END;
/

--Consultas basicas para comprobar la correcta insercion
SELECT * FROM Operacion;

SELECT Edad
FROM Cliente;

-- Consulta para obtener el saldo total de todas las cuentas corrientes en una oficina específica
SELECT SUM(Saldo) AS Saldo_Total
FROM Cuenta_Corriente, Oficina
WHERE Oficina.Codigo = '0987654321';

-- Esta consulta selecciona el nombre y apellidos de los clientes que tienen una cuenta corriente con un saldo superior a 5000.
SELECT Nombre, Apellidos
FROM Cliente
WHERE DNI IN (
    SELECT DNI
    FROM Cuenta_Corriente
    WHERE Saldo > 5000
);

-- Esta consulta selecciona el nombre y apellidos de los clientes cuya edad es mayor que la edad promedio de todos los clientes en la tabla
SELECT Nombre, Apellidos
FROM Cliente
WHERE Edad > (
    SELECT AVG(Edad)
    FROM Cliente
);
