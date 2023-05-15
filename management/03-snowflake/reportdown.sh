#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_work"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_timesheet"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_report-story"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_work"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_timesheet"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_report-story"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view/23232963-fff0-4037-badf-3e355cf42ec0" -H "kbn-xsrf: reporting"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view/26b1c9b2-d3b2-4db3-84af-cf10ba93f8c6" -H "kbn-xsrf: reporting"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view/c00b8f8b-f5a6-487a-986a-7166a8cbb122" -H "kbn-xsrf: reporting"
