module Battle
  class Visual
    module ZVBattleMsgShowHP
      def create_hp_animation_handler(target, hp, effectiveness, *_args, **_kwargs)
        handler = super
        replace = %i[replace_effectiveness? replace_critical_hit?]
        return handler if replace.none? { |r| Configs.zv_battle_msg.send(r) }

        # Must shift this array regardless whether it's direct damage
        critical_hit = @scene.logic.zv_battle_msg_internal.critical_hits.last&.shift
        direct_damage = effectiveness && hp <= 0

        if direct_damage
          popup = ZVBattleMsg::HitPopupAnimation.new(@scene)
          handler[:popup] = popup.create_animation(
            target, hp, effectiveness: effectiveness, critical: critical_hit
          )
        end

        return handler
      end
    end
    prepend ZVBattleMsgShowHP
  end
end
