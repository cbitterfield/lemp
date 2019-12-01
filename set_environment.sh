# Set Default Environment Variables here
export LOG_STDOUT=/data/logs/nginix/dev_site/access.log
export LOG_LEVEL=info
export WEBSITE=xxx-example.local
export SSH_PORT=2222
export MYSQL_PORT=6306
export HTTP_PORT=8080
export HTTPS_PORT=8443

# Option Values for security; if not defined they are assigned at run time.
export MYSQL_ROOT_PASS="**notdefined**"
export MYSQL_DATABASE="**notdefined**"
export MYSQL_USER="**notdefined**"
export MYSQL_USER_PASS="**notdefined**"
export SITE_PASS="**notdefined**"
export SSH_PUBLIC=""
export HOST_MOUNT="$HOME/data"
export TLS="yes"