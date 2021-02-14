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
out/target/product/${GONK_PRODUCT_NAME}"

# Copy the system libraries to the sysroot
LIBRARIES="out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.gnss@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.gnss@1.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.gnss@2.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.gnss.visibility_control@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.graphics.composer@2.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.graphics.composer@2.2.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.graphics.composer@2.3.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.power@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.radio@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.radio@1.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.sensors@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.vibrator@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi@1.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi@1.2.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi@1.3.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi.hostapd@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi.hostapd@1.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi.supplicant@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi.supplicant@1.1.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.hardware.wifi.supplicant@1.2.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/android.system.wifi.keystore@1.0.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/binder_b2g_connectivity_interface-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/binder_b2g_system_interface-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/binder_b2g_telephony_interface-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/binder_b2g_remotesimunlock_interface-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/dnsresolver_aidl_interface-V2-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libaudioclient.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libbase.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libbinder.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libcamera_client.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libc++.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libcutils.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libfmq.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libgui.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhardware_legacy.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhardware.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhidlbase.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhidlmemory.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhidltransport.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libhwbinder.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libmedia_omx.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libmedia.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libmtp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libstagefright_foundation.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libstagefright_omx.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libstagefright.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libsuspend.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libsync.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libsysutils.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libui.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libutils.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libvold_binder_shared.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/libwificond_ipc_shared.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/netd_aidl_interface-V2-cpp.so
out/target/product/${GONK_PRODUCT_NAME}/system/lib${BINSUFFIX}/netd_event_listener_interface-V1-cpp.so"

tar -c $SYSROOT_PREBUILTS $SYSROOT_LIBRARIES $SYSROOT_INCLUDE_FOLDERS $LIBRARIES --transform 's,^,api-sysroot/,S' | $GECKO_PATH/taskcluster/scripts/misc/zstdpy > "api-sysroot.tar.zst"
