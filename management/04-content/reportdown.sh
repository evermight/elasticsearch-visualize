#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_report"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_report-task"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_report-time"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_report-story"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_report-epic"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view/30be2d2d-dff1-4ab1-88c8-b0db199c3e62" -H "kbn-xsrf: reporting"
