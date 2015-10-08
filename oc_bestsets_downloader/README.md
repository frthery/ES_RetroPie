oc_bestsets_downloader.sh
=================
A script for synchronizing Open-Consoles BestSets (http://www.open-consoles.com/t7388-centralisation-les-bestsets-open-consoles).

- Install "wget https://github.com/frthery/ES_RetroPie/blob/master/oc_bestsets_downloader/oc_bestsets_downloader.sh"
- Execute "sudo chmod 755 oc_bestsets_downloader.sh"
- Edit script and change the rom path value (if necessary): ROMS_PATH=...

Usage:
======
oc_bestsets_downloader.sh [--mega-dl|--drive-dl] [--show-packages] [--deploy-seq] [--force-sync] [--local-ini]

Commands:<br/>
Synchronize: ./oc_bestsets_downloader.sh<br/>
Show available packages: ./oc_bestsets_downloader.sh --show-packages<br/>
Deploy specific packages: ./oc_bestsets_downloader.sh --deploy-seq=0,1,...<br/>

Use --force-sync argument to force local packages synchronization<br/>
Use --local-ini argument to force using your local ini file (oc_bestsets.ini)<br/>

oc_bestsets_media_downloader.sh
=================
A script for synchronizing Open-Consoles BestSets Medias.

- Install "wget https://github.com/frthery/ES_RetroPie/blob/master/oc_bestsets_downloader/oc_bestsets_media_downloader.sh"
- Execute "sudo chmod 755 oc_bestsets_media_downloader.sh"
- Edit script and change the rom path value (if necessary): ROMS_PATH=...
- Change the gamelists path value (if necessary): GAMELISTS_PATH=...
- Change the pictures path value (if necessary): PICTURES_PATH=...

