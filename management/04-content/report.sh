#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_report"
curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_report/_mapping" \
-H "Content-Type: application/json" \
-d @$PROJECTPATH/mapping/report.json

allfacts=("report-epic" "report-story" "report-task" "report-time")

for data_table in ${allfacts[@]}; do
if [ -f $PROJECTPATH/pipeline/$data_table.json ]; then
  pipeline=`cat ${PROJECTPATH}/pipeline/${data_table}.json`
  pipeline="${pipeline//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_{$data_table}" \
  -H "Content-Type: application/json" \
  -d "$pipeline"
fi
done

echo '' > $PROJECTPATH/logstash/report.conf;
for data_table in ${allfacts[@]}; do
  cat $PROJECTPATH/logstash/$data_table.conf >> $PROJECTPATH/logstash/report.conf
done

logstashconf=`cat ${PROJECTPATH}/logstash/report.conf`
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

#dataview=`cat ${PROJECTPATH}/kibana/data-view/report.json`
#dataview="${dataview//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
#curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view" \
#-H "kbn-xsrf: reporting" \
#-H "Content-Type: application/json" \
#-d "$dataview"
