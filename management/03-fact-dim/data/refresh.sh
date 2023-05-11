#!/bin/bash

source ../.env
mysql -e "drop database $INDEXNAME"
mysql -e "create database $INDEXNAME"
mysql project < schema.sql;
#mysql project < data.sql;
