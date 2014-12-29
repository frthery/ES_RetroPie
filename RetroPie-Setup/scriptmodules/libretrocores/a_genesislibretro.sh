rp_module_id="a_genesislibretro"
rp_module_desc="Genesis LibretroCore Genesis-Plus-GX (Additional)"
rp_module_menus="2+"

function sources_a_genesislibretro() {
    gitPullOrClone "$rootdir/emulatorcores/Genesis-Plus-GX" git://github.com/libretro/Genesis-Plus-GX.git
}

function build_a_genesislibretro() {
    pushd "$rootdir/emulatorcores/Genesis-Plus-GX"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Genesis LibretroCore Genesis-Plus-GX!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.genesislibretro

    popd
}

function configure_a_genesislibretro() {
    mkdir -p $romdir/gamegear
    
    ensureSystemretroconfig "gamegear"
    setESSystem "Sega Game Gear" "gamegear" "~/RetroPie/roms/gamegear" ".gg .GG" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/Genesis-Plus-GX/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gamegear/retroarch.cfg  %ROM%\"" "gamegear" "gamegear"
}

function copy_a_genesislibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/Genesis-Plus-GX/ -name $so_filter | xargs cp -t $outputdir
}
