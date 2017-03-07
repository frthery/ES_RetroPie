rp_module_id="a_stellalibretro"
rp_module_desc="Atari 2600 LibretroCore Stella (Additional)"
rp_module_menus="2+"

function sources_a_stellalibretro() {
    gitPullOrClone "$rootdir/emulatorcores/stella-libretro" git://github.com/libretro/stella-libretro.git
}

function build_a_stellalibretro() {
    pushd "$rootdir/emulatorcores/stella-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/stella-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/stella-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Atari 2600 LibretroCore Stella!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.stellalibretro

    popd
}

function copy_a_stellalibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/stella-libretro/ -name $so_filter | xargs cp -t $outputdir
}
