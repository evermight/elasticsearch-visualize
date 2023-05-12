#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_work"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_work"
