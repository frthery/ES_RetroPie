#!/bin/bash

# MAIN
# no arguments error
if [ "$1" = "" ]; then
    echo "ERROR: no arguments found!"
    exit 1
fi

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -name)
            [ $VALUE = 'all' ] && opt_all=1
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

HOST_CC=x86_64-w64-mingw32 MAKEFLAGS=-j4 ./build_retropie.sh -b -name=$mod_id

exit 0
