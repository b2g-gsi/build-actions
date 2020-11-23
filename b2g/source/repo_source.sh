
        df -h
        cd ${work}
        git clone https://github.com/ittat/B2G -b ittat-patch-gsi  --depth=1 
        cd ./B2G
        echo Download ...
        REPO_INIT_FLAGS="--depth=1" REPO_SYNC_FLAGS=" -j128 --force-sync --current-branch --no-tags --no-clone-bundle --optimized-fetch --prune" ./config.sh ${device_name}
        df -h
