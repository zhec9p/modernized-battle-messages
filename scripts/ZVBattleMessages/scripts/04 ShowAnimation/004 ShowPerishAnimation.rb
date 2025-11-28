module Battle
  class Visual
    # Show an animation for a battler's perish count
    # @param target [PFM::PokemonBattler]
    # @param countdown [Integer] Perish count
    def zv_show_perish_animation(target, countdown)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      perish = ZVBattleMsg::PerishAnimation.new(viewport, @scene, target_sprite, countdown)

      anim = ya.player(perish.create_animation, ya.dispose_sprite(perish))
      anim.resolver = { background: @background }
      @animations << anim
      log_data("@background: #{@background}")
      anim.start
      wait_for_animation
    end
  end
end
