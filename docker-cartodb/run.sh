#!/bin/bash
PORT=3000

#!/bin/bash -x

PGDATA="/etc/postgresql/9.5/main"
CARTODB="/cartodb-postgresql"

FIRST_RUN_FILE_FLAG=${CARTODB}/CartoDB_setup_finished
DATABASE_INITIALIZED_FILE_FLAG=${PGDATA}/PostgreSQL_database_initialized


if [[ -f "${DATABASE_INITIALIZED_FILE_FLAG}" ]]; then
  echo
  echo "PostgreSQL Database Initialized..."
  echo
else
	echo "Opening database Locally for some work ..."

	service postgresql start

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
  ldconfig

  if [[ $POSTGRESQL_INSTALLCHECK ]]; then
    cd /cartodb-postgresql
    PGUSER=postgres make installcheck
  fi

	#gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
	#gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
	#gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/legacy.sql
	#gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/rtpostgis.sql
	#gosu postgres psql -d template_postgis -f $POSTGIS_SQL_PATH/topology.sql
	#gosu postgres psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
	#gosu postgres psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

	#gosu postgres psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;'

	echo "Stopping Database For a Complete Start ... "

	service postgresql stop

	touch ${DATABASE_INITIALIZED_FILE_FLAG}
fi


echo
echo "Starting PostgreSQL..."
echo
service postgresql start
tail -f /var/log/postgresql/postgresql-9.5-main.log &

#exec start-stop-daemon --start --chuid ${PG_USER}:${PG_USER} --exec ${PG_BINDIR}/postgres -- -D ${PGDATA}

echo
echo "Starting Redis..."
echo
service redis-server start
tail -f /var/log/redis/redis-server.log &
# service varnish start

echo
echo "Starting SQL API..."
echo
cd /CartoDB-SQL-API
echo | node app.js development &
sleep 10
tail -f /CartoDB-SQL-API/logs/cartodb-sql-api.log &


echo
echo "Starting Editor..."
echo

cd /cartodb
sed -i "s^__DB_PORT__^$DB_PORT^g" config/database.yml
sed -i "s^__DB_HOST__^$DB_HOST^g" config/database.yml
sed -i "s^__DB_USER__^$DB_USER^g" config/database.yml
sed -i "s^__DB_PORT__^$DB_PORT^g" config/app_config.yml
sed -i "s^__DB_HOST__^$DB_HOST^g" config/app_config.yml
sed -i "s^__DB_USER__^$DB_USER^g" config/app_config.yml
sed -i "s^__REDIS_HOST__^$REDIS_HOST^g" config/database.yml
sed -i "s^__REDIS_PORT__^$REDIS_PORT^g" config/database.yml
sed -i "s^__REDIS_HOST__^$REDIS_HOST^g" config/app_config.yml
sed -i "s^__REDIS_PORT__^$REDIS_PORT^g" config/app_config.yml

echo
echo "Starting Rake migrate..."
echo

RAILS_ENV=$CARTO_ENV bundle exec rake db:create && RAILS_ENV=$CARTO_ENV bundle exec rake db:migrate

echo
echo "Starting resque..."
echo

RAILS_ENV=$CARTO_ENV bundle exec ./script/resque > resque.log 2>&1 &

if [[ $START_RAILS_SERVER ]]; then
  sed -i "s^__APP_ASSETS_HOST__^$APP_ASSETS_HOST^g" config/app_config.yml
  echo
  echo "Starting rails server..."
  echo
  RAILS_ENV=$CARTO_ENV bundle exec rails server
else
  sed -i "s^__APP_ASSETS_HOST__^$APP_ASSETS_DEVELOPMENT_HOST^g" config/app_config.yml
  echo
  echo "CartoDB environment initialized. Now you can exec bash command in docker_cartodb container to start development."
  echo
fi

#cd /cartodb
#source /usr/local/rvm/scripts/rvm
#bundle exec script/restore_redis
#bundle exec script/resque > resque.log 2>&1 &
#bundle exec rails s -p $PORT
