# Persistent spell meter runtime

SpellMeter requests the local player's current-session spell data from `C_DamageMeter.GetCombatSessionSourceFromType`. Damage mode uses `Enum.DamageMeterType.Dps`; healing mode uses `Enum.DamageMeterType.Hps`. The window renders the first ten entries in Blizzard's returned order, with each row's full-color icon, spell name, and per-second value visible above its meter bar. Icons use a foreground frame so the bar cannot cover or tint them. Hovering an icon shows the matching spell tooltip; leaving the icon hides it.

During combat, Blizzard marks returned values secret. `SpellMeterRows.lua` preserves API order, formats only the displayed per-second value to zero decimal places through `FontString:SetFormattedText`, and sends total amounts directly to `StatusBar` methods. It never compares, sorts, or performs arithmetic on spell amounts.

The window refreshes on `PLAYER_ENTERING_WORLD`, `DAMAGE_METER_CURRENT_SESSION_UPDATED`, `DAMAGE_METER_COMBAT_SESSION_UPDATED`, and `DAMAGE_METER_RESET`, so visible spell rows update during live combat as Blizzard publishes session changes. The mode button switches between DPS and HPS; dragging saves the anchor, and the close button or `/spellmeter` command controls visibility. Account-wide `SpellMeterDB` stores mode, visibility, and anchor coordinates.
