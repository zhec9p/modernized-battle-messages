module ZVBattleUI
  # Popup message when a super effective move hits
  class SuperEffectivePopup < PopupMessagePreset
    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'super-effective')
    end
  end

  # Popup message when a not very effective move hits
  class NotVeryEffectivePopup < PopupMessagePreset
    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'not-very-effective')
    end
  end

  # Popup message when a move doesn't affect the target
  class UnaffectedPopup < PopupMessage
    FADE_IN_DURATION = 0.125
    FADE_OUT_DURATION = 0.125
    IDLE_DURATION = 0.4
    BATTLER_OPACITY_FACTOR = 0.7

    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation

      x = @target_sprite.x + x_offset
      y = @target_sprite.y + y_offset
      battler_opacity1 = @target_sprite.opacity
      battler_opacity2 = (BATTLER_OPACITY_FACTOR * battler_opacity1).round

      fade_in  = ->(sp, opa1 = 0, opa2 = 255) { ya.opacity_change(FADE_IN_DURATION, sp, opa1, opa2) }
      fade_out = ->(sp, opa1 = 255, opa2 = 0) { ya.opacity_change(FADE_OUT_DURATION, sp, opa1, opa2) }
      idle     = -> { ya.wait(IDLE_DURATION) }

      popup_anim = ya.move_discreet(0, @sprite_stack, x, y, x, y)
      popup_anim.play_before(fade_in.call(@sprite_stack))
                .play_before(idle.call)
                .play_before(fade_out.call(@sprite_stack))
                .play_before(fade_in.call(@sprite_stack))
                .play_before(idle.call)

      anim = fade_in.call(@target_sprite, battler_opacity1, battler_opacity2)
      anim.parallel_add(popup_anim)
      anim.play_before(fade_out.call(@sprite_stack))
          .parallel_add(fade_in.call(@target_sprite, battler_opacity2, battler_opacity1))

      return anim
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'no-effect')
    end
  end
end
