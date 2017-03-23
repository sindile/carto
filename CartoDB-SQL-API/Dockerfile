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

RUN cd CartoDB-SQL-API && npm install

# Create configuration

ADD ./development.js CartoDB-SQL-API/config/environments/development.js

ADD start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

EXPOSE 8125
