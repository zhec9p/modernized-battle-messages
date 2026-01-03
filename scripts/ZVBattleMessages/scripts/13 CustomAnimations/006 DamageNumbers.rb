module ZVBattleMsg
  # Handle damage popup numbers animation in the battle scene
  class DamageNumbers < UI::SpriteStack
    include Offsets3D

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target [PFM::PokemonBattler]
    # @param quantity [Integer]
    def initialize(viewport, scene, target, quantity)
      super(viewport, default_cache: :animation)

      @scene = scene
      @target = target
      @quantity = quantity
      @target_sprite = @scene.visual.battler_sprite(@target.bank, @target.position)

      create_text
      self.z = @target_sprite.z
      self.opacity = 0
    end

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation

      return ya.player(
        number_animation,
        ya.wait(wait_duration),
        ya.send_command_to(self, :opacity=, 0)
      )
    end

    private

    # Draw text for the damage value
    def create_text
      value = displayable_value
      dx = calculate_left_digit_x_offset(value)

      @digits = value.each_char.map do |digit|
        dx += extra_space_before_unit if digit == unit
        text = with_font(font_id) do
          add_text(dx, 0, _width = 0, _height = nil, digit, _align = 0, outline_size, color: color_id)
        end
        dx += text.real_width + space_after_digit
        next text
      end
    end

    # Animation for popping up the damage number
    # @return [Yuki::Animation::AnimationMixin]
    def number_animation
      ya = Yuki::Animation

      digit_animations = @digits.map.with_index do |digit, index|
        next single_digit_animation(digit, index)
      end

      return ya.parallel(*digit_animations)
    end

    # Animation for popping up a digit from the damage number
    # @param digit [Text]
    # @param index [Integer]
    # @return [Yuki::Animation::AnimationMixin]
    def single_digit_animation(digit, index)
      ya = Yuki::Animation
      dx  = digit.x + @target_sprite.x + x_offset
      dy1 = digit.y + @target_sprite.y + y_offset
      dy2 = dy1 + digit_y_displacement

      return ya.player(
        ya.wait(time_between_digits * index),
        ya.parallel(
          ya.send_command_to(digit, :opacity=, 255),
          ya.move_discreet(move_duration, digit, dx, dy1, dx, dy2, distortion: :zv_abs_function)
        )
      )
    end

    # Damage value to display as a string based on style
    # @return [String]
    def displayable_value
      value = ''

      case Configs.zv_battle_msg.damage_numbers.measurement
      when :points
        value = @quantity.to_s.to_pokemon_number
      when :percent
        percentage = (@quantity.to_f * 100 / @target.max_hp).round
        value = percentage.to_s.to_pokemon_number
      end

      value += unit
      return value
    end

    # Calculate the x-offset for the leftmost digit of the value
    # @param value [String] Displayable damage value
    # @return [Integer]
    def calculate_left_digit_x_offset(value)
      tmp_stack = UI::SpriteStack.new(viewport)
      tmp_text = tmp_stack.with_font(font_id) do
        tmp_stack.add_text(0, 0, _width = 0, _height = nil, value, _align = 0, outline_size)
      end
      return -tmp_text.real_width / 2
    ensure
      tmp_stack&.dispose
    end

    # Amount of time to wait between playing each digit's animation
    # @return [Float]
    def time_between_digits = 0.05

    # Color ID of the displayable value
    # @return [Integer]
    def color_id = Configs.zv_battle_msg.damage_numbers.hurt_color

    # Unit, if any, to display next to the value
    # @return [String]
    def unit = Configs.zv_battle_msg.damage_numbers.unit_text

    # Font ID
    # @return [Integer]
    def font_id = Configs.zv_battle_msg.damage_numbers.font_id

    # Offsets relative to a battler's sprite
    # @return [Array<Array<Integer>>]
    def position_offsets = [
      [0, -35], # Player battler
      [0, -2] # Enemy battler
    ]

    def digit_y_displacement = -5
    def move_duration = 0.3
    def wait_duration = 0.65
    def outline_size = Configs.zv_battle_msg.damage_numbers.outline_size
    def space_after_digit = 0
    def extra_space_before_unit = 1
  end

  class HealNumbers < DamageNumbers
    private

    # Color ID of the displayable value
    # @return [Integer]
    def color_id = Configs.zv_battle_msg.damage_numbers.heal_color
  end
end
