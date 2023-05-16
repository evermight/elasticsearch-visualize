#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

#type (Required, string) Valid options include visualization, dashboard, search, index-pattern, config. 
stype='visualization'
curl -X GET -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/saved_objects/_find?type=visualization" -H "kbn-xsrf: true"
