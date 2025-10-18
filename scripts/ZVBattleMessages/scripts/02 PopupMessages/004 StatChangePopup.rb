module ZVBattleMsg
  class StatChangePopup < PopupMessage
    TEXT_IDS = { atk: 0, dfe: 1, spd: 2, ats: 3, dfs: 4, acc: 5, eva: 6 }

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

    # Text for the popup message
    def create_text
      stage_text = @stages.to_s
      stage_text.prepend('+') if stat_up?
      message = "#{stat_name} #{stage_text}"
      align_center = 1
      white = 9

      @sprite_stack.with_font(20) do
        @sprite_stack.add_text(-48, -11, 96, 8, message, align_center, 0, color: white)
      end
    end

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'stat-change')
    end

    # 3-letter name of the stat
    # @return [String]
    def stat_name
      return parse_text(Configs.zv_battle_msg.csv_id, TEXT_IDS[@stat])
    end

    # @return [Boolean]
    def stat_up?
      return @stages >= 0
    end

    class << self
      # Duration of the main part of the animation
      # @return [Float]
      def main_duration
        return 1.0
      end
    end
  end
end
