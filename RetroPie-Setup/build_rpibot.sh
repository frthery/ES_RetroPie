#!/bin/bash

function binaries() {
   local system=$1
   local outputbin="$outputdir/$system"
   local outputzip=$2

   ./build_retropie.sh -binary=$system -name=all
   [ ! -d $outputbin/output ] && mkdir $outputbin/output
   ls ${outputbin}/*.tar.gz | xargs -i tar -xzf {} -C ${outputbin}/output
   [ ! -d $outputbin/binaries ] && mkdir $outputbin/binaries
   find ${outputbin}/output -name \*.so | xargs -i cp {} $outputbin/binaries

   ./build_retropie.sh -binary=$system -name=retroarch

   zip ${outputzip} build_retropie.log $outputbin/retroarch.tar.gz -j $outputbin/binaries/*.so
}

build='none'
binary='none'
os='jessie'

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            #usage
            exit
            ;;
        -binary-all | -binary-rpi1 | -binary-rpi2 | -binary-rpi3)
            binary=$PARAM
            [ "$VALUE" != "" ] && os=$VALUE
            ;;
        -binary-all)
            binary=1
            [ "$VALUE" != "" ] && os=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

echo '--- [START] [RPIBOT] ---'
pushd "/home/pi/RetroPie-Setup"

now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now

#git reset --hard HEAD
#git pull

#./build_retropie.sh -u

if [[ "$binary" =~ "-binary" ]]; then
    if [ "$binary" = "-binary-all" ] || [ "$binary" = "-binary-rpi1" ]; then
       echo "--- [WGET:BINARIES] [RPI1] [$os] ---"
       outputzip=$outputdir/cores-retropie-rpi1-$os-$now.zip
       binaries $os'/rpi1' $outputzip
    fi

    if [ "$binary" = "-binary-all" ] || [ "$binary" = "-binary-rpi2" ]; then
       echo "--- [WGET:BINARIES] [RPI2] [$os] ---"
       outputzip=$outputdir/cores-retropie-rpi2-$os-$now.zip
       binaries $os'/rpi2' $outputzip
    fi

    if [ "$binary" = "-binary-all" ] || [ "$binary" = "-binary-rpi3" ]; then
       echo "--- [WGET:BINARIES] [RPI3] [$os] ---"
       outputzip=$outputdir/cores-retropie-rpi3-$os-$now.zip
       binaries $os'/rpi3' $outputzip
    fi
elif [ "$build" == "-build-rpi2" ]; then
    echo "--- [BUILD] [RPI2] ---"
    outputzip=$outputdir/cores-rpi-armv7-$now.zip
    FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_armsneslibretro,a_fbalibretro,a_fceunextlibretro,a_fmsxlibretro,a_gambattelibretro,a_genesislibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro

    zip ${outputzip} build_retropie.log -j $outputdir/*.so
elif [ "$build" == "-build-rpi1" ]; then
    echo "--- [BUILD] [RPI1] ---"
    outputzip=$outputdir/cores-rpi-$now.zip
    #./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_armsneslibretro,a_fbalibretro,a_fceunextlibretro,a_fmsxlibretro,a_gambattelibretro,a_genesislibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro
    ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_fbalibretro,a_cap32libretro,a_fceunextlibretro,a_gambattelibretro,a_genesislibretro,a_gwlibretro,a_mame2000libretro,a_mame2003libretro,a_mame2010libretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro

    zip ${outputzip} build_retropie.log -j $outputdir/*.so
fi

popd
echo '--- [END] [RPIBOT] ---'

exit 0

