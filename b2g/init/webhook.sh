#!/bin/bash
set -e

curl -H "Authorization: token ${GIT_ACCESS_TOKEN}"   --request POST   --data '{"event_type": "'$1'","client_payload": {"image":"'${image}'", "gecko_version":"'${gecko_version}'", "device_name":"'${device_name}'","device_arch":"'${device_arch}'"}}' ${repo_dispatches}
