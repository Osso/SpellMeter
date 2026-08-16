#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target=/syncthing/World of Warcraft/_retail_/Interface/AddOns/SpellMeter

rm -rf "$target"
mkdir -p "$target"
cp "$project_dir/SpellMeter.toc" "$target/"
cp "$project_dir/SpellMeter.lua" "$target/"
cp "$project_dir/SpellMeterModel.lua" "$target/"
cp "$project_dir/SpellMeterRows.lua" "$target/"

printf 'Installed SpellMeter at %s\n' "$target"
