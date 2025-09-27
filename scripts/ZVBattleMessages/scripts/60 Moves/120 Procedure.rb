module Battle
  class Move
    # Show the critical hit message
    # @param actual_targets [Array<PFM::PokemonBattler>]
    # @param target [PFM::PokemonBattler]
    def zv_hit_criticality_message(actual_targets, target)
      return unless critical_hit?

      message = actual_targets.size == 1 ? parse_text(18, 84) : parse_text_with_pokemon(19, 384, target)
      return scene.display_message_and_wait(message) unless Configs.zv_battle_msg.replace_critical_hit

      scene.zv_log_battle_message(message)
    end

    module ZVBattleMsgProcedure
      def efficent_message(effectiveness, target)
        return super unless Configs.zv_battle_msg.replace_effectiveness

        if effectiveness > 1
          scene.zv_log_battle_message(parse_text_with_pokemon(19, 6, target))
        elsif effectiveness > 0 && effectiveness < 1
          scene.zv_log_battle_message(parse_text_with_pokemon(19, 15, target))
        end
      end

      private

      def accuracy_immunity_test(user, targets)
        return super unless Configs.zv_battle_msg.replace_unaffected

        return targets.select do |target|
          if target_immune?(user, target)
            scene.visual.zv_show_unaffected_animation(target)
            scene.zv_log_battle_message(parse_text_with_pokemon(19, 210, target))
            next false
          elsif move_blocked_by_target?(user, target)
            next false
          end

          next true
        end
      end
    end
    prepend ZVBattleMsgProcedure
  end
end
