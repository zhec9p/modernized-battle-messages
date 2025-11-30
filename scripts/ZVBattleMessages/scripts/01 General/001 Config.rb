module ZVBattleMsg
  # Main directory name for assets in the following paths:
  # - graphics/animations/
  # - audio/se/
  MAIN_DIR_NAME = 'zv-battle-messages'

  # ID of this plugin's CSV file
  CSV_ID = 93_208

  # Replace the messages displayed for super-effective and not-very-effective hits with popup animations?
  REPLACE_EFFECTIVENESS = true

  # Replace the message displayed for a critical hit with a popup animation?
  REPLACE_CRITICAL_HIT = true

  # Replace the message displayed when a move doesn't affect a battler with a popup animation?
  REPLACE_UNAFFECTED = true

  # Replace the message displayed when an attack misses with a popup and battler animation?
  REPLACE_MISS = true

  # Replace the message displayed when a battler's stat stage changes with a popup animation?
  # This also speeds up the vanilla stat change animation, which the popup will overlap with.
  REPLACE_STAT_CHANGE = true

  # Replace the message displayed for a battler's perish count with a custom animation?
  REPLACE_PERISH = true
end
