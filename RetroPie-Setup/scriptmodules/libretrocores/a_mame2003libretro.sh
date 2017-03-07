rp_module_id="a_mame2003libretro"
rp_module_desc="MAME 2003 LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_mame2003libretro() {
    gitPullOrClone "$rootdir/emulatorcores/mame2003-libretro" git://github.com/libretro/mame2003-libretro.git
}

function build_a_mame2003libretro() {
    pushd "$rootdir/emulatorcores/mame2003-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mame2003-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mame2003-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ARM=1 CC="gcc-4.8" CXX="g++-4.8" 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile mame2003 LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mame2003libretro

    popd
}

function copy_a_mame2003libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mame2003-libretro/ -name $so_filter | xargs cp -t $outputdir
}