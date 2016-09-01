#!/bin/bash
pushd "/home/pi/RetroPie-Setup"
now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now

#git reset --hard HEAD
#git pull

#./build_retropie.sh -u
outputzip=$outputdir/cores-pchip-$now.zip
FORMAT_COMPILER_TARGET=armv7-cortexa8-hardfloat ./build_retropie.sh -b -name=a_cap32libretro,a_fceunextlibretro,a_gambattelibretro,a_genesislibretro,a_gpsplibretro,a_gwlibretro,a_mame2000libretro,a_mednafenpcefastlibretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_prboomlibretro,a_snes9x2002libretro,a_snes9xnextlibretro,a_stellalibretro

zip ${outputzip} build_retropie.log -j $outputdir/*.so
popd

exit 0

