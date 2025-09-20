module ZVBattleMsg
  # Base class for creating an animation that displays a short popup message on a battler.
  # Tested with 96px x 17px popup message images on 96px x 96px battler sprites in 2D battle mode.
  class PopupMessage
    DIR_NAME = 'popup-messages'

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
    def create_sprite
      sprite = @sprite_stack.add_sprite(0, 0, popup_filename)
      sprite.set_origin(sprite.width / 2, sprite.height)
    end

    # Text for the popup message
    def create_text
      nil
    end

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      raise 'This method should be implemented in the subclass'
    end

    # x offset for the animation
    # @return [Integer]
    def x_offset
      return 0
    end

    # y offset for the animation
    # @return [Integer]
    def y_offset
      return -20
    end
  end

  # Popup message class with a preset animation
  class PopupMessagePreset < PopupMessage
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
