#!/bin/bash

git diff --name-only |\
awk '{ FS="/"}; /^(aws|env)/{ printf "%s/%s\n",$1,$2 }' |\
uniq |\
wc -l |\
awk '{$1=$1;print}'