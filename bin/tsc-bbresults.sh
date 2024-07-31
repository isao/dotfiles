#!/bin/bash -eu

tsc --noEmit --pretty false "$@" \
    | bbresults -p '^(?P<file>.+?)\((?P<line>\d+),(?P<col>\d+)\): (?P<type>\w+) (?P<msg>.+)'
