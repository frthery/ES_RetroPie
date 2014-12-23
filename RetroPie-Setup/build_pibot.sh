#!/bin/bash

pushd "/home/pi/RetroPie-Setup"

./build_retropie.sh -u
./build_retropie.sh -b -name=a_retroarch,a_armsneslibretro,a_fbalibretro,a_gambattelibretro,a_genesislibretro,a_gpsplibretro,a_imamelibretro,a_mednafenpcefastlibretro,a_neslibretro,a_pcsx_rearmedlibretro,a_picodrivelibretro,a_pocketsneslibretro,a_prboomlibretro,a_snes9xnextlibretro,a_stellalibretro,a_virtualjaguarlibretro,a_yabauselibretro

popd
