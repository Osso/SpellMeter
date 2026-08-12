# SpellMeter

SpellMeter keeps World of Warcraft Retail's live per-spell DPS or HPS breakdown visible in a movable window. It reads Blizzard's supported Damage Meter API, so it works with Retail's restricted instance-combat data.

## Features

- Persistent ordered spell bars for the current player's combat session
- Full-color spell icon, name, and whole-number per-second value rendered above each bar
- Hovering an icon shows its matching spell tooltip; leaving hides the tooltip
- DPS/HPS mode switch
- Blizzard-provided per-second values refreshed during live combat updates
- Saved window position, visibility, and selected mode
- `/spellmeter` toggles the window

## Use

- Drag the window to move it; its position is saved.
- Click the mode button to switch between DPS and HPS.
- Hover a spell icon to show its matching spell tooltip; move away to hide it.
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

Retail marks live combat-meter values secret during combat. SpellMeter displays Blizzard's values directly, rounds only the displayed per-second value to a whole number, and cannot calculate a custom rolling five-second window or sort rows numerically. Rows retain Blizzard's order; they are not independently ranked by SpellMeter.

## Development

```sh
./run-tests.sh
```
