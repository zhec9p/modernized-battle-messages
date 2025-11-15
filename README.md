# Modernized Battle Messages for PSDK

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Credits](#credits)

## Overview
Do you find pressing through "It's super effective!" and other messages of its ilk to be tedious? This plugin replaces some of them with succinct animations to make battles feel snappier and less of a button masher.

The following replacements are available and can be enabled or disabled in `Data/configs/plugins/zv_battle_msg_config.json` from your project's root folder.

- `replace_effectiveness`: Replaces the message displayed for super-effective and not-very-effective hits with a corresponding popup animation.

- `replace_critical_hit`: Replaces the message displayed for a critical hit with a popup animation.

- `replace_unaffected`: Replaces the message displayed when a move doesn't affect a battler with a popup and battler sprite animation.

- `replace_stat_change`: Replaces the message displayed when a battler's stat stage changes with a popup animation. This also speeds up the vanilla stat change animation, which the popup will overlap with.

- `replace_miss`: Replaces the message displayed when an attack misses with a popup and battler sprite animation.

- `replace_perish`: Replaces the message displayed for a battler's perish count with a custom animation.

## Installation
To install:
1. Download `ZVBattleMessages.psdkplug` and `193208.csv` from the [newest release](https://github.com/zhec9p/modernized-battle-messages/releases/latest).
2. Place the downloaded .psdkplug file in the `scripts` subdirectory of your project's root folder.
3. Open the `cmd.bat` file located in your project's root folder. This will bring up a command prompt.
4. In the command prompt, type `psdk --util=plugin load` and press Enter.
5. Place the downloaded .csv file in the `Data/Text/Dialogs` folder path from your project's root folder.

> [!NOTE]
> If you're already using the `193208.csv` filename for a different file, then you can rename this plugin's CSV file to a different `1NNNNN.csv` file. Change the number in the `csv_id` field in this plugin's JSON config file to the `NNNNN` number you picked.

To uninstall:
1. Delete `ZVBattleMessages.psdkplug` from the `scripts` subdirectory of your project's root folder
2. Open the `cmd.bat` file located in your project's root folder. Enter in `psdk --util=plugin load`. Enter "Y" when asked whether to remove the files added by the plugin.
3. Delete `193208.csv` or whatever you named that CSV file from `YOUR_PROJECT_ROOT/Data/Text/Dialogs`.

## Dependencies
- PSDK 26.48 or newer

## Credits
#### Plugin Creator
- zhec

#### External Assets
- Clock, ticking by natalie -- https://commons.wikimedia.org/wiki/File:Clock_ticking.ogg
- BELL.wav by kgeshev -- https://freesound.org/s/378799/

#### Special Thanks
- Aelysya for the French translations
