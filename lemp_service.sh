#!/bin/bash

# Author Colin A. Bitterfield
# Source code available on github.com/cbitterfield/lemp2
# License: GNU Public 3.0

# Set Default Environment Variables here
export LOG_STDOUT=${LOG_STDOUT:-"/data/logs/nginix/dev_site/access.log"}
export LOG_LEVEL=${LOG_LEVEL:-info}
export WEBSITE=${WEBSITE:-website.local}
export SSH_PORT=${SSH_PORT:-"2222"}
export MYSQL_PORT=${MYSQL_PORT:-"6306"}
export HTTP_PORT=${HTTP_PORT:-"8080"}
export HTTPS_PORT=${HTTPS_PORT:-"8443"}

# Option Values for security; if not defined they are assigned at run time.
export MYSQL_ROOT_PASS=${MYSQL_ROOT_PASS:-**notdefined**}
export MYSQL_DATABASE=${MYSQL_DATABASE:-**notdefined**}
export MYSQL_USER=${MYSQL_USER:-**notdefined**}
export MYSQL_USER_PASS=${MYSQL_USER_PASS:-**notdefined**}
export SITE_PASS=${SITE_PASS:-**notdefined**}
export SSH_PUBLIC=${SSH_PUBLIC:-"**notdefined**"}
export HOST_MOUNT=${HOST_MOUNT:-''}
if [ $HOST_MOUNT ]; then 
export MOUNT_POINT="${HOST_MOUNT}:/data"
else
unset MOUNT_POINT
fi

set -e
NAME=LEMP2
INSTANCE="cbitterfield/lemp2:latest"

#Build the docker command based on parameters:
#It will be docker run CMD
#
CMD="/usr/local/bin/docker run --name $NAME -it "
if [ "$SSH_PORT" ]; then CMD="$CMD -p $SSH_PORT:22"  ; fi
if [ "$HTTP_PORT" ]; then CMD="$CMD -p $HTTP_PORT:80"  ; fi
if [ "$HTTPS_PORT" ]; then CMD="$CMD -p $HTTPS_PORT:443 "  ; fi
if [ "$MYSQL_PORT" ]; then CMD="$CMD -p $MYSQL_PORT:3306 "  ; fi
if [ "$WEBSITE" ]; then CMD="$CMD --add-host $WEBSITE:127.0.0.1 "  ; fi
CMD="$CMD --env WEBSITE  --env LOG_STDOUT  --env LOG_LEVEL --env MYSQL_USER --env TLS --env MYSQL_USER_PASS --env MYSQL_ROOT_PASS --env SITE_PASS --env SSH_PUBLIC --env MYSQL_DATABASE"
if [ "$MOUNT_POINT" ]; then CMD="$CMD -v $MOUNT_POINT "  ; fi
CMD="$CMD $INSTANCE"

###############################################


case "$1" in
  start)
        echo "Starting docker: $NAME"
        echo "website name set to [$WEBSITE]"
        if [ "$DATABASE" ]; then echo "database name set to [$DATABASE]" ; fi
        if [ "$DATABASE_USER" ]; then echo "database user set to [$DATABASE_USER]" ; fi
        if [ "$DATABASE_USER_PASS" ]; then echo "database password set to [$DATABASE_USER_PASS]" ; fi
        if [ "$DEVSITE_PASS" ]; then echo "Linux user [dev_site] password is set to [$DEVSITE_PASS]" ; fi
        if [ "$SSH_PUBLIC" ]; then echo "Enabling key access to [dev_site] password" ; fi
        if [ "$MOUNT_POINT" ]; then echo "MOUNT_POINT is $MOUNT_POINT" ; fi
        echo "All undefined values are defaulted on startup and presented to sdtout"
        echo "In the user directory is a copy of all of the passswords, delete after you have downloaded it"
        # Test to see if a container is already running as LEMP2
        
        LEMP2="$(docker ps -f name=$NAME -qa)"
        if [ "$LEMP2" ]; then 
             echo "Starting an existing container $NAME"
             docker start $NAME -a
        else
             echo "Starting a new container $NAME"
             $CMD
        fi
        
	;;
  stop)
        echo -n "Stopping docker: $NAME"
        docker container stop $NAME
        echo "."
	;;
	
  clear)
        echo -n "Clearing docker container: $NAME"
        docker container stop $NAME
        docker container rm $NAME
	echo "."
	;;
	
  login)
  		docker exec -it $NAME /bin/bash
  ;;	
	
  status)
		echo -n "Getting docker status: $NAME"
		docker ps -f name=$NAME
		echo "."
	;;
	
	show_docker)
	printf "Docker Command for usage"
	printf "Set the following environment variables"
	printf "{ LOG_STDOUT | LOG_LEVEL | WEBSITE | SSH_PORT | MYSQL_PORT | HTTP_PORT | HTTPS_PORT | DEVSITE_PASS | WEBSITE_PASSWORD | MYSQL_ROOT_PASSWORD "
	printf "\t DATABASE_USER | DATABASE_USER_PASS }"
	printf "docker run -it --name LEMP2 -p "$HTTP_PORT":80 -p HTTPS_PORT:443 -p "$SSH_PORT":22 \\"
	printf "-p "$MYSQL_PORT":3306 --add-host "$WEBSITE":127.0.0.1 \\ "
	printf "--env WEBISTE  --env LOG_STDOUT  --env LOG_LEVEL cbitterfield/lemp2:latest "
	
	;;

  *)
	printf "Usage: %s %s" $1 "[start|stop|status|show_docker|clear]"
	exit 1
esac
