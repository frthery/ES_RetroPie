rp_module_id="a_pocketsneslibretro"
rp_module_desc="SNES LibretroCore PocketSNES (Additional)"
rp_module_menus="2+"

function sources_a_pocketsneslibretro() {
    gitPullOrClone "$rootdir/emulatorcores/pocketsnes-libretro" git://github.com/ToadKing/pocketsnes-libretro.git

    pushd "$rootdir/emulatorcores/pocketsnes-libretro"
    patch -N -i $scriptdir/supplementary/pocketsnesmultip.patch $rootdir/emulatorcores/pocketsnes-libretro/src/ppu.cpp
    popd
}

function build_a_pocketsneslibretro() {
    pushd "$rootdir/emulatorcores/pocketsnes-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore PocketSNES!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.pocketsneslibretro

    popd
}

function configure_a_pocketsneslibretro() {
    mkdir -p $romdir/snes

    rps_retronet_prepareConfig
    setESSystem "Super Nintendo" "snes" "~/RetroPie/roms/snes" ".smc .sfc .fig .swc .SMC .SFC .FIG .SWC" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pocketsnes-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/snes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "snes" "snes"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}

function copy_a_pocketsneslibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/pocketsnes_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/pocketsnes-libretro/ -name $so_filter) && cp $file $outfile
}