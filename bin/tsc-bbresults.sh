#!/bin/bash -eu

pattern='^(?P<file>\w.+)\((?P<line>\d+),(?P<col>\d+)\): (?P<type>\w+) (?P<msg>.+(\n\s+.+)*)'

tsc --noEmit $* | bbresults -p "$pattern"
