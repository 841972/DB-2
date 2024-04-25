git clone https://github.com/krejcmat/hadoop-hbase-docker.git
cd hadoop-hbase-docker
##Construimos la imagen de los master y slaves
./build-image.sh hadoop-hbase-base

## Iniciamos contenedor
./start-container.sh latest 3

## Check members of cluster
serf members
cd ~
## Configuramos hadoop e iniciamos los servicios
./configure-members.sh
./start-hadoop.sh
./start-hbase.sh