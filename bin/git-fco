#!/bin/sh -eux

branch=$(git branch -r | cut -c3- | fzf)
git checkout -t "$branch"