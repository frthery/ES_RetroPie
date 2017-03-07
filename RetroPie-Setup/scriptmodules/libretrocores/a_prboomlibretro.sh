rp_module_id="a_prboomlibretro"
rp_module_desc="DOOM LibretroCore PRBOOM (Additional)"
rp_module_menus="2+"

function sources_a_prboomlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-prboom" git://github.com/libretro/libretro-prboom.git
}

function build_a_prboomlibretro() {
    pushd "$rootdir/emulatorcores/libretro-prboom"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/libretro-prboom/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/libretro-prboom/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile DOOM LibretroCore PRBOOM!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.prboomlibretro

    popd
}

function copy_a_prboomlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-prboom/ -name $so_filter | xargs cp -t $outputdir
}