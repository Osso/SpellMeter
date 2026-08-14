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

- `SpellMeter.lua` — window, events, Blizzard API integration, tooltip forwarding, and saved state.
- `SpellMeterModel.lua` — mode and settings behavior.
- `SpellMeterRows.lua` — secret-safe row binding.
- `SpellMeter.toc` — Retail addon manifest.
- `.pkgmeta` — CurseForge package name, runtime-file exclusions, manual changelog, and no-library package setting.
- `CHANGELOG.md` — Markdown release notes for the published package.
- `LICENSE` — MIT license for the project.
- `assets/curseforge-logo.png` — CurseForge project artwork, excluded from the addon archive.
- `deploy.sh` — local AddOns installation.

## Tests asserting this spec

- `unit/run.lua`
- `tests/smoke.lua`
- `run-tests.sh`

## CurseForge publication status

- Project ID: `1651789`, created under `ossoleil`.
- License: MIT.
- Third-party distribution: enabled.
- Source: public GitHub repository `Osso/SpellMeter`; automatic packaging is limited to tagged commits.
- GitHub push webhook: ID `665556362`, active; query parameters are intentionally redacted.
- Project state: new and unapproved; no file has been submitted yet.
- Remaining work: create the tag-triggered 0.1.0 package, then complete CurseForge moderation and file verification.

## Known gaps (current cycle)

CurseForge token provisioning is complete; the secret value is not recorded here.

- [x] Prove addon loading and persistent rendering in a simulator or live Retail client.
- [x] Create the CurseForge project and record its project ID.
- [x] Configure the GitHub push packaging webhook.
- [ ] Create the tag-triggered CurseForge 0.1.0 package and complete moderation/file verification.

## Out of scope

- True rolling five-second calculations: Retail blocks arithmetic on secret combat values.
- Custom combat-log parsing.
- Other players, historical sessions, and advanced appearance settings.
