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
    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      fade_in  = -> { ya.opacity_change(fade_in_duration, self, 0, 255) }
      fade_out = -> { ya.opacity_change(fade_out_duration, self, 255, 0) }
      waiting  = -> { ya.wait(wait_duration) }

      tx = @target_sprite.x + x_offset
      ty = @target_sprite.y + y_offset

      return ya.player(
        ya.send_command_to(self, :x=, tx),
        ya.send_command_to(self, :y=, ty),
        *([fade_in.call, waiting.call, fade_out.call] * 2),
      )
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
