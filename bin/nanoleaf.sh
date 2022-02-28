#!/bin/bash -e

# https://documenter.getpostman.com/view/1559645/RW1gEcCH#cbbfadae-fa4a-4cdf-933e-1e9d8fbf40d0

# Get IP from router.
IP=${IP:-"192.168.7.157"}

# On the Nanoleaf controller, hold the on-off button for 5-7 seconds until the
# LED starts flashing in a pattern. Then:
#
#    curl -X POST http:/$IP:16021/api/v1/new
#
TOKEN=${TOKEN:-$(security find-generic-password -w -s 'nanoleaf-api-token' -a 'shapes-2021')}

# All commands start with this.
baseUrl="http://$IP:16021/api/v1/$TOKEN"

state-on() {
    curl --silent --location \
        --request PUT "$baseUrl/state" \
        --header 'Content-Type: application/json' \
        --data-raw "{\"on\": {\"value\": $1}}"
}

brightness() {
    if [[ -z $1 ]]
    then
        curl --silent --location "$baseUrl/state/brightness"
    else
        curl --silent --location \
            --request PUT "$baseUrl/state" \
            --data-raw "{\"brightness\": {\"value\":$1}}"
    fi
}

effect-list() {
    curl --silent --location "$baseUrl/effects/effectsList"
}

effect-select() {
    curl --silent --location \
        --request PUT "$baseUrl/effects" \
        --data-raw "{\"select\": \"$1\"}"
}

effect-pick() {
    effect-select "$(effect-list | fx '.reduce((o,x) => o.concat(`\n${x}`))' | fzf)"
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
        curl --silent --location "$baseUrl/"
        ;;

    'effect-list' | 'list' )
        effect-list "$2"
        ;;

    'effect-select' | 'select' )
        effect-select "$2"
        ;;

    'effect-pick' | 'pick' )
        effect-pick "$2"
        ;;

    * )
        echo "Usage: $(basename "$0") on|off|info|list" >&2
        echo "Usage: $(basename "$0") brightness [0-100]" >&2
        echo "Usage: $(basename "$0") select '<effect name from list>'" >&2
        echo "Usage: $(basename "$0") pick    # requires fx and fzf" >&2
        ;;
esac
