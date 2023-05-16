#!/bin/bash

while getopts i: option
do
    case "${option}" in
        i) dvid=${OPTARG};;
    esac
done

if [ -z $dvid ]; then
  echo '-i for dashboard id required'
  exit
fi


source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/saved_objects/_export" -H "kbn-xsrf: true"  -H 'Content-Type: application/json' \
  -d '{
  "objects": [
    {
      "type": "dashboard",
      "id": "'$dvid'"
    }
  ]
}'
