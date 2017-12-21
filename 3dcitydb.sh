#!/bin/sh
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create database
echo ""
echo "# Setting up 3DCityDB ... ####################################################"
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
echo "# Setting up 3DCityDB ... done! ###############################################"

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
# 3DCityDB ---------------------------------------------------------------------
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
