module Battle
  class Move
    module ZVBattleMsgProcedure
      def efficent_message(effectiveness, target)
        return super unless Configs.zv_battle_msg.replace_effectiveness

        if effectiveness > 1
          scene.zv_log_battle_message(parse_text_with_pokemon(19, 6, target))
        elsif effectiveness > 0 && effectiveness < 1
          scene.zv_log_battle_message(parse_text_with_pokemon(19, 15, target))
        end
      end

      def hit_criticality_message(actual_targets, target)
        return super unless Configs.zv_battle_msg.replace_critical_hit
        return unless critical_hit?

        message = actual_targets.size == 1 ? parse_text(18, 84) : parse_text_with_pokemon(19, 384, target)
        scene.zv_log_battle_message(message)
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

      def proceed_move_accuracy(user, targets)
        return super unless Configs.zv_battle_msg.replace_miss

        if bypass_accuracy?(user, targets)
          log_data('# proceed_move_accuracy: bypassed')
          return targets
        end

        return targets.select do |target|
          accuracy_dice = logic.move_accuracy_rng.rand(100)
          hit_chance = chance_of_hit(user, target)
          log_data("# target= #{target}, # accuracy= #{hit_chance}, value = #{accuracy_dice} (testing=#{hit_chance > 0}, failure=#{accuracy_dice >= hit_chance})")

          if accuracy_dice >= hit_chance
            if hit_chance > 0
              scene.visual.zv_show_miss_animation(target)
              scene.zv_log_battle_message(parse_text_with_pokemon(19, 213, target))
            else
              scene.zv_log_battle_message(parse_text_with_pokemon(19, 24, target))
            end
            next false
          end

          next true
        end
      end
    end
    prepend ZVBattleMsgProcedure
  end
end
