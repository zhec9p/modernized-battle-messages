module ZVBattleMsg
  class StatChangePopup < PopupMessage
    STAT_TEXT_IDS = { atk: 0, dfe: 1, spd: 2, ats: 3, dfs: 4, acc: 5, eva: 6 }

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param target_sprite [BattleUI::PokemonSprite]
    # @param stat [Symbol]
    # @param stages [Integer]
    def initialize(viewport, scene, target_sprite, stat, stages)
      @stat = stat
      @stages = stages
      super(viewport, scene, target_sprite)
    end

    # @return [Yuki::Animation::TimedAnimation]
    # @note This animation doesn't dispose
    def create_animation
      x = @target_sprite.x + x_offset
      y1 = @target_sprite.y + y_offset
      y2 = y1 - 20
      y1, y2 = y2, y1 unless stat_up?

      ya = Yuki::Animation
      appear_anim = ya.opacity_change(0.1, @sprite_stack, 0, 255)
      appear_anim.play_before(ya.wait(self.class.main_duration))
                 .play_before(ya.opacity_change(0.1, @sprite_stack, 255, 0))

      anim = ya.move_discreet(self.class.main_duration, @sprite_stack, x, y1, x, y2)
      anim.parallel_add(appear_anim)
      return anim
    end

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(ROOT_DIR_NAME, DIR_NAME, 'stat-change')
    end

    # Message to display on the popup
    # @return [String, nil]
    def text_content
      stat_name = parse_text(Configs.zv_battle_msg.csv_id, STAT_TEXT_IDS[@stat])
      stage_text = @stages.to_s
      stage_text.prepend('+') if stat_up?
      return "#{stat_name} #{stage_text}"
    end

    # Position of the text relative to the popup's sprite stack
    # @return [Array<Integer>]
    def text_position = [-48, -13]

    # @return [Boolean]
    def stat_up?
      return @stages >= 0
    end

    class << self
      # Duration of the main part of the animation
      # @return [Float]
      def main_duration = 1.0
    end
  end
end
