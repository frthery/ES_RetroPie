rp_module_id="a_imamelibretro"
rp_module_desc="iMAME4all LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_imamelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/imame4all-libretro" git://github.com/libretro/imame4all-libretro.git
}

function build_a_imamelibretro() {
    pushd "$rootdir/emulatorcores/imame4all-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/imame4all-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/imame4all-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]]; then
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ARM=1 USE_CYCLONE=1 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile iMAME4all LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.imame4alllibretro

    popd
}

function configure_a_imamelibretro() {
    mkdir -p $romdir/mame-libretro

    #setESSystem "MAME" "mame-libretro" "~/RetroPie/roms/mame-libretro" ".zip .ZIP" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/imame4all-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/mame/retroarch.cfg %ROM%" "arcade" "mame"
}

function copy_a_imamelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/imame4all_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/imame4all-libretro/ -name $so_filter) && cp $file $outfile
}