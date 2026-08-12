# Persistent spell meter

SpellMeter provides a persistent player spell breakdown for World of Warcraft Retail. Source lives in the repository root.

## What it must do

- [x] Switch between Blizzard's DPS and HPS meter types.
- [x] Preserve Blizzard's spell order.
- [x] Pass secret per-second and total values directly to supported UI sinks without arithmetic.
- [x] Display each per-second DPS/HPS value rounded to zero decimal places.
- [x] Render each spell icon above its meter bar without desaturation.
- [x] Show the matching spell tooltip while hovering an icon and hide it when leaving.
- [x] Preserve valid saved mode, position, and visibility settings while replacing invalid values.
- [x] Refresh the visible window from current-player combat-session updates.
- [ ] Remain visible until the user closes or toggles it.
- [ ] Restore its saved screen position after reload.

## How it works

- [Runtime design](../wiki/systems/persistent-spell-meter.md)

## Implementation inventory

- `SpellMeter.lua` — window, events, Blizzard API integration, and saved state.
- `SpellMeterModel.lua` — mode and settings behavior.
- `SpellMeterRows.lua` — secret-safe row binding.
- `SpellMeter.toc` — Retail addon manifest.
- `deploy.sh` — local AddOns installation.

## Tests asserting this spec

- `unit/run.lua`
- `tests/smoke.lua`
- `run-tests.sh`

## Known gaps (current cycle)

- [x] Prove addon loading and persistent rendering in a simulator or live Retail client.

## Out of scope

- True rolling five-second calculations: Retail blocks arithmetic on secret combat values.
- Custom combat-log parsing.
- Other players, historical sessions, and advanced appearance settings.
