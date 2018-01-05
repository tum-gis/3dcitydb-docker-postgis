# 3D City Database Docker image
This is the git repo of the (not yet, but hopefully soon to become) [official image](https://docs.docker.com/docker-hub/official_repos/) for the [3D City Database (3DCityDB)](https://github.com/3dcitydb/3dcitydb).
It allows for the *instant* creation of a 3DCityDB instance without having to setup and configure a database server.
All you need is a [Docker](https://www.docker.com/what-docker) installation and the image provided here.
Detailed information on how to get and setup Docker on your system is provided in the [official documentation](https://docs.docker.com/engine/installation/).

> **Note:** Everything in this repo is in an early testing stage. 
> If you experience any problems or see possible enhancements please let me know by creating a new issue [here](https://github.com/tum-gis/3dcitydb-docker/issues).

## Quick start
For a quick run of the 3DCityDB Docker image first either [pull](#tum-gis-registry) (recommended) or [download](#get-docker-image) the ready-to-run 3DCityDB Docker image or create a fresh [build](#how-to-build).
Second, when the 3DCityDB Docker image is available on your system see the documentation and examples on how to [run](#how-to-run-the-3dcitydb-docker-image) the 3DCityDB Docker image.
 
## Content
* **[Get the 3DCityDB Docker image](#get-docker-image)**
  * [TUM-GIS Docker registry](#tum-gis-registry)
  * [Docker image import/export](#docker-import-export) 
* **[How to run the 3DCityDB Docker image](#how-to-run-the-3dcitydb-docker-image)**
  * [Parameter overview](#parameter-overview)
  * [Usage examples](#usage-examples)
* **[How to build](#how-to-build)**
  * [Build parameters](#build-parameters)

<a name="get-docker-image"></a>
## Get the 3DCityDB Docker image
The best way of sharing Docker images is with a [Docker registry](https://docs.docker.com/registry/). 
A registry allows for the distribution of Docker images with the [`docker pull`](https://docs.docker.com/engine/reference/commandline/pull/#usage) 
and [`docker push`](https://docs.docker.com/engine/reference/commandline/push/) commands.
The official Docker registry offering 100,000+ free apps is called [Docker Hub](https://hub.docker.com/).

Currently, the 3DCityDB Docker image has not been released to the public, it is not (jet) available on [Docker Hub](https://hub.docker.com/).
Meanwhile, three options are available to get the 3DCityDB Docker image:
* [Pull image from TUM-GIS Docker registry](#tum-gis-registry)
* [Download and import image](#docker-import-export)
* [Build image](#how-to-build)

<a name="tum-gis-registry"></a>
### TUM-GIS Docker registry
The TUM-GIS Docker registry is a Docker registry set up at a server at TUM, Chair of Geoinformatics. 
It is meant for testing purpose and **only reachable within the TUM network**.
Follow the steps below to obtain the 3DCityDB Docker image from there:

1. Import SSL certificate  
First, download the self-signed SSL certificate of the TUM-GIS Docker registry.
Depending on your operating system use the *x509* or *pfx/p12* certificate format.  
   * x509:    [x509 SSL certificate download](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/domain.crt)
   * pfx/p12: [pfx SSL certificate download](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/domain.pfx)

2. Import SSL certificate  
After downloading the SSL certificate, you need to install it on your system. 
The certificate install process varies for different operation system:
   * Windows: Right-click certificate (x509) file and select *Install certificate*.
     Follow the instructions of the install wizard and leave all options at their defaults.
  
   * MAC OSX: A guide for install SSL certificates can be found [here](https://www.sslsupportdesk.com/how-to-import-a-certificate-into-      mac-os/).
   * Other operating systems: Google -> "myOS SSL certificate install"
  
3. Restart Docker  
To make sure the new certificate is known to Docker restart Docker. 
If the certificate seems not to be known after restarting Docker, retry the install process and reboot your system.

4. Pull the 3DCityDB Docker image  
Now you should be able to access the TUM-GIS Docker registry and pull images from it using [`docker pull`](https://docs.docker.com/engine/reference/commandline/pull/#usage).
```bash
docker pull tum-gis-testserver.duckdns.org/3dcitydb           # latest image (3DCityDB v.3.3.1)
docker pull tum-gis-testserver.duckdns.org/3dcitydb:v3.0.0    # 3DCityDB v.3.0.0
```
After the image has been pulled successfully you are ready to [run](#how-to-run-the-3dcitydb-docker-image) the image.
  
<a name="docker-import-export"></a>
### Docker image import/export
To import a Docker image on your local system the docker [`docker load`](https://docs.docker.com/engine/reference/commandline/load/) command can be used.
First, download the 3DCityDB Docker image here:  
DOWNLOAD: [**3DCityDB Docker TESTING image**](https://www.3dcitydb.org/3dcitydb/fileadmin/public/3dcitydb-docker/3dcitydb.tar.gz)

To find out what images exist on your system run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/). 
You will receive an output similar to this:
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
After the import has completed, you are ready to [run](#how-to-run-the-3dcitydb-docker-image) from the image.

<a name="how-to-run-the-3dcitydb-docker-image"></a>
## How to run the 3DCityDB Docker image
Below some examples on how to run the 3DCityDB Docker image are given. 
By *running* an image with [`docker run`](https://docs.docker.com/engine/reference/commandline/run/), a *container* is created from it. 
To get familiar with the terms *image* and *container* take a look at the [official Docker documentation](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/).

<a name="parameter-overview"></a>
### Parameter overview
The `-p <host port>:<container port>` switch of the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/)
command allows you to specify on which port the 3DCityDB instance will listen on your host system.
For instance, use `-p 1234:5432` if you want to access the database instance on port *1234* of the system hosting the Docker container.

To customize the 3DCityDB Docker container you need to adapt the environment variables specifying the EPSG code (*SRSNO*), 
the spatial reference system name (*SRSNAME*) and the database name (*CITYDBNAME*) according to your needs.
The table below gives an overview on the currently available configuration parameters. 
If a parameter is omitted in the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) call, its default value from the table is used.

| Parameter name | Description                            | Default value     |
|----------------|----------------------------------------|-------------------|
| CITYDBNAME     | Database name of the 3DCityDB instance | *3dcitydb-docker* |
| SRSNO          | Spatial reference system EPSG code     | *4326*            |
| SRSNAME        | Spatial reference system name          | *EPSG:4326*       |

> **Note:**
> The 3DCityDB Docker image provided here is based on the official PostgreSQL 10.1 image. 
> There are much more configurations options available, e.g. for setting a custom database user and password. 
> Please take a look at the [PostgreSQL Docker image documentation](https://hub.docker.com/_/postgres/) for more.

<a name="usage-examples"></a>
### Usage examples
Below some examples for running a 3DCityDB container named *citydb-container* based on the image named *3dcitydb*  are given.
The 3DCityDB database name used during the example is *mycitydb*. 
The spatial reference system of this 3DCityDB is *31468*, *EPSG:31468*.
The host port of the 3DCityDB is port *1234*.

```bash
# list all locally available images
docker images

# run container in foreground mode
docker run --name citydb-container -p 1234:5432 -it \
    -e "SRSNAME=EPSG:31468" \
    -e "SRSNO=31468" \
    -e "CITYDBNAME=mycitydb" \
    3dcitydb

# run container in foreground mode with interactive bash shell, e.g. for making changes to the container
docker run --name citydb-container -p 1234:5432 -it \
    -e "SRSNAME=EPSG:31468" \
    -e "SRSNO=31468" \
    -e "CITYDBNAME=mycitydb" \
    3dcitydb bash

# run container in detached (background) mode
docker run --name citydb-container -p 1234:5432 -d \
    -e "SRSNAME=EPSG:31468" \
    -e "SRSNO=31468" \
    -e "CITYDBNAME=mycitydb" \
    3dcitydb

# Container commands
docker ps -a                  # list all running and stopped containers
docker port citydb-container  # show the port mapping for the container named citydb-container
docker stop citydb-container  # stop a running container
docker start citydb-container # start a stopped container
docker rm citydb-container    # remove a container
```
> **Note:**
> In the example above long commands are broken to several lines for readability using bash line continue ("\").  

> **Note:**  Docker offers much more than the commands listed above. 
> [Here](https://github.com/wsargent/docker-cheat-sheet) you can find a more comprehensive overview on Docker's commands.

<a name="how-to-build"></a>
## How to build
Building an image from the Dockerfile in this repo is easy. 
You simply need to download the source code from this repo and run the 
[`docker build`](https://docs.docker.com/engine/reference/commandline/build/) command. 
Follow the step below to build a 3DCityDB Docker image.

```bash
# 1. Download source code using git. 
git clone https://github.com/tum-gis/3dcitydb-docker.git
# 2. Change to the source folder you just cloned.
cd 3dcitydb-docker
# 3. Build a docker image tagged as 3dcitydb.
docker build -t 3dcitydb .
```

If the build succeeds, you are ready to run the image as described above.
To list all locally available images run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/). 

<a name="build-parameters"></a>
### Build parameters
To build a Docker image with a specific 3DCityDB version, 
the [`docker build --build-arg`](https://docs.docker.com/engine/reference/commandline/build/) parameter can be used.

**Note:** This feature has only been tested with 3DCityDB version *3.0.0* so far.

| Parameter name         | Description                            | Default value     |
|------------------------|----------------------------------------|-------------------|
| citydb_version         | Version of the 3DCityDB                | *3.3.1*           |
| citydb_default_db_name | Name of the database created at container startup, if not overwritten by CITYDBNAME environment variable. | *3dcitydb-docker* |

Build example:
```bash
docker build \
    --build-arg "citydb_version=3.0.0" \
    --build-arg "citydb_default_db_name=my3DCityDB" \
    -t 3dcitydb .
```
> **Note:**
> In the example above long commands are broken to several lines for readability using bash line continue ("\").
 
