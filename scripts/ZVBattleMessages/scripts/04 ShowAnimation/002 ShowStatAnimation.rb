module BattleUI
  class PokemonSprite
    module ZVBattleMsgChangeStat
      def change_stat_animation(amount, stat = nil, target = nil)
        return super(amount) unless Configs.zv_battle_msg.replace_stat_change && stat && target

        ya = Yuki::Animation
        anim = ya.se_play(stat_se(amount))

        unless target&.effects&.has?(&:out_of_reach?)
          sprite = UI::StatAnimation.new(viewport, amount, z, @bank)
          sprite_anim = ya.move(0, sprite, x, y, x + sprite.x_offset, y + sprite.y_offset)
          sprite_duration = [0.1, ZVBattleMsg::StatChangePopup.main_duration + 0.2].max
          sprite_anim.play_before(ya.scalar(sprite_duration, sprite, :animation_progression=, 0, 1))
                     .play_before(ya.send_command_to(sprite, :dispose))
          anim.parallel_add(sprite_anim)
        end

        popup = ZVBattleMsg::StatChangePopup.new(viewport, @scene, self, stat, amount)
        popup_anim = popup.create_animation
        popup_anim.play_before(ya.send_command_to(popup, :dispose))
        anim.parallel_add(popup_anim)

        anim.start
        animation_handler[:stat_change] = anim
      end
    end
    prepend ZVBattleMsgChangeStat
  end
end

module Battle
  class Visual
    module ZVBattleMsgShowStat
      def show_stat_animation(target, amount, stat = nil)
        return super(target, amount) unless Configs.zv_battle_msg.replace_stat_change

        wait_for_animation
        target_sprite = battler_sprite(target.bank, target.position)
        target_sprite.change_stat_animation(amount, stat, target)
        wait_for_animation
      end
    end
    prepend ZVBattleMsgShowStat
  end
end
