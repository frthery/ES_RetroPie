rp_module_id="a_picodrivelibretro"
rp_module_desc="Genesis LibretroCore Picodrive (Additional)"
rp_module_menus="2+"

function sources_a_picodrivelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/picodrive" git://github.com/libretro/picodrive.git
    
    pushd "$rootdir/emulatorcores/picodrive"
    git submodule init && git submodule update
    popd
}

function build_a_picodrivelibretro() {
    pushd "$rootdir/emulatorcores/picodrive"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/picodrive/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/picodrive/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Genesis LibretroCore Picodrive!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.picodrivelibretro

    popd
}

function copy_a_picodrivelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/picodrive/ -name $so_filter | xargs cp -t $outputdir
}