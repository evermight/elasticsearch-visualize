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

curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_user_policy"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_project_policy"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_epic_policy"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_story_policy"
curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_task_policy"
#curl -X DELETE -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_ingest/pipeline/project"
