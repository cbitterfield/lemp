# Set Default Environment Variables here
export LOG_STDOUT=/data/logs/nginix/dev_site/access.log
export LOG_LEVEL=info
export WEBSITE=www.services.com
export SSH_PORT=2222
export MYSQL_PORT=6306
export HTTP_PORT=8080
export HTTPS_PORT=8443

# Option Values for security; if not defined they are assigned at run time.
export MYSQL_ROOT_PASS="**notdefined**"
export MYSQL_DATABASE="services"
export MYSQL_USER="app_services"
export MYSQL_USER_PASS="services123"
export SITE_PASS="**notdefined**"
export SSH_PUBLIC="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2PeGFvEodzqF0Q1Szrr3WrjAyfGQE3N8ggYMtIG89atldkUBifGbI8Qw0MD52ZmjVUJFSOIUAaD0JTlaSwcDb7g5aQMuhsTDpebDolvMDfIBi+ZuRuph0h1mAMY7424Hpu8xmTQBolHjw2W+M7d8NAJjzNUh2GVTx0xjr723o4PmOQ4Nipan38YiqIK+kPO+hUb1pJ5yC8yI559KZfoXfPIwhp+liuwMEcW8XPgLNZecwl7NMyunjtuEnAatmlooPSA8X4cCMArqMLRLdYqcth+uiheQKDHqt0/7AU2SK/7uo5ZMRsacxz9qa5AyWlCZebo6J5zHO3s8P7tGCJz+9 colin@bitterfield.com"
export HOST_MOUNT="$HOME/data"