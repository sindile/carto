#  http://cartodb.readthedocs.io/en/latest/install.html
# CartoDB is guaranteed to run without any issue in Ubuntu 12.04 x64. This documentation describes the process to install CartoDB in this specific OS version.

FROM ubuntu:12.04


# -----------------------------------------------------------------
# System requirements
# -----------------------------------------------------------------

# Systemp locales

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US

ENV DEBIAN_FRONTEND noninteractive
ENV PGUSER=postgres

# Build essentials & GIT & APT tools

RUN apt-get update && apt-get install -y --no-install-recommends  autoconf \
      binutils-doc bison build-essential flex git software-properties-common \
      python-software-properties curl

# -----------------------------------------------------------------
# PostgreSQL
# -----------------------------------------------------------------

# Add PPA repository

RUN add-apt-repository -y ppa:cartodb/postgresql-9.5 && apt-get update

# Set postgreSQL user/group IDs

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

# Use gosu for postgres user
ENV GOSU_VERSION 1.10
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove wget

# Install client packages

RUN apt-get update \
    && apt-get install -y -q --no-install-recommends libpq5 \
                libpq-dev \
                postgresql-client-9.5 \
                postgresql-client-common

ENV PATH=$PATH:/usr/lib/postgresql/9.5/bin

# Install server packages

RUN apt-get install -y -q --no-install-recommends postgresql-9.5 \
                     postgresql-contrib-9.5 \
                     postgresql-server-dev-9.5 \
                     postgresql-plpython-9.5

# Install CartoDB postgresql extension

RUN git clone https://github.com/CartoDB/cartodb-postgresql.git && \
              cd cartodb-postgresql && \
              make all install && ldconfig


# -----------------------------------------------------------------
# GIS dependencies
# -----------------------------------------------------------------

# Add GIS PPA

RUN add-apt-repository -y ppa:cartodb/gis && apt-get update

# Install Proj

RUN apt-get install -y -q --no-install-recommends proj proj-bin proj-data libproj-dev

# Install JSON

RUN apt-get install -y -q --no-install-recommends libjson0 libjson0-dev python-simplejson

# Install GEOS

RUN apt-get install -y -q --no-install-recommends libgeos-c1v5 libgeos-dev

# Install GDAL

RUN apt-get install -y -q --no-install-recommends gdal-bin libgdal1-dev libgdal-dev
RUN apt-get install -y -q --no-install-recommends gdal2.1-static-bin

# -----------------------------------------------------------------
# PostGIS
# -----------------------------------------------------------------

# Install PostGIS

RUN apt-get install -y -q --no-install-recommends libxml2-dev
RUN apt-get install -y -q --no-install-recommends liblwgeom-2.2.2 postgis postgresql-9.5-postgis-2.2 postgresql-9.5-postgis-scripts

# Correct the Error: could not open temporary statistics file "/var/run/postgresql/9.5-main.pg_stat_tmp/global.tmp": No such file or directory

RUN mkdir -p /var/run/postgresql/9.5-main.pg_stat_tmp
RUN chown postgres:postgres /var/run/postgresql/9.5-main.pg_stat_tmp -R

# -----------------------------------------------------------------
# Redis
# -----------------------------------------------------------------

# Add redis PPA

RUN add-apt-repository -y  ppa:cartodb/redis && apt-get update

# Install redis

RUN apt-get install -y -q --no-install-recommends redis-server

# -----------------------------------------------------------------
# NodeJS
# -----------------------------------------------------------------

# Add the PPA

RUN add-apt-repository -y ppa:cartodb/nodejs-010 && apt-get update

RUN apt-get install -y -q --no-install-recommends nodejs

RUN npm install npm@2.14.16 -g


# -----------------------------------------------------------------
# SQL API
# -----------------------------------------------------------------

# Download API

RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && \
        cd CartoDB-SQL-API && \
        git checkout master

# Install npm dependencies

RUN cd /CartoDB-SQL-API && npm install

# -----------------------------------------------------------------
# Ruby
# -----------------------------------------------------------------

# Download ruby-install

RUN apt-get install -y -q --no-install-recommends wget && \
      wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
      tar -xzvf ruby-install-0.5.0.tar.gz && \
      cd ruby-install-0.5.0 && \
      make install

# Install some ruby dependencies

RUN apt-get install -y -q --no-install-recommends libreadline6-dev openssl

# Install ruby 2.2.3

RUN ruby-install ruby 2.2.3

# add the Ruby 2.2.3 bin folder to your PATH variable

ENV PATH=$PATH:/opt/rubies/ruby-2.2.3/bin

# Install bundler

RUN gem install bundler

# Install compass

RUN gem install compass

# -----------------------------------------------------------------
# Editor
# -----------------------------------------------------------------

# Download the editor code

RUN git clone --recursive https://github.com/teanocrata/cartodb.git

WORKDIR cartodb

# Install pip

RUN wget  -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py

# Install a necessary package for python dependencies

RUN apt-get install -y -q --no-install-recommends python-all-dev

# Install dependencies

RUN apt-get install -y -q --no-install-recommends imagemagick unp zip libpq-dev libicu-dev
RUN RAILS_ENV=development bundle install
RUN npm install

# Install GDAL

# Add GIS PPA

RUN add-apt-repository -y ppa:cartodb/gis && apt-get update

RUN apt-get install -y -q --no-install-recommends gdal-bin libgdal1-dev libgdal-dev
RUN apt-get install -y -q --no-install-recommends gdal2.1-static-bin

RUN CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal PATH=$PATH:/usr/include/gdal pip install --no-use-wheel -r python_requirements.txt

# Add the grunt command to the PATH

ENV PATH=$PATH:/cartodb/node_modules/grunt-cli/bin

# Install all necesary gems

RUN bundle install

# Precompile assets

RUN bundle exec grunt --environment development --force

# Add configuration files

ADD pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf
ADD postgresql.conf /etc/postgresql/9.5/main/postgresql.conf
ADD app_config.yml /cartodb/config/app_config.yml
ADD database.yml /cartodb/config/database.yml
ADD ./development.js /CartoDB-SQL-API/config/environments/development.js


EXPOSE 3000 8080 8181

ENV GDAL_DATA /usr/share/gdal/1.10

ADD ./run.sh /opt/run.sh

CMD ["/bin/bash", "/opt/run.sh"]
