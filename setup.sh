#!/usr/bin/env bash

PROVIDENCE_VERSION="1.7.14"

PROVIDENCE_URL="https://github.com/collectiveaccess/providence/archive/${PROVIDENCE_VERSION}.tar.gz"
PROVIDENCE_FILE="./ca/providence-${PROVIDENCE_VERSION}.tar.gz"

function dl_file() {
    local url="$2"
    local file="$1"
    if [[ ! -f ${file} ]]; then
        curl \
            --fail \
            -L \
            "${url}" \
            -o "$file"
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to download $file"
            exit 1
        fi
    fi
}

function query_password() {
    local name="${1}"
    local pass_file="${2}"
    if [[ ! -f $pass_file ]]; then
         read -s -p "Password for $name: " pword
         echo ""
         echo "$pword" > "$pass_file"
         chmod 0600 "$pass_file"
    fi
}

dl_file "$PROVIDENCE_FILE" "$PROVIDENCE_URL"

mkdir -p secrets
query_password 'db_pass' './secrets/db_pass.txt'
query_password 'db_root_pass' './secrets/db_root_pass.txt'

if [[ ! -f .env ]]; then
    cp ./envs/dev.sh .env
fi
