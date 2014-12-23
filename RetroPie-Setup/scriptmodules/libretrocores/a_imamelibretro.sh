rp_module_id="a_imamelibretro"
rp_module_desc="iMAME4all LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_imamelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/imame4all-libretro" git://github.com/libretro/imame4all-libretro.git
}

function build_a_imamelibretro() {
    pushd "$rootdir/emulatorcores/imame4all-libretro"

    [ -z "${NOCLEAN}" ] && make -f makefile.libretro clean || echo "Failed to clean!"
    make -f makefile.libretro platform=unix ARM=1 ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.imame4alllibretro

    #make -f makefile.libretro clean
    #make -f makefile.libretro ARM=1

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/imame4all-libretro/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile iMAME4all core."
    fi

    popd
}

function configure_a_imamelibretro() {
    mkdir -p $romdir/mame-libretro

    setESSystem "MAME" "mame-libretro" "~/RetroPie/roms/mame-libretro" ".zip .ZIP" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/imame4all-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/mame/retroarch.cfg %ROM%" "arcade" "mame"
}

function copy_a_imamelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/imame4all_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/imame4all-libretro/ -name $so_filter) && cp $file $outfile
}