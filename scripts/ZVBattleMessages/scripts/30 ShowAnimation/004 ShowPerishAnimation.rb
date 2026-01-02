module Battle
  class Visual
    # Show animation for a battler's perish count
    # @param target [PFM::PokemonBattler]
    # @param old_count [Integer]
    # @param new_count [Integer]
    def zv_show_perish_animation(target, old_count, new_count)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      perish = ZVBattleMsg::PerishAnimation.new(viewport, @scene, target_sprite, old_count, new_count)
      anim = ya.player(perish.create_animation, ya.dispose_sprite(perish))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end
