# Modernized Battle Messages

## Description
Do you find pressing through "It's super effective!" and other messages of its ilk to be tedious? This plugin replaces some of them with succinct animations to make battles feel snappier and less of a button masher.

## Installation
1. Download `ZVBattleMessages.psdkplug` and `193208.csv` from the newest release in **[Releases](https://github.com/zhec9p/modernized-battle-messages/releases)**.
2. Place `193208.csv` in `YOUR_PROJECT_ROOT/Data/Text/Dialogs`.
3. Place `ZVBattleMessages.psdkplug` in `YOUR_PROJECT_ROOT/scripts`.
4. Open `YOUR_PROJECT_ROOT/cmd.bat`. This will bring up a command prompt.
5. In the command prompt, type `psdk --util=plugin load` and press Enter,

After installing the plugin, you can open `YOUR_PROJECT_ROOT/Data/configs/plugins/zv_battle_msg_config.json` to see which battle messages are modernized and disable any you wish. `YOUR_PROJECT_ROOT/scripts/00000 Plugins/NNNNN ZVBattleMessages/01 General/001 Config.rb` has comments on what each setting in the JSON file does.

Uninstalling the plugin doesn't remove the CSV file.

> [!NOTE]
> If you're already using the `193208.csv` filename for a different file, then you can rename this plugin's CSV file to a different `1NNNNN.csv` file. Change the number in the `csv_id` field in this plugin's JSON config file to the `NNNNN` number you picked.

## Limitations
The animations in this plugin are currently meant for 2D battle mode.

## Dependencies
None.

## Credits
#### Plugin Creator
- zhec

#### External Assets
- Clock, ticking by natalie -- https://commons.wikimedia.org/wiki/File:Clock_ticking.ogg
- BELL.wav by kgeshev -- https://freesound.org/s/378799/

#### Special Thanks
- Aelysya for the French translations.
