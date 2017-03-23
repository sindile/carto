#!/bin/bash

service postgresql start
wait $!
echo "*************************************************************************"
echo "Create user public user"
echo "*************************************************************************"
createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres
wait $!
echo "*************************************************************************"
echo "Create user tileuser"
echo "*************************************************************************"
createuser tileuser --no-createrole --no-createdb --no-superuser -U postgres
wait $!
echo "*************************************************************************"
echo "Create template database"
echo "*************************************************************************"
createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
wait $!
echo "*************************************************************************"
echo "Create land"
echo "*************************************************************************"
createlang plpgsql -U postgres -d template_postgis
wait $!
echo "*************************************************************************"
echo "Create extension postgis"
echo "*************************************************************************"
psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;'
wait $!
echo "*************************************************************************"
echo "ldconfig"
echo "*************************************************************************"
ldconfig
wait $!
echo "*************************************************************************"
echo "Change directory"
echo "*************************************************************************"
cd cartodb-postgresql
wait $!
echo "*************************************************************************"
echo "Test"
echo "*************************************************************************"
PGUSER=postgres make installcheck
wait $!
echo "*************************************************************************"
echo "Tail log"
echo "*************************************************************************"
tail -f /var/log/postgresql/postgresql-9.5-main.log
