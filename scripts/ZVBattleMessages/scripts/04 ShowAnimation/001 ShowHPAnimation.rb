module Battle
  class Visual
    module ZVBattleMsgHitPopup
      # Create a popup message about the effectiveness of a hit
      # @param target_sprite [BattleUI::PokemonSprite]
      # @poram effectiveness [Integer, nil]
      # @return [ZVBattleMsg::PopupMessage, nil]
      def hit_effectiveness_popup(target_sprite, effectiveness)
        return nil unless effectiveness
        return ZVBattleMsg::SuperEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 1
        return ZVBattleMsg::NotVeryEffectivePopup.new(viewport, @scene, target_sprite) if effectiveness > 0 && effectiveness < 1

        return nil
      end

      # Create a popup message about whether the hit is critical
      # @param target_sprite [BattleUI::PokemonSprite]
      # @poram critical [Boolean, nil]
      # @return [ZVBattleMsg::PopupMessage, nil]
      def critical_hit_popup(target_sprite, critical)
        return nil unless critical

        return ZVBattleMsg::CriticalHitPopup.new(viewport, @scene, target_sprite)
      end

      # Create relevant popup messages on a hit
      # @param targets [Array<PFM::PokemonBattler>]
      # @param effectiveness [Array<Integer>]
      # @param critical [Array<Boolean>]
      # @return [Array<ZVBattleMsg::PopupMessage>]
      def create_hit_popup_animations(targets, effectiveness, critical)
        ya = Yuki::Animation
        popups = Hash.new { |h, k| h[k] = [] }

        targets.each_with_index do |target, index|
          target_sprite = battler_sprite(target.bank, target.position)
          popups[target] << critical_hit_popup(target_sprite, critical[index]) if Configs.zv_battle_msg.replace_critical_hit
          popups[target] << hit_effectiveness_popup(target_sprite, effectiveness[index]) if Configs.zv_battle_msg.replace_effectiveness
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

      def show_hp_animations(targets, hps, effectiveness = [], critical: [], &messages)
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
          animations += create_hit_popup_animations(targets, effectiveness, critical) unless animations.empty?
          scene_update_proc { animations.each(&:update) } until animations.all?(&:done?)

          messages&.call
          show_kos(targets)
        end
      end
    end
    prepend ZVBattleMsgHitPopup
  end

  module VisualMock
    def show_hp_animations(targets, hps, effectiveness = [], critical: [], &messages)
      return
    end
  end

  class Logic
    class DamageHandler
      module ZVBattleMsgDamageHandler
        def damage_change(hp, target, launcher = nil, skill = nil, &messages)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          skill&.damage_dealt += hp
          @scene.visual.show_hp_animations([target], [-hp], [skill&.effectiveness], critical: [skill&.critical_hit?], &messages)
          target.last_hit_by_move = skill if skill
          exec_hooks(DamageHandler, :post_damage, binding) if target.hp > 0

          if target.hp <= 0
            exec_hooks(DamageHandler, :post_damage_death, binding)
            target.ko_count += 1
          end

          target.add_damage_to_history(hp, launcher, skill, target.hp <= 0)
          log_data("# damage_change(#{hp}, #{target}, #{launcher}, #{skill}, #{target.hp <= 0})")
        rescue Hooks::ForceReturn => e
          log_data("# FR: damage_change #{e.data} from #{e.hook_name} (#{e.reason})")
          return e.data
        ensure
          @scene.visual.refresh_info_bar(target)
        end

        def drain(hp_factor, target, launcher, skill = nil, hp_overwrite: nil, drain_factor: 1, &messages)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          hp = hp_overwrite || (target.max_hp / hp_factor).clamp(1, Float::INFINITY)
          skill&.damage_dealt += hp
          @scene.visual.show_hp_animations([target], [-hp], [skill&.effectiveness], critical: [skill&.critical_hit?], &messages)
          target.last_hit_by_move = skill if skill

          hp_multiplier = 1.0
          log_data("# drain hp_multiplier = #{hp_multiplier} before pre_drain hook")
          exec_hooks(DamageHandler, :pre_drain, binding)
          log_data("# drain hp_multiplier = #{hp_multiplier} after pre_drain hook")

          hp_healed = (hp * hp_multiplier / drain_factor).to_i.clamp(1, Float::INFINITY)
          exec_hooks(DamageHandler, :drain_prevention, binding)
          log_data("# drain drain_appliable? #{hp_healed > 0} after drain_prevention hook")

          @scene.display_message_and_wait(parse_text_with_pokemon(19, 905, target)) if hp_healed > 0 && launcher.alive? && heal(launcher, hp_healed)

          exec_hooks(DamageHandler, :post_damage, binding) if target.hp > 0
          if target.hp <= 0
            exec_hooks(DamageHandler, :post_damage_death, binding)
            target.ko_count += 1
          end

          target.add_damage_to_history(hp, launcher, skill, target.hp <= 0)
          log_data("# drain damage_change(#{hp}, #{target}, #{launcher}, #{skill}, #{target.hp <= 0})")
        rescue Hooks::ForceReturn => e
          log_data("# FR: drain damage_change #{e.data} from #{e.hook_name} (#{e.reason})")
          return e.data
        ensure
          @scene.visual.refresh_info_bar(target)
        end
      end
      prepend ZVBattleMsgDamageHandler
    end
  end
end
