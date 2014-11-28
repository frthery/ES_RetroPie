rp_module_id="yabause"
rp_module_desc="SATURN LibretroCore yabause"
rp_module_menus="2+"

function sources_yabause() {
    gitPullOrClone "$rootdir/emulatorcores/yabause" git://github.com/libretro/yabause.git
}

function build_yabause() {
    pushd "$rootdir/emulatorcores/yabause/libretro"
    make clean
    make 
    popd
    if [[ -z `find $rootdir/emulatorcores/yabause/libretro/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile YABAUSE core."
    fi
}

function configure_yabause() {
    mkdir -p $romdir/saturn

    #rps_retronet_prepareConfig
    #setESSystem "Sega SATURN" "saturn" "~/RetroPie/roms/saturn" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/yabause/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/saturn/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "saturn" "saturn"
}