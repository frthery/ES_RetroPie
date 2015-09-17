#!/bin/bash

# MAIN
# no arguments error
if [ "$1" = "" ]; then
    echo "ERROR: no arguments found!"
    exit 1
fi

build_rpi=0
build_rpi2=0
mod_id=''

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            #usage
            exit
            ;;
        -rpi)
            build_rpi=1
            ;;
        -rpi2)
            build_rpi2=1
            ;;
        -name)
            mod_id=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ $build_rpi2 = 1 ]; then
    echo '--- BUILD: RPI2 Module: ['$mod_id'] ---'
    FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat MAKEFLAGS=-j4 ./build_retropie.sh -b -name=$mod_id
else
    echo '--- BUILD: RPI Module: ['$mod_id'] ---'
    ./build_retropie.sh -b -name=$mod_id
fi

exit 0
