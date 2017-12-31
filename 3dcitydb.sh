#!/bin/sh
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Set default env: CITYDBNAME, SRSNO, SRSNAME
echo ""
echo "# Setting up 3DCityDB environment ... ##########################################"
if [ -z ${CITYDBNAME+x} ]; then
  export CITYDBNAME="3dcitydb-docker";
  echo "NOTE:"
  echo "   CITYDBNAME has not been set. Using default CITYDBNAME=$CITYDBNAME."
  echo "   To change the default CITYDBNAME, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -d -e \"CITYDBNAME=myCustomDatabaseName\" 3dcitydb\""
fi

if [ -z ${SRSNO+x} ]; then
  export SRSNO=4326;
  echo "" 
  echo "NOTE:"
  echo "   SRSNO has not been set. Using default SRSNO=4326."
  echo "   To change the default SRSNO, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -d -e \"SRSNO=31468\" 3dcitydb\""
fi

if [ -z ${SRSNAME+x} ]; then
  export SRSNAME="EPSG:4326";
  echo 
  echo "";
  echo "NOTE:"
  echo "   SRSNAME has not been set. Using default SRSNAME=\"EPSG:4426\"."
  echo "   To change the default SRSNAME, use the docker run \"-e\" switch."
  echo "   Example: \"docker run -d -e \"SRSNAME=EPSG:31468\" 3dcitydb\""
fi

cat <<EOF

   DBNAME            $CITYDBNAME
   SRSNO             $SRSNO
   SRSNAME           $SRSNAME
EOF
echo "# Setting up 3DCityDB environment ...done! #####################################"

# Create database
echo ""
echo "# Setting up 3DCityDB ... ######################################################"
echo "Creating database $CITYDBNAME ..."
echo "CREATE DATABASE \"$CITYDBNAME\";" | "${psql[@]}"
echo "Creating database $CITYDBNAME ...done!"
echo ""

# Setup PostGIS extension
echo "Create PostGIS extensions in database $CITYDBNAME ..."
"${psql[@]}" --dbname="$CITYDBNAME" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL
echo "Create PostGIS extensions in database $CITYDBNAME ...done!"
echo ""

# setup 3dcitydb
echo "Setting up 3DcityDB version $CITYDBVERSION database schema in $CITYDBNAME ..."
cd /3dcitydb
"${psql[@]}" -d "$CITYDBNAME" -U "$POSTGRES_USER" -f "../3dcitydb/CREATE_DB.sql" -v srsno=$SRSNO -v srsname=$SRSNAME > /dev/null
echo "Setting up 3DcityDB version $CITYDBVERSION database schema in $CITYDBNAME ...done!"
echo ""
echo "# Setting up 3DCityDB ... done! ################################################"

# echo version info and maintainer
cat <<EOF


# 3DCityDB Docker #############################################################
#
# PostgreSQL/PostGIS ----------------------------------------------------------
#   PostgreSQL version $PG_MAJOR - $PG_VERSION
#     PG User         $POSTGRES_USER
#     PG Password     $POSTGRES_PASSWORD
#   PostGIS version   $POSTGIS_MAJOR - $POSTGIS_VERSION
#
# 3DCityDB --------------------------------------------------------------------
#   3DCityDB version  $CITYDBVERSION
#     version info    https://github.com/3dcitydb/3dcitydb/releases/tag/v$CITYDBVERSION
#   DBNAME            $CITYDBNAME
#   SRSNO             $SRSNO
#   SRSNAME           $SRSNAME
#
# Maintainer ------------------------------------------------------------------
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Civil, Geo and Environmental Engineering
#   Technical University of Munich (TUM)
#   <b.willenborg@tum.de>
#
###############################################################################


EOF
