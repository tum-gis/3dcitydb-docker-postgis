# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
FROM postgres:10-alpine
# Maintainer ##################################################################
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup PostGIS and 3DCityDB ##################################################
ARG postgis_version='2.4.4'
ENV POSTGIS_VERSION=${postgis_version}
ARG citydb_version='v3.1.0'
ENV CITYDBVERSION=${citydb_version}

RUN set -ex \
  && apk update \
  && apk add --no-cache --virtual .fetch-deps tar openssl git \
  && git clone -b "${POSTGIS_VERSION}" --depth 1 https://github.com/postgis/postgis.git postgis_temp \
  && git clone -b "${CITYDBVERSION}" --depth 1 https://github.com/3dcitydb/3dcitydb.git 3dcitydb_temp \
  && apk add --no-cache --virtual .build-deps \
      autoconf automake g++ json-c-dev \
      libtool libxml2-dev make perl \
  && apk add --no-cache --virtual .build-deps-testing \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      gdal-dev geos-dev proj4-dev protobuf-c-dev \
  && cd postgis_temp \
  && ./autogen.sh \
  && ./configure && make && make install \
  && cd .. \      
  && apk add --no-cache --virtual .postgis-rundeps json-c \
  && apk add --no-cache --virtual .postgis-rundeps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        geos gdal proj4 protobuf-c \
  && mkdir -p 3dcitydb \
  && cp -r 3dcitydb_temp/PostgreSQL/SQLScripts/* 3dcitydb \
  && apk del .fetch-deps .build-deps .build-deps-testing \  
  && rm -rf  postgis_temp 3dcitydb_temp \
  && mkdir -p /docker-entrypoint-initdb.d

COPY 3dcitydb.sh /docker-entrypoint-initdb.d/
COPY CREATE_DB.sql /3dcitydb/
COPY addcitydb dropcitydb purgedb /usr/local/bin/

RUN set -x \ 
  && ln -s usr/local/bin/addcitydb / \
  && chmod u+x /usr/local/bin/addcitydb \
  && ln -s usr/local/bin/dropcitydb / \
  && chmod u+x /usr/local/bin/dropcitydb \
  && ln -s usr/local/bin/purgedb / \
  && chmod u+x /usr/local/bin/purgedb  
