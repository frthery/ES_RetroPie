rp_module_id="a_fceunextlibretro"
rp_module_desc="NES LibretroCore fceu-next (Additional)"
rp_module_menus="2+"

function sources_a_fceunextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/fceu-next" git://github.com/libretro/fceu-next.git
}

function build_a_fceunextlibretro() {
    pushd "$rootdir/emulatorcores/fceu-next/fceumm-code"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fceu-next/fceumm-code/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fceu-next/fceumm-code/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile NES LibretroCore fceu-next!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fceunextlibretro

    popd
}

function configure_a_fceunextlibretro() {
    mkdir -p $romdir/nes

    #rps_retronet_prepareConfig
    #setESSystem "Nintendo Entertainment System" "nes" "~/RetroPie/roms/nes" ".nes .NES" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/fceu-next/fceumm-code/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/nes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "nes" "nes"
}

function copy_a_fceunextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fceu-next/fceumm-code/ -name $so_filter | xargs cp -t $outputdir
}