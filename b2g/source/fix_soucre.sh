#!/bin/bash
set -e 
        ####patcher         
        if [ -d "${work}/B2G/patcher" ]; then
          echo apply patch
          cd ${work}/B2G
          ./patcher/patcher.sh
        fi
        
        ####fix 10.15 issue
        cd ${work}/B2G
        /usr/bin/sed -i '' '14d'  system/sepolicy/tests/Android.bp
        /usr/bin/sed -i '' '65i\'$'\n\"10\.15\"\,\n' build/soong/cc/config/x86_darwin_host.go
      
        ####gecko split
        cd ${work}
        cp B2G/gonk-misc/Android.mk ./Android.mk.gonk.old
        
        cd ~
        git clone https://github.com/OnePlus-onyx/build-CI -b b2g
        sudo chmod +x ~/build-CI/patch-b2g-aosp.sh
        ~/build-CI/patch-b2g-aosp.sh
        
        cd ${work}
        cp B2G/gonk-misc/Android.mk ./Android.mk.gonk.patch
        
        ####api-daemon split
        cd ${work}/B2G/gonk-misc
        if [ -d "${work}/B2G/gonk-misc/api-daemon" ];then
          echo api-daemon patch
          sudo rm -r ${work}/B2G/gonk-misc/api-daemon
        fi
        git clone https://github.com/ittat/api-daemon -b ittat-patch-without-api-daemon
        
        
        ####
        cd ${work}/B2G
        sudo rm -rf .repo
