# Persistent spell meter runtime

SpellMeter requests the local player's current-session spell data from `C_DamageMeter.GetCombatSessionSourceFromType`. Damage mode uses `Enum.DamageMeterType.Dps`; healing mode uses `Enum.DamageMeterType.Hps`. The window renders the first ten entries in Blizzard's returned order, with each row's icon, spell name, and per-second value visible over its meter bar.

During combat, Blizzard marks returned values secret. `SpellMeterRows.lua` therefore preserves API order and sends values directly to `FontString` and `StatusBar` methods. It never compares, formats, sorts, or performs arithmetic on spell amounts.

The window refreshes on `PLAYER_ENTERING_WORLD`, Blizzard Damage Meter current-session updates, and resets. The mode button switches between DPS and HPS; dragging saves the anchor, and the close button or `/spellmeter` command controls visibility. Account-wide `SpellMeterDB` stores mode, visibility, and anchor coordinates.
