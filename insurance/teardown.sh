#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_user"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_project"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_epic"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_story"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_time"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_task"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_work"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_user"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_project"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_epic"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_story"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_task"
#curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_ingest/pipeline/project"

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_work"
