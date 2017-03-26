#!/bin/bash

# Initialize the metadata database

RAILS_ENV=development bundle exec rake db:create && RAILS_ENV=development bundle exec rake db:migrate
