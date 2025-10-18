module ZVBattleUI
  # Popup message when a move misses the target
  class MissPopup < PopupMessagePreset
    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      anim = super
      miss_anim = ya::UserBankRelativeAnimation.new
      miss_anim.resolver = { user: @target_sprite }.method(:[])
      miss_anim.play_before_on_bank(0, friend_animation)
      miss_anim.play_before_on_bank(1, foe_animation)
      anim.parallel_add(miss_anim)
      return anim
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'miss')
    end

    # Animation of player/ally battler sprite in parallel of the popup message
    # @return [Yuki::Animation::TimedAnimation]
    def friend_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances
      anim = ya.move_discreet(dodge_outward_duration, @target_sprite, tx, ty, tx - dodge_x, ty + dodge_y)
      anim.play_before(ya.wait(dodge_wait_duration))
      anim.play_before(ya.move_discreet(dodge_inward_duration, @target_sprite, tx - dodge_x, ty + dodge_y, tx, ty))
      return anim
    end

    # Animation of enemy battler sprite in parallel of the popup message
    # @return [Yuki::Animation::TimedAnimation]
    def foe_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances
      anim = ya.move_discreet(dodge_outward_duration, @target_sprite, tx, ty, tx + dodge_x, ty - dodge_y)
      anim.play_before(ya.wait(dodge_wait_duration))
      anim.play_before(ya.move_discreet(dodge_inward_duration, @target_sprite, tx + dodge_x, ty - dodge_y, tx, ty))
      return anim
    end

    # @return [Array<Integer, Integer>]
    def dodge_distances
      return [25, 0]
    end

    def dodge_outward_duration = 0.05
    def dodge_wait_duration = 0.4
    def dodge_inward_duration = 0.2
  end
end
