#!/bin/bash

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
      "id": "73bc811f-b382-4fd8-81d1-3f24c8309ad5"
    }
  ]
}' > kibana/dashboard/management.ndjson
