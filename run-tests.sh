#!/bin/sh
set -eu

lua tests/run.lua
luac -p SpellMeterModel.lua SpellMeterRows.lua SpellMeter.lua
