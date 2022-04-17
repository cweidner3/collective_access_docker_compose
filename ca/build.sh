#!/usr/bin/env bash

REPO="${1}"
SUFFIX="${2}"

PROVIDENCE_VERSION="1.7.14"
DATE=$(date +%Y%m%d)

if [[ -z ${REPO} ]]; then
    LONG_TAG="collective-access:${PROVIDENCE_VERSION}-${DATE}"
    SHORT_TAG="collective-access:${PROVIDENCE_VERSION}"
else
    LONG_TAG="${REPO}/collective-access:${PROVIDENCE_VERSION}-${DATE}"
    SHORT_TAG="${REPO}/collective-access:${PROVIDENCE_VERSION}"
fi
if [[ -n ${SUFFIX} ]]; then
    LONG_TAG="${LONG_TAG}-${SUFFIX}"
    SHORT_TAG="${SHORT_TAG}-${SUFFIX}"
fi

echo "Using tags"
echo "  $LONG_TAG"
echo "  $SHORT_TAG"
read -p 'Continue? [yn]' useropt
if [[ $useropt != y ]]; then
    exit 1
fi

docker build -t "${LONG_TAG}" .
docker tag "${LONG_TAG}" "${SHORT_TAG}"
