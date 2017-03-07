rp_module_id="a_yabauselibretro"
rp_module_desc="SATURN LibretroCore YABAUSE (Additional)"
rp_module_menus="2+"

function sources_a_yabauselibretro() {
    gitPullOrClone "$rootdir/emulatorcores/yabause" git://github.com/libretro/yabause.git
}

function build_a_yabauselibretro() {
    pushd "$rootdir/emulatorcores/yabause/libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/yabause/libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/yabause/libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SATURN LibretroCore YABAUSE!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.yabauselibretro

    popd
}

function copy_a_yabauselibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/yabause/libretro/ -name $so_filter | xargs cp -t $outputdir
}