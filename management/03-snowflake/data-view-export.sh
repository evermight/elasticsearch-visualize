#!/bin/bash

while getopts i: option
do
    case "${option}" in
        i) dvid=${OPTARG};;
    esac
done

if [ -z $dvid ]; then
  echo '-i for data view id required'
  exit
fi

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi
curl -X GET -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view/${dvid}" \
  -H "kbn-xsrf: reporting"
