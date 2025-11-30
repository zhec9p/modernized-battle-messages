module ZVBattleMsg
  # Popup message when a move misses the target
  class MissPopup < PopupMessage
    include PopupMessageBasicAnimation

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      miss_anim = ya.user_bank_relative_animation([friend_animation, foe_animation])
      miss_anim.resolver = { user: @target_sprite }
      return ya.parallel(super, miss_anim)
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return ZVBattleMsg.file_join(DIR_NAME, 'miss')
    end

    # Animation of player/ally battler sprite in parallel of the popup message
    # @return [Yuki::Animation::AnimationMixin]
    def friend_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances

      return ya.player(
        ya.move_discreet(dodge_outward_duration, @target_sprite, tx, ty, tx - dodge_x, ty + dodge_y),
        ya.wait(dodge_wait_duration),
        ya.move_discreet(dodge_inward_duration, @target_sprite, tx - dodge_x, ty + dodge_y, tx, ty)
      )
    end

    # Animation of enemy battler sprite in parallel of the popup message
    # @return [Yuki::Animation::AnimationMixin]
    def foe_animation
      ya = Yuki::Animation
      tx = @target_sprite.x
      ty = @target_sprite.y
      dodge_x, dodge_y = dodge_distances

      return ya.player(
        ya.move_discreet(dodge_outward_duration, @target_sprite, tx, ty, tx + dodge_x, ty - dodge_y),
        ya.wait(dodge_wait_duration),
        ya.move_discreet(dodge_inward_duration, @target_sprite, tx + dodge_x, ty - dodge_y, tx, ty)
      )
    end

    def dodge_distances        = [25, 0]
    def dodge_outward_duration = 0.075
    def dodge_wait_duration    = 0.4
    def dodge_inward_duration  = 0.2
  end
end
