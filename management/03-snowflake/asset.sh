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

if [ -f $PROJECTPATH/policy/$data_table.json ]; then
  policy=`cat ${PROJECTPATH}/policy/${data_table}.json`
  policy="${policy//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_{$data_table}_policy" \
  -H "Content-Type: application/json" \
  -d "$policy"

  sleep 10
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_{$data_table}_policy/_execute"
fi
