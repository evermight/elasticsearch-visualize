mysql -e 'drop database timesheet;'
mysql -e 'create database timesheet;'
mysql timesheet < light-schema.sql;
#mysql timesheet < data.sql;
