docker pull cassandra
docker run --name cassandra -p 9042:9042 --rm --name dbeaver-cassandra -d cassandra
## Entramos dentro del server
docker exec -ti dbeaver-cassandra bash

#Se ejecuta dentro de la máquina
apt-get update
apt-get install nano
## Editamos los auth
nano /etc/cassandra/cassandra.yaml
exit 
## Reiniciamos el contenedor
docker restart dbeaver-cassandra

# Crear un superusuario
docker exec -it dbeaver-cassandra cqlsh -u cassandra -p cassandra -e "CREATE USER new_superuser WITH PASSWORD 'new_password' SUPERUSER;" 

# Crear la estructura básica del espacio de datos
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "CREATE KEYSPACE mykeyspace WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "USE mykeyspace; CREATE TABLE Car( id uuid PRIMARY KEY, model text, description text, color text);" 

# Crear usuarios y roles con distinto acceso
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "CREATE ROLE reader WITH PASSWORD = 'reader_password' AND LOGIN = true;" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "CREATE ROLE writer WITH PASSWORD = 'writer_password' AND LOGIN = true;" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "GRANT MODIFY ON KEYSPACE mykeyspace TO writer;" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "GRANT SELECT ON KEYSPACE mykeyspace TO reader;" 

# Probar los roles
echo "INSERT INTO mykeyspace.Car (id, model, description, color) VALUES (uuid(), 'Model S', 'Tesla Model S', 'Red');" | docker exec -i dbeaver-cassandra cqlsh -u writer -p writer_password 
echo "SELECT * FROM mykeyspace.Car;" | docker exec -i dbeaver-cassandra cqlsh -u reader -p reader_password 

# Borrar todo
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "DROP KEYSPACE mykeyspace;" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "DROP ROLE reader;" 
docker exec -it dbeaver-cassandra cqlsh -u new_superuser -p new_password -e "DROP ROLE writer;" 
docker exec -it dbeaver-cassandra cqlsh -u dbeaver-cassandra -p dbeaver-cassandra -e "DROP USER new_superuser;" 
