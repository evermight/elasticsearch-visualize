#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi
allfacts=("user" "project" "epic" "story" "task" "time")
for facttable in ${allfacts[@]}; do
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${facttable}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${facttable}/_mapping" \
  -H "Content-Type: application/json" \
  -d @$PROJECTPATH/mapping/$facttable.json
done
cat $PROJECTPATH/logstash/user.conf \
$PROJECTPATH/logstash/project.conf \
$PROJECTPATH/logstash/epic.conf \
$PROJECTPATH/logstash/story.conf \
$PROJECTPATH/logstash/task.conf \
$PROJECTPATH/logstash/time.conf \
> $PROJECTPATH/logstash/all.conf;

logstashconf=`cat ${PROJECTPATH}/logstash/all.conf`
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

rm -f $PROJECTPATH/logstash/all.conf

#curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_enrich/policy/zip_geo_policy" \
#-H "Content-Type: application/json" \
#-d @$PROJECTPATH/policy/zip_geo.json

#sleep 30
#curl -X PUT -u $ELASTICUSER:$ELASTICPASS "$hostprotocol://$ELASTICHOST/_enrich/policy/zip_geo_policy/_execute"


