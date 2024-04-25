-- Inserts de prueba para colegito
INSERT INTO colegito.Departamento (Nombre_Dep, Ubicacion, Descripcion) VALUES
('Departamento1', 'Ubicacion1', 'Descripción1'),
('Departamento2', 'Ubicacion2', 'Descripción2');

INSERT INTO colegito.Asignatura (Codigo, Nombre_As, Creditos, Horas_estimadas, Departamento, Dificultad) VALUES
('A001', 'Asignatura1', 5, 50, 'Departamento1', 1),
('A002', 'Asignatura2', 4, 40, 'Departamento2', 2);

INSERT INTO colegito.Persona (DNI, Fecha_Nacimiento, Nombre, Apellidos) VALUES
('11111111A', '1990-01-01', 'Persona1', 'Apellido1'),
('22222222B', '1995-05-05', 'Persona2', 'Apellido2');

INSERT INTO colegito.Profesor (DNI, Experiencia) VALUES
('11111111A', 10),
('22222222B', 5);

INSERT INTO colegito.Estudiante (DNI, Nota_Media) VALUES
('11111111A', 8.5),
('22222222B', 7.0);

INSERT INTO colegito.Programa (Nombre_Programa, Duracion, Tipo) VALUES
('Programa1', '2 años', 'Tipo1'),
('Programa2', '1 año', 'Tipo2');

INSERT INTO colegito.Servicio (Nombre_Servicio, Descripcion, Recompensa) VALUES
('Servicio1', 'Descripción1', 'Recompensa1'),
('Servicio2', 'Descripción2', 'Recompensa2');

INSERT INTO colegito.Participa (DNI, Programa) VALUES
('11111111A', 'Programa1'),
('22222222B', 'Programa2');

INSERT INTO colegito.Ofrece (DNI, Servicio) VALUES
('11111111A', 'Servicio1'),
('22222222B', 'Servicio2');

INSERT INTO colegito.Imparte (DNI, Asignatura) VALUES
('11111111A', 'A001'),
('22222222B', 'A002');

INSERT INTO colegito.Matriculado (DNI, Asignatura) VALUES
('11111111A', 'A001'),
('22222222B', 'A002');



-- Inserts de prueba para colegiete
INSERT INTO colegiete.Departamento (Nombre_Dep, Oficina, Descripcion) VALUES
('Departamento3', 'Oficina1', 'Descripción3'),
('Departamento4', 'Oficina2', 'Descripción4');

INSERT INTO colegiete.Asignatura (Codigo, Nombre, ECTS, Trabajo_Previsto, Departamento, Nivel) VALUES
('A003', 'Asignatura3', 6, 60, 'Departamento3', 3),
('A004', 'Asignatura4', 7, 70, 'Departamento4', 4);

INSERT INTO colegiete.Individuo (DNI, Tipo, Nacimiento, Experiencia, Nota_Media) VALUES
('33333333C', 'Estudiante', '1992-02-02', NULL, NULL),
('44444444D', 'Profesor', '1985-03-03', 8, 7.5),
('55555555E', 'Otro', '1978-04-04', 15, 6.0);

INSERT INTO colegiete.Nombre (DNI, Nombre, Apellidos) VALUES
('33333333C', 'Persona3', 'Apellido3'),
('44444444D', 'Persona4', 'Apellido4'),
('55555555E', 'Persona5', 'Apellido5');

INSERT INTO colegiete.Enseña (AsignaturaENS, DNI) VALUES
('A003', '44444444D'),
('A004', '55555555E');

INSERT INTO colegiete.Estudia (AsignaturaEST, DNI) VALUES
('A003', '33333333C'),
('A004', '44444444D');

INSERT INTO colegiete.Programa (Nombre_Programa, Duracion, Tipo) VALUES
('Programa3', '3 años', 'Tipo3'),
('Programa4', '2 años', 'Tipo4');

INSERT INTO colegiete.Servicio (Nombre_Servicio, Descripcion, Recompensa) VALUES
('Servicio3', 'Descripción3', 'Recompensa3'),
('Servicio4', 'Descripción4', 'Recompensa4');

INSERT INTO colegiete.Participa (ProgramaP, DNI) VALUES
('Programa3', '33333333C'),
('Programa4', '44444444D');

INSERT INTO colegiete.Asignado (ServicioA, DNI) VALUES
('Servicio3', '44444444D'),
('Servicio4', '55555555E');

-- Consulta en el esquema vista_combinada
SELECT * FROM vista_combinada.departamento_completo;
SELECT * FROM vista_combinada.asignatura_completa;
SELECT * FROM vista_combinada.persona_completa;
SELECT * FROM vista_combinada.profesor_completo;
SELECT * FROM vista_combinada.estudiante_completo;
SELECT * FROM vista_combinada.programa_completo;
SELECT * FROM vista_combinada.servicio_completo;
SELECT * FROM vista_combinada.participa_completo;
SELECT * FROM vista_combinada.ofrece_completo;
SELECT * FROM vista_combinada.imparte_completo;
SELECT * FROM vista_combinada.matriculado_completo;
