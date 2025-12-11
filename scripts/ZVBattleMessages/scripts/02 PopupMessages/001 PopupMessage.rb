module ZVBattleMsg
  # Base class for creating an animation that displays a short popup message on a battler
  class PopupMessage < UI::SpriteStack
    # Offsets for most popup messages relative to a battler's sprite.
    #   OFFSETS[0] => Player battler
    #   OFFSETS[1] => Enemey battler
    OFFSETS = [[0, -42], [0, -42]]

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize(viewport, scene, target_sprite)
      @scene = scene
      @target_sprite = target_sprite

      super(viewport, default_cache: :animation)
      create_sprite
      create_text
      self.z = target_sprite.z
      self.opacity = 0
    end

    # @return [Yuki::Animation::AnimationMixin]
    def create_animation
      raise 'This method should be implemented in the subclass'
    end

    private

    # @return [Sprite]
    def create_sprite
      filename = ZVBattleMsg.translate_animation_filename(popup_filename)
      sprite = add_sprite(0, 0, filename)
      sprite.set_origin(sprite.width / 2, sprite.height)
      return sprite
    end

    # @return [Text]
    def create_text
      return unless respond_to?(:text_content, true)

      return with_font(font_id) do
        add_text(*text_position, *text_dimensions, text_content, text_alignment, color: color_id)
      end
    end

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      raise 'This method must be implemented in the subclass'
    end

    # @return [Integer]
    def x_offset
      offset = OFFSETS[@target_sprite.bank][0]
      offset += Graphics.width / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end

    # @return [Integer]
    def y_offset
      offset = OFFSETS[@target_sprite.bank][1]
      offset += Graphics.height / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end

    # @return [Array<Integer>]
    # @note Unused if the text_content method isn't implemented
    def text_position
      raise 'This method must be implemented in the subclass if `text_content` is implemented'
    end

    # @return [Array<Integer>]
    # @note Unused if the text_content method isn't implemented
    def text_dimensions = [96, 8]

    # @return [Integer]
    # @note Unused if the text_content method isn't implemented
    def text_alignment = 1

    # @return [Integer]
    # @note Unused if the text_content method isn't implemented
    def color_id = 9

    # @return [Integer]
    # @note Unused if the text_content method isn't implemented
    def font_id = 20
  end

  # Basic popup message animation creation
  module PopupMessageBasicAnimation
    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      tx = @target_sprite.x + x_offset
      ty = @target_sprite.y + y_offset

      return ya.parallel(
        ya.move_discreet(main_duration + 0.1, self, tx, ty, tx, ty + y_displacement),
        ya.player(
          ya.opacity_change(0.1, self, 0, 255),
          ya.wait(main_duration),
          ya.opacity_change(0.1, self, 255, 0)
        )
      )
    end

    private

    def main_duration = 0.7
    def y_displacement = -20
  end
end
