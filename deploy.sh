#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
remote_destination='alessio-desktop:C:/World of Warcraft/_retail_/Interface/AddOns/SpellMeter/'

ssh alessio-desktop powershell.exe -NoProfile -NonInteractive -Command - <<'POWERSHELL'
$ErrorActionPreference = "Stop"
$addonDirectory = "C:\World of Warcraft\_retail_\Interface\AddOns\SpellMeter"
if (Test-Path -LiteralPath $addonDirectory) {
    Remove-Item -LiteralPath $addonDirectory -Recurse -Force
}
New-Item -ItemType Directory -Path $addonDirectory -Force | Out-Null
POWERSHELL

scp \
    "$project_dir/SpellMeter.toc" \
    "$project_dir/SpellMeter.lua" \
    "$project_dir/SpellMeterModel.lua" \
    "$project_dir/SpellMeterRows.lua" \
    "$remote_destination"

printf 'Installed SpellMeter at %s\n' "$remote_destination"
