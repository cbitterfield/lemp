#!/bin/bash

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
export SSH_PUBLIC=${SSH_PUBLIC:-"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2PeGFvEodzqF0Q1Szrr3WrjAyfGQE3N8ggYMtIG89atldkUBifGbI8Qw0MD52ZmjVUJFSOIUAaD0JTlaSwcDb7g5aQMuhsTDpebDolvMDfIBi+ZuRuph0h1mAMY7424Hpu8xmTQBolHjw2W+M7d8NAJjzNUh2GVTx0xjr723o4PmOQ4Nipan38YiqIK+kPO+hUb1pJ5yC8yI559KZfoXfPIwhp+liuwMEcW8XPgLNZecwl7NMyunjtuEnAatmlooPSA8X4cCMArqMLRLdYqcth+uiheQKDHqt0/7AU2SK/7uo5ZMRsacxz9qa5AyWlCZebo6J5zHO3s8P7tGCJz+9 colin@bitterfield.com"}

set -e
NAME=LEMP2

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
        echo "All undefined values are defaulted on startup and presented to sdtout"
        echo "In the user directory is a copy of all of the passswords, delete after you have downloaded it"
        # Test to see if a container is already running as LEMP2
        LEMP2="`docker ps -f name=$NAME -qa`"
        if [ "$LEMP2" ]; then 
             echo "Starting an existing container $NAME"
             docker start $NAME -a
        else
             echo "Starting a new container $NAME"
             docker run --name LEMP2 -it -p $HTTP_PORT:80 -p $HTTPS_PORT:443 -p $SSH_PORT:22 -p $MYSQL_PORT:3306 \
        --add-host $WEBSITE:127.0.0.1 --env WEBSITE  --env LOG_STDOUT  --env LOG_LEVEL --env MYSQL_USER \
        --env MYSQL_USER_PASS --env MYSQL_ROOT_PASS --env SITE_PASS --env DATABASE -v $HOME/data:/data\
        cbitterfield/lemp2:latest
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
	echo "Docker Command for usage"
	echo "Set the following environment variables"
	echo "{ LOG_STDOUT | LOG_LEVEL | WEBSITE | SSH_PORT | MYSQL_PORT | HTTP_PORT | HTTPS_PORT | DEVSITE_PASS | WEBSITE_PASSWORD | MYSQL_ROOT_PASSWORD "
	echo "\t DATABASE_USER | DATABASE_USER_PASS }
	echo "docker run -it --name LEMP2 -p $HTTP_PORT:80 -p HTTPS_PORT:443 -p $SSH_PORT:22 \\"
	echo "-p $MYSQL_PORT:3306 --add-host $WEBSITE:127.0.0.1 \\ "
	echo "--env WEBISTE  --env LOG_STDOUT  --env LOG_LEVEL cbitterfield/lemp2:latest "
	
	;;

  *)
	echo "Usage: "$1 {start|stop|status|show_docker|clear}"
	exit 1
esac
