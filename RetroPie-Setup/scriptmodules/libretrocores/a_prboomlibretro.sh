rp_module_id="a_prboomlibretro"
rp_module_desc="Doom LibretroCore prboom (Additional)"
rp_module_menus="2+"

function sources_a_prboomlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/libretro-prboom" git://github.com/libretro/libretro-prboom.git
}

function build_a_prboomlibretro() {
    pushd "$rootdir/emulatorcores/libretro-prboom"

   [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
   [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.prboomlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/libretro-prboom/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile Doom core."
    fi

    popd
}

function install_a_prboomlibretro() {
    mkdir -p $romdir/ports/doom
    cp $rootdir/emulatorcores/libretro-prboom/prboom.wad $romdir/ports/doom 

    # download and install Doom 1 shareware
    if `wget "http://downloads.petrockblock.com/retropiearchives/doom1.wad"`; then
        mv doom1.wad "$romdir/ports/doom/"
    else
        __ERRMSGS="$__ERRMSGS Could not successfully download and install Doom 1 shareware."
    fi
    # download and install midi instruments
    pushd /usr/local/lib
    if `wget "http://downloads.petrockblock.com/retropiearchives/timidity.tar.gz"`; then
        tar -xf timidity.tar.gz
        ln -f -s /usr/local/lib/timidity/timidity.cfg /etc/timidity.cfg
    else
        __ERRMSGS="$__ERRMSGS Could not successfully download and install Timidity patchsets."
    fi
    popd
}

function configure_a_prboomlibretro() {
    mkdir -p $romdir/ports/doom
    cp $rootdir/emulatorcores/libretro-prboom/prboom.wad $romdir/ports/doom

    cat > "$romdir/ports/Doom 1 Shareware.sh" << _EOF_
#!/bin/bash
$rootdir/supplementary/runcommand/runcommand.sh 1 "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/libretro-prboom/ -name "*libretro*.so" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/doom/retroarch.cfg $romdir/ports/doom/doom1.wad"
_EOF_
    chmod +x "$romdir/ports/Doom 1 Shareware.sh"

    setESSystem 'Ports' 'ports' '~/RetroPie/roms/ports' '.sh .SH' '%ROM%' 'pc' 'ports'    
}

function copy_a_prboomlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/libretro-prboom/ -name $so_filter | xargs cp -t $outputdir
}