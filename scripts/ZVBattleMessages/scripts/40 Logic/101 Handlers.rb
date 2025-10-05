module Battle
  class Logic
    class StatChangeHandler
      module ZVBattleMsgStatChangeHandler
        def show_stat_change_text_and_animation(stat, power, amount, target, no_message)
          return super unless Configs.zv_battle_msg.replace_stat_change
          return if power.zero? && amount.zero?

          @scene.visual.show_stat_animation(target, amount, stat) if amount != 0
          @scene.zv_log_battle_stat_change(stat, power, amount, target) unless no_message
        end
      end
      prepend ZVBattleMsgStatChangeHandler
    end

    class DamageHandler
      module ZVBattleMsgDamageHandler
        def damage_change(*args, **kwargs, &block)
          skill = args[3]
          @logic.zv_battle_msg_internal.critical_hits << [skill&.critical_hit?]
          ret = super
          @logic.zv_battle_msg_internal.critical_hits.pop
          return ret
        end

        def drain(*args, **kwargs, &block)
          skill = args[3]
          @logic.zv_battle_msg_internal.critical_hits << [skill&.critical_hit?]
          ret = super
          @logic.zv_battle_msg_internal.critical_hits.pop
          return ret
        end

        def heal_change(...)
          @logic.zv_battle_msg_internal.critical_hits << []
          ret = super
          @logic.zv_battle_msg_internal.critical_hits.pop
          return ret
        end
      end
      prepend ZVBattleMsgDamageHandler
    end
  end
end
