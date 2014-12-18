rp_module_id="gambattelibretro"
rp_module_desc="Gameboy Color LibretroCore Gambatte"
rp_module_menus="2+"

function sources_gambattelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gambatte-libretro" git://github.com/libretro/gambatte-libretro.git
}

function build_gambattelibretro() {
    pushd "$rootdir/emulatorcores/gambatte-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean [code=$?] !"
    make -f Makefile.libretro -C libgambatte platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    #make -C libgambatte -f Makefile.libretro clean
    #make -C libgambatte -f Makefile.libretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/gambatte-libretro/libgambatte/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile Game Boy Color core."
    fi

    popd
}

function configure_gambattelibretro() {
    mkdir -p $romdir/gbc
    mkdir -p $romdir/gb

    setESSystem "Game Boy" "gb" "~/RetroPie/roms/gb" ".gb .GB" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gambatte-libretro/libgambatte/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gb/retroarch.cfg %ROM%\"" "gb" "gb"
    setESSystem "Game Boy Color" "gbc" "~/RetroPie/roms/gbc" ".gbc .GBC" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gambatte-libretro/libgambatte/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gbc/retroarch.cfg %ROM%\"" "gbc" "gbc"
}

function copy_gambattelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gambatte-libretro/ -name $so_filter | xargs cp -t ./bin
}