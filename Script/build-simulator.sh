#!/bin/zsh

LIBSSL_TAG=$1

set -e

cd $(dirname $0)/..
if [ ! -f .root ]; then
    echo "[*] malformated project structure"
    exit 1
fi

mkdir -p "build"
pushd "build" > /dev/null
echo "[*] prepare source code..."
git clone https://github.com/openssl/openssl openssl || true
pushd openssl > /dev/null
echo "[*] cleaning..."
git clean -fdx > /dev/null
git reset --hard > /dev/null
git checkout "$LIBSSL_TAG"

SOURCE_DIR=$(pwd)
echo "[*] source dir: $SOURCE_DIR"
popd > /dev/null
popd > /dev/null

DEST_PREFIX=$(pwd)/build/dest

# SOURCE_DIR=$1 SDK_PLATFORM=$2 PLATFORM=$3 EFFECTIVE_PLATFORM_NAME=$4 ARCHS=$5 MIN_VERSION=$6

# EFFECTIVE_PLATFORM_NAME Note:
#   this parameter is not used as a compiler flag
#   but for our script to distinguish between different platforms
#   where we may add CFLAG as Xcode does

./Script/build-openssl-lib.sh $SOURCE_DIR "iphonesimulator" "iPhoneSimulator" "" "arm64" "11.0" "$DEST_PREFIX/iphonesimulator_arm64"
./Script/build-openssl-lib.sh $SOURCE_DIR "iphonesimulator" "iPhoneSimulator" "" "x86_64" "11.0" "$DEST_PREFIX/iphonesimulator_x86"
