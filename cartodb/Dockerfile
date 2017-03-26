#  http://cartodb.readthedocs.io/en/latest/install.html
# CartoDB is guaranteed to run without any issue in Ubuntu 12.04 x64. This documentation describes the process to install CartoDB in this specific OS version.

FROM ubuntu:12.04


# -----------------------------------------------------------------
# System requirements
# -----------------------------------------------------------------

# Systemp locales

RUN locale-gen en_US.UTF-8 &&  update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Build essentials

RUN apt-get update && apt-get install -y --no-install-recommends  autoconf binutils-doc bison build-essential flex

# GIT

RUN apt-get install -y -q --no-install-recommends git

# APT tools

RUN apt-get install -y -q --no-install-recommends python-software-properties


# -----------------------------------------------------------------
# PostgreSQL
# -----------------------------------------------------------------

# Add PPA repository

RUN add-apt-repository -y ppa:cartodb/postgresql-9.5 && apt-get update

# Install client packages

RUN apt-get install -y -q --no-install-recommends libpq5 \
                     libpq-dev \
                     postgresql-client-9.5 \
                     postgresql-client-common

# Install server packages

RUN apt-get install -y -q --no-install-recommends postgresql-9.5 \
                     postgresql-contrib-9.5 \
                     postgresql-server-dev-9.5 \
                     postgresql-plpython-9.5

COPY pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf

# -----------------------------------------------------------------
# NodeJS
# -----------------------------------------------------------------

# Add the PPA

RUN add-apt-repository -y ppa:cartodb/nodejs-010 && apt-get update

RUN apt-get install -y -q --no-install-recommends nodejs

RUN npm install npm@2.14.16 -g

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

RUN git clone --recursive https://github.com/CartoDB/cartodb.git

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

# Create configuration files

ADD app_config.yml config/app_config.yml
ADD database.yml config/database.yml

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 3000
