module Battle
  class Visual
    # Create a popup message about the effectiveness of a hit
    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram effectiveness [Integer, nil]
    # @return [ZVBattleUI::PopupMessage, nil]
    def zv_hit_effectiveness_popup(target_sprite, effectiveness)
      return nil unless effectiveness
      return ZVBattleUI::SuperEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 1
      return ZVBattleUI::NotVeryEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 0 && effectiveness < 1

      return nil
    end

    # Create a popup message about whether the hit is critical
    # @param target_sprite [BattleUI::PokemonSprite]
    # @poram critical [Boolean, nil]
    # @return [ZVBattleUI::PopupMessage, nil]
    def zv_critical_hit_popup(target_sprite, critical)
      return nil unless critical

      return ZVBattleUI::CriticalHitPopup.new(viewport, @scene, target_sprite)
    end

    # Create relevant popup messages on a hit
    # @param targets [Array<PFM::PokemonBattler>]
    # @param effectiveness [Array<Integer>]
    # @param critical [Array<Boolean>]
    # @return [Array<ZVBattleUI::PopupMessage>]
    def zv_create_hit_popup_animations(targets, effectiveness, critical)
      ya = Yuki::Animation
      popups = Hash.new { |h, k| h[k] = [] }

      targets.each_with_index do |target, index|
        target_sprite = battler_sprite(target.bank, target.position)
        popups[target] << zv_critical_hit_popup(target_sprite, critical[index]) if Configs.zv_battle_msg.replace_critical_hit
        popups[target] << zv_hit_effectiveness_popup(target_sprite, effectiveness[index]) if Configs.zv_battle_msg.replace_effectiveness
        popups[target].compact!
      end

      animations = popups.values.map do |target_popups|
        next target_popups.map.with_index do |tp, index|
          anim = ya.wait(0.5 * index)
          anim.play_before(tp.create_animation)
              .play_before(ya.send_command_to(tp, :dispose))
          anim.start
          next anim
        end
      end

      return animations.flatten
    end

    module ZVBattleMsgShowHP
      def show_hp_animations(targets, hps, effectiveness = [],
                             critical: @scene.logic.zv_battle_msg_internal.critical_hits.last || [],
                             &messages)
        return super(targets, hps, effectiveness, &messages) unless
          Configs.zv_battle_msg.replace_effectiveness ||
          Configs.zv_battle_msg.replace_critical_hit

        create_hp_animation = lambda do |target, index|
          return FakeHPAnimation.new(@scene, target, effectiveness[index]) if hps[index] && hps[index] == 0
          return HPAnimation.new(@scene, target, hps[index], effectiveness[index]) if hps[index]

          return nil
        end

        lock do
          wait_for_animation
          animations = targets.map.with_index do |target, index|
            show_info_bar(target)
            next create_hp_animation.call(target, index)
          end

          animations.compact!
          animations += zv_create_hit_popup_animations(targets, effectiveness, critical) unless animations.empty?
          scene_update_proc { animations.each(&:update) } until animations.all?(&:done?)

          messages&.call
          show_kos(targets)
        end
      end
    end
    prepend ZVBattleMsgShowHP
  end

  module VisualMock
    module ZVBattleMsgMockShowHP
      def show_hp_animations(targets, hps, effectiveness = [], critical: [], &messages)
        super(targets, hps, effectiveness, &messages)
      end
    end
    prepend ZVBattleMsgMockShowHP
  end
end
