#!/bin/bash

pushd "/home/pi/RetroPie-Setup"

now=`date +%Y%m%d`
outputdir=$(pwd)/bin/$now
mediafiredir='/cygdrive/c/Users/frthery/MediaFire/Datas/github-retroarch-build/'

#git reset --hard HEAD
#git pull

./build_retropie.sh -u
#HOST_CC=x86_64-w64-mingw32 ./build_retropie.sh -b -name=a_retroarch,a_armsneslibretro,a_fbalibretro,a_fceunextlibretro,a_fmsxlibretro,a_gambattelibretro,a_genesislibretro,a_gpsplibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro
#HOST_CC=x86_64-w64-mingw32 ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_mupen64libretro,a_ppsspplibretro,a_yabauselibretro
HOST_CC=x86_64-w64-mingw32 ./build_retropie.sh -b -name=a_retroarch,a_gpsplibretro,a_mupen64libretro

zip "cores-win64-$now.zip" -j $outputdir/*.dll
[ -f "$outputdir/retroarch-win64-1.0.zip" ] && cp "$outputdir/retroarch-win64-1.0.zip" "$mediafiredir/retroarch-win64-1.0-$now.zip"
[ -f "cores-win64-$now.zip" ] && cp "cores-win64-$now.zip" "$mediafiredir/cores/"

popd
