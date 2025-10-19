module Configs
  module Project
    class ZVBattleMsg
      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Replaces the message displayed for super-effective and not-very-effective hits with a corresponding popup animation
      # @return [Boolean]
      attr_accessor :replace_effectiveness

      # Replaces the message displayed for a critical hit with a popup animation
      # @return [Boolean]
      attr_accessor :replace_critical_hit

      # Replaces the message displayed when a move doesn't affect a battler with a popup and battler animation
      # @return [Boolean]
      attr_accessor :replace_unaffected

      # Replaces the message displayed when an attack misses with a popup and battler animation
      # @return [Boolean]
      attr_accessor :replace_miss

      # Replaces the message displayed when a battler's stat stage changes with a popup animation. This also speeds up
      # the vanilla stat change animation, which the popup will overlap with
      # @return [Boolean]
      attr_accessor :replace_stat_change

      # Replaces the message displayed for a battler's perish count with a custom animation
      # @return [Boolean]
      attr_accessor :replace_perish

      def initialize
        @csv_id                = 93_208
        @replace_effectiveness = true
        @replace_critical_hit  = true
        @replace_unaffected    = true
        @replace_miss          = true
        @replace_stat_change   = true
        @replace_perish        = true
      end
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
