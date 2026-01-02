module Battle
  class Visual
    # Show animation for a battler avoiding an attack
    # @param target [PFM::PokemonBattler]
    # @param countdown [Integer] Perish count
    def zv_show_miss_animation(target)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      popup = ZVBattleMsg::MissPopup.new(viewport, @scene, target_sprite)
      anim = ya.player(popup.create_animation, ya.dispose_sprite(popup))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end
