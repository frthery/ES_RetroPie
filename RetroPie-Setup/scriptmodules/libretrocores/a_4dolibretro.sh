rp_module_id="a_4dolibretro"
rp_module_desc="3DO LibretroCore 4DO (Additional)"
rp_module_menus="4+"

function sources_a_4dolibretro() {
    gitPullOrClone "$rootdir/emulatorcores/4do-libretro" git://github.com/libretro/4do-libretro
}

function build_a_4dolibretro() {
    pushd "$rootdir/emulatorcores/4do-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile 3DO LibretroCore 4DO!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.4dolibretro

    popd
}

function configure_a_4dolibretro() {
    mkdir -p $romdir/3do
}

function copy_a_4dolibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/4do-libretro/ -name $so_filter | xargs cp -t $outputdir
}
