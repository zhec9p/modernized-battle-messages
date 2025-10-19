module ZVBattleMsg
  # Responsible for creating an animation for all popup messages regarding a hit when a battler's HP should change
  class HitPopupAnimation
    # param scene [Battle::Scene]
    def initialize(scene)
      @scene = scene
    end

    # @param target [PFM::PokemonBattler]
    # @param hp [Integer]
    # @param effectiveness [Float, nil]
    # @param critical [Boolean, nil]
    # @return [Yuki::Animation::TimedAnimation]
    def create_animation(target, hp, effectiveness:, critical:)
      ya = Yuki::Animation
      full_anim = ya.wait(0)
      popups = create_popups(target, hp, effectiveness: effectiveness, critical: critical)

      popups.each_with_index do |pu, index|
        anim = ya.wait(time_between_popups * index)
        anim.play_before(pu.create_animation)
            .play_before(ya.send_command_to(pu, :dispose))

        full_anim.parallel_add(anim)
      end

      return full_anim
    end

    private

    # Create all relevant popup messages for the hit
    # @param target [PFM::PokemonBattler]
    # @param hp [Integer]
    # @param effectiveness [Float, nil]
    # @param cfitical [Boolean, nil]
    # @return [Array<ZVBattleMsg::PopupMessage>]
    def create_popups(target, _hp, effectiveness:, critical:)
      target_sprite = @scene.visual.battler_sprite(target.bank, target.position)
      popups = [
        critical_hit_popup(target_sprite, critical),
        hit_effectiveness_popup(target_sprite, effectiveness)
      ]
      popups.compact!
      return popups
    end

    # Create a popup message about the effectiveness of a hit
    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram effectiveness [Float, nil]
    # @return [ZVBattleMsg::PopupMessage, nil]
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
    # @return [ZVBattleMsg::PopupMessage, nil]
    def critical_hit_popup(target_sprite, critical)
      return unless Configs.zv_battle_msg.replace_critical_hit && critical

      viewport = @scene.visual.viewport
      return CriticalHitPopup.new(viewport, @scene, target_sprite)
    end

    # Amount of time to wait between playing each popup message
    # @return [Float]
    def time_between_popups
      return 0.5
    end
  end
end
