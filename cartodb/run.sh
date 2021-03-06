#!/bin/bash

# Initialize the metadata database
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
sed -i "s^__APP_ASSETS_HOST__^$APP_ASSETS_HOST^g" config/app_config.yml

RAILS_ENV=$CARTO_ENV bundle exec rake db:create && RAILS_ENV=$CARTO_ENV bundle exec rake db:migrate

bundle exec grunt --environment $CARTO_ENV dev > assets_server.log 2>&1 &

RAILS_ENV=$CARTO_ENV bundle exec ./script/resque > resque.log 2>&1 &

RAILS_ENV=$CARTO_ENV bundle exec rails server
