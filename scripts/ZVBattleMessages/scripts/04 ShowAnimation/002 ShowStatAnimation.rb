module BattleUI
  class PokemonSprite
    module ZVBattleMsgChangeStat
      def change_stat_animation(amount, stat = nil, target = nil)
        return super(amount) unless Configs.zv_battle_msg.replace_stat_change? && stat && target

        ya = Yuki::Animation
        out_of_reach = target&.effects&.has?(&:out_of_reach?)

        # StatChangePopup must be instantiated after StatAnimation to ensure that
        # the stat animation's particles don't obscure the popup.
        aura  = UI::StatAnimation.new(viewport, amount, z, @bank) unless out_of_reach
        popup = ZVBattleMsg::StatChangePopup.new(viewport, @scene, self, stat, amount)
        anims = [
          ya.se_play(stat_se(amount)),
          ya.player(popup.create_animation, ya.send_command_to(popup, :dispose))
        ]

        unless out_of_reach
          anims << ya.player(
            ya.move(0, aura, x, y, x + aura.x_offset, y + aura.y_offset),
            ya.scalar(popup.main_duration + 0.2, aura, :animation_progression=, 0, 1),
            ya.send_command_to(aura, :dispose)
          )

          popup.z = [popup.z, aura.z + 1].max
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
