rp_module_id="a_yabauselibretro"
rp_module_desc="SATURN LibretroCore YABAUSE (Additional)"
rp_module_menus="2+"

function sources_a_yabauselibretro() {
    gitPullOrClone "$rootdir/emulatorcores/yabause" git://github.com/libretro/yabause.git
}

function build_a_yabauselibretro() {
    pushd "$rootdir/emulatorcores/yabause/libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SATURN LibretroCore YABAUSE!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.yabauselibretro

    popd
}

function configure_a_yabauselibretro() {
    mkdir -p $romdir/saturn

    #rps_retronet_prepareConfig
    #setESSystem "Sega SATURN" "saturn" "~/RetroPie/roms/saturn" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/yabause/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/saturn/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "saturn" "saturn"
}

function copy_a_yabauselibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/yabause/libretro/ -name $so_filter | xargs cp -t $outputdir
}