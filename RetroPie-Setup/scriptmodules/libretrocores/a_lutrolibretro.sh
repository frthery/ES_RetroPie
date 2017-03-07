rp_module_id="a_lutrolibretro"
rp_module_desc="LUTRO LibretroCore LOVE API (Additional)"
rp_module_menus="4+"

function sources_a_lutrolibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-lutro" git://github.com/libretro/libretro-lutro
}

function build_a_lutrolibretro() {
    pushd "$rootdir/emulatorcores/libretro-lutro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile LUTRO LibretroCore LOVE API!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.lutrolibretro

    popd
}

function copy_a_lutrolibretro() {
    #[ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-lutro/ -name "lutro_retro.*" | xargs cp -t $outputdir
}
