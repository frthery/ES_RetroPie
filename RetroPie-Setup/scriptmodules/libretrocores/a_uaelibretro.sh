rp_module_id="a_uaelibretro"
rp_module_desc="AMIGA LibretroCore uae4all (Additional)"
rp_module_menus="2+"

function sources_a_uaelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-uae" git://github.com/libretro/libretro-uae.git
}

function build_a_uaelibretro() {
    pushd "$rootdir/emulatorcores/libretro-uae/build"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile AMIGA LibretroCore uae4all!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.uaelibretro

    popd
}

function copy_a_uaelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-uae/build/ -name $so_filter | xargs cp -t $outputdir
}