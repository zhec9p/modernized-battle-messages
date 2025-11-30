module ZVBattleMsg
  # Handle the perish count animation in the battle scene
  class PerishAnimation < UI::SpriteStack
    # Subdirectory in the following directories that is holding this animation's assets
    # - audio/*/zv-battle-messages
    # - graphics/animations/zv-battle-messages
    DIR_NAME = 'perish'

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
      @clock         = create_sprite(clock_filename, clock_position)
      @hour_hand     = create_sprite(hour_hand_filename, hand_position)
      @minute_hand   = create_sprite(minute_hand_filename, hand_position)
      @counter       = create_sprite(counter_filename, counter_position, *counter_dimensions, type: SpriteSheet)
      self.opacity   = 0
    end

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      tx = @target_sprite.x + x_offset
      ty = @target_sprite.y + y_offset

      return ya.player(
        ya.parallel(
          ya.player(
            ya.move_discreet(0, self, tx, ty, tx, ty),
            ya.send_command_to(@counter, :sx=, @old_count),
            ya.opacity_change(0.1, self, 0, 255),
            hand_animation
          ),
          idle_animation(@old_count),
        ),
        ya.parallel(
          ya.player(
            count_change_animation,
            ya.wait(post_count_duration),
            ya.opacity_change(0.1, self, 255, 0)
          ),
          idle_animation(@new_count)
        )
      )
    end

    private

    # Animation for the clock hands
    # @return [Yuki::Animation::AnimationMixin]
    def hand_animation
      ya = Yuki::Animation

      return ya.parallel(
        ya.rotation(hand_duration, @minute_hand, 0, 360 * (@old_count - @new_count)),
        ya.rotation(hand_duration, @hour_hand, @old_count * 30, @new_count * 30),
        ya.se_play(hand_se_filename)
      )
    end

    # Animation for changing to the new count
    # @return [Yuki::Animation::AnimationMixin]
    def count_change_animation
      ya = Yuki::Animation
      anims = [ya.send_command_to(@counter, :sx=, @new_count)]
      anims << ya.se_play(death_se_filename) if death?(@new_count)
      return ya.parallel(*anims)
    end

    # How long the animation lasts after the new count before disappearing
    # @return [Float]
    def post_count_duration
      duration = 0.4
      duration += 0.1 if death?(@new_count)
      return duration
    end

    # Animation based on the count that would run parallel of the main animation
    # @param count [Integer]
    # @return [Yuki::Animation::AnimationMixin]
    def idle_animation(count)
      ya = Yuki::Animation
      return ya.send_command_to(@counter, :sy=, 1) if death?(count)
      return ya.wait(0) unless peril?(count)

      return ya.timed_loop_animation(
        0.2, [
          ya.send_command_to(@counter, :sy=, 1),
          ya.wait(0.1),
          ya.send_command_to(@counter, :sy=, 0)
        ]
      )
    end

    # Is the count a low number?
    # @param count [Integer]
    # @return [Boolean]
    def peril?(count)
      return count <= 1 && !death?(count)
    end

    # Is the count zero?
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

    def x_offset = 0
    def y_offset = -32

    def clock_filename = ZVBattleMsg.file_join(DIR_NAME, 'clock')
    def clock_position = [0, 0]

    def minute_hand_filename = ZVBattleMsg.file_join(DIR_NAME, 'minute-hand')
    def hour_hand_filename   = ZVBattleMsg.file_join(DIR_NAME, 'hour-hand')
    def hand_se_filename     = ZVBattleMsg.file_join(DIR_NAME, 'clock-ticking-single')
    def hand_position        = [0, 0]
    def hand_duration        = 0.5

    def counter_filename   = ZVBattleMsg.file_join(DIR_NAME, 'countdown')
    def counter_position   = [0, -32]
    def counter_dimensions = [5, 2]

    def death_se_filename = ZVBattleMsg.file_join(DIR_NAME, 'bell-tolling-single')
  end
end
