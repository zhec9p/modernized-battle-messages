module ZVBattleMsg
  # Handle the perish count animation in the battle scene
  class PerishAnimation
    DIR_NAME = 'perish'

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param countdown [Integer]
    def initialize(viewport, scene, target_sprite, countdown)
      @sprite_stack = UI::SpriteStack.new(viewport, default_cache: :animation)
      @scene = scene
      @target_sprite = target_sprite
      @countdown = countdown
      @clock = create_sprite(clock_filename)
      @clock_face = create_sprite(clock_face_filename)
      @hand = create_sprite(hand_filename)
      @counter = create_sprite(counter_filename, *counter_dimensions, type: SpriteSheet)
      @counter.sx = countdown
    end

    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      fade_in  = ->(sprite, duration: 0.1, opacity_end: 255) { ya.opacity_change(duration, sprite, 0, opacity_end) }
      fade_out = ->(sprite, duration: 0.1, opacity_start: 255) { ya.opacity_change(duration, sprite, opacity_start, 0) }

      tx = @target_sprite.x
      ty = @target_sprite.y

      anim = ya.move_discreet(0, @sprite_stack, tx, ty, tx + x_offset, ty + y_offset)
      tick_anim = ya.se_play(clock_se_filename)
      anim.play_before(tick_anim)

      # rubocop:disable Layout/MultilineMethodCallIndentation
      count_anim = tick_anim
        .parallel_add(fade_in.call(@clock))
        .parallel_add(fade_in.call(@clock_face, opacity_end: 120))
        .parallel_add(fade_in.call(@hand))
        .play_before(ya.rotation(hand_duration, @hand, 0, 360))
        .play_before(fade_out.call(@hand))
        .parallel_add(ya.send_command_to(@counter, :opacity=, 255))
      # rubocop:enable Layout/MultilineMethodCallIndentation

      count_anim.parallel_add(ya.se_play(ball_se_filename)) if @countdown == 0
      count_anim.play_before(ya.wait(0.4))
                .play_before(fade_out.call(@counter))
                .parallel_add(fade_out.call(@clock_face))
                .parallel_add(fade_out.call(@clock))

      return anim
    end

    def dispose
      @sprite_stack.dispose
    end

    private

    # @param filename [String]
    # @param args [Array] The arguments after the viewport argument of the sprite to create the sprite
    # @param type [Class] Class to use to generate the sprite
    # @return [Sprite]
    def create_sprite(filename, *args, type: Sprite)
      sprite = @sprite_stack.add_sprite(0, -32, filename, *args, type: type)
      sprite.opacity = 0
      sprite.set_origin(sprite.width / 2, sprite.height / 2)
      apply_3d_battle_settings(sprite)
      return sprite
    end

    # Apply the 3D settings to the sprite if the 3D camera is enabled
    # @param sprite [Sprite, Spritesheet]
    def apply_3d_battle_settings(sprite)
      return unless Battle::BATTLE_CAMERA_3D

      sprite.shader = Shader.create(:fake_3d)
      @scene.visual.sprites3D.append(sprite)
      sprite.shader.set_float_uniform('z', @target_sprite.shader_z_position)
    end

    # x offset for the animation
    # @return [Integer]
    def x_offset
      return 0
    end

    # y offset for the animation
    # @return [Integer]
    def y_offset
      return 0
    end

    # Duration of the rotation of the clock hand
    # @return [Float] In seconds
    def hand_duration
      return 0.5
    end

    def clock_filename      = File.join(Constants::DIR_NAME, DIR_NAME, 'clock')
    def clock_face_filename = File.join(Constants::DIR_NAME, DIR_NAME, 'clock-perish-face')
    def hand_filename       = File.join(Constants::DIR_NAME, DIR_NAME, 'clock-hand')
    def counter_filename    = File.join(Constants::DIR_NAME, DIR_NAME, 'clock-countdown')

    def clock_se_filename = File.join(Constants::DIR_NAME, DIR_NAME, 'clock-ticking-single')
    def ball_se_filename  = File.join(Constants::DIR_NAME, DIR_NAME, 'bell-tolling-single')

    def counter_dimensions = [10, 1]
  end
end
