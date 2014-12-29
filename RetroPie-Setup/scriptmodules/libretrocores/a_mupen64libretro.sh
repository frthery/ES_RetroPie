rp_module_id="a_mupen64libretro"
rp_module_desc="N64 LibretroCore Mupen64Plus"
rp_module_menus="4+"

function sources_a_mupen64libretro() {
    rmDirExists "$rootdir/emulatorcores/mupen64plus"
    # Base repo:
    [ ${FORMAT_COMPILER_TARGET} = "win" ] && gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/libretro/mupen64plus-libretro.git
    # Freezed fixed repo:
    #gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/gizmo98/mupen64plus-libretro.git
}

function build_a_mupen64libretro() {
    #rpSwap on 750
    
    pushd "$rootdir/emulatorcores/mupen64plus"
    
    # Add missing path --> Fix already merged https://github.com/libretro/mupen64plus-libretro/commit/c035cf1c7a2514aeb14adf51ad825208ff1a068d
    # sed -i 's|GL_LIB := -lGLESv2|GL_LIB := -L/opt/vc/lib -lGLESv2|g' Makefile

    #make clean
    #make platform=rpi 

    if [ ${FORMAT_COMPILER_TARGET} = "win" ]; then
        [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi    
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile N64 LibretroCore Mupen64Plus!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mupen64libretro

    popd

    #rpSwap off
}

function configure_a_mupen64libretro() {
    mkdir -p $romdir/n64

    ensureSystemretroconfig "n64"

    # Set core options
    ensureKeyValue "mupen64-gfxplugin" "rice" "$rootdir/configs/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-gfxplugin-accuracy" "low" "$rootdir/configs/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-screensize" "640x480" "$rootdir/configs/all/retroarch-core-options.cfg"

    # Copy config files
    cp $rootdir/emulatorcores/mupen64plus/mupen64plus/mupen64plus-core/data/mupen64plus.cht $home/RetroPie/BIOS/mupen64plus.cht
    cp $rootdir/emulatorcores/mupen64plus/mupen64plus/mupen64plus-core/data/mupencheat.txt $home/RetroPie/BIOS/mupencheat.txt
    cp $rootdir/emulatorcores/mupen64plus/mupen64plus/mupen64plus-core/data/mupen64plus.ini $home/RetroPie/BIOS/mupen64plus.ini 
    cp $rootdir/emulatorcores/mupen64plus/mupen64plus/mupen64plus-core/data/font.ttf $home/RetroPie/BIOS/font.ttf

    # Set permissions
    chmod +x "$home/RetroPie/BIOS/mupen64plus.cht"
    chmod +x "$home/RetroPie/BIOS/mupencheat.txt"
    chmod +x "$home/RetroPie/BIOS/mupen64plus.ini"
    chmod +x "$home/RetroPie/BIOS/font.ttf"

    rps_retronet_prepareConfig
    setESSystem "Nintendo 64" "n64" "~/RetroPie/roms/n64" ".z64 .Z64 .n64 .N64 .v64 .V64" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mupen64plus/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/n64/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "n64" "n64"
}

function copy_a_mupen64libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mupen64plus/ -name $so_filter | xargs cp -t $outputdir
}
