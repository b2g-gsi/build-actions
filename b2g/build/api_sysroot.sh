#!/bin/bash

export GONK_PATH=`pwd`
export GECKO_PATH=${GONK_PATH}/gecko

# Prepare the device-specific paths in the AOSP build files
case "${TARGET_ARCH}" in
    arm)
        ARCH_NAME="arm"
        ARCH_ABI="androideabi"
        ;;
    arm64)
        ARCH_NAME="aarch64"
        ARCH_ABI="android"
        TARGET_TRIPLE=$ARCH_NAME-linux-$ARCH_ABI
        BINSUFFIX=64
        ;;
    x86)
        ARCH_NAME="i686"
        ARCH_ABI="android"
        TARGET_TRIPLE=$ARCH_NAME-linux-$ARCH_ABI
        ;;
    x86_64)
        ARCH_NAME="x86"
        ARCH_ABI="android"
        BINSUFFIX=64
        ;;
    *)
        echo "Unsupported $TARGET_ARCH"
        exit 1
        ;;
esac

TARGET_TRIPLE=${TARGET_TRIPLE:-$TARGET_ARCH-linux-$ARCH_ABI}

if [ "$TARGET_ARCH_VARIANT" = "$TARGET_ARCH" ] ||
   [ "$TARGET_ARCH_VARIANT" = "generic" ]; then
TARGET_ARCH_VARIANT=""
else
TARGET_ARCH_VARIANT="_$TARGET_ARCH_VARIANT"
fi

if [ "$TARGET_CPU_VARIANT" = "$TARGET_ARCH" ] ||
   [ "$TARGET_CPU_VARIANT" = "generic" ]; then
TARGET_CPU_VARIANT=""
else
TARGET_CPU_VARIANT="_$TARGET_CPU_VARIANT"
fi

ARCH_FOLDER="${TARGET_ARCH}${TARGET_ARCH_VARIANT}${TARGET_CPU_VARIANT}"


# Package the sysroot
SYSROOT_PREBUILTS="prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/lib/gcc/x86_64-linux-android/4.9.x"

SYSROOT_INCLUDE_FOLDERS="frameworks/av/camera/include
frameworks/av/include
frameworks/av/media/libaudioclient/include
frameworks/av/media/libmedia/aidl
frameworks/av/media/libmedia/include
frameworks/av/media/libstagefright/foundation/include
frameworks/av/media/libstagefright/include
frameworks/av/media/mtp
frameworks/native/headers/media_plugin
frameworks/native/include/gui
frameworks/native/include/media/openmax
frameworks/native/libs/binder/include
frameworks/native/libs/gui/include
frameworks/native/libs/math/include
frameworks/native/libs/nativebase/include
frameworks/native/libs/nativewindow/include
frameworks/native/libs/ui/include
frameworks/native/opengl/include
hardware/interfaces/graphics/composer/2.1/utils/command-buffer/include
hardware/interfaces/graphics/composer/2.2/utils/command-buffer/include
hardware/interfaces/graphics/composer/2.3/utils/command-buffer/include
hardware/libhardware/include
hardware/libhardware_legacy/include
system/connectivity
system/core/base/include
system/core/libcutils/include
system/core/liblog/include
system/core/libprocessgroup/include
system/core/libsuspend/include
system/core/libsync/include
system/core/libsystem/include
system/core/libsysutils/include
system/core/libutils/include
system/libfmq/include
system/libhidl/base/include
system/libhidl/transport/include
system/libhidl/transport/token/1.0/utils/include
system/media/audio/include
system/media/camera/include
bionic/libc/kernel/uapi    
bionic/libc/kernel/uapi/asm-arm    
bionic/libc/kernel/android/scsi    
bionic/libc/kernel/android/uapi  
libnativehelper/include_deprecated
out/target/product/${GONK_PRODUCT_NAME}/obj
out/target/product/${GONK_PRODUCT_NAME}/system"

tar -c $SYSROOT_PREBUILTS $SYSROOT_LIBRARIES $SYSROOT_INCLUDE_FOLDERS --transform 's,^,api-sysroot/,S' | $GECKO_PATH/taskcluster/scripts/misc/zstdpy > "api-sysroot.tar.zst"
