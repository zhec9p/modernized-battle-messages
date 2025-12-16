module ZVBattleMsg
  # Popup message when a super effective move hits
  class SuperEffectivePopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return Configs.zv_battle_msg.animation_path('super-effective')
    end
  end

  # Popup message when a not very effective move hits
  class NotVeryEffectivePopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return Configs.zv_battle_msg.animation_path('not-very-effective')
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
        ya.move_discreet(0, self, tx, ty, tx, ty),
        fade_in.call,
        waiting.call,
        fade_out.call,
        fade_in.call,
        waiting.call,
        fade_out.call
      )
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return Configs.zv_battle_msg.animation_path('no-effect')
    end

    def fade_in_duration  = 0.125
    def fade_out_duration = 0.125
    def wait_duration     = 0.4
  end
end
