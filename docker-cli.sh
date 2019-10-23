#!/usr/bin/env bash

export uid=$(id -u)
export gid=$(id -g)
export ip=$(ip addr show docker0 | grep inet | awk '{print $2}' | head -n 1 | awk -F "/" '{print $1}')

declare -a known_commands=("build" "up" "down" "console")

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1; i < $#; i++)) {
        if [[ "${!i}" == "${value}" ]]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

if [[ $(contains "${known_commands[@]}" "$1") == "n" ]]
  then
    echo "Command is not supplied. Usage: docker-cli.sh [build|up|down|console]"
    exit
fi

command=$1

if [[ "$command" == "build" ]]; then
    docker build -t php7.2-apache-v8js ./main/
    docker build -t php7.2-apache-v8js-console ./console/
fi

if [[ "$command" == "up" ]]; then
    docker-compose up -d

    echo "IP для xdebug: ${ip}"
fi

if [[ "$command" == "down" ]]; then
    docker-compose down
fi

if [[ "$command" == "console" ]]; then
    docker-compose run console bash
fi
