CREATE OR REPLACE VIEW Oficina_gb
AS
SELECT 'Banquete' as Banco, codoficina as codigo_oficina, dir as direccion, tfno as telefono
FROM Sucursal@SCHEMA2BD2
UNION
SELECT 'Banquito' as Banco, Codigo as codigo_oficina, Direccion as direccion, Telefono as telefono
FROM a844417.Oficina;

CREATE OR REPLACE VIEW Cuenta_gb
AS
SELECT 'Banquete' AS Banco,ccc, NULL AS iban, Saldo, fechaCreacion
FROM Cuenta@SCHEMA2BD2
UNION
SELECT 'Banquito' AS Banco,SUBSTR(IBAN, LENGTH(IBAN)-17) AS ccc,SUBSTR(IBAN, 1, 6) AS iban, Saldo, Fecha_Creacion as FechaCreacion
FROM a844417.Cuenta;


CREATE OR REPLACE VIEW Titular_gb 
AS
SELECT 'Banquete' AS Banco, t.DNI AS DNI, NULL AS edad, t.apellido1 || ' ' || t.apellido2 AS apellidos, t.nombre AS nombre,
t.fecha_nacimiento AS fecha_na, t.telefono, 'Calle: ' || d.calle || ' nº ' || d.numero || ' de ' || d.piso || ' CP: ' || c.codpostal ||  ' de ' || d.ciudad AS direccion, NULL AS email
FROM Titular@schema2bd2 t, Direccion@schema2bd2 d, Codpostal@schema2bd2 c
WHERE t.direccion = d.id_direccion AND d.calle = c.calle AND d.ciudad=c.ciudad
UNION
SELECT 'Banquito' AS Banco,DNI, EDAD, apellidos, nombre, NULL AS fecha_na, TO_CHAR(telefono) AS telefono, direccion, email
FROM A844417.cliente;


CREATE OR REPLACE VIEW Operacion_gb 
AS
SELECT DISTINCT 'Banquete' AS Banco, numop AS numero_op, descripcionop, TO_CHAR(fechaop, 'YYYY-MM-DD') AS fechaop, horaop, cantidadop, ccc AS cuenta_origen, NULL AS iban
FROM operacion@schema2bd2
UNION
SELECT 'Banquito' AS Banco, Numero_Operacion AS numero_op, descipcion AS descripcionop, 
       TO_CHAR(Momento, 'YYYY-MM-DD') AS fechaop,
       TO_CHAR(Momento, 'HH24:MI') AS horaop, 
       cantidad AS cantidadop, 
       SUBSTR(cuenta_origen, LENGTH(cuenta_origen)-17) AS cuenta_origen,SUBSTR(cuenta_origen, 1, 6) AS iban 
FROM a844417.operacion;

CREATE OR REPLACE VIEW Corriente_gb 
AS
SELECT DISTINCT 'Banquete' AS Banco, ccc, NULL AS IBAN, sucursal_codoficina AS oficina 
FROM cuentacorriente@schema2bd2
UNION
SELECT 'Banquito' AS Banco, SUBSTR(IBAN, LENGTH(IBAN)-17) AS ccc,SUBSTR(IBAN, 1, 6) AS iban, TO_NUMBER(Oficina) AS oficina
FROM a844417.CUENTA_CORRIENTE;

CREATE OR REPLACE VIEW Ahorro_gb 
AS
SELECT DISTINCT 'Banquete' AS Banco, ccc, NULL AS iban, tipointeres AS interes 
FROM cuentaahorro@schema2bd2
UNION
SELECT 'Banquito' AS Banco, SUBSTR(IBAN, LENGTH(IBAN)-17) AS ccc,SUBSTR(IBAN, 1, 6) AS iban, interes
FROM a844417.cuenta_ahorro;

CREATE OR REPLACE VIEW Posee_gb
AS
SELECT 'Banquete' AS Banco,titular AS DNI, ccc, NULL AS iban
FROM cuenta@schema2bd2
UNION
SELECT 'Banquito' AS Banco,DNI, SUBSTR(IBAN, LENGTH(IBAN)-17) AS ccc,SUBSTR(IBAN, 1, 6) AS iban
FROM a844417.posee;

CREATE OR REPLACE VIEW Transferencia_gb
AS
SELECT 'Banquete' AS Banco, numop AS numero_op, cuentadestino AS cuenta_destino, ccc AS cuenta_origen, NULL AS iban
FROM OpTransferencia@schema2bd2
UNION
SELECT 'Banquito' AS Banco, t.numero_operacion AS numero_op, t.cuenta_destino, SUBSTR(o.cuenta_origen, LENGTH(o.cuenta_origen)-17) AS cuenta_origen,SUBSTR(cuenta_origen, 1, 6) AS iban
FROM a844417.TRANSFERENCIA t , a844417.OPERACION o
WHERE t.numero_operacion = o.numero_operacion;

CREATE OR REPLACE VIEW Retirada_gb
AS
SELECT 'Banquete' AS Banco, r.numop AS numero_op, r.sucursal_codoficina AS oficina, r.ccc AS cuenta_origen, NULL AS iban
FROM Opefectivo@schema2bd2 r
WHERE r.tipoopefectivo = 'retirada'
UNION 
SELECT 'Banquito' AS Banco, r.numero_operacion AS numero_op, r.codigo_oficina AS oficina, SUBSTR(o.cuenta_origen, LENGTH(o.cuenta_origen)-17) AS cuenta_origen,SUBSTR(cuenta_origen, 1, 6) AS iban
FROM a844417.RETIRADA r, a844417.OPERACION o
WHERE r.numero_operacion = o.numero_operacion;


CREATE OR REPLACE VIEW Ingreso_gb
AS
SELECT 'Banquete' AS Banco, i.numop AS numero_op, i.sucursal_codoficina AS oficina, i.ccc AS cuenta_origen, NULL AS iban
FROM Opefectivo@schema2bd2 i
WHERE i.tipoopefectivo = 'ingreso'
UNION 
SELECT 'Banquito' AS Banco, i.numero_operacion AS numero_op, i.codigo_oficina AS oficina,  SUBSTR(o.cuenta_origen, LENGTH(o.cuenta_origen)-17) AS cuenta_origen,SUBSTR(cuenta_origen, 1, 6) AS iban
FROM a844417.INGRESO i, a844417.OPERACION o
WHERE i.numero_operacion = o.numero_operacion;









