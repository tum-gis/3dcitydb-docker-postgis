@echo off
TITLE 3DCityDB PostGIS Docker Image Quickstart Script
SETLOCAL
::-----------------------------------------------------------------------------
:: 3DCityDB PostGIS Docker Image Quickstart Script ----------------------------
:: Contact: Bruno Willenborg <b.willenborg@tum.de
:: Chair of Geoinformatics, Technical University of Munich (TUM)
::-----------------------------------------------------------------------------

:: Greetings ------------------------------------------------------------------
echo. 
echo ########################################################################################
echo ## 3DCityDB PostGIS Docker Image Quickstart Script #####################################
echo ########################################################################################
echo.
echo Welcome to the 3DCityDB PostGIS Docker Image Quickstart Script. This script will 
echo guide you through the process of setting up a 3DCityDB Docker Container. It is going
echo to download the latest 3DCityDB PostGIS Docker image from DockerHub for you and create
echo a 3DCityDB PostGIS Docker container based on the configuration parameters requested
echo during this script.
echo.
echo Please follow the instructions of the script.
echo   Enter the required parameters when prompted and press ENTER to confirm.
echo   Only press ENTER when prompted to use the default value.
echo.
echo Documentation and help:
echo    3DCityDB PostGIS Docker Image:  https://github.com/tum-gis/3dcitydb-docker-postgis
echo    3DCityDB on DockerHub:          https://hub.docker.com/r/tumgis/3dcitydb-postgis/
echo    3DCityDB:                       https://github.com/3dcitydb
echo.
echo Having problems or need support?
echo    Please file an issue here:
echo    https://github.com/tum-gis/3dcitydb-docker-postgis/issues
echo. 
echo ########################################################################################
echo.
:: Check, IF Docker engine is running -----------------------------------------
docker info > nul
IF NOT "%errorlevel%"=="0" (
  echo.
  echo !!!!! WARNING !!!!! ############################################################
  echo Docker seems not to be installed or running.
  echo Please make sure Docker is up and runnung and retry. Use the "docker info" command to check if Docker is operational.
  echo Help on setting up Docker can be found here: https://docs.docker.com/install/
  echo.
  echo Press any key to quit.
  echo ################################################################################
  echo.
  pause
  exit /b  
)

:: Prompt for CONTAINERNAME, PORT, DBUSER, DBPASSWORD, DBNAME, SRID, SRSNAME ----------------------
:: CONTAINERNAME
:q1
set var=
echo.
echo Please enter a NAME for the 3DCityDB PostGIS Docker container. Press ENTER to use default.
set /p var="(default=citydb-container): "

IF /i NOT "%var%"=="" (
  set CONTAINERNAME=%var%
) else (
  set CONTAINERNAME=citydb-container
)

:: PORT
:q2
set var=
echo.
echo Please enter a PORT for the 3DCityDB PostGIS Docker container to listen on. Press ENTER to use default.
set /p var="(default=5432): "

IF /i NOT "%var%"=="" (
    set PORT=%var%
) else (
  set PORT=5432
  goto:q3
)

:: Port is numeric and between 1 and 65535?
SET "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
IF defined num (
  echo.
  echo PORT must be numeric and between 1 and 65535. Please retry.
  goto:q2
)

IF NOT %var% GTR 1024 (
  echo.
  echo PORT must be numeric and between 1025 and 65535. Please retry.
  goto:q2
) 
IF NOT %var% LEQ 65535 (
  echo.
  echo PORT must be numeric and between 1025 and 65535. Please retry.
  goto:q2
) 

:: DBUSER
:q3
set var=
echo.
echo Please enter a USERNAME for the 3DCityDB. Press ENTER to use default.
set /p var="(default=postgres): "

IF /i NOT "%var%"=="" (
  set DBUSER=%var%
) else (
  set DBUSER=postgres
)

:: DBPASSWORD
:q4
set var=
echo.
echo Please enter a PASSWORD for the 3DCityDB. Press ENTER to use default.
set /p var="(default=postgres): "

