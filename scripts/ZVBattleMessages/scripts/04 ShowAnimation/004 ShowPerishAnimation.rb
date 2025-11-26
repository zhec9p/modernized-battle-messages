module Battle
  class Visual
    # Show an animation for a battler's perish count
    # @param target [PFM::PokemonBattler]
    # @param countdown [Integer] Perish count
    def zv_show_perish_animation(target, countdown)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      perish = ZVBattleMsg::PerishAnimation.new(viewport, @scene, target_sprite, countdown)
      anim = ya.player(perish.create_animation, ya.send_command_to(perish, :dispose))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end
