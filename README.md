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

Retail marks live combat-meter values and spell IDs secret during combat. SpellMeter forwards those values directly to Blizzard UI sinks and tooltip APIs without inspecting, comparing, or converting them. It rounds only the displayed per-second value to a whole number, cannot calculate a custom rolling five-second window, and cannot sort rows numerically. Rows retain Blizzard's order; they are not independently ranked by SpellMeter.

## CurseForge packaging

The root `.pkgmeta` packages the addon as `SpellMeter` with only the four runtime files from `SpellMeter.toc`. It excludes repository documentation, project artwork, tests, unit fixtures, and local scripts. `CHANGELOG.md` is the Markdown manual changelog; no external libraries are bundled. CurseForge project artwork lives at `assets/curseforge-logo.png`.

## License

SpellMeter is available under the [MIT License](LICENSE).

## CurseForge publication status

The CurseForge project is `1651789` under `ossoleil`, with MIT licensing and third-party distribution enabled. Its source points to `Osso/SpellMeter`, automatic packaging is limited to tagged commits, and GitHub push webhook `665556362` is active with redacted query parameters. The project is new and unapproved with no file yet. Remaining work is the tag-triggered 0.1.0 package, followed by moderation and file verification.

## Development

```sh
./run-tests.sh
```
