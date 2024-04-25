DELETE FROM Retirada;
DELETE FROM Ingreso;
DELETE FROM Transferencia;
DELETE FROM Operacion;
DELETE FROM Cuenta_Corriente;
DELETE FROM Oficina;
DELETE FROM Cuenta_Ahorro;
DELETE FROM Posee;
DELETE FROM Cuenta;
DELETE FROM Cliente;


INSERT INTO Cliente (DNI, Telefono, Nombre, Apellidos, Edad, Direccion, Email) VALUES ('123456789A', 123456789, 'Juan', 'Gonzalez', 30, 'Calle Principal 123', 'juan@example.com');
INSERT INTO Cliente (DNI, Telefono, Nombre, Apellidos, Edad, Direccion, Email) VALUES ('987654321B', 987654321, 'Maria', 'Lopez', 25, 'Avenida Central 456', 'maria@example.com');
INSERT INTO Cliente (DNI, Telefono, Nombre, Apellidos, Edad, Direccion, Email) VALUES('456789123C', 456789123, 'Carlos', 'Martinez', 40, 'Calle Secundaria 789', 'carlos@example.com');
INSERT INTO Cliente (DNI, Telefono, Nombre, Apellidos, Edad, Direccion, Email) VALUES ('321654987D', 321654987, 'Laura', 'Sanchez', 35, 'Plaza Mayor 456', 'laura@example.com');


INSERT INTO Cuenta (IBAN, Num_cuenta, Saldo, Fecha_creacion)
VALUES
    ('ES1234567890123456789012', 1234567890123456, 1000.00, TO_DATE('2024-03-19', 'YYYY-MM-DD')),
    ('ES9876543210987654321098', 9876543210987654, 500.00, TO_DATE('2024-03-19', 'YYYY-MM-DD')),
    ('ES7418529630147852963014', 7418529630147852, 2000.00, TO_DATE('2024-03-19', 'YYYY-MM-DD')),
    ('ES3692581470369258147036', 3692581470369258, 1500.00, TO_DATE('2024-03-19', 'YYYY-MM-DD'));


INSERT INTO Posee (DNI, IBAN)
VALUES
    ('987654321B', 'ES9876543210987654321098'),
    ('456789123C', 'ES1234567890123456789012'),
    ('321654987D', 'ES7418529630147852963014'),
    ('123456789A', 'ES3692581470369258147036');


INSERT INTO Cuenta_Ahorro (IBAN, Interes)
VALUES
    ('ES9876543210987654321098', 2.0),
    ('ES1234567890123456789012', 1.8),
    ('ES7418529630147852963014', 2.5),
    ('ES3692581470369258147036', 1.6);



INSERT INTO Oficina (Codigo, Direccion, Telefono)
VALUES
    ('OF001', 'Av. Principal 456', 987654321),
    ('OF002', 'Calle Secundaria 789', 123456789),
    ('OF003', 'Plaza Mayor 456', 456789123),
    ('OF004', 'Avenida Central 123', 987654321);


INSERT INTO Cuenta_Corriente (IBAN, Oficina)
VALUES
    ('ES9876543210987654321098', 'OF001'),
    ('ES1234567890123456789012', 'OF002'),
    ('ES7418529630147852963014', 'OF003'),
    ('ES3692581470369258147036', 'OF004');



INSERT INTO Operacion (Numero_Operacion, Momento, Cantidad, Descipcion, Cuenta_Origen)
VALUES
    (1, TO_DATE('2024-03-19', 'YYYY-MM-DD'), 100.00, 'Compra en supermercado', 'ES1234567890123456789012'),
    (2, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 50.00, 'Retiro en cajero automático', 'ES9876543210987654321098'),
    (3, TO_DATE('2024-03-21', 'YYYY-MM-DD'), 200.00, 'Transferencia a amigo', 'ES7418529630147852963014'),
    (4, TO_DATE('2024-03-22', 'YYYY-MM-DD'), 300.00, 'Compra en línea', 'ES3692581470369258147036');


INSERT INTO Transferencia (Numero_Operacion, Cuenta_Destino)
VALUES
    (2, 'ES1234567890123456789012'),
    (3, 'ES9876543210987654321098'),
    (4, 'ES7418529630147852963014'),
    (1, 'ES3692581470369258147036');

INSERT INTO Ingreso (Numero_Operacion, Codigo_Oficina)
VALUES
    (2, 'OF002'),
    (3, 'OF003'),
    (4, 'OF004'),
    (1, 'OF001');

INSERT INTO Retirada (Numero_Operacion, Codigo_Oficina)
VALUES
    (2, 'OF002'),
    (3, 'OF003'),
    (4, 'OF004'),
    (1, 'OF001');



SELECT * FROM Cliente;


SELECT cc.*, o.Direccion AS Direccion_Oficina
FROM Cuenta_Corriente cc
JOIN Oficina o ON cc.Oficina = o.Codigo;


SELECT *
FROM Transferencia t
JOIN Operacion o ON t.Numero_Operacion = o.Numero_Operacion
WHERE TRUNC(o.Momento) = TRUNC(SYSDATE);
