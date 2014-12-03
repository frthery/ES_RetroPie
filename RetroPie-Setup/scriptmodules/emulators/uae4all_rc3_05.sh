rp_module_id="uae4all_rc3_05"
rp_module_desc="AMIGA emulator uae4all-src-rc3.chips.0.5"
rp_module_menus="2+"

#function depends_uae4all_rc3_05() {
    #rps_checkNeededPackages libsdl1.2-dev libsdl-mixer1.2-dev libasound2-dev
#}

function sources_uae4all_rc3_05() {
    #kick.rom: http://misapuntesde.com/res/Amiga_roms.zip
    #http://www.armigaproject.com/pi/uae4armiga4pi.tar.gz
    #http://fdarcel.free.fr/uae4all-src-rc3.chips.0.5.tar.bz2
    #ftp://researchlab.spdns.de/rpi/uae4all2/uae4all2-2.3.5.3rpi.tgz

    rmDirExists "$rootdir/emulators/uae4all_rc3_05"
    #mkdir "$rootdir/emulators/uae4all_rc3_05"
    #pushd "$rootdir/emulators/uae4all_rc3_05"
	[ -f uae4all-src-rc3.chips.0.5.tar.bz2 ] && rm uae4all-src-rc3.chips.0.5.tar.bz2
    wget http://fdarcel.free.fr/uae4all-src-rc3.chips.0.5.tar.bz2
    tar xjvf uae4all-src-rc3.chips.0.5.tar.bz2 -C "$rootdir/emulators/" && rm uae4all-src-rc3.chips.0.5.tar.bz2
    mv "$rootdir/emulators/uae4all-rpi" "$rootdir/emulators/uae4all_rc3_05"
    #popd
}

function configure_uae4all_rc3_05() {
    mkdir -p $romdir/amiga

    #startAmigaDisk.sh
    wget https://raw.githubusercontent.com/frthery/ES_RetroPie/master/RetroPie-Setup/supplementary/startAmigaDisk.sh
    mv startAmigaDisk.sh "$rootdir/emulators/uae4all_rc3_05/"

    chmod 755 "$rootdir/emulators/uae4all_rc3_05/startAmigaDisk.sh"
    chown -R pi:pi "$rootdir/emulators/uae4all_rc3_05"

    #rps_retronet_prepareConfig
    #setESSystem "Amiga" "amiga" "~/RetroPie/roms/amiga" ".adf .ADF" "$rootdir/emulators/uae4all_rc3_05/startAmigaDisk.sh %ROM%" "amiga" "amiga"
}