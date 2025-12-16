module Configs
  module Project
    class ZVBattleMsg
      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Prefix name for this plugin's assets, used in the following ways:
      # - graphics/animations/$PREFIX/* (Here, prefix is the subfolder name)
      # - audio/se/$PREFIX-* (Here, prefix is the prefix of the filenames, followed by '-')
      # @return [String]
      attr_accessor :prefix

      # Replace the messages displayed for super-effective and not-very-effective hits with popup animations?
      # @return [Boolean]
      attr_accessor :replace_effectiveness

      # Replace the message displayed for a critical hit with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_critical_hit

      # Replace the message displayed when a move doesn't affect a battler with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_unaffected

      # Replace the message displayed when an attack misses with a popup and battler animation?
      # @return [Boolean]
      attr_accessor :replace_miss

      # Replace the message displayed when a battler's stat stage changes with a popup animation?
      # @return [Boolean]
      # @note This also speeds up the vanilla stat change animation, which the popup will overlap with.
      attr_accessor :replace_stat_change

      # Replace the message displayed for a battler's perish count with a custom animation?
      # @return [Boolean]
      attr_accessor :replace_perish

      # @param filename [String]
      # @return [String]
      def animation_path(filename)
        return File.join(prefix, filename)
      end

      # @param filename [String]
      # @return [String]
      def se_path(filename)
        return "#{prefix}-#{filename}"
      end

      def initialize
        self.csv_id                = 93_208
        self.prefix                = 'zv-battle-messages'
        self.replace_effectiveness = true
        self.replace_critical_hit  = true
        self.replace_unaffected    = true
        self.replace_miss          = true
        self.replace_stat_change   = true
        self.replace_perish        = true
      end
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
