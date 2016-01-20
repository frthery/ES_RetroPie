rp_module_id="a_reicastlibretro"
rp_module_desc="REICAST LibretroCore (Additional)"
rp_module_menus="4+"

function sources_a_reicastlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/reicast-libretro" git://github.com/libretro/reicast-emulator.git
}

function build_a_reicastlibretro() {
    pushd "$rootdir/emulatorcores/reicast-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile REICAST LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.reicastlibretro

    popd
}

function configure_a_reicastlibretro() {
    mkdir -p $romdir/dc
}

function copy_a_reicastlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/reicast-libretro/ -name $so_filter | xargs cp -t $outputdir
}
