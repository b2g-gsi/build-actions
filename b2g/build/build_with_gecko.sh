#!/bin/bash
set -e 

        df -h
        ####
        cd ${work}
        mkdir pre-gecko
        cd pre-gecko
        rclone copy itd:ci/${remotepath}/${gecko_version} ./
          
        ####  build
        export CCACHE_DIR=~/.ccache
        /usr/local/bin/ccache  -M 20G
        /usr/local/bin/ccache -s
        export USE_CCACHE=1
        cd ${work}/B2G
        export DISABLE_SOURCES_XML=true
        export USE_PREBUILT_B2G=1
        export OUT_DIR_COMMON_BASE=${out_work}
        export PREFERRED_B2G="${work}/pre-gecko/${gecko_version}"
        
        if [ ${kernel} == "true" ]; then
                ./build.sh -j16 bootimage
        else
        
        ./build.sh -j16 systemimage

        if [ "$device_name" == "onyx" ]; then
                #./build.sh -j16 dist DIST_DIR=dist_output
                #./build.sh -j16 systemimage
                #./build/tools/releasetools/ota_from_target_files dist_output/b2g_onyx-target_files-eng.runner.zip onyx_b2g_ota_update.zip
        else
                ./build.sh -j16 vndk-test-sepolicy
        fi
