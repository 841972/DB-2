echo "create 'alumnos', 'info'" | hbase shell

echo "put 'alumnos', 'andrei', 'info:nombre', 'Andrei'" | hbase shell
echo "put 'alumnos', 'andrei', 'info:edad', '20'" | hbase shell

echo "put 'alumnos', 'guillermo', 'info:nombre', 'Guillermo'" | hbase shell
echo "put 'alumnos', 'guillermo', 'info:edad', '20'" | hbase shell

echo "put 'alumnos', 'pablo', 'info:nombre', 'Pablo'" | hbase shell
echo "put 'alumnos', 'pablo', 'info:edad', '20'" | hbase shell

echo "scan 'alumnos'" | hbase shell
echo "get 'alumnos', 'andrei'" | hbase shell
echo "get 'alumnos', 'guillermo'" | hbase shell
echo "get 'alumnos', 'pablo'" | hbase shell

echo "disable 'alumnos'" | hbase shell
echo "drop 'alumnos'" | hbase shell