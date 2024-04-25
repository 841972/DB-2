#!/bin/bash
# Script para instalar PostgreSQL en un sistema basado en Linux (CentOS)

# Primermente, se debe actualizar el sistema
sudo yum update
# Instalación de PostgreSQL
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm 

sudo yum install -y postgresql14-server 

#Inicializar la base de datos y activar el inicio automático de PostgreSQL
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14 
