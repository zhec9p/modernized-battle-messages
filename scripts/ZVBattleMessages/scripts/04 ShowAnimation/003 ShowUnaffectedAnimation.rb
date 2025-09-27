module Battle
  class Visual
    # Show animation of a battler being immune to a move
    # @param target [PFM::PokemonBattler]
    def zv_show_unaffected_animation(target)
      ya = Yuki::Animation
      target_sprite = battler_sprite(target.bank, target.position)
      animator = ZVBattleMsg::UnaffectedPopup.new(viewport, @scene, target_sprite)

      anim = animator.create_animation
      anim.play_before(ya.send_command_to(animator, :dispose))
      @animations << anim
      anim.start
      wait_for_animation
    end
  end
end
