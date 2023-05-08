mysql -e 'drop database management;'
mysql -e 'create database management;'
mysql management < schema.sql;
#mysql management < data.sql;
