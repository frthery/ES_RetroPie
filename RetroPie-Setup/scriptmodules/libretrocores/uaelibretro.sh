rp_module_id="uae"
rp_module_desc="AMIGA LibretroCore uae"
rp_module_menus="2+"

function sources_uae() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-uae" git://github.com/libretro/libretro-uae.git
}

function build_uae() {
    pushd "$rootdir/emulatorcores/libretro-uae/build"
    make clean
    make 
    popd
    if [[ -z `find $rootdir/emulatorcores/libretro-uae/build/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile UAE core."
    fi
}

function configure_uae() {
    mkdir -p $romdir/amiga

    #rps_retronet_prepareConfig
    #setESSystem "Sega SATURN" "saturn" "~/RetroPie/roms/saturn" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/yabause/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/saturn/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "saturn" "saturn"
}