#!/bin/bash
pushd "/home/pi/RetroPie-Setup"
now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now

#git reset --hard HEAD
#git pull

#./build_retropie.sh -u
outputzip=$outputdir/cores-gcw0-$now.zip
HOST_CC=mipsel-gcw0-linux MAKEFLAGS=-j4 ./build_retropie.sh -b -name=a_gpsplibretro,a_fceunextlibretro,a_gambattelibretro,a_genesislibretro,a_mednafenpcefastlibretro,a_mednafenpsxlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro

zip ${outputzip} build_retropie.log -j $outputdir/*.so
popd