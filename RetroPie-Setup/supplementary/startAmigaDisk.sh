#!/bin/bash
filename=$1
echo "File: ["$filename"]"

pushd "/opt/retropie/emulators/uae4all_rc3_05/"
if [[ -f "df0.adf" ]]; then
   sudo rm df0.adf
fi
ln -s "$filename" df0.adf

./uae4all_cyclone -s floppy0=df0.adf
popd
