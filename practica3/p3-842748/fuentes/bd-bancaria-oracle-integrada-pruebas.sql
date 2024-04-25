SELECT * FROM RETIRADA_GB;

SELECT * FROM INGRESO_GB;

SELECT * FROM TRANSFERENCIA_GB;


SELECT p.ccc AS numero_cuenta, 
       t.DNI AS DNI_titular, 
       t.edad AS edad_titular, 
       t.apellidos AS apellidos_titular, 
       t.nombre AS nombre_titular,
       t.fecha_na AS fecha_nacimiento_titular,
       t.telefono AS telefono_titular,
       t.direccion AS direccion_titular,
       t.email AS email_titular
FROM Posee_gb p
INNER JOIN Titular_gb t ON p.DNI = t.DNI;


SELECT c.*, a.interes
FROM Cuenta_gb c
INNER JOIN Ahorro_gb a ON c.ccc = a.ccc
WHERE a.interes > 1;

SELECT * FROM Oficina_gb WHERE direccion LIKE '%Palotes%';
SELECT * FROM Titular_gb WHERE direccion LIKE '%Madrid%';


SELECT DNI, COUNT(*) as num_transactions
FROM (
    SELECT DNI
    FROM Operacion_gb o
    JOIN Posee_gb p ON o.cuenta_origen = p.ccc
) GROUP BY DNI;


WITH ingresos_totales AS (
    SELECT i.Banco, i.oficina, SUM(o.cantidadop) as ingreso_total
    FROM Ingreso_gb i
    JOIN Operacion_gb o ON i.numero_op = o.numero_op
    GROUP BY i.Banco, i.oficina
),
retiradas_totales AS (
    SELECT r.Banco, r.oficina, SUM(o.cantidadop) as retirada_total
    FROM Retirada_gb r
    JOIN Operacion_gb o ON r.numero_op = o.numero_op
    GROUP BY r.Banco, r.oficina
)
SELECT d.Banco, d.oficina, ingreso_total, COALESCE(retirada_total, 0) as retirada_total
FROM ingresos_totales d
LEFT JOIN retiradas_totales w ON d.Banco = w.Banco AND d.oficina = w.oficina
UNION
SELECT w.Banco, w.oficina, COALESCE(ingreso_total, 0) as ingreso_total, retirada_total
FROM retiradas_totales w
LEFT JOIN ingresos_totales d ON w.Banco = d.Banco AND w.oficina = d.oficina;