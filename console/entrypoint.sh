#!/usr/bin/env bash
set -e

if [[ -z "${UID}" ]]; then
    echo "Required UID environment variable"
    exit 1
fi

if [[ -z "${GID}" ]]; then
    echo "Required GID environment variable"
    exit 1
fi


groupmod -g ${GID} hostuser
usermod -u ${UID} hostuser  > /dev/null 2>&1

exec runuser -u hostuser -- "$@"
