rp_module_id="a_snes9x2002libretro"
rp_module_desc="SNES LibretroCore Snes9x2002 (Additional)"
rp_module_menus="2+"

function sources_a_snes9x2002libretro() {
    gitPullOrClone "$rootdir/emulatorcores/snes9x2002-libretro" git://github.com/libretro/snes9x2002.git
}

function build_a_snes9x2002libretro() {
    pushd "$rootdir/emulatorcores/snes9x2002-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/snes9x2002-libretro/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/snes9x2002-libretro/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile ARM_ASM=1 platform=unix 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore Snes9x2002!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.snes9x2002libretro

    popd
}

function configure_a_snes9x2002libretro() {
    mkdir -p $romdir/snes
}

function copy_a_snes9x2002libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/snes9x2002-libretro/ -name $so_filter | xargs cp -t $outputdir
}