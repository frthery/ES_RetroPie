#!/bin/bash

echo '--- [START] [RPIBOT] ---'
pushd "/home/pi/RetroPie-Setup"

now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now

#git reset --hard HEAD
#git pull

./build_retropie.sh -u

if [ "$1" == "-binary-all" ]; then
    echo '--- [WGET:BINARIES] [RPI1] ---'
    ./build_retropie.sh -binary=jessie/rpi1 -name=lr-armsnes

    echo '--- [WGET:BINARIES] [RPI2] ---'
    ./build_retropie.sh -binary=jessie/rpi2 -name=lr-armsnes

    echo '--- [WGET:BINARIES] [RPI3] ---'
    ./build_retropie.sh -binary=jessie/rpi3 -name=lr-armsnes
elif [ "$1" == "-build-rpi2" ]; then
    echo '--- [BUILD] [RPI2] ---'
    outputzip=$outputdir/cores-rpi-armv7-$now.zip
    FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_armsneslibretro,a_fbalibretro,a_fceunextlibretro,a_fmsxlibretro,a_gambattelibretro,a_genesislibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro
elif [ "$1" == "-build-rpi1" ]; then
    echo '--- [BUILD] [RPI1] ---'
    outputzip=$outputdir/cores-rpi-$now.zip
    #./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_armsneslibretro,a_fbalibretro,a_fceunextlibretro,a_fmsxlibretro,a_gambattelibretro,a_genesislibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro
    ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_fbalibretro,a_cap32libretro,a_fceunextlibretro,a_gambattelibretro,a_genesislibretro,a_gwlibretro,a_mame2000libretro,a_mame2003libretro,a_mame2010libretro,a_mednafenpcefastlibretro,a_mupen64libretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro
fi

if [ "$1" == "-build-*" ]; then
   echo '--- [ZIP] ['${outputzip}'] ---'
   zip ${outputzip} build_retropie.log -j $outputdir/*.so
fi

popd
echo '--- [END] [RPIBOT] ---'

exit 0

