/*Postgresql*/
CREATE SCHEMA IF NOT EXISTS colegito;
SET search_path TO colegito;
DROP TABLE IF EXISTS Matriculado;
DROP TABLE IF EXISTS Imparte;
DROP TABLE IF EXISTS Participa;
DROP TABLE IF EXISTS Ofrece;
DROP TABLE IF EXISTS Estudiante;
DROP TABLE IF EXISTS Profesor;
DROP TABLE IF EXISTS Asignatura;
DROP TABLE IF EXISTS Servicio;
DROP TABLE IF EXISTS Programa;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Persona;

Create table Departamento(
    Nombre_Dep varchar(50) primary key,
    Ubicacion varchar(50) not null,
    Descripcion varchar(100) not null
);
Create table Asignatura(
    Codigo varchar(50) primary key,
    Nombre_As varchar(50) not null,
    Creditos int not null,
    Horas_estimadas int not null,
    Departamento varchar(50) not null,
    Dificultad int not null,
    foreign key (Departamento) references Departamento(Nombre_Dep)
);
Create table Persona(
    DNI varchar(50) primary key,
    Fecha_Nacimiento date not null,
    Nombre varchar(50) not null,
    Apellidos varchar(100) not null
);
Create table Imparte(
    Asignatura varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, Asignatura),
    foreign key (DNI) references Persona(DNI),
    foreign key (Asignatura) references Asignatura(Codigo)
);
Create table Matriculado(
    Asignatura varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, Asignatura),
    foreign key (DNI) references Persona(DNI),
    foreign key (Asignatura) references Asignatura(Codigo)
);
Create table Servicio(
    Nombre_Servicio varchar(50) primary key,
    Descripcion varchar(100) not null,
    Recompensa varchar(50) not null
);
Create table Programa(
    Nombre_Programa varchar(50) primary key,
    Duracion varchar(50) not null,
    Tipo varchar(50) not null
);
Create table Participa(
    DNI varchar(50) not null,
    Programa varchar(50) not null,
    primary key (DNI, Programa),
    foreign key (DNI) references Persona(DNI),
    foreign key (Programa) references Programa(Nombre_Programa)
);
Create table Ofrece(
    DNI varchar(50) not null,
    Servicio varchar(50) not null,
    primary key (DNI, Servicio),
    foreign key (DNI) references Persona(DNI),
    foreign key (Servicio) references Servicio(Nombre_Servicio)
);
Create table Estudiante(
    DNI varchar(50) primary key,
    Nota_Media float not null,
    foreign key (DNI) references Persona(DNI)
);
Create table Profesor(
    DNI varchar(50) primary key,
    Experiencia int not null,
    foreign key (DNI) references Persona(DNI)
);
