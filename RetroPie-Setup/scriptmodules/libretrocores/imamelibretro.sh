rp_module_id="imamelibretro"
rp_module_desc="iMAME4all LibretroCore"
rp_module_menus="2+"

function sources_imamelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/imame4all-libretro" git://github.com/libretro/imame4all-libretro.git
}

function build_imamelibretro() {
    pushd "$rootdir/emulatorcores/imame4all-libretro"
    
    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean [code=$?] !"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    #make -f makefile.libretro clean
    #make -f makefile.libretro ARM=1

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/imame4all-libretro/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile MAME core."
    fi

    popd
}

function configure_imamelibretro() {
    mkdir -p $romdir/mame-libretro

    setESSystem "MAME" "mame-libretro" "~/RetroPie/roms/mame-libretro" ".zip .ZIP" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/imame4all-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/mame/retroarch.cfg %ROM%" "arcade" "mame"
}

function copy_imamelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/imame4all-libretro/ -name $so_filter | xargs cp -t ./bin
}