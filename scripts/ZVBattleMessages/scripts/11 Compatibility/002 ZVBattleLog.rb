module Battle
  class Scene
    # Compatibility support for zhec's Battle Log plugin
    unless Object.const_defined?(:ZVBattleLog)
      def zv_log_battle_message(...) = nil
      def zv_log_move_usage_message(...) = nil
      def zv_battle_log_busy = false
    end
  end
end
