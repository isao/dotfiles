#!/bin/bash -eux

cd "$(git rev-parse --show-toplevel)/Web" || {
    echo "Run this in the mediafirst ReachClient repo."
    exit 1
}

args=${@:-''}
pattern='(?P<file>.+?)[(](?P<line>\d+),((?P<col>\d+))[)]: (?P<type>error \w+): (?P<msg>.*)$'

node node_modules/typescript/bin/tsc $args | \
    bbresults -p $pattern
