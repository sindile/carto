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
# Redis
# -----------------------------------------------------------------

# Add redis PPA

RUN add-apt-repository -y  ppa:cartodb/redis && apt-get update

# Install redis

RUN apt-get install -y -q --no-install-recommends redis-server

ENTRYPOINT ["redis-server"]
EXPOSE 6379
