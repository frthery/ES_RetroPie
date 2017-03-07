rp_module_id="a_fbacorescps1libretro"
rp_module_desc="CPS1 LibretroCore cps1(Additional)"
rp_module_menus="2+"

function sources_a_fbacorescps1libretro() {
    gitPullOrClone "$rootdir/emulatorcores/fba-cores-cps1" git://github.com/libretro/fba_cores_cps1.git
}

function build_a_fbacorescps1libretro() {
    pushd "$rootdir/emulatorcores/fba-cores-cps1"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-cps1/makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-cps1/makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f makefile.libretro clean || echo "Failed to clean!"
    make -f makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile FBA CPS1 LibretroCore fbacps1!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fbacps1libretro

    popd
}

function copy_a_fbacorescps1libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fba-cores-cps1/ -name $so_filter | xargs cp -t $outputdir
}