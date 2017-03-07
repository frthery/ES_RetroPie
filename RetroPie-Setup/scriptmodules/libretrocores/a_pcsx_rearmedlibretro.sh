rp_module_id="a_pcsx_rearmedlibretro"
rp_module_desc="Playstation 1 LibretroCore pcsx_rearmed (Additional)"
rp_module_menus="2+"

function depends_a_pcsx_rearmedlibretro() {
    getDepends libpng12-dev libx11-dev
}

function sources_a_pcsx_rearmedlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/pcsx_rearmed" git://github.com/libretro/pcsx_rearmed.git
}

function build_a_pcsx_rearmedlibretro() {
    pushd "$rootdir/emulatorcores/pcsx_rearmed"

    ./configure --platform=libretro
    if [ $? -eq 0 ]; then
       [ -z "${NOCLEAN}" ] && make -f Makefile clean
       #make -f Makefile.libretro ${COMPILER} USE_DYNAREC=1 BUILTIN_GPU=neon 2>&1 | tee makefile.log
       #make -f Makefile.libretro ${COMPILER} USE_DYNAREC=1 2>&1 | tee makefile.log
       make -f Makefile 2>&1 | tee makefile.log
       [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Playstation 1 LibretroCore pcsx_rearmed!"
       [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.pcsx_rearmedlibretro
    else
       __ERRMSGS="Could not successfully configure Playstation 1 LibretroCore pcsx_rearmed!"
    fi

    popd
}

function copy_a_pcsx_rearmedlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/pcsx_rearmed_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/pcsx_rearmed/ -name $so_filter) && cp $file $outfile
    #find $rootdir/emulatorcores/pcsx_rearmed/ -name $so_filter | xargs cp -t $outputdir
}
