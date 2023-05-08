#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/$INDEXNAME"
curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/$INDEXNAME/_mapping" \
-H "Content-Type: application/json" \
-d @$PROJECTPATH/mapping/project.json

curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_ingest/pipeline/project" \
-H "Content-Type: application/json" \
-d @$PROJECTPATH/pipeline/project.json

logstashconf=`cat ${PROJECTPATH}/logstash/logstash.conf`
logstashconf="${logstashconf//\#\#JDBCJARFILE\#\#/"$JDBCJARFILE"}"
logstashconf="${logstashconf//\#\#JDBCCONNSTRING\#\#/"$JDBCCONNSTRING"}"
logstashconf="${logstashconf//\#\#JDBCUSER\#\#/"$JDBCUSER"}"
logstashconf="${logstashconf//\#\#JDBCPASS\#\#/"$JDBCPASS"}"
logstashconf="${logstashconf//\#\#ELASTICHOST\#\#/"$ELASTICHOST"}"
logstashconf="${logstashconf//\#\#ELASTICSSL\#\#/"$ELASTICSSL"}"
logstashconf="${logstashconf//\#\#ELASTICUSER\#\#/"$ELASTICUSER"}"
logstashconf="${logstashconf//\#\#ELASTICPASS\#\#/"$ELASTICPASS"}"
logstashconf="${logstashconf//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
/usr/share/logstash/bin/logstash -e "$logstashconf"

#curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_enrich/policy/zip_geo_policy" \
#-H "Content-Type: application/json" \
#-d @$PROJECTPATH/policy/zip_geo.json

#sleep 30
#curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_enrich/policy/zip_geo_policy/_execute"


