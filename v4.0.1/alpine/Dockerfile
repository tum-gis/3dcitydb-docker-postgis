# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
ARG baseimage_tag='12-alpine'
FROM postgres:${baseimage_tag}

# Labels ######################################################################
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/tum-gis/3dcitydb-docker-postgis"

# Setup PostGIS and 3DCityDB ##################################################
ARG postgis_version='3.0.0'
ENV POSTGIS_VERSION=${postgis_version}
ARG citydb_version='v4.0.1'
ENV CITYDBVERSION=${citydb_version}

# Setup fetch deps
RUN set -ex && \
 apk update && \
 apk add --no-cache --virtual .fetch-deps tar openssl git

# Create folders
RUN set -ex && \
  mkdir -p 3dcitydb && \
  mkdir -p /docker-entrypoint-initdb.d

# Fetch 3DCityDB
RUN set -ex && \
  git clone -b "${POSTGIS_VERSION}" --depth 1 https://github.com/postgis/postgis.git postgis_temp && \
  git clone -b "${CITYDBVERSION}" --depth 1 https://github.com/3dcitydb/3dcitydb.git 3dcitydb_temp && \
  mv 3dcitydb_temp/PostgreSQL/SQLScripts/* 3dcitydb

# Setup build deps
RUN set -ex && \  
  apk add --no-cache --virtual .build-deps \
    autoconf automake clang-dev json-c-dev libtool libxml2-dev llvm8 make perl

RUN set -ex && \
  apk add --no-cache --virtual .build-deps-edge \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    g++ geos-dev gdal-dev proj-dev protobuf-c-dev

# Build PostGIS
RUN set -ex && \
  cd postgis_temp && \
  ./autogen.sh && \
  ./configure && make && make install && \
  cd ..

# Setup runtime deps
RUN set -ex && \
  apk add --no-cache --virtual .postgis-rundeps \
    json-c

RUN set -ex && \  
  apk add --no-cache --virtual .postgis-rundeps-edge \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    geos gdal proj protobuf-c libstdc++

# Cleanup
RUN set -ex && \
  apk del .fetch-deps .build-deps .build-deps-edge && \
  rm -rf  postgis_temp 3dcitydb_temp

# Copy scripts
COPY 3dcitydb.sh /docker-entrypoint-initdb.d/
COPY addcitydb dropcitydb purgedb /usr/local/bin/

# Set permissions
RUN set -ex && \ 
  ln -s usr/local/bin/addcitydb / && \
  ln -s usr/local/bin/dropcitydb / && \
  ln -s usr/local/bin/purgedb / && \
  chmod u+x /usr/local/bin/dropcitydb && \
  chmod u+x /usr/local/bin/addcitydb && \
  chmod u+x /usr/local/bin/purgedb  
