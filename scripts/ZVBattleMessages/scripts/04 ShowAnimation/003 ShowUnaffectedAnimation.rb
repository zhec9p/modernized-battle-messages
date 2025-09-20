module Battle
  class Visual
    # Show animation of a battler being immune to a move
    # @param target [PFM::PokemonBattler]
    def show_unaffected_animation(target)
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

  class Move
    module ZVBattleMsgAccuracyImmunity
      def accuracy_immunity_test(user, targets)
        return super unless Configs.zv_battle_msg.replace_unaffected

        return targets.select do |target|
          if target_immune?(user, target)
            scene.visual.show_unaffected_animation(target)
            # scene.display_message_and_wait(parse_text_with_pokemon(19, 210, target))
            next false
          elsif move_blocked_by_target?(user, target)
            next false
          end

          next true
        end
      end
    end
    prepend ZVBattleMsgAccuracyImmunity
  end
end
