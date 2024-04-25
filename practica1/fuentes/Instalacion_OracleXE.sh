#!/bin/bash
# Descripción: Este script descarga la imagen de Oracle Database Express Edition desde el registro de contenedor,
#              luego inicia un contenedor utilizando esta imagen y, finalmente, abre una sesión interactiva en la
#              base de datos Oracle utilizando SQL*Plus como el usuario SYSDBA.

# Descargar la imagen del contenedor de Oracle Database Express Edition desde el registro de contenedor
docker pull container-registry.oracle.com/database/express:latest

# Ejecutar un contenedor a partir de la imagen descargada
docker run -d --name mibaseoracle container-registry.oracle.com/database/express:21.3.0-xe

# Iniciar una sesión interactiva en la base de datos Oracle utilizando SQL*Plus como usuario SYSDBA
docker exec -it mibaseoracle sqlplus / as sysdba
