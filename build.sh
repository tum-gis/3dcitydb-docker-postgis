#!/bin/bash
# Build 3DCityDB PostGIS Docker images ########################################
# Set repository and image name
REPOSITORY="tumgis"
IMAGENAME="3dcitydb-postgis"

# Set 3DCityDB versions to build, last version in list = latest tag
declare -a citydb_versions=("v3.0.0" "v3.1.0" "v3.2.0" "v3.3.0" "v3.3.1")

# define additional scripts to copy to each version folder
scripts='CREATE_DB.sql 3dcitydb.sh addcitydb dropcitydb purgedb'

for i in "${citydb_versions[@]}"
do
  version="${i}"
  version_alpine="${i}/alpine"
  df_version=${version}/Dockerfile
  df_version_alpine=${version_alpine}/Dockerfile
  
  # build and tag image 
  echo
  echo "Building ${version}..."
  docker build -t "${REPOSITORY}/${IMAGENAME}:${version}" "$version"
  echo
  echo "Building ${version}...done!"
  
  echo
  echo "Building ${version_alpine} ..."
  docker build -t "${REPOSITORY}/${IMAGENAME}:${version}-alpine" "$version_alpine"
  echo 
  echo "Building ${version_alpine} ...done!"
done

# create tag "latest" from last position in citydb_versions array
echo 
echo "Creating latest tag..."
lastelem=${citydb_versions[$((${#citydb_versions[@]}-1))]}
docker tag "${REPOSITORY}/${IMAGENAME}:${lastelem}" "${REPOSITORY}/${IMAGENAME}:latest"
docker tag "${REPOSITORY}/${IMAGENAME}:${lastelem}-alpine" "${REPOSITORY}/${IMAGENAME}:latest-alpine"
echo "Creating latest tag...done!"

read