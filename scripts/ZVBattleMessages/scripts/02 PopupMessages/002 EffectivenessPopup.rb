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
    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation

      x = @target_sprite.x + x_offset
      y = @target_sprite.y + y_offset
      battler_opacity1 = @target_sprite.opacity
      battler_opacity2 = (battler_opacity_factor * battler_opacity1).round

      fade_in  = ->(sp, opa1 = 0, opa2 = 255) { ya.opacity_change(fade_in_duration, sp, opa1, opa2) }
      fade_out = ->(sp, opa1 = 255, opa2 = 0) { ya.opacity_change(fade_out_duration, sp, opa1, opa2) }
      stay     = -> { ya.wait(fade_stay_duration) }

      popup_anim = ya.move_discreet(0, @sprite_stack, x, y, x, y)
      popup_anim.play_before(fade_in.call(@sprite_stack))
                .play_before(stay.call)
                .play_before(fade_out.call(@sprite_stack))
                .play_before(fade_in.call(@sprite_stack))
                .play_before(stay.call)

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

    def fade_in_duration = 0.125
    def fade_out_duration = 0.125
    def fade_stay_duration = 0.4
    def battler_opacity_factor = 0.75
  end
end
