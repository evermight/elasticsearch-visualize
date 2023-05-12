#!/bin/bash

while getopts d: option
do
    case "${option}" in
        d) data_table=${OPTARG};;
    esac
done

if [ -z $data_table ]; then
  echo '-d for data table required'
  exit
fi

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${data_table}"
curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${data_table}/_mapping" \
-H "Content-Type: application/json" \
-d @$PROJECTPATH/mapping/$data_table.json

if [ -f $PROJECTPATH/pipeline/$data_table.json ]; then
  pipeline=`cat ${PROJECTPATH}/pipeline/${data_table}.json`
  pipeline="${pipeline//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_ingest/pipeline/${INDEXNAME}_{$data_table}" \
  -H "Content-Type: application/json" \
  -d "$pipeline"
fi

logstashconf=`cat ${PROJECTPATH}/logstash/$data_table.conf`
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

if [ -f $PROJECTPATH/kibana/data-view/$data_table.json ]; then
#  pipeline=`cat ${PROJECTPATH}/pipeline/${data_table}.json`
#  pipeline="${pipeline//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
#  curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/saved_objects/_import" \
  curl -X POST -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${KIBANAHOST}/api/data_views/data_view" \
  -H "kbn-xsrf: reporting" \
  -H "Content-Type: application/json" \
  -d @$PROJECTPATH/kibana/data-view/$data_table.json
#  -d "$pipeline"
fi
