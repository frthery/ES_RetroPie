rp_module_id="a_lutroponglibretro"
rp_module_desc="PONG LibretroCore (Additional)"
rp_module_menus="4+"

function sources_a_lutroponglibretro() {
    gitPullOrClone "$rootdir/emulatorcores/lutro-pong" git://github.com/libretro/lutro-pong.git
}

function build_a_lutroponglibretro() {
    pushd "$rootdir/emulatorcores/lutro-pong"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile PONG LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.lutroponglibretro

    popd
}

function copy_a_lutroponglibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/lutro-pong/ -name $so_filter | xargs cp -t $outputdir
}
