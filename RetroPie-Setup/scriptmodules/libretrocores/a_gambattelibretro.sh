rp_module_id="a_gambattelibretro"
rp_module_desc="Gameboy Color LibretroCore Gambatte (Additional)"
rp_module_menus="2+"

function sources_a_gambattelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gambatte-libretro" git://github.com/libretro/gambatte-libretro.git
}

function build_a_gambattelibretro() {
    pushd "$rootdir/emulatorcores/gambatte-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro -C libgambatte clean || echo "Failed to clean!"
    make -f Makefile.libretro -C libgambatte platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Gameboy Color LibretroCore Gambatte!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.gambattelibretro

    popd
}

function configure_a_gambattelibretro() {
    mkdir -p $romdir/gbc
    mkdir -p $romdir/gb

    setESSystem "Game Boy" "gb" "~/RetroPie/roms/gb" ".gb .GB" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gambatte-libretro/libgambatte/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gb/retroarch.cfg %ROM%\"" "gb" "gb"
    setESSystem "Game Boy Color" "gbc" "~/RetroPie/roms/gbc" ".gbc .GBC" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gambatte-libretro/libgambatte/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gbc/retroarch.cfg %ROM%\"" "gbc" "gbc"
}

function copy_a_gambattelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gambatte-libretro/ -name $so_filter | xargs cp -t $outputdir
}