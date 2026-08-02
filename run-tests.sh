#!/bin/sh
set -eu

lua unit/run.lua
luac -p SpellMeterModel.lua SpellMeterRows.lua SpellMeter.lua
