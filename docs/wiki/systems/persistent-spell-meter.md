# Persistent spell meter runtime

SpellMeter requests the local player's current-session spell data from `C_DamageMeter.GetCombatSessionSourceFromType`. Damage mode uses `Enum.DamageMeterType.Dps`; healing mode uses `Enum.DamageMeterType.Hps`.

During combat, Blizzard marks returned values secret. `SpellMeterRows.lua` therefore preserves API order and sends values directly to `FontString` and `StatusBar` methods. It never compares, formats, sorts, or performs arithmetic on spell amounts.

The window refreshes on Blizzard Damage Meter current-session updates and resets. Account-wide `SpellMeterDB` stores mode, visibility, and anchor coordinates.
