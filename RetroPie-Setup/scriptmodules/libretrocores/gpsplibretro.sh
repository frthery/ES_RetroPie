rp_module_id="gpsplibretro"
rp_module_desc="GBA LibretroCore gpsp"
rp_module_menus="2+"

function sources_gpsplibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gpsp" https://github.com/libretro/gpsp.git
}

function build_gpsplibretro() {
    rpSwap on 256 240
    
    pushd "$rootdir/emulatorcores/gpsp/"
    #make -f Makefile.libretro clean
    make platform=armvhardfloat
    #make -f Makefile.libretro
    popd
    if [[ -z `find $rootdir/emulatorcores/gpsp/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile GPSP core."
    fi
    
    rpSwap off
}

function configure_gpsplibretro() {
    mkdir -p $romdir/gba

    #rps_retronet_prepareConfig
    #setESSystem "Gameboy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gpsp/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gpsp/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
}