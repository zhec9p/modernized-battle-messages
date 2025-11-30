module Battle
  module Effects
    class PerishSong
      module ZVBattleMsgPerishSong
        def on_end_turn_event(logic, scene, battlers)
          return super unless ZVBattleMsg.replace_perish?
          return if @pokemon.dead?

          new_counter = @counter - 1
          scene.visual.zv_show_perish_animation(@pokemon, @counter, new_counter)
          message = parse_text_with_pokemon(19, 863, @pokemon, { PFM::Text::NUMB[2] => new_counter.to_s })
          scene.zv_log_battle_message(message)
          logic.damage_handler.damage_change(@pokemon.max_hp, @pokemon) if triggered?
        end
      end
      prepend ZVBattleMsgPerishSong
    end
  end
end

