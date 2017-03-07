rp_module_id="a_virtualjaguarlibretro"
rp_module_desc="JAGUAR LibretroCore VirtualJaguar (Additional)"
rp_module_menus="2+"

function sources_a_virtualjaguarlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/virtualjaguar-libretro" git://github.com/libretro/virtualjaguar-libretro.git
}

function build_a_virtualjaguarlibretro() {
    pushd "$rootdir/emulatorcores/virtualjaguar-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile JAGUAR LibretroCore VirtualJaguar!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.virtualjaguarlibretro

    popd
}

function copy_a_virtualjaguarlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/virtualjaguar-libretro/ -name $so_filter | xargs cp -t $outputdir
}
