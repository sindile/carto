#!/bin/bash -x

PGDATA="/etc/postgresql/9.5/main"
CARTODB="/cartodb-postgresql"

FIRST_RUN_FILE_FLAG=${CARTODB}/CartoDB_setup_finished
DATABASE_INITIALIZED_FILE_FLAG=${PGDATA}/PostgreSQL_database_initialized


if [ ! -f ${DATABASE_INITIALIZED_FILE_FLAG} ]
	then
		echo "Opening database Locally for some work ..."

		gosu postgres pg_ctl -D "${PGDATA}" -o "-c listen_addresses=''" -w start



		POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.2
		#createdb -E UTF8 template_postgis
		#createlang -d template_postgis plpgsql
		#psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis'"




		gosu postgres createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres

		gosu postgres createuser tileuser --no-createrole --no-createdb --no-superuser -U postgres

		gosu postgres createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
		#gosu postgres createdb -O postgres -U postgres -E UTF8 template_postgis
		gosu postgres psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;'
		gosu postgres psql -U postgres template_postgis -c 'CREATE EXTENSION postgis_topology;'

		gosu postgres psql -U postgres template_postgis -c 'CREATE OR REPLACE LANGUAGE plpgsql;'
		gosu postgres psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"

		gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
		gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
		gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/legacy.sql
		gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/rtpostgis.sql
		gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/topology.sql
		gosu postgres psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
		gosu postgres psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

		#gosu postgres psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;'

		echo "Stopping Database For a Complete Start ... "

		gosu postgres pg_ctl -D "${PGDATA}" -m fast -w stop

		touch ${DATABASE_INITIALIZED_FILE_FLAG}
	else

		echo
		echo "PostgreSQL Database Initialized..."
		echo


	fi


echo
echo "Starting PostgreSQL..."
echo
echo PGDATA $PGDATA
gosu postgres pg_ctl -D "${PGDATA}" -o "-c listen_addresses='*'" -w start
#/usr/sbin/service postgresql start

#exec start-stop-daemon --start --chuid ${PG_USER}:${PG_USER} --exec ${PG_BINDIR}/postgres -- -D ${PGDATA}
