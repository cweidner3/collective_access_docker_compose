#!/usr/bin/env bash

set -e

CA_DIR="$(pwd)"

CA_DB_HOST="${CA_DB_HOST:-localhost}"
CA_DB_USER="${CA_DB_USER:-my_database_user}"
CA_DB_PASSWORD="${CA_DB_PASSWORD:-my_database_password}"
CA_DB_DATABASE="${CA_DB_DATABASE:-name_of_my_database}"
CA_APP_DISPLAY_NAME="${CA_APP_DISPLAY_NAME:-My First CollectiveAccess System}"
CA_ADMIN_EMAIL="${CA_ADMIN_EMAIL:-info@put-your-domain-here.com}"

CA_QUEUE_ENABLED="${CA_QUEUE_ENABLED:-0}"
CA_DEFAULT_LOCALE="${CA_DEFAULT_LOCALE:-en_US}"
CA_USE_CLEAN_URLS="${CA_USE_CLEAN_URLS:-0}"
CA_APP_NAME="${CA_APP_NAME:-collectiveaccess}"
CA_GOOGLE_MAPS_KEY="${CA_GOOGLE_MAPS_KEY:-}"
CA_CACHE_BACKEND="${CA_CACHE_BACKEND:-file}"
CA_ALLOW_INSTALLER_TO_OVERWRITE_EXISTING_INSTALLS="${CA_ALLOW_INSTALLER_TO_OVERWRITE_EXISTING_INSTALLS:-false}"
CA_STACKTRACE_ON_EXCEPTION="${CA_STACKTRACE_ON_EXCEPTION:-false}"

function set_var() {
    local var="${1}"
    local val="${2}"

    sed -E \
        -e "s~['\"]${var}['\"],\s*['\"][^'\"]+['\"]~\"$var\", \"${val}\"~"
}
function set_bool() {
    local var="${1}"
    local val="${2}"

    sed -E \
        -e "s~['\"]${var}['\"],\s*['\"][^'\"]+['\"]~\"$var\", ${val}~"
}

mkdir -p /conf
cat ./providence/setup.php-dist \
    |  set_var   '__CA_DB_HOST__'            "${CA_DB_HOST}"          \
    |  set_var   '__CA_DB_USER__'            "${CA_DB_USER}"          \
    |  set_var   '__CA_DB_PASSWORD__'        "${CA_DB_PASSWORD}"      \
    |  set_var   '__CA_DB_DATABASE__'        "${CA_DB_DATABASE}"      \
    |  set_var   '__CA_APP_DISPLAY_NAME__'   "${CA_APP_DISPLAY_NAME}" \
    |  set_var   '__CA_ADMIN_EMAIL__'        "${CA_ADMIN_EMAIL}"      \
    |  set_var   '__CA_DEFAULT_LOCALE__'     "${CA_DEFAULT_LOCALE}"   \
    |  set_var   '__CA_APP_NAME__'           "${CA_APP_NAME}"         \
    |  set_var   '__CA_GOOGLE_MAPS_KEY__'    "${CA_GOOGLE_MAPS_KEY}"  \
    |  set_var   '__CA_CACHE_BACKEND__'      "${CA_CACHE_BACKEND}"    \
    |  set_bool  '__CA_QUEUE_ENABLED__'      "${CA_QUEUE_ENABLED}"    \
    |  set_bool  '__CA_USE_CLEAN_URLS__'     "${CA_USE_CLEAN_URLS}"   \
    |  set_bool  '__CA_ALLOW_INSTALLER_TO_OVERWRITE_EXISTING_INSTALLS__'  "${CA_ALLOW_INSTALLER_TO_OVERWRITE_EXISTING_INSTALLS}"  \
    |  set_bool  '__CA_STACKTRACE_ON_EXCEPTION__'  "${CA_STACKTRACE_ON_EXCEPTION}" \
    > ./providence/setup.php

if  [[ -z ${PHP_INI_DIR} ]]; then
    echo "Error: PHP_INI_DIR is not set" >&2
    exit 1
fi
mkdir -p "${PHP_INI_DIR}/conf.d"
cat > "${PHP_INI_DIR}/conf.d/01-conf.ini" <<EOF
[PHP]
; Set ot larger tan the largest filesize
upload_max_filesize = 2M
; Set to around the value of upload_max_filesize
post_max_size = 8M
; Increase if needed
memory_limit = 128M
; Enable this for setting things up, disable for production
display_errors = On
EOF

find ./providence/media -not -user www-data -exec chown www-data:www-data {} +

exec "apache2-foreground" "${@}"
