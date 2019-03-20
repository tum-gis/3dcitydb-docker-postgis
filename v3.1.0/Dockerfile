# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
ARG baseimage_tag='11'
FROM postgres:${baseimage_tag}

# Labels ######################################################################
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/tum-gis/3dcitydb-docker-postgis"

# Setup PostGIS and 3DCityDB ##################################################
ENV POSTGIS_MAJOR='2.5'
ARG citydb_version='v3.1.0'
ENV CITYDBVERSION=${citydb_version}

ARG BUILD_PACKAGES='ca-certificates git'
ARG RUNTIME_PACKAGES="postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
    postgis"

# Setup build and runtime deps
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES

# Create folders
RUN set -x && \
  mkdir -p 3dcitydb && \
  mkdir -p /docker-entrypoint-initdb.d

# Clone 3DCityDB
RUN set -x && \
  git clone -b "${CITYDBVERSION}" --depth 1 https://github.com/3dcitydb/3dcitydb.git 3dcitydb_temp && \
  mv 3dcitydb_temp/PostgreSQL/SQLScripts/* 3dcitydb

# Cleanup
RUN set -x && \
  rm -rf 3dcitydb_temp && \
  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY CREATE_DB.sql /3dcitydb/
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
