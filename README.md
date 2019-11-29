## LEMP: Linux | NGINX | MYSQP | PHP Docker Image

LEMP is a variation of the ubiquitous LAMP stack used for developing and deploying web applications. Traditionally, LAMP consists of Linux, Apache, MySQL, and PHP. Due to its modular nature, the components can easily be swapped out. With LEMP, Apache is replaced with the lightweight yet powerful Nginx.

![cbitterfield]<img src="https://github.com/cbitterfield/lemp/blob/master/cbitterfield_logo.jpg" alt="cbitterfield logo" width="250" >

logo by Anna Maria Paliasna Weaver (c) 2019

# This is a fully functional LEMP development environment with Secure Headers
This image is designed to be fully functional with data persitence.

## Capabilities:

* Start/Stop/Login script included for easy use
* Supports TLS self signed and real
* Allows for configuring database name, user and password via environment variables.
* Allows doe SSH/SFTP access by password and by key
* Includes a fully comprehensive example index.php to test LEMP functions
* Includes support for secure headers in TLS
* Fully documented scripts and docker file
* Fully configurable logging and debugging
* Fully configured with a seperate user and group for LEMP site (username = dev_site)
* Single mount point for host
* Uses docker volumes if not using host mount point

### Environment variables

**Variables:**
- LOG_LEVEL
- LOG_STDOUT
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_USER_PASS
- MYSQL_ROOT_PASS 
- SITE_PASS
- SSH_PUBLIC
- TLS

### Ports Exposed

**Ports**
- 22 [SSH/SFTP]
- 80 [http]
- 443 [https]
- 3603 [mysql]

## service script (lemp_service.sh)

usage lemp_service.sh [start|stop|status|show_docker|login|clear]

Script passes through any locally set variables.

login option runs interactive bash shell
clear option removes all containers in use

Article on the building of this image is available
Full References available
[MEDIUM](https://medium.com/@cbitterfield/creating-a-docker-development-lemp-container-a90e64d69b36)

## Example DOCKER USAGE

docker run -it --name LEMP \
    -p "$HTTP_PORT":80 -p HTTPS_PORT:443 -p "$SSH_PORT":22  -p "$MYSQL_PORT":3306 
    --add-host "$WEBSITE":127.0.0.1 \
    --env WEBSITE  --env LOG_STDOUT  --env LOG_LEVEL --env MYSQL_USER --env TLS --env MYSQL_USER_PASS \
    --env MYSQL_ROOT_PASS --env SITE_PASS --env SSH_PUBLIC --env MYSQL_DATABASE \
    -v $MOUNT_POINT:/data cbitterfield/lemp2:latest
