module Battle
  module Effects
    class FutureSight
      module ZVBattleMsgFutureSight
        def on_delete
          return super unless Configs.zv_battle_msg.replace_critical_hit
          return unless (target = find_target)

          @logic.scene.display_message_and_wait(message(target))
          # TODO: Add animation

          hp = @move.damages(@origin, target)
          damage_handler = @logic.damage_handler
          damage_handler.damage_change_with_process(hp, target, @origin, @move) do
            @move.hit_criticality_message([target], target)
            @move.efficent_message(@move.effectiveness, target) if hp > 0
          end
        end
      end
      prepend ZVBattleMsgFutureSight
    end
  end
end
