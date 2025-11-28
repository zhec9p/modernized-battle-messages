module ZVBattleMsg
  # Handle the perish count animation in the battle scene
  class PerishAnimation < UI::SpriteStack
    # Subdirectory in audio/ or animation/ holding this animation's assets
    DIR_NAME = 'perish'

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param countdown [Integer]
    def initialize(viewport, scene, target_sprite, countdown)
      super(viewport, default_cache: :animation)
      @scene = scene
      @target_sprite = target_sprite
      @countdown = countdown
      @clock = create_sprite(clock_filename)
      @clock_face = create_sprite(clock_face_filename)
      @hand = create_sprite(hand_filename)
      @counter = create_sprite(counter_filename, *counter_dimensions, type: SpriteSheet)
      @counter.sx = countdown
      @counter.sy = 1
      self.opacity = 0
    end

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    # @note This animation requires a resolver for :background
    def create_animation
      ya = Yuki::Animation
      tx = @target_sprite.x + x_offset
      ty = @target_sprite.y + y_offset

      return ya.player(
        ya.move_discreet(0, self, tx, ty, tx, ty),
        ya.parallel(ya.opacity_change(0.1, @clock, 0, 255),
                    ya.opacity_change(0.1, @clock_face, 0, 255),
                    ya.opacity_change(0.1, @hand, 0, 255)),
        hand_animation,
        ya.parallel(bell_animation,
                    ya.send_command_to(@counter, :opacity=, 255),
                    ya.send_command_to(@clock_face, :opacity=, 0),
                    ya.send_command_to(@hand, :opacity=, 0)),
        ya.wait(0.1),
        ya.send_command_to(@counter, :sy=, 0),
        ya.wait(0.3),
        ya.parallel(ya.opacity_change(0.1, @clock, 255, 0),
                    ya.opacity_change(0.1, @counter, 255, 0))
      )
    end

    private

    # @return [Yuki::Animation::AnimationMixin]
    def hand_animation
      ya = Yuki::Animation

      return ya.parallel(
        ya.rotation(hand_duration, @hand, 0, 360),
        ya.se_play(clock_se_filename)
      )
    end

    # @return [Yuki::Animation::AnimationMixin]
    def bell_animation
      ya = Yuki::Animation
      return ya.wait(0) if @countdown > 0

      return ya.se_play(bell_se_filename)
    end

    # @param filename [String]
    # @param args [Array] The arguments after the viewport argument of the sprite to create the sprite
    # @param type [Class] Class to use to generate the sprite
    # @return [Sprite]
    def create_sprite(filename, *args, type: Sprite)
      sprite = add_sprite(0, -32, filename, *args, type: type)
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

    def clock_filename      = ZVBattleMsg.file_join(DIR_NAME, 'clock')
    def clock_face_filename = ZVBattleMsg.file_join(DIR_NAME, 'clock-face')
    def hand_filename       = ZVBattleMsg.file_join(DIR_NAME, 'clock-hand')
    def counter_filename    = ZVBattleMsg.file_join(DIR_NAME, 'countdown')
    def clock_se_filename   = ZVBattleMsg.file_join(DIR_NAME, 'clock-ticking-single')
    def bell_se_filename    = ZVBattleMsg.file_join(DIR_NAME, 'bell-tolling-single')
    def counter_dimensions  = [10, 2]
  end
end
