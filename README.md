# SpellMeter

SpellMeter keeps World of Warcraft Retail's live per-spell DPS or HPS breakdown visible in a movable window. It reads Blizzard's supported Damage Meter API, so it works with Retail's restricted instance-combat data.

## Features

- Persistent ranked spell bars for the current combat session
- DPS/HPS mode switch
- Blizzard-provided per-second values
- Saved window position, visibility, and selected mode
- `/spellmeter` toggles the window

## Install

Run:

```sh
./deploy.sh
```

This installs the addon into:

```text
/syncthing/Sync/Projects/wow/Interface/AddOns/SpellMeter
```

Reload WoW with `/reload` after installation.

## Limitations

Retail marks live combat-meter values secret during combat. SpellMeter can display Blizzard's values directly but cannot calculate a custom rolling five-second window, reformat those values, or sort them numerically. Rows retain Blizzard's order.

## Development

```sh
./run-tests.sh
```
