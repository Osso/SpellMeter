# SpellMeter

SpellMeter keeps World of Warcraft Retail's live per-spell DPS or HPS breakdown visible in a movable window. It reads Blizzard's supported Damage Meter API, so it works with Retail's restricted instance-combat data.

## Features

- Persistent ordered spell bars for the current player's combat session
- Full-color spell icon, name, and whole-number per-second value rendered above each bar
- Hovering an icon shows its matching spell tooltip; leaving hides the tooltip
- DPS/HPS mode switch
- Blizzard-provided per-second values refreshed during live combat updates
- Saved window position and selected mode; session-only visibility
- `/spellmeter` toggles the window

## Use

- Drag the window to move it; its position is saved.
- Click the mode button to switch between DPS and HPS.
- Hover a spell icon to show its matching spell tooltip; move away to hide it.
- Click the close button or run `/spellmeter` to hide or show it during the current UI session. Visibility is not saved: every reload or login starts visible, including with legacy `SpellMeterDB.shown = false`; mode and position remain saved.
- The window displays up to ten spell rows in Blizzard's order.

## Install

Run:

```sh
./deploy.sh
```

This transfers exactly the four runtime files over SSH host `alessio-desktop` into:

```text
C:\World of Warcraft\_retail_\Interface\AddOns\SpellMeter
```

The configured SSH host must be reachable. Reload WoW with `/reload` after installation.

## Limitations

Retail marks live combat-meter values and spell IDs secret during combat. SpellMeter forwards those values directly to Blizzard UI sinks and tooltip APIs without inspecting, comparing, or converting them. It rounds only the displayed per-second value to a whole number, cannot calculate a custom rolling five-second window, and cannot sort rows numerically. Rows retain Blizzard's order; they are not independently ranked by SpellMeter.

## CurseForge packaging

The root `.pkgmeta` packages the addon as `SpellMeter` with only the four runtime files from `SpellMeter.toc`. It excludes repository documentation, project artwork, tests, unit fixtures, and local scripts. `CHANGELOG.md` is the Markdown manual changelog; no external libraries are bundled. The CurseForge icon is a stylized DPS-bar graphic at `assets/curseforge-logo.png`; it is excluded from the addon archive.

## License

SpellMeter is available under the [MIT License](LICENSE).

## CurseForge publication status

The CurseForge project is `1651789` under `ossoleil`, with MIT licensing and third-party distribution enabled. Its source points to `Osso/SpellMeter`; the GitHub push webhook `665556362` remains documented separately from the current direct upload. Version `0.1.1` was uploaded exactly once with `curseforge upload` through the documented Upload API, producing release file `8665107` for Retail `12.1.0` from commit `44a0dc9945ddf854705bd2eba145a73873c70b7c`. No `0.1.1` Git tag or tag-packaging build was used. The archive is 9,103 bytes with SHA-256 `7e623d44efb4cc32967e7ac5d323c4060dae303cb6f5a741bd12713e9f8dac85` and contains exactly the four runtime files, each byte-matching that commit. The project uses the DPS-bar icon and includes `SpellMeter-DPS.png` in its media gallery.

## Development

```sh
./run-tests.sh
```

This runs unit, Lua syntax, and wow-sim behavioral tests against an isolated committed legacy SavedVariables fixture. It defaults to `../wow-ui-sim/target/debug/wow-sim`; set `WOW_SIM_BIN` for an explicit override. It never reads or writes live WoW state.
