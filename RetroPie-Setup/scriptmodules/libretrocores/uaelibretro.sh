rp_module_id="uaelibretro"
rp_module_desc="AMIGA LibretroCore uae4all"
rp_module_menus="2+"

function sources_uaelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-uae" git://github.com/libretro/libretro-uae.git
}

function build_uaelibretro() {
    pushd "$rootdir/emulatorcores/libretro-uae/build"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean [code=$?] !"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/libretro-uae/build/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile UAE core."
    fi

    popd
}

function configure_uaelibretro() {
    mkdir -p $romdir/amiga

    #rps_retronet_prepareConfig
    #setESSystem "Sega SATURN" "saturn" "~/RetroPie/roms/saturn" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/yabause/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/saturn/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "saturn" "saturn"
}

function copy_uaelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-uae/build/ -name $so_filter | xargs cp -t ./bin
}