CREATE KEYSPACE IF NOT EXISTS test_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};

USE test_keyspace;

CREATE TABLE IF NOT EXISTS test_table (
    id INT PRIMARY KEY,
    name TEXT
);

INSERT INTO test_table (id, name) VALUES (1, 'John');
INSERT INTO test_table (id, name) VALUES (2, 'Alice');

SELECT * FROM test_table;

DROP TABLE IF EXISTS test_table;

DROP KEYSPACE IF EXISTS test_keyspace;