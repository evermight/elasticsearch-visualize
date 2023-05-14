#!/bin/bash

while getopts d: option
do
    case "${option}" in
        d) data_table=${OPTARG};;
    esac
done

if [ -z $data_table ]; then
  echo '-d for data table required'
  exit
fi

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

if [ -f $PROJECTPATH/kibana/data-view/$data_table.json ]; then
  dataview=`cat ${PROJECTPATH}/kibana/data-view/${data_table}.json`
  dataview="${dataview//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
  curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view" \
  -H "kbn-xsrf: reporting" \
  -H "Content-Type: application/json" \
  -d "$dataview"
fi
