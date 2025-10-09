module ZVBattleUI
  # Responsible for creating an animation for all popup messages regarding a hit when a battler's HP should change
  class PopupHitHPAnimator < ShowHPAnimatorBase
    # param scene [Battle::Scene]
    def initialize(scene)
      super()
      @scene = scene
    end

    # @param target [PFM::PokemonBattler]
    # @param hp [Integer]
    # @param effectiveness [Float, nil]
    # @param **_kwargs [Hash]
    # @return [Yuki::Animation::TimedAnimation, nil]
    def create_animation(target, _hp, effectiveness, **others)
      ya = Yuki::Animation
      full_anim = ya.wait(0)
      target_sprite = @scene.visual.battler_sprite(target.bank, target.position)

      popups = [
        critical_hit_popup(target_sprite, others[:critical]),
        hit_effectiveness_popup(target_sprite, effectiveness)
      ].compact

      popups.each_with_index do |popup, index|
        anim = ya.wait(0.5 * index)
        anim.play_before(popup.create_animation)
            .play_before(ya.send_command_to(popup, :dispose))

        full_anim.parallel_add(anim)
      end

      full_anim.start
      return full_anim
    end

    private

    # Create a popup message about the effectiveness of a hit
    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram effectiveness [Float, nil]
    # @return [ZVBattleUI::PopupMessage, nil]
    def hit_effectiveness_popup(target_sprite, effectiveness)
      return unless Configs.zv_battle_msg.replace_effectiveness && effectiveness

      viewport = @scene.visual.viewport
      return SuperEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 1
      return NotVeryEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 0 && effectiveness < 1

      return nil
    end

    # Create a popup message about whether the hit is critical
    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram critical [Boolean, nil]
    # @return [ZVBattleUI::PopupMessage, nil]
    def critical_hit_popup(target_sprite, critical)
      return unless Configs.zv_battle_msg.replace_critical_hit && critical

      viewport = @scene.visual.viewport
      return CriticalHitPopup.new(viewport, @scene, target_sprite)
    end
  end
end
