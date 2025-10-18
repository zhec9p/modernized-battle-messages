module Battle
  class Visual
    # Show an animation for a battler avoiding an attack
    # @param target [PFM::PokemonBattler]
    # @param countdown [Integer] Perish count
    def zv_show_miss_animation(target)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      popup = ZVBattleMsg::MissPopup.new(viewport, @scene, target_sprite)
      anim = popup.create_animation
      anim.play_before(ya.send_command_to(popup, :dispose))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end
