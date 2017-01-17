#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
OUTPUT="$(speedtest-cli --simple | awk -F: '{ print $2 }' | awk '{sub(/^[ \t]+/, ""); print}')"

PING="$(echo "${OUTPUT}" | awk ' NR==1' | cut -d " " -f1)"
DOWNLOAD="$(echo "${OUTPUT}" | awk ' NR==2' | cut -d " " -f1)"
UPLOAD="$(echo "${OUTPUT}" | awk ' NR==3' | cut -d " " -f1)"



currenttime=$(date +%s)
curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
         [{\"metric\":\"speedtest.ping\",
          \"points\":[[$currenttime, $PING]],
          \"type\":\"gauge\",
          \"host\":\"hostname\",
          \"tags\":[\"environment:speedtest\"]}
        ]
    }" \
'https://app.datadoghq.com/api/v1/series?api_key=APIKEY'

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
         [{\"metric\":\"speedtest.download\",
          \"points\":[[$currenttime, $DOWNLOAD]],
          \"type\":\"gauge\",
          \"host\":\"hostname\",
          \"tags\":[\"environment:speedtest\"]}
        ]
    }" \
'https://app.datadoghq.com/api/v1/series?api_key=APIKEY'

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
         [{\"metric\":\"speedtest.upload\",
          \"points\":[[$currenttime, $UPLOAD]],
          \"type\":\"gauge\",
          \"host\":\"hostname\",
          \"tags\":[\"environment:speedtest\"]}
        ]
    }" \
'https://app.datadoghq.com/api/v1/series?api_key=APIKEY'
