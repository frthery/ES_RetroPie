rp_module_id="a_armsneslibretro"
rp_module_desc="SNES LibretroCore ARMSNES (Additional)"
rp_module_menus="4+"

function sources_a_armsneslibretro() {
    gitPullOrClone "$rootdir/emulatorcores/armsnes-libretro" git://github.com/rmaz/ARMSNES-libretro

    pushd "$rootdir/emulatorcores/armsnes-libretro"
    patch -N -i $scriptdir/supplementary/pocketsnesmultip.patch $rootdir/emulatorcores/armsnes-libretro/src/ppu.cpp
    popd
}

function build_a_armsneslibretro() {
    pushd "$rootdir/emulatorcores/armsnes-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore ARMSNES!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.armsneslibretro

    popd
}

function copy_a_armsneslibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/armsnes_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/armsnes-libretro/ -name libpocketsnes.*) && cp $file $outfile
}
