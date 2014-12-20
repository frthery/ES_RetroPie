rp_module_id="pocketsneslibretro"
rp_module_desc="SNES LibretroCore PocketSNES"
rp_module_menus="2+"

function sources_pocketsneslibretro() {
    gitPullOrClone "$rootdir/emulatorcores/pocketsnes-libretro" git://github.com/ToadKing/pocketsnes-libretro.git

    pushd "$rootdir/emulatorcores/pocketsnes-libretro"
    patch -N -i $scriptdir/supplementary/pocketsnesmultip.patch $rootdir/emulatorcores/pocketsnes-libretro/src/ppu.cpp
    popd
}

function build_pocketsneslibretro() {
    pushd "$rootdir/emulatorcores/pocketsnes-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.pocketsneslibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/pocketsnes-libretro/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile SNES core."
    fi

    popd
}

function configure_pocketsneslibretro() {
    mkdir -p $romdir/snes

    rps_retronet_prepareConfig
    setESSystem "Super Nintendo" "snes" "~/RetroPie/roms/snes" ".smc .sfc .fig .swc .SMC .SFC .FIG .SWC" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pocketsnes-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/snes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "snes" "snes"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}

function copy_pocketsneslibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
	outfile=$outputdir/pocketsnes_$(echo $so_filter | sed 's/*//g')
    find $rootdir/emulatorcores/pocketsnes-libretro/ -name $so_filter | xargs cp $outfile
}