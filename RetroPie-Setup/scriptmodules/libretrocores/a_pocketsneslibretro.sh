rp_module_id="a_pocketsneslibretro"
rp_module_desc="SNES LibretroCore PocketSNES (Additional)"
rp_module_menus="2+"

function sources_a_pocketsneslibretro() {
    gitPullOrClone "$rootdir/emulatorcores/pocketsnes-libretro" git://github.com/ToadKing/pocketsnes-libretro.git

    pushd "$rootdir/emulatorcores/pocketsnes-libretro"
    patch -N -i $scriptdir/supplementary/pocketsnesmultip.patch $rootdir/emulatorcores/pocketsnes-libretro/src/ppu.cpp
    popd
}

function build_a_pocketsneslibretro() {
    pushd "$rootdir/emulatorcores/pocketsnes-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/pocketsnes-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/pocketsnes-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile ARM_ASM=1 ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore PocketSNES!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.pocketsneslibretro

    popd
}

function copy_a_pocketsneslibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/pocketsnes_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/pocketsnes-libretro/ -name $so_filter) && cp $file $outfile
}