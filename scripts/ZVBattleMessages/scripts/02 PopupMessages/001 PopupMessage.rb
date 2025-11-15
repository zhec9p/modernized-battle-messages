module ZVBattleMsg
  # Base class for creating an animation that displays a short popup message on a battler.
  # Tested with 96px x 17px popup message images on 96px x 96px battler sprites in 2D battle mode.
  class PopupMessage
    # Subdirectory in audio/zv-battle-messages or animation/zv-battle-messages holding popup messages' assets
    DIR_NAME = 'popup-messages'

    # Offsets for most popup messages relative to a battler's sprite.
    #   OFFSETS[0] => Player battler
    #   OFFSETS[1] => Enemey battler
    OFFSETS = [[0, -42], [0, -42]]

    TEXT_DIMENSIONS = [96, 8] # Dimensions of the popup's text surface. Unused if text_content returns nil
    TEXT_ALIGNMENT = 1        # Center alignment for text. Unused if text_content returns nil

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    def initialize(viewport, scene, target_sprite)
      @scene = scene
      @target_sprite = target_sprite

      @sprite_stack = UI::SpriteStack.new(viewport, default_cache: :animation)
      create_sprite
      create_text
      @sprite_stack.z = target_sprite.z
      @sprite_stack.opacity = 0
    end

    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      raise 'This method should be implemented in the subclass'
    end

    def dispose
      @sprite_stack.dispose
    end

    private

    # Sprite for the popup message
    # @return [Sprite]
    def create_sprite
      filename = ZVBattleMsg.translate_animation_filename(popup_filename)
      sprite = @sprite_stack.add_sprite(0, 0, filename)
      sprite.set_origin(sprite.width / 2, sprite.height)
      return sprite
    end

    # Text for the popup message
    # @return [Text]
    def create_text
      content = text_content
      return unless content

      text = @sprite_stack.with_font(20) do
        @sprite_stack.add_text(*text_position, *TEXT_DIMENSIONS, content, TEXT_ALIGNMENT, color: text_color_id)
      end

      return text
    end

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      raise 'This method must be implemented in the subclass'
    end

    # X offset for the animation
    # @return [Integer]
    def x_offset
      offset = OFFSETS[@target_sprite.bank][0]
      offset += Graphics.width / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end

    # Y offset for the animation
    # @return [Integer]
    def y_offset
      offset = OFFSETS[@target_sprite.bank][1]
      offset += Graphics.height / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end

    # Message to display on the popup
    # @return [String, nil]
    # @note All text_* methods after this one are unused if this one returns nil
    def text_content = nil

    # Position of the text relative to the popup's sprite stack
    # @return [Array<Integer>]
    def text_position
      raise "This method should be implemented in the subclass if `text_content` doesn't return nil"
    end

    # Text color ID based on Fonts
    # @return [Integer, nil]
    def text_color_id = 9
  end

  # Basic popup message animation creation
  module PopupMessageBasicAnimation
    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation
      appear_anim = ya.opacity_change(0.1, @sprite_stack, 0, 255)
      appear_anim.play_before(ya.wait(main_duration))
                 .play_before(ya.opacity_change(0.1, @sprite_stack, 255, 0))

      x = @target_sprite.x + x_offset
      y = @target_sprite.y + y_offset
      anim = ya.move_discreet(main_duration + 0.1, @sprite_stack, x, y, x, y - 20)
      anim.parallel_add(appear_anim)
      return anim
    end

    private

    # Duration of the main part of the animation
    # @return [Float]
    def main_duration
      return 0.7
    end
  end
end
