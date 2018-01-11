#!/bin/bash
# Export 3DCityDB images ######################################################
# Set registry, image name and export folder
REGISTRY="localhost"
IMAGENAME="3dcitydb"
EXPORTFOLDER=".."

# Set versions to export
declare -a versions=("3.0.0" "3.1.0" "3.2.0" "3.3.0" "3.3.1")

# export all version
for i in "${versions[@]}"
do
  echo "Exporting ${REGISTRY}/${IMAGENAME}:v${i} to $(realpath ${EXPORTFOLDER}/${IMAGENAME}v${i}.tar.gz) ..."
  docker save "${REGISTRY}/${IMAGENAME}:v${i}" | gzip -f > "${EXPORTFOLDER}/${IMAGENAME}v${i}.tar.gz"
  echo "Exporting ${REGISTRY}/${IMAGENAME}:v${i} to $(realpath ${EXPORTFOLDER}/${IMAGENAME}v${i}.tar.gz) ...done!"
done
