module Configs
  module Project
    class ZVBattleMsg
      attr_writer :replace_effectiveness,
                  :replace_critical_hit,
                  :replace_unaffected,
                  :replace_miss,
                  :replace_stat_change,
                  :replace_perish

      # Directory name for assets in the following paths:
      # - graphics/animations/
      # - audio/se/
      # @return [String]
      attr_accessor :dir_name

      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Replace the messages displayed for super-effective and not-very-effective hits with popup animations?
      # @return [Boolean]
      def replace_effectiveness?(...)
        return show_any_animation?(...) && @replace_effectiveness
      end

      # Replace the message displayed for a critical hit with a popup animation?
      # @return [Boolean]
      def replace_critical_hit?(...)
        return show_any_animation?(...) && @replace_critical_hit
      end

      # Replace the message displayed when a move doesn't affect a battler with a popup animation?
      # @return [Boolean]
      def replace_unaffected?(...)
        return show_any_animation?(...) && @replace_unaffected
      end

      # Replace the message displayed when an attack misses with a popup and battler animation?
      # @return [Boolean]
      def replace_miss?(...)
        return show_any_animation?(...) && @replace_miss
      end

      # Replace the message displayed when a battler's stat stage changes with a popup animation?
      # @return [Boolean]
      # @note This also speeds up the vanilla stat change animation, which the popup will overlap with.
      def replace_stat_change?(...)
        return show_any_animation?(...) && @replace_stat_change
      end

      # Replace the message displayed for a battler's perish count with a custom animation?
      # @return [Boolean]
      def replace_perish?(...)
        return show_any_animation?(...) && @replace_perish
      end

      # @param filename [String]
      # @return [String]
      def filepath(filename)
        File.join(dir_name, filename)
      end

      def initialize
        self.dir_name              = 'zv-battle-messages'
        self.csv_id                = 93_208
        self.replace_effectiveness = true
        self.replace_critical_hit  = true
        self.replace_unaffected    = true
        self.replace_miss          = true
        self.replace_stat_change   = true
        self.replace_perish        = true
      end

      private

      # Show any of this plugin's animations?
      # @param ignore_option [Boolean] Disregard the game setting for showing battle animations?
      # @return [Boolean]
      def show_any_animation?(ignore_option: false)
        return ignore_option || $options.show_animation
      end
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
