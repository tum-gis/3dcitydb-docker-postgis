# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################
# Base image
FROM postgres:10.1
# Maintainer ##################################################################
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup PostGIS ###############################################################
ENV POSTGIS_MAJOR 2.4
ENV POSTGIS_VERSION 2.4.3+dfsg-2.pgdg90+1

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
    postgis=$POSTGIS_VERSION

# Setup 3DCityDB ##############################################################
ARG citydb_version=3.3.1
ENV CITYDBVERSION=${citydb_version}
ARG citydb_default_db_name="citydb"
ENV CITYDBNAME=${citydb_default_db_name}

# make sure a default password is set
ARG postgres_password=postgres
ENV POSTGRES_PASSWORD=${postgres_password}

RUN set -x \
  && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && mkdir -p 3dcitydb && wget "https://github.com/3dcitydb/3dcitydb/archive/v${CITYDBVERSION}.tar.gz" -O 3dcitydb.tar.gz \
  && tar -C 3dcitydb -xzvf 3dcitydb.tar.gz 3dcitydb-$CITYDBVERSION/PostgreSQL/SQLScripts --strip=3  && rm 3dcitydb.tar.gz \
  && apt-get purge -y --auto-remove ca-certificates wget

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./3dcitydb.sh /docker-entrypoint-initdb.d/3dcitydb.sh
COPY ./CREATE_DB.sql /3dcitydb/CREATE_DB.sql

# add addCityDB.sh
COPY ./addCityDB.sh /usr/local/bin/
RUN ln -s usr/local/bin/addCityDB.sh / # backwards compat
RUN chmod u+x /usr/local/bin/addCityDB.sh

# add dropCityDB.sh
COPY ./dropCityDB.sh /usr/local/bin/
RUN ln -s usr/local/bin/dropCityDB.sh / # backwards compat
RUN chmod u+x /usr/local/bin/dropCityDB.sh

# add purgeDB.sh
COPY ./purgeDB.sh /usr/local/bin/
RUN ln -s usr/local/bin/purgeDB.sh / # backwards compat
RUN chmod u+x /usr/local/bin/purgeDB.sh
