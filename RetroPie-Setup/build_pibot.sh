#!/bin/bash

pushd "/home/pi/RetroPie-Setup"

./build_retropie.sh -u
./build_retropie.sh -b -name=armsneslibretro,fbalibretro,gambattelibretro,genesislibretro,imamelibretro,mednafenpcefastlibretro,neslibretro,pcsx_rearmedlibretro,picodrivelibretro,pocketsneslibretro,prboomlibretro,snes9xnextlibretro,stellalibretro,virtualjaguarlibretro,yabauselibretro

popd
