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

RAILS_ENV=$CARTO_ENV bundle exec rake db:create && RAILS_ENV=$CARTO_ENV bundle exec rake db:migrate

RAILS_ENV=$CARTO_ENV bundle exec ./script/resque

RAILS_ENV=$CARTO_ENV bundle exec rails server
