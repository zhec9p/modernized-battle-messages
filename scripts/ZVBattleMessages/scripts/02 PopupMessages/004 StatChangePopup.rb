module ZVBattleMsg
  # Popup message for a stat stage change
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

    # @return [Yuki::Animation::AnimationMixin]
    # @note This animation doesn't dispose
    def create_animation
      ya = Yuki::Animation

      tx  = @target_sprite.x + x_offset
      ty1 = @target_sprite.y + y_offset
      ty2 = ty1 + y_displacement
      ty1, ty2 = ty2, ty1 unless stat_up?

      return ya.parallel(
        ya.move_discreet(main_duration, self, tx, ty1, tx, ty2),
        ya.player(
          ya.opacity_change(0.1, self, 0, 255),
          ya.wait(main_duration),
          ya.opacity_change(0.1, self, 255, 0)
        )
      )
    end

    # @return [Float]
    def main_duration = 1.0

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return Configs.zv_battle_msg.filepath('stat-change')
    end

    # Message to display on the popup
    # @return [String, nil]
    def text_content
      stat_name = parse_text(Configs.zv_battle_msg.csv_id, STAT_TEXT_IDS[@stat])
      stage_text = @stages.to_s
      stage_text.prepend('+') if stat_up?
      return "#{stat_name} #{stage_text}"
    end

    # @return [Array<Integer>]
    def text_position = [-48, -13]

    # @return [Boolean]
    def stat_up?
      return @stages >= 0
    end

    # @return [Integer]
    def y_displacement = -20
  end
end
