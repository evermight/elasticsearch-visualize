#!/bin/bash

source ./.env

hostprotocol="http"
if [ "$ELASTICSSL" = "true" ]; then
  hostprotocol="https"
fi

allfacts=("user" "project" "epic" "story" "task" "time")
for data_table in ${allfacts[@]}; do
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${data_table}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/${INDEXNAME}_${data_table}/_mapping" \
  -H "Content-Type: application/json" \
  -d @$PROJECTPATH/mapping/$data_table.json
done

echo '' > $PROJECTPATH/logstash/all.conf;
for data_table in ${allfacts[@]}; do
  cat $PROJECTPATH/logstash/$data_table.conf >> $PROJECTPATH/logstash/all.conf
done

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

for data_table in ${allfacts[@]}; do
if [ -f $PROJECTPATH/policy/$data_table.json ]; then
  policy=`cat ${PROJECTPATH}/policy/${data_table}.json`
  policy="${policy//\#\#INDEXNAME\#\#/"$INDEXNAME"}"
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_{$data_table}" \
  -H "Content-Type: application/json" \
  -d "$policy"

  sleep 10
  curl -X PUT -u $ELASTICUSER:$ELASTICPASS "${hostprotocol}://${ELASTICHOST}/_enrich/policy/${INDEXNAME}_{$data_table}/_execute"
fi
done
