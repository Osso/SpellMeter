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
- `deploy.sh` — local AddOns installation.

## Tests asserting this spec

- `unit/run.lua`
- `tests/smoke.lua`
- `tests/legacy_startup.lua`
- `tests/fixtures/wtf/Account/SpellMeterRegression/SavedVariables/SpellMeter.lua` — committed legacy hidden-state fixture
- `run-tests.sh`

## CurseForge publication status

- Project ID: `1651789`, created under `ossoleil`.
- License: MIT.
- Third-party distribution: enabled.
- Source: public GitHub repository `Osso/SpellMeter`; automatic packaging is limited to tagged commits.
- Release tag: `0.1.0` at commit `e609f02031d73021457aaa799e707ef0f44510fc`.
- GitHub push webhook: ID `665556362`, active; tag delivery succeeded; query parameters are intentionally redacted.
- CurseForge builds `345260` and `345261` completed.
- CurseForge file `8644762` is release `0.1.0` for game version `12.0.7` and is **Under Review**.
- Downloaded package verification: `3,478` bytes, SHA-256 `2dd10ee561dd45143ebcfc7140bd3e6139679435d9878a48f0c63ef0163ef0fb`; exactly four runtime files, each byte-identical to source.
- Project presentation uses the DPS-bar icon and includes `SpellMeter-DPS.png` in the media gallery.
- Submission and package verification are complete. CurseForge moderation/public approval remains pending.

## Known gaps (current cycle)

CurseForge token provisioning is complete; the secret value is not recorded here.

- [x] Prove addon loading and persistent rendering in a simulator or live Retail client.
- [x] Create the CurseForge project and record its project ID.
- [x] Configure and verify the GitHub push packaging webhook.
- [x] Submit and verify the tagged CurseForge 0.1.0 package.
- [ ] Complete CurseForge moderation and public approval.

## Out of scope

- True rolling five-second calculations: Retail blocks arithmetic on secret combat values.
- Custom combat-log parsing.
- Other players, historical sessions, and advanced appearance settings.
