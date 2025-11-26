module BattleUI
  class PokemonSprite
    module ZVBattleMsgChangeStat
      def change_stat_animation(amount, stat = nil, target = nil)
        return super(amount) unless Configs.zv_battle_msg.replace_stat_change? && stat && target

        ya = Yuki::Animation
        popup = ZVBattleMsg::StatChangePopup.new(viewport, @scene, self, stat, amount)
        anims = [
          ya.se_play(stat_se(amount)),
          ya.player(popup.create_animation, ya.send_command_to(popup, :dispose))
        ]

        unless target&.effects&.has?(&:out_of_reach?)
          sprite = UI::StatAnimation.new(viewport, amount, z, @bank)
          sprite_duration = popup.main_duration + 0.2

          anims << ya.player(
            ya.move(0, sprite, x, y, x + sprite.x_offset, y + sprite.y_offset),
            ya.scalar(sprite_duration, sprite, :animation_progression=, 0, 1),
            a.send_command_to(sprite, :dispose)
          )
        end

        anim = ya.parallel(*anims)
        animation_handler[:stat_change] = anim
        anim.start
      end
    end
    prepend ZVBattleMsgChangeStat
  end
end

module Battle
  class Visual
    module ZVBattleMsgShowStat
      def show_stat_animation(target, amount, stat = nil)
        return super(target, amount) unless Configs.zv_battle_msg.replace_stat_change?

        wait_for_animation
        target_sprite = battler_sprite(target.bank, target.position)
        target_sprite.change_stat_animation(amount, stat, target)
        wait_for_animation
      end
    end
    prepend ZVBattleMsgShowStat
  end
end
