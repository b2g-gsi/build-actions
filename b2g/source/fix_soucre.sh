#!/bin/bash
set -e 
        ####patcher 
        #todo
        echo 123
        cd ${work}/B2G
        sudo rm -r patcher
        git clone https://github.com/ittat/patcher -b test
        
        if [ -d "${work}/B2G/patcher" ]; then
          echo apply patch
          chmod +x ${work}/B2G/patcher/patcher.sh
          cd ${work}/B2G
          ./patcher/patcher.sh
        fi
        
        chmod +x ${work}/B2G/patcher/patch_reset.sh
        cd ${work}/B2G
        echo 1234
        ./patcher/patch_reset.sh
        
        ####fix 10.15 issue
        cd ${work}/B2G
        /usr/bin/sed -i '' '14d'  system/sepolicy/tests/Android.bp
        /usr/bin/sed -i '' '65i\'$'\n\"10\.15\"\,\n' build/soong/cc/config/x86_darwin_host.go
      
        ####gecko split
        #cd ${work}
        #cp B2G/gonk-misc/Android.mk ./Android.mk.gonk.old
        
        #cd ~
        #git clone https://github.com/OnePlus-onyx/build-CI -b b2g
        #sudo chmod +x ~/build-CI/patch-b2g-aosp.sh
        #~/build-CI/patch-b2g-aosp.sh
        
        #cd ${work}
        #cp B2G/gonk-misc/Android.mk ./Android.mk.gonk.patch
        
        ####api-daemon split
        #cd ${work}/B2G/gonk-misc
        #if [ -d "${work}/B2G/gonk-misc/api-daemon" ];then
        #  echo api-daemon patch
        #  sudo rm -r ${work}/B2G/gonk-misc/api-daemon
        #fi
        #git clone https://github.com/ittat/api-daemon -b ittat-patch-without-api-daemon
        
        ####onyx
        #if [ ${device_name} == "onyx" ]; then
        #  echo replace onyx fake kernel
        #  cd ${work}/B2G/kernel/oneplus
        #  sudo rm -r onyx
        #  git clone https://github.com/OnePlus-onyx/kernel_oneplus_onyx -b ci --depth=1
        #  mv kernel_oneplus_onyx onyx
        #fi
        
        
        ####
        cd ${work}/B2G
        sudo rm -rf .repo
