#!/bin/bash
# Script sourced from https://www.petefreitag.com/item/897.cfm
#


max_iterations=13
wait_seconds=6
http_endpoint="http://127.0.0.1:7001/status"

iterations=0
while true
do
	((iterations++))
	echo "Attempt $iterations"
	sleep $wait_seconds

	http_code=$(curl --verbose -s -o /tmp/result.txt -w '%{http_code}' "$http_endpoint";)

	if [ "$http_code" -ge 200 -a "$http_code" -lt 400 ]; then
		echo "Server Up"
		break
	fi

	if [ "$iterations" -ge "$max_iterations" ]; then
		echo "Loop Timeout"
		exit 1
	fi
done

