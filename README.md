# 3D City Database Docker image
This is the git repo of the (not jet, but hopefully soon to become) [official image](https://docs.docker.com/docker-hub/official_repos/) for the [3D City Database(3DCityDB)](https://github.com/3dcitydb/3dcitydb).
It allows for the *instant* creation of a 3DCityDB instance without having to setup and configure a database server.
All you need is a [Docker](https://www.docker.com/what-docker) installation and the image provided here.
Detailed information on how to get and setup Docker on your system is provided in the [official documentation](https://docs.docker.com/engine/installation/).

The 3DCityDB Docker image provided here is based on the official PostgreSQL 10.1 image. 
There are several configurations options available, e.g. for setting database user passwords. 
Please find the [documentation here](https://hub.docker.com/_/postgres/).

---
** PLEASE NOTE **

**Everything you find in the repo is in an early testing stage.**

If you experience any problems or see possible enhancements please let me know by creating a new issue [here](https://github.com/tum-gis/3dcitydb-docker/issues).

---
## Setup and usage
Currently, this docker image has not been released to [Docker Hub](https://hub.docker.com/).
Hence, you either need to build it yourself or import the pre-build docker image provided below.

### Sharing Docker images
The best way of sharing Docker images with the public is with [Docker Hub](https://hub.docker.com/).
However, as the 3DCityDB Docker image is not published jet, we need to using the `docker image save` and `docker image load` functions.

[**3DCityDB Docker TESTING image download**](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/3dcitydb.tar.gz)
#### Ubuntu docker image import/export
To save and *gzip* compress a Docker image run:
```bash
sudo docker image save 3dcitydb | gzip > 3dcitydb.tar.gz
```
To import the image on another system run:
```bash
sudo sh -c 'gunzip -c 3dcitydb.tar.gz | docker image load'
```
When the import has completed, you are ready to run the image.

### How to build
Building an image from the Dockerfile in this repo is easy. You simply need to download the source code from this repo and run the 
`docker build` command.

#### Ubuntu build step-by-step guide
1. Download source code using git. 
```bash
git clone https://github.com/tum-gis/3dcitydb-docker.git
```
2. Change to the source folder you just cloned.
```bash
cd 3dcitydb-docker
```
3. Build a docker image named *3dcitydb*.
```bash
sudo docker build -t 3dcitydb .
```
4. If the build succeeds, you are ready to run the image.

### Run this image
Below some examples on how to run this container on Ubuntu are given.
Adapt the environment variables specifying the EPSG code (*SRSNO*), the spatial reference system name (*SRSNAME*) and the database name (*CITYDBNAME*) according to your needs.
The `-p` switch allows you to specify on which port the 3DCityDB instance will be listening.
For instance, use `-p 1234:5432` if you want to access the database instance on port *1234* of the system hosting the Docker container.

#### Parameter overview
| ENV        | Description                            | Default value   |
|------------|----------------------------------------|-----------------|
| CITYDBNAME | Database name of the 3DCityDB instance | 3dcitydb-docker |
| SRSNO      | Spatial reference system EPSG code     | 4326            |
| SRSNAME    | Spatial reference system name          | EPSG:4326       |

#### Usage examples - Ubuntu
```bash
# run container in foreground mode
sudo docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" -p 1234:5432 -it 3dcitydb

# run container in foreground mode with interactive bash shell, e.g. for making changes to the container
sudo docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" --name citydb-instance -p 1234:5432 -it 3dcitydb bash

# run container in detached mode
sudo docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" -d --name citydb-instance -p 1234:5432 3dcitydb

# stop container running in detached mode
sudo docker stop citydb-instance 

# remove container named citydb-instance
sudo docker rm citydb-instance
```
