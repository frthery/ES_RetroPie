rp_module_id="a_scummvmlibretro"
rp_module_desc="SCUMMVM LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_scummvmlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/scummvm" git://github.com/libretro/scummvm.git
}

function build_a_scummvmlibretro() {
    pushd "$rootdir/emulatorcores/scummvm/backends/platform/libretro/build/"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SCUMMVM LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.scummvmlibretro

    popd
}

function copy_a_scummvmlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/scummvm/backends/platform/libretro/build/ -name $so_filter | xargs cp -t $outputdir
}