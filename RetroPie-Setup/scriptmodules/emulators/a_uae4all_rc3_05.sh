rp_module_id="a_uae4all_rc3_05"
rp_module_desc="AMIGA emulator uae4all-src-rc3.chips.0.5 (Additional)"
rp_module_menus="2+"

function depends_a_uae4all_rc3_05() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libasound2-dev
}

function sources_a_uae4all_rc3_05() {
    #kick.rom: http://misapuntesde.com/res/Amiga_roms.zip
    #http://www.armigaproject.com/pi/uae4armiga4pi.tar.gz
    #http://fdarcel.free.fr/uae4all-src-rc3.chips.0.5.tar.bz2
    #ftp://researchlab.spdns.de/rpi/uae4all2/uae4all2-2.3.5.3rpi.tgz

    rmDirExists "$rootdir/emulators/uae4all_rc3_05"
    [ ! -d tmp ] && mkdir tmp
    [ -f tmp/uae4all-src-rc3.chips.0.5.tar.bz2 ] && rm tmp/uae4all-src-rc3.chips.0.5.tar.bz2
    wget http://fdarcel.free.fr/uae4all-src-rc3.chips.0.5.tar.bz2 -P tmp
    tar xjvf tmp/uae4all-src-rc3.chips.0.5.tar.bz2 -C "$rootdir/emulators/" && rm tmp/uae4all-src-rc3.chips.0.5.tar.bz2
    mv "tmp/uae4all-rpi" "$rootdir/emulators/uae4all_rc3_05"
    #popd
}

function configure_a_uae4all_rc3_05() {
    mkdir -p $romdir/amiga

    #startAmigaDisk.sh
    wget https://raw.githubusercontent.com/frthery/ES_RetroPie/master/RetroPie-Setup/supplementary/startAmigaDisk.sh -P tmp
    mv tmp/startAmigaDisk.sh "$rootdir/emulators/uae4all_rc3_05/"

    chmod 755 "$rootdir/emulators/uae4all_rc3_05/startAmigaDisk.sh"
    chown -R pi:pi "$rootdir/emulators/uae4all_rc3_05"

    #rps_retronet_prepareConfig
    #setESSystem "Amiga" "amiga" "~/RetroPie/roms/amiga" ".adf .ADF" "$rootdir/emulators/uae4all_rc3_05/startAmigaDisk.sh %ROM%" "amiga" "amiga"
}
