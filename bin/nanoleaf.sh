#!/bin/bash -e

# https://documenter.getpostman.com/view/1559645/RW1gEcCH#cbbfadae-fa4a-4cdf-933e-1e9d8fbf40d0

# Get IP from router.
IP=${IP:-"192.168.7.157"}

# On the Nanoleaf controller, hold the on-off button for 5-7 seconds until the
# LED starts flashing in a pattern. Then:
#    curl -X POST http:/$IP:16021/api/v1/new
TOKEN=${TOKEN:-"in8SPOGUk3Zj3iFfUCrFkKfK4wH6O3lz"}

state-on() {
    curl --silent --location \
        --request PUT "http://$IP:16021/api/v1/$TOKEN/state" \
        --header 'Content-Type: application/json' \
        --data-raw "{\"on\": {\"value\": $1}}"
}

brightness() {
    if [[ -z $1 ]]
    then
        curl --silent --location \
            --request GET "http://$IP:16021/api/v1/$TOKEN/state/brightness"
    else
        curl --silent --location \
            --request PUT "http://$IP:16021/api/v1/$TOKEN/state" \
            --data-raw "{\"brightness\": {\"value\":$1}}"
    fi
}


case $1 in
    'on' )
        state-on true
        ;;

    'off' )
        state-on false
        ;;

    'brightness' )
        brightness "$2"
        ;;

    'info' )
        curl --silent --location --request GET "http://$IP:16021/api/v1/$TOKEN/"
        ;;

    * )
        echo "Usage: $(basename "$0") on|off|info|brightness [0-100]" >&2
        ;;
esac
