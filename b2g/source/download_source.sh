
        df -h
        cd ~
        rclone copy itd:ci/${remotepath}/${sourceimage}.dmg.sparseimage.zst ./
        zstd --decompress  ${sourceimage}.dmg.sparseimage.zst
        sudo rm -r ./${sourceimage}.dmg.sparseimage.zst
        rclone copy itd:ci/${remotepath}/${outimage}.dmg.sparseimage ./
        
        #####mount
        hdiutil attach /Users/runner/${sourceimage}.dmg.sparseimage -mountpoint ${work}
        if [ -d "${work}/B2G/out" ];then
          sudo rm -r ${work}/B2G/out
        fi
        hdiutil attach /Users/runner/${outimage}.dmg.sparseimage -mountpoint  ${out_work}
        sudo ln -s  ${out_path}  ${work}/B2G/out
        ls -al ${out_work}
        df -h
