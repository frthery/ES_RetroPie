rp_module_id="a_mednafensaturnlibretro"
rp_module_desc="SATURN LibretroCore mednafen-saturn (Additional)"
rp_module_menus="2+"

function sources_a_mednafensaturnlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-saturn-libretro" git://github.com/libretro/beetle-saturn-libretro.git
}

function build_a_mednafensaturnlibretro() {
    pushd "$rootdir/emulatorcores/mednafen-saturn-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-saturn-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-saturn-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SATURN LibretroCore mednafen-saturn!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafensaturnlibretro

    popd
}

function configure_a_mednafensaturnlibretro() {
    mkdir -p $romdir/saturn
}

function copy_a_mednafensaturnlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-saturn-libretro/ -name $so_filter | xargs cp -t $outputdir
}