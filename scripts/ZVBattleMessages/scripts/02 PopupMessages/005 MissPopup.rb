module ZVBattleUI
  # Popup message when a move doesn't affect the target
  class MissPopup < PopupMessagePreset
    DODGE_RADIUS  = 25
    OUT_DURATION  = 0.05
    WAIT_DURATION = 0.45
    IN_DURATION   = 0.2

    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      anim = super
      dodge_anim = ya::UserBankRelativeAnimation.new
      dodge_anim.resolver = { user: @target_sprite }.method(:[])
      dodge_anim.play_before_on_bank(0, friend_animation)
      dodge_anim.play_before_on_bank(1, foe_animation)
      anim.parallel_add(dodge_anim)
      return anim
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'miss')
    end

    # Animation of battler sprite at the player's bank in parallel of the popup message
    # @return [Yuki::Animation::TimedAnimation]
    def friend_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances
      anim = ya.move_discreet(OUT_DURATION, @target_sprite, tx, ty, tx - dodge_x, ty + dodge_y)
      anim.play_before(ya.wait(WAIT_DURATION))
      anim.play_before(ya.move_discreet(IN_DURATION, @target_sprite, tx - dodge_x, ty + dodge_y, tx, ty))
      return anim
    end

    # Animation of battler sprite at the enemy bank in parallel of the popup message
    # @return [Yuki::Animation::TimedAnimation]
    def foe_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances
      anim = ya.move_discreet(OUT_DURATION, @target_sprite, tx, ty, tx + dodge_x, ty - dodge_y)
      anim.play_before(ya.wait(WAIT_DURATION))
      anim.play_before(ya.move_discreet(IN_DURATION, @target_sprite, tx + dodge_x, ty - dodge_y, tx, ty))
      return anim
    end

    # @return [Array<Integer, Integer>]
    def dodge_distances
      angle = Math.atan(Graphics.height.to_f / Graphics.width)
      x = (Math.cos(angle) * DODGE_RADIUS).round
      y = (Math.sin(angle) * DODGE_RADIUS).round
      return x, y
    end
  end
end
