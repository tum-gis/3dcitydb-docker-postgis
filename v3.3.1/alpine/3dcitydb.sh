#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

# psql should stop on error
psql=( psql -v ON_ERROR_STOP=1 )

# Warn, if $POSTGRES_USER and $POSTGRES_PASSWORD are at their defaults
if [ -z ${POSTGRES_USER+x} ] || [ "$POSTGRES_USER" = "postgres" ] ; then
  export POSTGRES_USER="postgres";
  echo
  echo "!!! WARNING !!! ################################################################"
  echo "   POSTGRES_USER is at its default setting."
  echo "   POSTGRES_USER=${POSTGRES_USER}."
  echo "   Consider changing the default username for security reasons!"
  echo
  echo "   To change the default POSTGRES_USER, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -e \"POSTGRES_USER=newuser\" tumgis/3dcitydb-postgis\""
  echo "################################################################################"
fi

# make sure a default non empty password is set
if [ -z ${POSTGRES_PASSWORD+x} ] || [ "$POSTGRES_PASSWORD" = "postgres" ] || [ "$POSTGRES_PASSWORD" = "" ] ; then
  export POSTGRES_PASSWORD="postgres";
  echo
  echo "!!! WARNING !!! ################################################################"
  echo "   POSTGRES_PASSWORD is at its default setting."
  echo "   POSTGRES_PASSWORD=${POSTGRES_PASSWORD}."
  echo "   Consider changing the default password for security reasons!"
  echo
  echo "   To change the default POSTGRES_PASSWORD, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -e \"POSTGRES_PASSWORD=newuser\" tumgis/3dcitydb-postgis\""
  echo "################################################################################"
fi

# Perform all actions as $POSTGRES_USER with password $POSTGRES_PASSWORD
export PGUSER="$POSTGRES_USER"
export PGPASSWORD="$POSTGRES_PASSWORD"

# Set default env: POSTGRES_PASSWORD, CITYDBNAME, SRID, SRSNAME
echo
echo "# Setting up tumgis/3dcitydb-postgis environment ... ###########################"
if [ -z ${CITYDBNAME+x} ]; then
  export CITYDBNAME="citydb";
  echo "NOTE:"
  echo "   CITYDBNAME has not been set. Using default CITYDBNAME=${CITYDBNAME}."
  echo "   To change the default CITYDBNAME, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -e \"CITYDBNAME=myCustomDatabaseName\" tumgis/3dcitydb-postgis\""
fi

if [ -z ${SRID+x} ]; then
  export SRID=4326;
  echo 
  echo "NOTE:"
  echo "   SRID has not been set. Using default SRID=${SRID}."
  echo "   To change the default SRID, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -e \"SRID=31468\" tumgis/3dcitydb-postgis\""
fi

if [ -z ${SRSNAME+x} ]; then
  export SRSNAME="urn:ogc:def:crs:EPSG::4326";
  echo 
  echo "";
  echo "NOTE:"
  echo "   SRSNAME has not been set. Using default SRSNAME=\"${SRSNAME}\"."
  echo "   To change the default SRSNAME, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -e \"SRSNAME=urn:adv:crs:DE_DHDN_3GK4*DE_DHN92_NH\" tumgis/3dcitydb-postgis\""
fi

echo
echo "# Setting up 3DCityDB environment ...done! #####################################"

# Create database
echo
echo "# Setting up 3DCityDB ... ######################################################"
echo
echo "Creating database $CITYDBNAME ..."
echo "CREATE DATABASE \"$CITYDBNAME\";" | "${psql[@]}"
echo "Creating database $CITYDBNAME ...done!"

# Setup PostGIS extension
echo
echo "Create PostGIS extensions in database $CITYDBNAME ..."
"${psql[@]}" -d "$CITYDBNAME" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL
echo "Create PostGIS extensions in database $CITYDBNAME ...done!"

# setup 3dcitydb
echo
echo "Setting up 3DCityDB version $CITYDBVERSION database schema in $CITYDBNAME ..."
cd /3dcitydb
"${psql[@]}" -d "$CITYDBNAME" -f "CREATE_DB.sql" -v srsno="$SRID" -v gmlsrsname="$SRSNAME" > /dev/null
echo "Setting up 3DCityDB version $CITYDBVERSION database schema in $CITYDBNAME ...done!"
echo
echo "# Setting up 3DCityDB ...done! #################################################"

# echo version info and maintainer
cat <<EOF


# 3DCityDB Docker PostGIS ######################################################
#
# PostgreSQL/PostGIS -----------------------------------------------------------
#   PostgreSQL version  $PG_MAJOR - $PG_VERSION
#   PostGIS version     $POSTGIS_VERSION
#
# 3DCityDB ---------------------------------------------------------------------
#   3DCityDB version  $CITYDBVERSION
#     version info    https://github.com/3dcitydb/3dcitydb/tree/${CITYDBVERSION}
#   DBNAME            $CITYDBNAME
#   SRID              $SRID
#   SRSNAME           $SRSNAME
#
# Maintainer -------------------------------------------------------------------
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Civil, Geo and Environmental Engineering
#   Technical University of Munich (TUM)
#   b.willenborg(at)tum.de
#
################################################################################

EOF
