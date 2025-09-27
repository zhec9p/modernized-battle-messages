module Battle
  class Scene
    unless method_defined?(:zv_log_battle_message)
      def zv_log_battle_message(...)
        nil
      end
    end

    unless method_defined?(:zv_log_battle_stat_change)
      def zv_log_battle_stat_change(...)
        nil
      end
    end
  end
end
