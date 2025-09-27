module Battle
  module Effects
    class PerishSong
      module ZVBattleMsgPerishSong
        def on_end_turn_event(logic, scene, battlers)
          return super unless Configs.zv_battle_msg.replace_perish
          return if @pokemon.dead?

          scene.visual.zv_show_perish_animation(@pokemon, @counter - 1)
          scene.zv_log_battle_message(parse_text_with_pokemon(19, 863, @pokemon, { PFM::Text::NUMB[2] => (@counter - 1).to_s }))
          logic.damage_handler.damage_change(@pokemon.max_hp, @pokemon) if triggered?
        end
      end
      prepend ZVBattleMsgPerishSong
    end
  end
end

