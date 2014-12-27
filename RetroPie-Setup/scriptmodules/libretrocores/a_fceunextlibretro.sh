rp_module_id="a_fceunextlibretro"
rp_module_desc="NES LibretroCore fceu-next"
rp_module_menus="2+"

function sources_a_fceunextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/fceu-next" git://github.com/libretro/fceu-next.git
}

function build_a_fceunextlibretro() {
    pushd "$rootdir/emulatorcores/fceu-next/fceumm-code"

    #make -f Makefile.libretro clean
    #make -f Makefile.libretro

    make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fceunextlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/fceu-next/fceumm-code/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile NES core."
    fi

    popd
}

function configure_a_neslibretro() {
    mkdir -p $romdir/nes

    rps_retronet_prepareConfig
    setESSystem "Nintendo Entertainment System" "nes" "~/RetroPie/roms/nes" ".nes .NES" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/fceu-next/fceumm-code/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/nes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "nes" "nes"
}