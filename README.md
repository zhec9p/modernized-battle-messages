# Modernized Battle Messages for PSDK
> [!WARNING]
> If your PSDK version is 26.50 or newer, and the version of this plugin you're using is v0.4.0 or older, then you must upgrade your plugin to the latest version. Please uninstall your older version of the plugin before installing the latest.

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Settings](#settings)
- [Credits](#credits)

## Overview
Do you find pressing through "It's super effective!" and other messages like it to be tedious? This PSDK plugin replaces some of them with concise animations to make battles feel snappier and less of a button masher.

## Installation
To install:
1. Download `ZVBattleMessages.psdkplug` and `193208.csv` from the [newest release](https://github.com/zhec9p/modernized-battle-messages/releases/latest).
2. Put the downloaded .psdkplug file in the `scripts` folder in your project.
3. Open the `cmd.bat` file in your project. This will bring up a command prompt.
4. Enter `psdk --util=plugin load` in the command prompt.
5. Put the downloaded .csv file in the `Data/Text/Dialogs` folder in your project.

> [!NOTE]
> If you're already using the `193208.csv` filename for a different file, then you can rename this plugin's CSV file to a different `1NNNNN.csv` file. Change the number in the `csv_id` field in this plugin's JSON config file to the `NNNNN` number you picked.

To uninstall:
1. Delete `ZVBattleMessages.psdkplug` from the `scripts` folder in your project.
2. Open the `cmd.bat` file in your project. This will bring up a command prompt.
3. Enter `psdk --util=plugin load` in the command prompt. Enter `Y` when asked whether to remove the files added by the plugin.
3. Delete `193208.csv` or whatever you named that CSV file from the `Data/Text/Dialogs` folder in your project.

## Dependencies
- PSDK 26.50 or newer

## Languages
- English
- French

## Settings
The following settings are available in the `Data/configs/plugins/zv_battle_msg_config.json` file in your project.

```json
{
  "csv_id": 93208,
  "prefix": "zv-battle-messages",

  "replace_effectiveness": true,
  "replace_critical_hit": true,
  "replace_unaffected": true,
  "replace_miss": true,
  "replace_stat_change": true,
  "replace_perish": true,

  "damage_numbers": {
    "enable": true,
    "measurement": "percent",
    "unit_text": "",
    "font_id": 0,
    "outline_size": 1,
    "hurt_color": 9,
    "heal_color": 13
  },

  "silence_messages": {
    "enable": true,
    "messages": [
      {
        "csv_id": 19,
        "text_id": 243,
        "note": "poison/toxic status end of turn"
      },
      {
        "csv_id": 19,
        "text_id": 261,
        "note": "burn status end of turn"
      },
      {
        "csv_id": 19,
        "text_id": 905,
        "note": "standard energy drain"
      }
    ]
  }
}
```

| Key | Expected Value | Default Value | Description |
| -- | -- | -- | -- |
| **`csv_id`** | Integer $⊆$ [0, 99999] | 93208 | ID of this plugin's CSV file. |
| **`prefix`** | String | "zv-battle-messages" | Subfolder name for this plugin's animation assets. For example, if you set `prefix` to `"zv-battle-messages"`, then the plugin will pull graphics files from the `graphics/animations/zv-battle-messages/` folder.<br/><br/> Filename prefix for this plugin's SE assets, followed by a `-` character. For example, if you set `prefix` to `"zv-battle-messages"`, then the plugin will pull SE files that begin with `zv-battle-messages-` from the `audio/se/` folder.<br/><br/>The purpose of this setting is to tell the plugin to use your custom asset files. This prevents the need to overwrite the plugin's provided assets with yours and risking deletion of your custom assets when reinstalling or uninstalling this plugin.
| **`replace_effectiveness`** | Boolean | `true` | Replaces the message displayed for super-effective and not-very-effective hits with a corresponding popup animation. |
| **`replace_critical_hit`** | Boolean | `true` | Replaces the message displayed for a critical hit with a popup animation. |
| **`replace_unaffected`** | Boolean | `true` | Replaces the message displayed when a move doesn't affect a battler with a popup animation. |
| **`replace_stat_change`** | Boolean | `true` | Replaces the message displayed when a battler's stat stage changes with a popup animation. This also speeds up the vanilla stat change animation, which the popup will overlap with. |
| **`replace_miss`** | Boolean | `true` | Replaces the message displayed when an attack misses with a popup and battler sprite animations. |
| **`replace_perish`** | Boolean | `true` | Replaces the message displayed for a battler's perish count with a custom animation. |
| **`damage_numbers`** |  [Damage Numbers](#damage-numbers) | [Damage Numbers](#damage-numbers) | Displays floating damage numbers for battlers losing or regaining health. |
| **`silence_messages`** | [Silence Messages](#silence-messages) | *[Silence Messages](#silence-messages)* | Prevents specific messages from being shown in the battle scene's dialogue window. |

#### Damage Numbers
The **`damage_numbers`** field in the JSON config file expects an object with the following key-value pairs.

| Key | Expected Value | Default Value | Description |
| -- | -- | -- | -- |
| **`enable`** | Boolean | `true` | Whether to enable this feature. |
| **`measurement`** | "percent",<br/>"points" | "percent" | Measurement to use for health lost/restored displayed.<br/><br/>`"percent"` displays them as percentages rounded to the nearest whole number, e.g., 25%.<br/><br/>`"points"` displays them as an exact HP quantity, e.g. 50 HP. |
| **`unit_text`** | String | "" | Text to use for the unit. Use an empty string for a unitless number, e.g., 25 instead of 25% or 50 instead of 50 HP in the above example. |
| **`font_id`** | Integer | 0 | Font ID based on your project's Studio settings |
| **`outline_size`** | Integer,<br/>null | 1 | Size of the text outline. |
| **`hurt_color`** | Integer | 9 | Color ID for health lost based on the `graphics/windowskins/_colors.png` file in your project. |
| **`heal_color`** | Integer | 13 | Color ID for health restored based on `graphics/windowskins/_colors.png` file in your project. |

#### Silence Messages
The **`silence_messages`** field in the JSON config file expects an object with the following key-value pairs.

- **`enable`**, which is whether to enable this feature (default: `true`)
- **`messages`** which is a list of messages to prevent displaying in the battle scene. This list is an array of objects. Each object represents a message and has the following key-value pairs.

  | Key | Expected Value | Description |
  | -- | -- | -- |
  | **`csv_id`** | Integer | The ID of the CSV file where the message is located
  | **`text_id`** | Integer | The text ID in the CSV file where the message is located
  | **`note`** | String | An optional personal note.

## Credits
#### Plugin Creator
- zhec

#### External Assets
- Clock, ticking by natalie -- https://commons.wikimedia.org/wiki/File:Clock_ticking.ogg
- BELL.wav by kgeshev -- https://freesound.org/s/378799/

#### Special Thanks
- Aelysya for the French translations
