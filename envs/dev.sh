export APP_FRONTEND_IMAGE=cweidner3/collective-access
export APP_FRONTEND_PORT=80
export APP_ADMINER_PORT=8080

export PHP_DEBUG_MODE=0
export PHP_UPLOAD_MAX_FILESIZE=64M
export PHP_POST_MAX_SIZE=64M
export PHP_MEMORY_LIMIT=512M

export MYSQL_DB_HOST=mysql
export MYSQL_DB_USER=collectiveaccess
export MYSQL_DB_NAME=ca

export CA_APP_DISPLAY_NAME="My First Collective Access"
export CA_APP_ADMIN_EMAIL="test@email.com"

export NFS_ROOT_PATH=/mnt/md0/appdata
export NFS_ADDRESS=192.168.1.10
export NFS_USER=user
export NFS_PASS=pass
