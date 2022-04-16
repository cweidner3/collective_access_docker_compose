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

dl_file "$PROVIDENCE_FILE" "$PROVIDENCE_URL"
