#!/bin/bash

echo "$1=$(jq -r ."$1" ./manifest/versions.json)" 