IF /i NOT "%var%"=="" (
  set DBPASSWORD=%var%
) else (
  set DBPASSWORD=postgres
)

:: DBNAME
:q5
set var=
echo.
echo Please enter a DATABASE NAME for the 3DCityDB. Press ENTER to use default.
set /p var="(default=citydb): "

IF /i NOT "%var%"=="" (
  set DBNAME=%var%
) else (
  set DBNAME=citydb
)

:: SRID
:q6
set var=
echo.
echo Please enter the SRID fof the spatial reference system of the 3DCityDB. Press ENTER to use default.
set /p var="(default SRS=WGS84, SRID=4326): "

IF /i NOT "%var%"=="" (
    set SRID=%var%
) else (
  set SRID=4326
  goto:q7
)

:: SRID is numeric?
SET "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
IF defined num (
  echo.
  echo SRID must be numeric. Please retry.
  goto:q6
)

:q7
set var=
echo.
echo Please enter the name of the spatial reference system to use for the 3DCityDB. Press ENTER to use default.
set /p var="(default SRS=WGS84, SRSNAME=urn:ogc:def:crs:EPSG::4326): "

IF /i NOT "%var%"=="" (
  set SRSNAME=%var%
) else (
  set SRSNAME=urn:ogc:def:crs:EPSG::4326
)

:: print settings
echo.
echo ########################################################################################
echo.
echo Here is a summary of the settings you provided:
echo.
echo Container name:          %CONTAINERNAME%
echo Container host port:     %PORT%
echo 3DCityDB username:       %DBUSER%
echo 3DCityDB password:       %DBPASSWORD%
echo 3DCityDB database name:  %DBNAME%
echo 3DCityDB SRS SRID:       %SRID%
echo 3DCityDB SRS SRSNAME:    %SRSNAME%
echo. 
echo ########################################################################################
echo.
:: Create Docker container
echo Trying to start your docker container now...
echo.
docker run -dit --name %CONTAINERNAME%^
    -p %PORT%:5432^
    -e "POSTGRES_USER=%DBUSER%"^
    -e "POSTGRES_PASSWORD=%DBPASSWORD%"^
    -e "CITYDBNAME=%DBNAME%"^
    -e "SRID=%SRID%"^
    -e "SRSNAME=%SRSNAME%"^
  tumgis/3dcitydb-postgis

:: Print info summary
if "%errorlevel%"=="0" (
  goto:success
) else (
  goto:fail
)

exit /b

:success
echo.
echo Good news. It seems your container war started successfully.
echo. 
echo Run "docker ps -a" to check the status of your container. [ running :) ^| exited :( ]
echo If the container status is "Exited" run "docker logs %CONTAINERNAME%" to get information on errors during startup.
echo.
echo ########################################################################################
echo.
echo Here are some useful Docker commands for this container:
echo.
echo docker ps -a                            List all containers and their current status
echo docker logs -f %CONTAINERNAME%         Attach the log of your container, useful for debugging
echo docker exec -it %CONTAINERNAME% bash   Get an interactive shell on your container, useful for making changes to the container
echo docker stop %CONTAINERNAME%            Stop the container, if you do not need it temporarily
echo docker start %CONTAINERNAME%           Start the container, if you need it again
echo.
echo !!!!!! DANGERZONE !!!!!!----------------------------------------------------------------
echo docker rm -f %CONTAINERNAME%           Stop if running and remove the container but keep its data 
echo docker rm -f -v %CONTAINERNAME%        Stop if running and remove the container and ALL its data. This cannot be undone!!
echo !!!!!! DANGERZONE !!!!!!----------------------------------------------------------------
echo.
echo ########################################################################################
echo.
goto:end

:fail
echo.
echo Oh no! Something went wrong. Inspect the error message above to get a clue on what happend.
echo.
echo ########################################################################################
echo.
goto:end

:end
echo Press any key to quit.
echo.
pause
exit /b
