module Battle
  class Visual
    # Show an animation for a battler's perish count
    # @param target [PFM::PokemonBattler]
    # @param countdown [Integer] Perish count
    def show_perish_animation(target, countdown)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      perish = ZVBattleMsg::PerishAnimation.new(viewport, @scene, target_sprite, countdown)

      anim = perish.create_animation
      anim.play_before(ya.send_command_to(perish, :dispose))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end

module Battle
  module Effects
    class PerishSong
      module ZVBattleMsgPerishSong
        def on_end_turn_event(logic, scene, battlers)
          return super unless Configs.zv_battle_msg.replace_perish
          return if @pokemon.dead?

          scene.visual.show_perish_animation(@pokemon, @counter - 1)
          # scene.display_message_and_wait(parse_text_with_pokemon(19, 863, @pokemon, { PFM::Text::NUMB[2] => (@counter - 1).to_s }))
          logic.damage_handler.damage_change(@pokemon.max_hp, @pokemon) if triggered?
        end
      end
      prepend ZVBattleMsgPerishSong
    end
  end
end
