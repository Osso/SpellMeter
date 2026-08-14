# Persistent spell meter runtime

SpellMeter requests the local player's current-session spell data from `C_DamageMeter.GetCombatSessionSourceFromType`. Damage mode uses `Enum.DamageMeterType.Dps`; healing mode uses `Enum.DamageMeterType.Hps`. The window renders the first ten entries in Blizzard's returned order, with each row's full-color icon, spell name, and per-second value visible above its meter bar. Icons use a foreground frame so the bar cannot cover or tint them. Hovering an icon shows the matching spell tooltip; leaving the icon hides it.

During combat, Blizzard marks returned values, including spell IDs, secret. `SpellMeterRows.lua` preserves API order, formats only the displayed per-second value to zero decimal places through `FontString:SetFormattedText`, and sends total amounts directly to `StatusBar` methods. The icon tooltip handler forwards `row.spellID` directly to `Tooltip:SetSpellByID`; it does not test, compare, convert, or otherwise inspect that secret ID. The addon never compares, sorts, or performs arithmetic on secret combat values.

The window refreshes on `PLAYER_ENTERING_WORLD`, `DAMAGE_METER_CURRENT_SESSION_UPDATED`, `DAMAGE_METER_COMBAT_SESSION_UPDATED`, and `DAMAGE_METER_RESET`, so visible spell rows update during live combat as Blizzard publishes session changes. The mode button switches between DPS and HPS; dragging saves the anchor, and the close button or `/spellmeter` command controls visibility. Account-wide `SpellMeterDB` stores mode, visibility, and anchor coordinates.

## CurseForge packaging

The root `.pkgmeta` packages the addon as `SpellMeter`, includes the four runtime files listed by `SpellMeter.toc`, excludes repository-only documentation, project artwork, tests, unit fixtures, and scripts, and disables no-library package creation because the addon has no externals. `CHANGELOG.md` is supplied as the Markdown manual changelog. The project is licensed under MIT (`LICENSE`), and `assets/curseforge-logo.png` is the CurseForge project artwork excluded from the addon archive.

## CurseForge publication status

- Upload API token: provisioned through the protected local credentials path; its value is not recorded here.
- Project ID: not yet recorded; project creation remains outstanding.
- GitHub packaging webhook: not yet configured or verified.
- CurseForge 0.1.0 publication: not yet submitted or verified.
