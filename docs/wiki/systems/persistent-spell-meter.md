# Persistent spell meter runtime

SpellMeter requests the local player's current-session spell data from `C_DamageMeter.GetCombatSessionSourceFromType`. Damage mode uses `Enum.DamageMeterType.Dps`; healing mode uses `Enum.DamageMeterType.Hps`. The window renders the first ten entries in Blizzard's returned order, with each row's full-color icon, spell name, and per-second value visible above its meter bar. Icons use a foreground frame so the bar cannot cover or tint them. Hovering an icon shows the matching spell tooltip; leaving the icon hides it.

During combat, Blizzard marks returned values, including spell IDs, secret. `SpellMeterRows.lua` preserves API order, formats only the displayed per-second value to zero decimal places through `FontString:SetFormattedText`, and sends total amounts directly to `StatusBar` methods. The icon tooltip handler forwards `row.spellID` directly to `Tooltip:SetSpellByID`; it does not test, compare, convert, or otherwise inspect that secret ID. The addon never compares, sorts, or performs arithmetic on secret combat values.

The window refreshes on `PLAYER_ENTERING_WORLD`, `DAMAGE_METER_CURRENT_SESSION_UPDATED`, `DAMAGE_METER_COMBAT_SESSION_UPDATED`, and `DAMAGE_METER_RESET`, so visible spell rows update during live combat as Blizzard publishes session changes. The mode button switches between DPS and HPS; dragging saves the anchor, and the close button or `/spellmeter` command hides or shows the window during the current UI session. Visibility is not saved: every reload or login starts visible, including when legacy `SpellMeterDB.shown = false` exists. Account-wide `SpellMeterDB` stores mode and anchor coordinates.

## CurseForge packaging

The root `.pkgmeta` packages the addon as `SpellMeter`, includes the four runtime files listed by `SpellMeter.toc`, excludes repository-only documentation, project artwork, tests, unit fixtures, and scripts, and disables no-library package creation because the addon has no externals. `CHANGELOG.md` is supplied as the Markdown manual changelog. The project is licensed under MIT (`LICENSE`), and `assets/curseforge-logo.png` is the stylized DPS-bar CurseForge icon excluded from the addon archive.

## CurseForge publication status

- Upload API token: provisioned through the protected local credentials path; its value is not recorded here.
- Project ID: `1651789` under `ossoleil`.
- License: MIT.
- Third-party distribution: enabled.
- Source: public GitHub repository `Osso/SpellMeter`.
- Version `0.1.1` was uploaded exactly once with `curseforge upload` through the documented Upload API.
- Release file: `8665107`, release type `release`, game version `12.1.0`.
- Release commit: `44a0dc9945ddf854705bd2eba145a73873c70b7c`.
- No `0.1.1` Git tag or tag-packaging build was used.
- Archive verification: `9,103` bytes, SHA-256 `7e623d44efb4cc32967e7ac5d323c4060dae303cb6f5a741bd12713e9f8dac85`; exactly four runtime files, each byte-identical to the release commit.
- Project presentation uses the DPS-bar icon and includes `SpellMeter-DPS.png` in the media gallery.
