# Create a LEMP docker iamge with NGINX and MYSQL
FROM ubuntu:18.04
USER root
LABEL Description="Development environment for LEMP stack, based on Ubuntu 18.04 LTS. Includes .htaccess support and popular PHP7 features, including composer and mail() function." 
LABEL License="GNU Public License 3.0" 
LABEL Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST WWW TLS PORT NUMBER]:443 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/data -v cbitterfield/lemp2" 
LABEL Version="2.0"
LABEL maintainer="Colin Bitterfield <colin@bitterfield.com>"
LABEL Author="Colin Bitterfield <colin@bitterfield.com>"


#Used for configuring the base image
ARG WEBSITE=mywebsite.local
ARG WEBSITE_UID=1500
ARG WEBSITE_USER='dev_site'
ARG LEMP_GRP=1000
ARG DATE_TIMEZONE=UTC
ARG DEBIAN_FRONTEND=noninteractive

# Create Data Directories
RUN mkdir /data
RUN mkdir /data/html
RUN mkdir /data/mysql
# Create the logs directories
RUN (mkdir /data/logs; mkdir /data/logs/nginx;mkdir /data/logs/mysql)
# Create the configuration directories
RUN (mkdir /data/conf;mkdir /data/conf/nginx;mkdir /data/conf/nginx/sites-available;mkdir /data/conf/nginx/sites-enabled;mkdir /data/conf/nginx/conf.d; mkdir /data/conf/mysql; mkdir /data/conf/mysql/conf.d;mkdir /data/conf/nginx/tls)

# Create Data Directories for examples
RUN mkdir /.data
RUN mkdir /.data/html
RUN mkdir /.data/mysql
RUN mkdir /.data/conf
# Create the logs directories
RUN (mkdir /.data/logs; mkdir /.data/logs/nginx;mkdir /.data/logs/mysql)
# Create the configuration directories
RUN (mkdir /.data/conf/nginx; mkdir /.data/conf/nginx/sites-available;mkdir /.data/conf/nginx/sites-enabled;mkdir /.data/conf/nginx/conf.d; mkdir /.data/conf/mysql; mkdir /.data/conf/mysql/conf.d;mkdir /.data/conf/nginx/tls)

# Update the operating system when we start and again at the end.
RUN apt-get update
RUN apt-get upgrade -y

# Add Basic Utilities needed
RUN apt-get install -y zip unzip
RUN apt install debconf-utils sudo -y 
RUN apt-get install git nodejs npm composer nano tree vim curl ftp ssh certbot -y

# Add Python 3.8
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt install python3.8 -y

#Setup Email 
RUN apt-get install postfix -y

# Install PHP and Modules
# Install FPM and FPM SQL Modules
RUN apt-get install php-fpm php-mysql libfcgi0ldbl -y
# Install CLI modules
RUN apt-get install \
	php7.2 \
	php7.2-bz2 \
	php7.2-cgi \
	php7.2-cli \
	php7.2-common \
	php7.2-curl \
	php7.2-dev \
	php7.2-enchant \
	php7.2-fpm \
	php7.2-gd \
	php7.2-gmp \
	php7.2-imap \
	php7.2-interbase \
	php7.2-intl \
	php7.2-json \
	php7.2-ldap \
	php7.2-mbstring \
	php7.2-mysql \
	php7.2-odbc \
	php7.2-opcache \
	php7.2-pgsql \
	php7.2-phpdbg \
	php7.2-pspell \
	php7.2-readline \
	php7.2-recode \
	php7.2-snmp \
	php7.2-sqlite3 \
	php7.2-sybase \
	php7.2-tidy \
	php7.2-xmlrpc \
	php7.2-xsl \
	php7.2-zip -y
	
# Configure PHP and set php.ini file location


# Install NGINX and prepare example fines
RUN apt-get install nginx nginx-extras -y
RUN sed -i '/include \/etc\/nginx\/conf.d/c \\tinclude \/data\/conf\/nginx_conf.d\/http_*.conf;' /etc/nginx/nginx.conf
RUN sed -i '/include \/etc\/nginx\/modules-enabled/c include \/data\/conf\/nginx\/conf.d\/pre_http_*.conf;' /etc/nginx/nginx.conf
RUN sed -i '/include \/etc\/nginx\/sites-enabled/c \\tinclude \/data\/conf\/nginx\/sites-enabled\/*.conf;' /etc/nginx/nginx.conf
RUN sed -i '/error_log \/var\/log\/nginx\/error.log;/c \\tinclude \/data\/conf\/nginx\/conf.d\/error_default.conf;' /etc/nginx/nginx.conf


RUN unlink /etc/nginx/sites-enabled/default
COPY default_site.conf /.data/conf/nginx/sites-available/default_site.conf
COPY dev_site.conf /.data/conf/nginx/sites-available/dev_site.conf
COPY index.php /.data/html/
COPY http_nginx.conf /.data/conf/nginx/conf.d/
COPY pre_http_nginx.conf /.data/conf/nginx/conf.d/

# Add MySQL aka MarianDB
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN echo '!includedir /data/conf/mysql/' >> /etc/mysql/my.cnf
COPY docker_mysql.cnf /etc/mysql/mariadb.conf.d/99-mysqld_datadir.cnf

# Set debian conf
COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections


# Set Environment Variables And Defaults
#Environment variables for use in running image
ENV LOG_LEVEL="info"
ENV TERM="xterm-256color"
ENV LOG_STDOUT="**notdefined**"
ENV MYSQL_ROOT_PASS="**notdefined**"
ENV MYSQL.dataBASE="**notdefined**"
ENV MYSQL_USER="**notdefined**"
ENV MYSQL_USER_PASS="**notdefined**"
ENV SITE_PASS="**notdefined**"
ENV TLS="**Boolean**"




# Create a user container for development website
RUN groupadd -g $LEMP_GRP lemp
RUN useradd --comment 'Default Development Website' --no-create-home --home-dir /data/html  --uid $WEBSITE_UID --user-group  --shell /bin/bash $WEBSITE_USER
RUN usermod -a -G sudo dev_site
RUN usermod -a -G dev_site www-data
RUN usermod -a -G lemp www-data
RUN usermod -a -G lemp mysql
RUN usermod -a -G lemp dev_site
RUN passwd --lock dev_site
 
 
#Set Permissions for default structure 
RUN chown -R root:lemp /.data
RUN chown -R $WEBSITE_USER:www-data /.data/html
RUN chown -R mysql:mysql /.data/mysql
RUN chmod -R 775 /.data


# Create start script and control scripts for LEMP
COPY lemp-start /usr/sbin/
RUN chmod +x /usr/sbin/lemp-start


#Exernal Volume and Network Connectons Defined
VOLUME /data

EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 3306

# Update the operating system when we start and again at the end.
# Make sure the image is current when we run for the first time.
RUN apt autoremove -y

#Run Initialization Script
CMD ["/usr/sbin/lemp-start"]

