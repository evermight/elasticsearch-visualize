#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/saved_objects/_import?createNewCopies=true" -H "kbn-xsrf: true" --form file=@./kibana/dashboard/rainerdata.ndjson
