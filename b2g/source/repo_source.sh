#!/bin/bash
set -e 
        df -h
        cd ${work}
        git clone ${b2g_source} -b ${b2g_branch}  --depth=1 
        cd ./B2G
        echo Download ...
        REPO_INIT_FLAGS="--depth=1" REPO_SYNC_FLAGS=" -j128 --force-sync --current-branch --no-tags --no-clone-bundle --optimized-fetch --prune" ./config.sh ${device_name}
        df -h
