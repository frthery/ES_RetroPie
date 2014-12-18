rp_module_id="turbografx16libretro"
rp_module_desc="TurboGrafx 16 LibretroCore mednafen-pce"
rp_module_menus="2+"

function sources_turbografx16libretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-pce-libretro/" https://github.com/petrockblog/mednafen-pce-libretro.git
}

function build_turbografx16libretro() {
    pushd "$rootdir/emulatorcores/mednafen-pce-libretro/"
    
    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean [code=$?] !"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"
    
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ ! -f `find $rootdir/emulatorcores/mednafen-pce-libretro/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile PC Engine core."
    fi
    
    popd
}

function configure_turbografx16libretro() {
    mkdir -p $romdir/pcengine-libretro

    rps_retronet_prepareConfig
    setESSystem "TurboGrafx 16 (PC Engine)" "pcengine-libretro" "~/RetroPie/roms/pcengine-libretro" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafen-pce-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_turbografx16libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-pce-libretro/ -name $so_filter | xargs cp -t ./bin
}