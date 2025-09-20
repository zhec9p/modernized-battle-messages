module Configs
  module Project
    class ZVBattleMsg
      # Replaces the message displayed for super-effective and not-very-effective hits with a popup animation
      # @return [Boolean]
      attr_accessor :replace_effectiveness

      # Replaces the message displayed for a critical hit with a popup animation,
      # @return [Boolean]
      attr_accessor :replace_critical_hit

      # Replaces the message displayed when a move doesn't affect a battler with a popup animation
      # @return [Boolean]
      attr_accessor :replace_unaffected

      # Replaces the message displayed when a battler's stat stage changes with a popup animation
      # @return [Boolean]
      attr_accessor :replace_stat_change

      # Replaces the message displayed for perish counts with a custom animation
      attr_accessor :replace_perish
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
