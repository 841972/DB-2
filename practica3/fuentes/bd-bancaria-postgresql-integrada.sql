
-- Crear un nuevo esquema para las vistas combinadas
CREATE SCHEMA IF NOT EXISTS vista_combinada;
SET search_path TO vista_combinada;

-- Eliminar vistas si existen
DROP VIEW IF EXISTS vista_combinada.matriculado_completo;
DROP VIEW IF EXISTS vista_combinada.imparte_completo;
DROP VIEW IF EXISTS vista_combinada.ofrece_completo;
DROP VIEW IF EXISTS vista_combinada.participa_completo;
DROP VIEW IF EXISTS vista_combinada.servicio_completo;
DROP VIEW IF EXISTS vista_combinada.programa_completo;
DROP VIEW IF EXISTS vista_combinada.estudiante_completo;
DROP VIEW IF EXISTS vista_combinada.profesor_completo;
DROP VIEW IF EXISTS vista_combinada.persona_completa;
DROP VIEW IF EXISTS vista_combinada.asignatura_completa;
DROP VIEW IF EXISTS vista_combinada.departamento_completo;

-- Crear vista para la tabla Departamento
CREATE VIEW departamento_completo AS
SELECT Nombre_Dep, Ubicacion, Descripcion
FROM colegito.Departamento
UNION
SELECT Nombre_Dep, Oficina as Ubicacion, Descripcion
FROM colegiete.Departamento;

-- Crear vista para la tabla Asignatura
CREATE VIEW asignatura_completa AS
SELECT Codigo, Nombre_As as Nombre, Creditos, Horas_estimadas, Departamento, Dificultad
FROM colegito.Asignatura
UNION
SELECT Codigo, Nombre, ECTS as Creditos, Trabajo_Previsto as Horas_estimadas, Departamento, Nivel as Dificultad
FROM colegiete.Asignatura;

-- Crear vista para la tabla Persona
CREATE VIEW persona_completa AS
SELECT DNI, Fecha_Nacimiento, Nombre, Apellidos, null as Experiencia,null as Nota_Media
FROM colegito.Persona
UNION
SELECT Individuo.DNI, Nacimiento as Fecha_Nacimiento, i.Nombre as Nombre, i.Apellidos as Apellidos, Experiencia, Nota_Media
FROM colegiete.Individuo
JOIN colegiete.Nombre i ON i.DNI = Individuo.DNI;




-- Crear vista para la tabla Profesor
CREATE VIEW profesor_completo AS
SELECT DNI, Experiencia
FROM colegito.Profesor
UNION
SELECT DNI, Experiencia
FROM colegiete.Individuo
WHERE Tipo = 'Profesor';

-- Crear vista para la tabla Estudiante
CREATE VIEW estudiante_completo AS
SELECT DNI, Nota_Media
FROM colegito.Estudiante
UNION
SELECT DNI, Nota_Media
FROM colegiete.Individuo
WHERE Tipo = 'Estudiante';

-- Crear vista para la tabla Programa
CREATE VIEW programa_completo AS
SELECT Nombre_Programa, Duracion, Tipo
FROM colegito.Programa
UNION
SELECT Nombre_Programa, Duracion, Tipo
FROM colegiete.Programa;

-- Crear vista para la tabla Servicio
CREATE VIEW servicio_completo AS
SELECT Nombre_Servicio, Descripcion, Recompensa
FROM colegito.Servicio
UNION
SELECT Nombre_Servicio, Descripcion, Recompensa
FROM colegiete.Servicio;

-- Crear vista para la tabla Participa
CREATE VIEW participa_completo AS
SELECT DNI, Programa
FROM colegito.Participa
UNION
SELECT DNI, ProgramaP as Programa
FROM colegiete.Participa;

-- Crear vista para la tabla Ofrece
CREATE VIEW ofrece_completo AS
SELECT DNI, Servicio
FROM colegito.Ofrece
UNION
SELECT DNI, ServicioA as Servicio
FROM colegiete.Asignado;

-- Crear vista para la tabla Imparte
CREATE VIEW imparte_completo AS
SELECT DNI, Asignatura
FROM colegito.Imparte
UNION
SELECT DNI, AsignaturaENS as Asignatura
FROM colegiete.Enseña;

-- Crear vista para la tabla Matriculado
CREATE VIEW matriculado_completo AS
SELECT DNI, Asignatura
FROM colegito.Matriculado
UNION
SELECT DNI, AsignaturaEST as Asignatura
FROM colegiete.Estudia;
