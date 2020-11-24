#!/bin/bash
set -e

curl -H "Authorization: token ${GIT_ACCESS_TOKEN}"   --request POST   --data '{"event_type": "'$1'","client_payload": {"device_name":"'${device_name}'", "gecko_version":"'${gecko_version}'", "device_arch":"'${device_arch}'", "repo_dispatches":"'${repo_dispatches}'", "b2g_source":"'${b2g_source}'", "b2g_branch":"'${b2g_branch}'"}}'  ${repo_dispatches}
