# SpellMeter

SpellMeter keeps World of Warcraft Retail's live per-spell DPS or HPS breakdown visible in a movable window. It reads Blizzard's supported Damage Meter API, so it works with Retail's restricted instance-combat data.

## Features

- Persistent ordered spell bars for the current player's combat session
- DPS/HPS mode switch
- Blizzard-provided per-second values
- Saved window position, visibility, and selected mode
- `/spellmeter` toggles the window

## Use

- Drag the window to move it; its position is saved.
- Click the mode button to switch between DPS and HPS.
- Click the close button or run `/spellmeter` to hide it; run `/spellmeter` again to show it.
- The window displays up to ten spell rows in Blizzard's order.

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

Retail marks live combat-meter values secret during combat. SpellMeter displays Blizzard's values directly but cannot calculate a custom rolling five-second window, reformat those values, or sort them numerically. Rows retain Blizzard's order; they are not independently ranked by SpellMeter.

## Development

```sh
./run-tests.sh
```
