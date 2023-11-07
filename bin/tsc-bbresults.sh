#!/bin/bash -eu

pattern='^(?P<file>\w.+?)\((?P<line>\d+),(?P<col>\d+)\): (?P<type>\w+) (?P<msg>.+(?:\n +[^\n]+)*)'

tsc --noEmit --pretty false $* | bbresults -p '$pattern'
