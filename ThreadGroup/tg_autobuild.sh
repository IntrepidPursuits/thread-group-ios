#!/usr/bin

echo "Building Arm64"
return
scons TARGET_OS=ios TARGET_ARCH=arm64 SYS_VERSION=8.3

echo "Building Armv7"
scons TARGET_OS=ios TARGET_ARCH=armv7 SYS_VERSION=8.3

echo "Building Armv7s"
scons TARGET_OS=ios TARGET_ARCH=armv7s SYS_VERSION=8.3

echo "Building i386"
scons TARGET_OS=ios TARGET_ARCH=i386 SYS_VERSION=8.3

echo "Building Universal Libraries"
lipo -create "arm64/release/libcoap.a" "armv7/release/libcoap.a" "armv7s/release/libcoap.a" "i386/release/libcoap.a" -output "libcoap.a"
lipo -create "arm64/release/liboctbstack.a" "armv7/release/liboctbstack.a" "armv7s/release/liboctbstack.a" "i386/release/liboctbstack.a" -output "liboctbstack.a"
lipo -create "arm64/release/libconnectivity_abstraction.a" "armv7/release/libconnectivity_abstraction.a" "armv7s/release/libconnectivity_abstraction.a" "i386/release/libconnectivity_abstraction.a" -output "libconnectivity_abstraction.a"

echo "Finished"