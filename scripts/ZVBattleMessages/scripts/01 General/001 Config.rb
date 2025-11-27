module Configs
  module Project
    class ZVBattleMsg
      # Main directory name for assets in the following paths:
      # - graphics/animations/
      # - audio/se/
      # @return [String]
      attr_accessor :dir_name

      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Replaces the message displayed for super-effective and not-very-effective hits with a corresponding popup animation
      # @return [Boolean]
      attr_writer :replace_effectiveness

      # Replaces the message displayed for a critical hit with a popup animation
      # @return [Boolean]
      attr_writer :replace_critical_hit

      # Replaces the message displayed when a move doesn't affect a battler with a popup animation
      # @return [Boolean]
      attr_writer :replace_unaffected

      # Replaces the message displayed when an attack misses with a popup and battler animation
      # @return [Boolean]
      attr_writer :replace_miss

      # Replaces the message displayed when a battler's stat stage changes with a popup animation. This also speeds up
      # the vanilla stat change animation, which the popup will overlap with
      # @return [Boolean]
      attr_writer :replace_stat_change

      # Replaces the message displayed for a battler's perish count with a custom animation
      # @return [Boolean]
      attr_writer :replace_perish

      def initialize
        @dir_name              = 'zv-battle-messages'
        @csv_id                = 93_208
        @replace_effectiveness = true
        @replace_critical_hit  = true
        @replace_unaffected    = true
        @replace_miss          = true
        @replace_stat_change   = true
        @replace_perish        = true
      end

      # Show any of the plugin animations?
      # @return [Boolean]
      def show_animation?
        return $options.show_animation
      end

      def replace_effectiveness? = show_animation? && @replace_effectiveness
      def replace_critical_hit?  = show_animation? && @replace_critical_hit
      def replace_unaffected?    = show_animation? && @replace_unaffected
      def replace_miss?          = show_animation? && @replace_miss
      def replace_stat_change?   = show_animation? && @replace_stat_change
      def replace_perish?        = show_animation? && @replace_perish
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
