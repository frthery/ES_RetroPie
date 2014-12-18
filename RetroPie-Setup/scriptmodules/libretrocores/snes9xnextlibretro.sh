rp_module_id="snes9xnextlibretro"
rp_module_desc="SNES LibretroCore Snes9xNext"
rp_module_menus="2+"

function sources_snes9xnextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/snes9x-next" git://github.com/libretro/snes9x-next.git
}

function build_snes9xnextlibretro() {
    pushd "$rootdir/emulatorcores/snes9x-next"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean [code=$?] !"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/snes9x-next/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile SNES core."
    fi

    popd
}

function configure_snes9xnextlibretro() {
    mkdir -p $romdir/snes

    #rps_retronet_prepareConfig
    #setESSystem "Super Nintendo" "snes" "~/RetroPie/roms/snes" ".smc .sfc .fig .swc .SMC .SFC .FIG .SWC" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pocketsnes-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/snes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "snes" "snes"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}

function copy_snes9xnextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/snes9x-next/ -name $so_filter | xargs cp -t $outputdir
}