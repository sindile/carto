FROM ubuntu:trusty
MAINTAINER Milo van der Linden <milo@dogodigi.net>

# ENV CARTO_ENV development
# ENV DB_HOST db
# ENV DB_PORT 5432
# ENV DB_USER postgres

# ENV REDIS_HOST redis
# ENV REDIS_PORT 6379
# ENV CARTO_SESSION_DOMAIN localdomain
# ENV CORS_ENABLED true

# ENV WINDSHAFT_PORT 8181

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends apt-utils make g++ git-core \
      libgif-dev libjpeg-dev libcairo2-dev \
      libhiredis-dev \
      libmapnik-dev \
      ca-certificates \
      python-mapnik \
      mapnik-utils \
      libprotobuf-dev \
      libstdc++6 \
      nodejs nodejs-legacy npm && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends libpango1.0-dev

RUN apt-get install -y --no-install-recommends software-properties-common && \
        add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
        apt-get update && \
        apt-get -y upgrade && \
        apt-get -y dist-upgrade

RUN git clone --depth 1 --branch master https://github.com/cartodb/windshaft-cartodb.git /windshaft-cartodb
RUN mkdir -p /windshaft-cartodb/logs
RUN mkdir -p /windshaft-cartodb/config/environments
RUN mkdir -p /tmp/windshaft/millstone
WORKDIR /windshaft-cartodb
RUN npm install

# Add config
COPY docker.js /windshaft-cartodb/config/environments/docker.js
# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 6081 6082
