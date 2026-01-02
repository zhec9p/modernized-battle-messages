module Battle
  class Visual
    module ZVBattleMsgShowHP
      private

      def create_hp_animation_handler(target, hp, effectiveness, *_args, **_kwargs)
        handler = super
        critical_hit = @scene.logic.zv_battle_msg_internal.critical_hits.last&.shift
        zv_create_hit_popup_animation(handler, target, hp, effectiveness, critical_hit)
        zv_create_damage_numbers_animation(handler, target, hp)
        return handler
      end

      def zv_create_hit_popup_animation(handler, target, hp, effectiveness, critical)
        config = Configs.zv_battle_msg
        return unless config.replace_effectiveness || config.replace_critical_hit
        return unless effectiveness && hp <= 0

        popup = ZVBattleMsg::HitPopupAnimation.new(@scene)
        handler[:zv_hit_popups] = popup.create_animation(
          target, hp, effectiveness: effectiveness, critical: critical
        )
      end

      def zv_create_damage_numbers_animation(handler, target, hp)
        return unless Configs.zv_battle_msg.damage_numbers.enable

        ya = Yuki::Animation
        klass = hp <= 0 ? ZVBattleMsg::DamageNumbers : ZVBattleMsg::HealNumbers
        numbers = klass.new(viewport, @scene, target, hp.abs)
        handler[:zv_damage_numbers] = ya.player(numbers.create_animation, ya.dispose_sprite(numbers))
      end
    end
    prepend ZVBattleMsgShowHP
  end
end
