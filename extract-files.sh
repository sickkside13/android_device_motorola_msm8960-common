#!/bin/sh

if [ $# -eq 1 ]; then
    COPY_FROM=$1
    test ! -d "$COPY_FROM" && echo error reading dir "$COPY_FROM" && exit 1
fi

test -z "$DEVICE" && echo device not set && exit 2
test -z "$VENDOR" && echo vendor not set && exit 2
test -z "$VENDORDEVICEDIR" && VENDORDEVICEDIR=$DEVICE
export VENDORDEVICEDIR

BASE=../../../vendor/$VENDOR/$VENDORDEVICEDIR/proprietary
rm -rf $BASE/*
rm -rf $BASE/../packages 2> /dev/null

for FILE in `egrep -v '(^#|^$)' ../$DEVICE/device-proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    if [ "$COPY_FROM" = "" ]; then
        adb pull /system/$FILE $BASE/$FILE
    else
        cp -p "$COPY_FROM/$FILE" $BASE/$FILE
    fi
done

for FILE in `egrep -v '(^#|^$)' ../msm8960-common/proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    if [ "$COPY_FROM" = "" ]; then
        adb pull /system/$FILE $BASE/$FILE
    else
        cp -p "$COPY_FROM/$FILE" $BASE/$FILE
    fi
done

    if [ -d $BASE/app ]; then
        mkdir -p ${BASE}/../packages
        mv $BASE/app/* ${BASE}/../packages/
    fi
rmdir ${BASE}/app 2> /dev/null

BASE=../../../vendor/$VENDOR/msm8960-common/proprietary
rm -rf $BASE/*
for FILE in `egrep -v '(^#|^$)' ../msm8960-common/common-proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    if [ "$COPY_FROM" = "" ]; then
        adb pull /system/$FILE $BASE/$FILE
    else
        cp -p "$COPY_FROM/$FILE" $BASE/$FILE
    fi
done

ADRENO=../../../vendor/$VENDOR/msm8960-common/Adreno200-AU_LINUX_ANDROID_JB_VANILLA_04.02.02.060.053
if [ ! -d $ADRENO ]; then
    mkdir -p $ADRENO
fi
MAKO=../../../vendor/$VENDOR/msm8960-common/mako/lib
if [ ! -d $MAKO ]; then
    mkdir -p $MAKO
fi
echo "Don't forget to add the adreno blobs from"
echo "https://developer.qualcomm.com/download/Adreno200-AU_LINUX_ANDROID_JB_VANILLA_04.02.02.060.053.zip"
echo "and mako blobs from https://dl.google.com/dl/android/aosp/qcom-mako-jdq39-c89670ca.tgz"
echo "to vendor/motorola/msm8960-common"
../msm8960-common/setup-makefiles.sh