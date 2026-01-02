module ZVBattleMsg
  # Handle the perish count animation in the battle scene
  class PerishAnimation < UI::SpriteStack
    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param old_count [Integer]
    # @param new_count [Integer]
    def initialize(viewport, scene, target_sprite, old_count, new_count)
      super(viewport, default_cache: :animation)
      @scene         = scene
      @target_sprite = target_sprite
      @old_count     = old_count
      @new_count     = new_count
      create_sprites
      self.opacity = 0
    end

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation

      return ya.player(
        *setup_animations,
        old_count_animation,
        new_count_animation
      )
    end

    private

    # Creates all the sprites needed for the animation
    def create_sprites
      @graduations = create_sprite(graduation_filename, graduation_position)
      @minute_hand = create_sprite(minute_hand_filename, hand_position)
      @hour_hand   = create_sprite(hour_hand_filename, hand_position)
      @number      = create_sprite(number_filename, number_position, *number_dimensions, type: SpriteSheet)
    end

    # @return [Array<Yuki::Animation::AnimationMixin>]
    def setup_animations
      ya = Yuki::Animation
      tx = @target_sprite.x + x_offset
      ty = @target_sprite.y + y_offset

      return [
        ya.move_discreet(0, self, tx, ty, tx, ty),
        ya.send_command_to(@number, :sx=, @old_count)
      ]
    end

    # Animation played during the old count
    # @return [Yuki::Animation::AnimationMixin]
    def old_count_animation
      ya = Yuki::Animation

      return ya.parallel(
        ya.player(
          ya.opacity_change(0.1, self, 0, 255),
          hand_animation
        ),
        idle_animation(@old_count)
      )
    end

    # Animation played during the new count
    # @return [Yuki::Animation::AnimationMixin]
    def new_count_animation
      ya = Yuki::Animation

      return ya.parallel(
        ya.player(
          number_change_animation(@new_count),
          clock_hide_animation,
          ya.wait(number_alone_duration),
          ya.opacity_change(0.1, @number, 255, 0)
        ),
        idle_animation(@new_count)
      )
    end

    # Animation based on the count that would run parallel of the main animation
    # @param count [Integer]
    # @return [Yuki::Animation::AnimationMixin]
    def idle_animation(count)
      ya = Yuki::Animation
      return ya.send_command_to(@number, :sy=, 1) if death?(count)
      return ya.wait(0) unless peril?(count)

      return ya.timed_loop_animation(
        0.2, [
          ya.send_command_to(@number, :sy=, 1),
          ya.wait(0.1),
          ya.send_command_to(@number, :sy=, 0)
        ]
      )
    end

    # Animation for the clock hands
    # @return [Yuki::Animation::AnimationMixin]
    def hand_animation
      ya = Yuki::Animation

      minute_angle = ->(count) { -count.to_f * 360.0 / max_count.to_f }
      min0 = minute_angle.call(@old_count)
      min1 = minute_angle.call(@new_count)
      hr0 = min0 / 12.0
      hr1 = min1 / 12.0

      return ya.parallel(
        ya.rotation(hand_duration, @minute_hand, min0, min1),
        ya.rotation(hand_duration, @hour_hand, hr0, hr1),
        ya.se_play(hand_se_filename)
      )
    end

    # Animation for the number change
    # @return [Yuki::Animation::AnimationMixin]
    def number_change_animation(count)
      ya = Yuki::Animation

      animations = [ya.send_command_to(@number, :sx=, count)]
      animations << ya.se_play(death_se_filename) if death?(count)
      return animations[0] if animations.size == 1

      return ya.parallel(*animations)
    end

    # @return [Yuki::Animation::AnimationMixin]
    def clock_hide_animation
      ya = Yuki::Animation

      return ya.parallel(
        ya.opacity_change(0.1, @graduations, 255, 0),
        ya.opacity_change(0.1, @hour_hand, 255, 0),
        ya.opacity_change(0.1, @minute_hand, 255, 0)
      )
    end

    # Is the perish count a low number?
    # @param count [Integer]
    # @return [Boolean]
    def peril?(count)
      return count <= 1 && !death?(count)
    end

    # Is the perish count zero?
    # @param count [Integer]
    # @return [Boolean]
    def death?(count)
      return count <= 0
    end

    # @param filename [String]
    # @param position [Array<Integer>]
    # @param args [Array] The arguments after the viewport argument of the sprite to create the sprite
    # @param type [Class] Class to use to generate the sprite
    # @return [Sprite]
    def create_sprite(filename, position, *args, type: Sprite)
      sprite = add_sprite(*position, filename, *args, type: type)
      sprite.set_origin(sprite.width / 2, sprite.height / 2)
      apply_3d_battle_settings(sprite)
      return sprite
    end

    # @param sprite [Sprite, Spritesheet]
    def apply_3d_battle_settings(sprite)
      return unless Battle::BATTLE_CAMERA_3D

      sprite.shader = Shader.create(:fake_3d)
      @scene.visual.sprites3D.append(sprite)
      sprite.shader.set_float_uniform('z', @target_sprite.shader_z_position)
    end

    def x_offset              = 0
    def y_offset              = -48
    def graduation_position   = [1, 1]
    def hand_position         = [0, 0]
    def hand_duration         = 0.5
    def max_count             = 4
    def max_graduations       = 12
    def number_position       = [0, 0]
    def number_dimensions     = [max_count + 1, 2]
    def number_alone_duration = 0.4

    def graduation_filename  = Configs.zv_battle_msg.animation_path('perish-graduation')
    def hour_hand_filename   = Configs.zv_battle_msg.animation_path('perish-hour-hand')
    def minute_hand_filename = Configs.zv_battle_msg.animation_path('perish-minute-hand')
    def number_filename      = Configs.zv_battle_msg.animation_path('perish-numbers')
    def hand_se_filename     = Configs.zv_battle_msg.se_path('perish-countdown')
    def death_se_filename    = Configs.zv_battle_msg.se_path('perish-death')
  end
end
