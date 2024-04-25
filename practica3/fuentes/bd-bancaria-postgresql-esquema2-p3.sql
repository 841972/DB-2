/*Postgresql*/
CREATE SCHEMA IF NOT EXISTS colegiete;
SET search_path TO colegiete;
DROP TABLE IF EXISTS Asignado;
DROP TABLE IF EXISTS Participa;
DROP TABLE IF EXISTS Enseña;
DROP TABLE IF EXISTS Estudia;
DROP TABLE IF EXISTS Nombre;
DROP TABLE IF EXISTS Individuo;
DROP TABLE IF EXISTS Asignatura;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Servicio;
DROP TABLE IF EXISTS Programa;

Create table Departamento(
    Nombre_Dep varchar(50) primary key,
    Oficina varchar(50) not null,
    Descripcion varchar(100) not null
);
Create table Asignatura(
    Codigo varchar(50) primary key,
    Nombre varchar(50) not null,
    ECTS int not null,
    Trabajo_Previsto int not null,
    Departamento varchar(50) not null,
    Nivel int not null,
    foreign key (Departamento) references Departamento(Nombre_Dep)
);
Create table Individuo(
    DNI varchar(50) not null primary key,
    Tipo varchar(50) not null,
    Nacimiento date not null,
    Experiencia int,
    Nota_Media float
);
Create table Nombre(
    DNI varchar(50) not null primary key,
    Nombre varchar(50) not null,
    Apellidos varchar(50) not null,
    foreign key (DNI) references Individuo(DNI)
);
Create table Enseña(
    AsignaturaENS varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, AsignaturaENS),
    foreign key (DNI) references Individuo(DNI),
    foreign key (AsignaturaENS) references Asignatura(Codigo)
    
);
Create table Estudia(
    AsignaturaEST varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, AsignaturaEST),
    foreign key (DNI) references Individuo(DNI),
    foreign key (AsignaturaEST) references Asignatura(Codigo)
);
Create table Programa(
    Nombre_Programa varchar(50) primary key,
    Duracion varchar(100) not null,
    Tipo varchar(50) not null
);
Create table Participa(
    ProgramaP   varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, ProgramaP),
    foreign key (DNI) references Individuo(DNI),
    foreign key (ProgramaP) references Programa(Nombre_Programa) 
);
Create table Servicio(
    Nombre_Servicio varchar(50) primary key,
    Descripcion varchar(100) not null,
    Recompensa varchar(50) not null
);
Create table Asignado(
    ServicioA varchar(50) not null,
    DNI varchar(50) not null,
    primary key (DNI, ServicioA),
    foreign key (DNI) references Individuo(DNI),
    foreign key (ServicioA) references Servicio(Nombre_Servicio)
);

