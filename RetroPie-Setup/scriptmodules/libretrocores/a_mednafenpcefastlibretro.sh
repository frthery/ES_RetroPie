rp_module_id="a_mednafenpcefastlibretro"
rp_module_desc="Mednafen PCE Fast LibretroCore"
rp_module_menus="2+"

function sources_a_mednafenpcefastlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafenpcefast" https://github.com/libretro/beetle-pce-fast-libretro.git
}

function build_a_mednafenpcefastlibretro() {
    pushd "$rootdir/emulatorcores/mednafenpcefast"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenpcefastlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/mednafenpcefast/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile Mednafen PCE Fast core."
    fi

    popd
}

function configure_a_mednafenpcefastlibretro() {
    mkdir -p $romdir/pcengine

    setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_mednafenpcefastlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafenpcefast/ -name $so_filter | xargs cp -t $outputdir
}