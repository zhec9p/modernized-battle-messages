module Battle
  class Move
    module ZVBattleMsgMove
      # Show the critical hit message
      # @param actual_targets [Array<PFM::PokemonBattler>]
      # @param target [PFM::PokemonBattler]
      def hit_criticality_message(actual_targets, target)
        return if Configs.zv_battle_msg.replace_critical_hit
        return unless critical_hit?

        message = actual_targets.size == 1 ? parse_text(18, 84) : parse_text_with_pokemon(19, 384, target)
        scene.display_message_and_wait(message)
      end

      def efficent_message(effectiveness, target)
        return super unless Configs.zv_battle_msg.replace_effectiveness
      end
    end
    prepend ZVBattleMsgMove

    class Basic
      module ZVBattleMsgBasic
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit
          return true if status?
          raise 'Badly configured move, it should have positive power' if power < 0

          successful_damages = actual_targets.map do |target|
            hp = damages(user, target)
            damage_handler = @logic.damage_handler
            damage_handler.damage_change_with_process(hp, target, user, self) do
              hit_criticality_message(actual_targets, target)
              efficent_message(effectiveness, target) if hp > 0
            end
            recoil(hp, user) if recoil? && damage_handler.instance_variable_get(:@reason).nil?
            next false if damage_handler.instance_variable_get(:@reason)

            next true
          end
          new_targets = actual_targets.map.with_index { |target, index| successful_damages[index] && target }.select { |target| target }
          actual_targets.clear.concat(new_targets)
          return successful_damages.include?(true)
        end
      end
      prepend ZVBattleMsgBasic
    end

    class MultiHit
      module ZVBattleMsgMultiHit
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          @user = user
          @actual_targets = actual_targets
          @nb_hit = 0
          @hit_amount = hit_amount(user, actual_targets)
          @hit_amount.times.count do |i|
            next false unless actual_targets.all?(&:alive?)
            next false if user.dead?

            @nb_hit += 1
            play_animation(user, actual_targets) if i > 0
            actual_targets.each do |target|
              hp = damages(user, target)
              @logic.damage_handler.damage_change_with_process(hp, target, user, self) do
                hit_criticality_message(actual_targets, target)
                efficent_message(effectiveness, target) if hp > 0 && i == @hit_amount - 1
              end
              recoil(hp, user) if recoil?
            end
            next true
          end
          @scene.display_message_and_wait(parse_text(18, 33, PFM::Text::NUMB[1] => @nb_hit.to_s))
          return false if user.dead?

          return true
        end
      end
      prepend ZVBattleMsgMultiHit
    end

    class TripleKick
      module ZVBattleMsgTripleKick
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          @user = user
          @actual_targets = actual_targets
          @nb_hit = 0
          @hit_amount = hit_amount(user, actual_targets)
          @hit_amount.times.count do |i|
            break false unless actual_targets.all?(&:alive?)
            break false if user.dead?

            break false if i > 0 && !user.has_ability?(:skill_link) && (actual_targets = recalc_targets(user, actual_targets)).empty?

            play_animation(user, actual_targets) if i > 0
            actual_targets.each do |target|
              hp = damages(user, target)
              @logic.damage_handler.damage_change_with_process(hp, target, user, self) do
                hit_criticality_message(actual_targets, target)
                efficent_message(effectiveness, target) if hp > 0 && i == @hit_amount - 1
              end
              recoil(hp, user) if recoil?
            end
            @nb_hit += 1
            next true
          end
          @scene.display_message_and_wait(parse_text(18, 33, PFM::Text::NUMB[1] => @nb_hit.to_s))
          return false if user.dead?

          return true
        end
      end
      prepend ZVBattleMsgTripleKick
    end

    class Absorb
      module ZVBattleMsgAbsorb
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit
          # Status move does not deal damages
          return true if status?
          raise 'Badly configured move, it should have positive power' if power < 0

          actual_targets.each do |target|
            hp = damages(user, target)
            @logic.damage_handler.drain_with_process(hp, target, user, self, hp_overwrite: hp, drain_factor: drain_factor) do
              hit_criticality_message(actual_targets, target)
              efficent_message(effectiveness, target) if hp > 0
            end
            recoil(hp, user) if recoil?
          end

          return true
        end
      end
      prepend ZVBattleMsgAbsorb
    end

    class BeatUp
      module ZVBattleMsgBeatUp
        private

        def deal_damage_to_target(user, actual_targets, target)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          hp = damages(user, target)
          @logic.damage_handler.damage_change_with_process(hp, target, user, self) do
            hit_criticality_message(actual_targets, target)
            efficent_message(effectiveness, target) if hp > 0 && target == actual_targets.last
          end
          recoil(hp, user) if recoil?
        end
      end
      prepend ZVBattleMsgBeatUp
    end

    class DragonDarts
      module ZVBattleMsgDragonDarts
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          @user = user
          @actual_targets = actual_targets
          @nb_hit = 0
          @hit_amount = 2
          @all_targets = nil

          @all_targets = actual_targets unless actual_targets.nil?
          @all_targets += @allies_targets unless @allies_targets.nil?

          @hit_amount.times do |i|
            target = @all_targets[i % @all_targets.size]
            next false unless target.alive?
            next false if user.dead?

            if @allies_targets == [target]
              result = proceed_internal_precheck(user, [target])
              return if result.nil?
            end

            @nb_hit += 1
            play_animation(user, [target]) if @nb_hit > 1
            hp = damages(user, target)
            @logic.damage_handler.damage_change_with_process(hp, target, user, self) do
              hit_criticality_message(actual_targets, target)
              efficent_message(effectiveness, target) if hp > 0 && @nb_hit == @hit_amount
            end
            recoil(hp, user) if recoil?
          end
          @scene.display_message_and_wait(parse_text(18, 33, PFM::Text::NUMB[1] => @nb_hit.to_s))
          return false if user.dead?

          return true
        end
      end
      prepend ZVBattleMsgDragonDarts
    end

    class Synchronoise
      module ZVBattleMsgSynchronoise
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit

          actual_targets.each do |target|
            next unless share_types?(user, target)

            hp = damages(user, target)
            @logic.damage_handler.damage_change_with_process(hp, target, user, self) do
              hit_criticality_message(actual_targets, target)
              efficent_message(effectiveness, target) if hp > 0
            end
            recoil(hp, user) if recoil?
          end

          return true
        end
      end
      prepend ZVBattleMsgSynchronoise
    end

    class UTurn
      module ZVBattleMsgUTurn
        private

        def deal_damage(user, actual_targets)
          return super unless Configs.zv_battle_msg.replace_critical_hit
          # Status move does not deal damages
          return true if status?
          raise 'Badly configured move, it should have positive power' if power < 0

          actual_targets.each do |target|
            @hp = damages(user, target)
            @logic.damage_handler.damage_change_with_process(@hp, target, user, self) do
              hit_criticality_message(actual_targets, target)
              efficent_message(effectiveness, target) if @hp > 0
            end
            recoil(@hp, user) if recoil?
          end

          return true
        end
      end
      prepend ZVBattleMsgUTurn
    end
  end
end
