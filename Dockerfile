# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
FROM postgres:10
# Maintainer ##################################################################
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup 3DCityDB ##############################################################
ENV POSTGIS_MAJOR 2.4
ENV POSTGIS_VERSION 2.4.3+dfsg-4.pgdg90+1
ARG citydb_version=3.3.1
ENV CITYDBVERSION=${citydb_version}
ARG citydb_name="citydb"
ENV CITYDBNAME=${citydb_name}

# make sure a default password is set
ARG postgres_password=postgres
ENV POSTGRES_PASSWORD=${postgres_password}

RUN set -x \
  && RUNTIME_PACKAGES="postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
    postgis=$POSTGIS_VERSION" \
  && BUILD_PACKAGES="ca-certificates wget" \   
  && apt-get update \
  && apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES \
  && mkdir -p 3dcitydb && wget "https://github.com/3dcitydb/3dcitydb/archive/v${CITYDBVERSION}.tar.gz" -O 3dcitydb.tar.gz \
  && tar -C 3dcitydb -xzvf 3dcitydb.tar.gz 3dcitydb-$CITYDBVERSION/PostgreSQL/SQLScripts --strip=3 \
  && rm 3dcitydb.tar.gz \
  && apt-get purge -y --auto-remove $BUILD_PACKAGES \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /docker-entrypoint-initdb.d

COPY ./3dcitydb.sh /docker-entrypoint-initdb.d/3dcitydb.sh
COPY ./CREATE_DB.sql /3dcitydb/CREATE_DB.sql
COPY ./addcitydb /usr/local/bin/
COPY ./dropcitydb /usr/local/bin/
COPY ./purgedb /usr/local/bin/

RUN set -x \ 
  && ln -s usr/local/bin/addcitydb / \
  && chmod u+x /usr/local/bin/addcitydb \
  && ln -s usr/local/bin/dropcitydb / \
  && chmod u+x /usr/local/bin/dropcitydb \
  && ln -s usr/local/bin/purgedb / \
  && chmod u+x /usr/local/bin/purgedb  
