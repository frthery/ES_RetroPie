rp_module_id="a_retroarch"
rp_module_desc="RetroArch (Additional)"
rp_module_menus="2+"

function depends_a_retroarch() {
    # sudo apt-get install build-essential git pkg-config libsdl2-dev libsdl1.2-dev
    # sudo apt-get install libudev-dev libxkbcommon-dev libsdl2-dev
    # sudo apt-get install mali-fbdev

    getDepends libudev-dev libxkbcommon-dev
#    cat > "/etc/udev/rules.d/99-evdev.rules" << _EOF_
#KERNEL=="event*", NAME="input/%k", MODE="666"
#_EOF_
#    sudo chmod 666 /dev/input/event*
}

function sources_a_retroarch() {
    # FORCE CLONE
    [ -d $rootdir/emulators/RetroArch ] && rm -R $rootdir/emulators/RetroArch
    gitPullOrClone "$rootdir/emulators/RetroArch" git://github.com/libretro/RetroArch.git
}

function build_a_retroarch() {
    pushd "$rootdir/emulators/RetroArch"

    if [ ${FORMAT_COMPILER_TARGET} = "win" ]; then
        #./configure --disable-sdl --enable-sdl2 --enable-floathard --enable-neon --disable-opengl --disable-gles --disable-vg --disable-fbo --disable-egl --disable-pulse --disable-oss --disable-x11 --disable-wayland --disable-ffmpeg --disable-7zip --disable-libxml2 --disable-freetype

        # ONLY WIN X64
        make -f Makefile.win libs_x86_64 || echo "Failed to extract libraries!"
        make -f Makefile.win clean
        make -f Makefile.win ${COMPILER} WINDRES=$HOST_CC-windres HAVE_D3D9=1 -j4 all 2>&1 | tee makefile.log || echo "Failed to compile!"
        [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.retroarch

        make -f Makefile.win ${COMPILER} WINDRES=$HOST_CC-windres HAVE_D3D9=1 dist_x86_64 || echo "Failed to dist_x86_64!"
        ZIP_BASE="`find . | grep "retroarch-win" | head -n1`"
        zip "./$ZIP_BASE" *.dll retroarch-redist-version || die "Failed to build full/redist!"
    else
        PARAMS=(--disable-x11 --enable-gles --disable-ffmpeg --disable-sdl --enable-sdl2 --disable-oss --disable-pulse --disable-al --disable-jack)
        if [ ${FORMAT_COMPILER_TARGET} = "armv7-cortexa8-hardfloat" ]; then
           # POCKETCHIP BUILD : --enable-mali_fbdev --disable-sdl --enable-sdl2 --enable-floathard --enable-neon --disable-opengl --disable-gles --disable-vg --disable-fbo --disable-egl --disable-pulse --disable-oss --disable-x11 --disable-wayland --disable-ffmpeg --disable-7zip --disable-libxml2 --disable-freetype
           #PARAMS+=(--enable-mali_fbdev --enable-neon --enable-floathard)
           PARAMS=(--enable-sdl --disable-sdl2 --enable-floathard --enable-neon --disable-opengl --disable-gles --disable-vg --disable-fbo --disable-egl --disable-pulse --disable-oss --disable-x11 --disable-wayland --disable-ffmpeg --disable-7zip --disable-libxml2 --disable-freetype)
        else 
           # RPI BUILD  : --disable-x11 --enable-gles --disable-ffmpeg --disable-sdl --enable-sdl2 --disable-oss --disable-pulse --disable-al --disable-jack --enable-dispmanx --enable-floathard
           # RPI2 BUILD : --disable-x11 --enable-gles --disable-ffmpeg --disable-sdl --enable-sdl2 --disable-oss --disable-pulse --disable-al --disable-jack --enable-dispmanx --enable-floathard --enable-neon
           #PARAMS+=(--prefix="$rootdir/emulators/RetroArch/installdir" --enable-dispmanx --enable-floathard)
           PARAMS+=(--enable-dispmanx --enable-floathard)
           if [ ${FORMAT_COMPILER_TARGET} = "armv7-cortexa7-hardfloat" ]; then
              PARAMS+=(--enable-neon)
           fi
        fi

        echo "FORMAT_COMPILER_TARGET: ${FORMAT_COMPILER_TARGET}"
        echo "CONFIGURE FLAGS: ${PARAMS[@]}"
        ./configure "${PARAMS[@]}"

        if [ $? -eq 0 ]; then
           [ -z "${NOCLEAN}" ] && make -f Makefile clean
           make -f Makefile 2>&1 | tee makefile.log
           #[ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile RetroArch!"
           [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.retroarch

           if [[ ! -f "$rootdir/emulators/RetroArch/retroarch" ]]; then
              __ERRMSGS="Could not successfully compile RetroArch!"
           fi
         else
             __ERRMSGS="Could not successfully configure RetroArch!"
         fi
    fi

    popd
}

function copy_a_retroarch() {
    pushd "$rootdir/emulators/RetroArch"

    if [ ${FORMAT_COMPILER_TARGET} = "win" ]; then
        ZIP_BASE="`find . | grep "retroarch-win" | head -n1`"
        cp $ZIP_BASE $outputdir
    else
        #DESTDIR=$outputdir/retroarch make install
        #PREFIX="$ouputdir/RetroArch/installdir" GLOBAL_CONFIG_DIR="$ouputdir/RetroArch/installdir" make install

        # GET ASSETS: git://github.com/libretro/retroarch-assets.git | http://buildbot.libretro.com/assets/frontend/
        #gitPullOrClone "$rootdir/emulators/RetroArch/assets" git://github.com/libretro/retroarch-assets.git

        wget http://buildbot.libretro.com/assets/frontend/assets.zip -O assets.zip
        wget http://buildbot.libretro.com/assets/frontend/info.zip -O info.zip

        [ -d $outputdir/RetroArch ] && rm -R $outputdir/RetroArch
        mkdir -p $outputdir/RetroArch/bin
        mkdir -p $outputdir/RetroArch/assets
        mkdir -p $outputdir/RetroArch/info
        mkdir -p $outputdir/RetroArch/tools
        mkdir -p $outputdir/RetroArch/share/pixmaps

        cp retroarch $outputdir/RetroArch/bin && cp retroarch.cfg $outputdir/RetroArch/bin
        #cp -R assets/* $outputdir/RetroArch/assets
        unzip assets.zip -d "$outputdir/RetroArch/assets"
        unzip info.zip -d "$outputdir/RetroArch/info"
        cp tools/cg2glsl.py $outputdir/RetroArch/tools/retroarch-cg2glsl && cp tools/retroarch-joyconfig $outputdir/RetroArch/tools/
        cp media/retroarch-*.png $outputdir/RetroArch/share/pixmaps && cp media/retroarch.svg $outputdir/RetroArch/share/pixmaps
    fi

    popd
}
