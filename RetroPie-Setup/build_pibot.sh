#!/bin/bash

pushd "/home/pi/RetroPie-Setup"

./build_retropie.sh -u
./build_retropie.sh -b -name=retroarch,armsneslibretro,fbalibretro,gambattelibretro,genesislibretro,gpsplibretro,imamelibretro,mednafenpcefastlibretro,neslibretro,pcsx_rearmedlibretro,picodrivelibretro,pocketsneslibretro,prboomlibretro,snes9xnextlibretro,stellalibretro,virtualjaguarlibretro,yabauselibretro

popd
