# Persistent spell meter

SpellMeter provides a persistent player spell breakdown for World of Warcraft Retail. Source lives in the repository root.

## What it must do

- [x] Switch between Blizzard's DPS and HPS meter types.
- [x] Preserve Blizzard's spell order.
- [x] Pass secret per-second and total values directly to supported UI sinks without arithmetic.
- [x] Display each per-second DPS/HPS value rounded to zero decimal places.
- [x] Render each spell icon above its meter bar without desaturation.
- [x] Show the matching spell tooltip while hovering an icon and hide it when leaving.
- [x] Preserve valid saved mode and position settings while replacing invalid values.
- [x] Refresh the visible window from current-player combat-session updates.
- [x] Start visible on every reload or login, including when legacy `SpellMeterDB.shown = false` exists; keep close-button and `/spellmeter` hide/show behavior session-only.
- [ ] Restore its saved screen position after reload.

## How it works

- [Runtime design](../wiki/systems/persistent-spell-meter.md)

## Implementation inventory

- `SpellMeter.lua` — window, events, Blizzard API integration, tooltip forwarding, and saved state.
- `SpellMeterModel.lua` — mode and settings behavior.
- `SpellMeterRows.lua` — secret-safe row binding.
- `SpellMeter.toc` — Retail addon manifest.
- `.pkgmeta` — CurseForge package name, runtime-file exclusions, manual changelog, and no-library package setting.
- `CHANGELOG.md` — Markdown release notes for the published package.
- `LICENSE` — MIT license for the project.
- `assets/curseforge-logo.png` — stylized DPS-bar CurseForge icon, excluded from the addon archive.
- `deploy.sh` — transfers the four runtime files over SSH to the active Retail AddOns directory.

## Tests asserting this spec

- `unit/run.lua`
- `tests/smoke.lua`
- `tests/legacy_startup.lua`
- `tests/deploy.sh`
- `tests/fixtures/wtf/Account/SpellMeterRegression/SavedVariables/SpellMeter.lua` — committed legacy hidden-state fixture
- `run-tests.sh`

## CurseForge publication status

- Project ID: `1651789`, created under `ossoleil`.
- License: MIT.
- Third-party distribution: enabled.
- Source: public GitHub repository `Osso/SpellMeter`.
- Version `0.1.1` was uploaded exactly once with `curseforge upload` through the documented Upload API.
- Release file: `8665107`, release type `release`, game version `12.1.0`.
- Release commit: `44a0dc9945ddf854705bd2eba145a73873c70b7c`.
- No `0.1.1` Git tag or tag-packaging build was used.
- Archive verification: `9,103` bytes, SHA-256 `7e623d44efb4cc32967e7ac5d323c4060dae303cb6f5a741bd12713e9f8dac85`; exactly four runtime files, each byte-identical to the release commit.
- The project uses the DPS-bar icon and includes `SpellMeter-DPS.png` in the media gallery.

## Known gaps (current cycle)

CurseForge token provisioning is complete; the secret value is not recorded here.

- [x] Prove addon loading and persistent rendering in a simulator or live Retail client.
- [x] Create the CurseForge project and record its project ID.
- [x] Configure and verify the GitHub push packaging webhook.
- [x] Submit and verify the direct-upload CurseForge 0.1.1 package.

## Out of scope

- True rolling five-second calculations: Retail blocks arithmetic on secret combat values.
- Custom combat-log parsing.
- Other players, historical sessions, and advanced appearance settings.
