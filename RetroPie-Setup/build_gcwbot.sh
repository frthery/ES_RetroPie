#!/bin/bash
pushd "/home/pi/RetroPie-Setup"
now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now

#git reset --hard HEAD
#git pull

#./build_retropie.sh -u
outputzip=$outputdir/cores-gcw0-$now.zip
HOST_CC=mipsel-gcw0-linux MAKEFLAGS=-j4 ./build_retropie.sh -b -name=a_craftlibretro,a_fceunextlibretro,a_fbacorescps1libretro,a_fbacorescps2libretro,a_fbacoresneolibretro,a_fbalibretro,a_gambattelibretro,a_genesislibretro,a_gpsplibretro,a_gwlibretro,a_mame2000libretro,a_mame2003libretro,a_mednafenlynxlibretro,a_mednafenngplibretro,a_mednafenpcefastlibretro,a_mednafenpsxlibretro,a_mednafenvblibretro,a_mednafenwswanlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_vecxlibretro,a_yabauselibretro

zip ${outputzip} build_retropie.log -j $outputdir/*.so
popd
