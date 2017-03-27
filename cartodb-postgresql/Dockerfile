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
ENV LANGUAGE = en_US

ENV DEBIAN_FRONTEND noninteractive

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
	&& apt-get purge -y --auto-remove ca-certificates wget

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

# Create some users used by some CartoDB apps internally

# RUN service postgresql start &&  createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres && createuser tileuser --no-createrole --no-createdb --no-superuser -U postgres && service postgresql stop

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

# Initialize template postgis database

# RUN service postgresql start && sleep 5 && \
#            createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis && \
# If you see the eror stating the language is already enabled you are good to
            # createlang plpgsql -U postgres -d template_postgis && \
#            psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;' && \
#            ldconfig && \
#            service postgresql stop

# Run an installcheck to verify the database has been installed properly

#RUN service postgresql start && sleep 10 && \
#            ldconfig && \
#            cd cartodb-postgresql && PGUSER=postgres make installcheck

ADD start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
EXPOSE 5432
