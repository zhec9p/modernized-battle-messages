module ZVBattleMsg
  # Popup message when a super effective move hits
  class SuperEffectivePopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(ROOT_DIR_NAME, DIR_NAME, 'super-effective')
    end
  end

  # Popup message when a not very effective move hits
  class NotVeryEffectivePopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(ROOT_DIR_NAME, DIR_NAME, 'not-very-effective')
    end
  end

  # Popup message when a move doesn't affect the target
  class UnaffectedPopup < PopupMessage
    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      fade_in  = -> { ya.opacity_change(fade_in_duration, @sprite_stack, 0, 255) }
      fade_out = -> { ya.opacity_change(fade_out_duration, @sprite_stack, 255, 0) }
      waiting  = -> { ya.wait(wait_duration) }

      x = @target_sprite.x + x_offset
      y = @target_sprite.y + y_offset
      anim = ya.move_discreet(0, @sprite_stack, x, y, x, y)
      anim.play_before(fade_in.call)
          .play_before(waiting.call)
          .play_before(fade_out.call)
          .play_before(fade_in.call)
          .play_before(waiting.call)
          .play_before(fade_out.call)

      return anim
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(ROOT_DIR_NAME, DIR_NAME, 'no-effect')
    end

    def fade_in_duration  = 0.125
    def fade_out_duration = 0.125
    def wait_duration     = 0.4
  end
end
