#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$project_dir"

wow_sim_bin=${WOW_SIM_BIN:-"$project_dir/../wow-ui-sim/target/debug/wow-sim"}
case "$wow_sim_bin" in
    /*) ;;
    *) wow_sim_bin="$project_dir/$wow_sim_bin" ;;
esac

if [ ! -f "$wow_sim_bin" ] || [ ! -x "$wow_sim_bin" ]; then
    printf '%s\n' "SpellMeter wow-sim boundary unavailable: $wow_sim_bin" >&2
    printf '%s\n' 'Set WOW_SIM_BIN to an executable wow-sim binary; no build or network fallback is used.' >&2
    exit 1
fi

lua unit/run.lua
luac -p SpellMeterModel.lua SpellMeterRows.lua SpellMeter.lua

sim_root=$(mktemp -d "${TMPDIR:-/tmp}/spellmeter-wow-sim.XXXXXX")
cleanup() {
    rm -rf "$sim_root"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$sim_root/Interface/AddOns" "$sim_root/data"
ln -s "$project_dir" "$sim_root/Interface/AddOns/SpellMeter"
ln -s "$project_dir/../wow-ui-sim/Interface/AddOns/TestFramework" \
    "$sim_root/Interface/AddOns/TestFramework"
cp "$wow_sim_bin" "$sim_root/wow-sim"
chmod 755 "$sim_root/wow-sim"

WOW_SIM_ADDONS_PATH="$sim_root/Interface/AddOns" \
WOW_SIM_INTERFACE_PATH="$sim_root/Interface" \
WOW_SIM_WTF_PATH="$project_dir/tests/fixtures/wtf" \
WOW_SIM_WTF_ACCOUNT=SpellMeterRegression \
WOW_SIM_WTF_REALM=RegressionRealm \
WOW_SIM_WTF_CHARACTER=RegressionCharacter \
XDG_DATA_HOME="$sim_root/data" \
"$sim_root/wow-sim" run-tests SpellMeter
