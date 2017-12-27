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

## Content
* **[Setup and usage](#setup-and-usage)**
  * [Sharing Docker images](#sharing-docker-images)
    * [Docker image import/export](#docker-import-export) 
* **[How to run the 3DCityDB Docker image](#how-to-run-the-3dcitydb-docker-image)**
  * [Parameter overview](#parameter-overview)
  * [Usage examples - Ubunutu](#usage-examples-ubuntu)
  * [Typical usage scenario](#typical-usage-scenario)
    * [Example use case: Create KML from CityGML buildings](#typical-usage-scenario-usecase)    
* **[How to build](#how-to-build)**
  * [Ubuntu build step-by-step guide](#ubuntu-build-step-by-step-guide)   
  
<a name="setup-and-usage"></a>
## Setup and usage
Currently, this docker image has not been released to [Docker Hub](https://hub.docker.com/).
Hence, you either need to build it yourself or import the pre-build docker image provided below.
When this image has been tested successfully, it will be released to [Docker Hub](https://hub.docker.com/).

<a name="sharing-docker-images"></a>
### Sharing Docker images
The best way of sharing Docker images with the public is with [Docker Hub](https://hub.docker.com/). 
To obtain an image from Docker Hub you simply need to download it using the [`docker pull` command](https://docs.docker.com/engine/reference/commandline/pull/#usage).
However, as the 3DCityDB Docker image is not published jet, we need to use the [`docker save`](https://docs.docker.com/engine/reference/commandline/save/) 
and [`docker load`](https://docs.docker.com/engine/reference/commandline/load/) commands to import the image you can download below on your system.

DOWNLOAD: [**3DCityDB Docker TESTING image**](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/3dcitydb.tar.gz)

<a name="docker-import-export"></a>
#### Docker image import/export
To find out what images exist on your system run `docker images` to list all local images. You will receive an output similar to this:
```
$: docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
3dcitydb            latest              69cb9b966a01        3 days ago          719 MB
bash                latest              a853bea42baa        2 weeks ago         12.2 MB
postgres            10                  ec61d13c8566        2 weeks ago         287 MB
postgres            10.1                ec61d13c8566        2 weeks ago         287 MB
postgres            latest              ec61d13c8566        2 weeks ago         287 MB
```

To save and *gzip* compress a Docker image run:
```bash
docker image save <repository[:tag]|image id> | gzip > <archiveName>.tar.gz

# example: 3dcitydb image
docker image save 3dcitydb | gzip > 3dcitydb.tar.gz
# example: postgresql 10.1 image
docker image save postgres:10.1 | gzip > "postgres-10.1.tar.gz"
docker image save ec61d13c8566 | gzip > "postgres-10.1.tar.gz"
```
To share an image, you simply need to provided the archive file.
To import the image on another system run:
```bash
gunzip -c <archiveName> | docker image load

# example: 3dcitydb image
gunzip -c 3dcitydb.tar.gz | docker image load
# if super user is required try following for a Ubuntu system:
sudo sh -c 'gunzip -c 3dcitydb.tar.gz | docker image load'
```

After the import has completed, you are ready to run (=create a container) from the image.

<a name="how-to-run-the-3dcitydb-docker-image"></a>
## How to run the 3DCityDB Docker image
Below some examples on how to run the 3DCityDB Docker image on an Ubuntu system are given. By *running* an image, a *container* is created from it. 
To get familiar with the terms *image* and *container* take a look at the [official Docker documentation](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/).

The `-p <host port:docker port>` switch of the `docker run` command allows you to specify on which port the 3DCityDB instance will listen on your host system.
For instance, use `-p 1234:5432` if you want to access the database instance on port *1234* of the system hosting the Docker container.

<a name="parameter-overview"></a>
### Parameter overview
To run the 3DCityDB Docker image you need to adapt the environment variables specifying the EPSG code (*SRSNO*), 
the spatial reference system name (*SRSNAME*) and the database name (*CITYDBNAME*) according to your needs.
The table below gives an overview on the currently available configuration parameters. 
If a parameter is omitted in the `docker run` call, its default value from the table is used.

| Parameter name | Description                            | Default value     |
|----------------|----------------------------------------|-------------------|
| CITYDBNAME     | Database name of the 3DCityDB instance | *3dcitydb-docker* |
| SRSNO          | Spatial reference system EPSG code     | *4326*            |
| SRSNAME        | Spatial reference system name          | *EPSG:4326*       |

**Note:**
The 3DCityDB Docker image provided here is based on the official PostgreSQL 10.1 image. 
There are several configurations options available, e.g. for setting a custom database user and password. 
Please find the [documentation here](https://hub.docker.com/_/postgres/).

<a name="usage-examples-ubuntu"></a>
### Usage examples
Below some examples for running a 3DCityDB container named *citydb-container* based on the image named *3dcitydb*  are given. 
The 3DCityDB database name used during the example is *mycitydb*. 
The spatial reference system of this 3DCityDB is *31468*, *EPSG:31468*.
The host port of the 3DCityDB is port *1234*.

Docker offers much more than the commands listed below. 
[Here](https://github.com/wsargent/docker-cheat-sheet) you can find a more comprehensive overview on Docker's commands.
```bash
# list all locally available images
docker images

# run a container in foreground mode
docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" -p 1234:5432 -it 3dcitydb

# run a container in foreground mode with interactive bash shell, e.g. for making changes to the container
docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" --name citydb-container -p 1234:5432 -it 3dcitydb bash

# run a container in detached mode
docker run -e "SRSNAME=EPSG:31468" -e "SRSNO=31468" -e "CITYDBNAME=mycitydb" -d --name citydb-container -p 1234:5432 3dcitydb

# Container commands
docker ps -a                  # list all running and stopped containers
docker port citydb-container  # show the port mapping for the container named citydb-container
docker stop citydb-container  # stop a running container
docker start citydb-container # start a stopped container
docker rm citydb-container    # remove a container
```

<a name="how-to-build"></a>
## How to build
Building an image from the Dockerfile in this repo is easy. You simply need to download the source code from this repo and run the 
`docker build` command.

<a name="ubuntu-build-step-by-step-guide"></a>
### Ubuntu build step-by-step guide
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
