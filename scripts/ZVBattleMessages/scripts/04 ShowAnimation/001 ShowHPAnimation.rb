module Battle
  class Visual
    module ZVBattleMsgShowHP
      def show_hp_animations(targets, hps, effectiveness = [], &messages)
        return super(targets, hps, effectiveness, &messages) unless
          Configs.zv_battle_msg.replace_effectiveness ||
          Configs.zv_battle_msg.replace_critical_hit

        critical = @scene.logic.zv_battle_msg_internal.critical_hits.last || []
        lock do
          wait_for_animation
          animations = []

          targets.each_with_index do |target, index|
            show_info_bar(target)
            hp = hps[index]
            next unless hp

            animations << Battle::Visual::FakeHPAnimation.new(@scene, target, effectiveness[index]) if hp == 0
            animations << Battle::Visual::HPAnimation.new(@scene, target, hp, effectiveness[index]) if hp != 0
            animations << ZVBattleUI::HitPopupAnimation.new(@scene).create_animation(
              target, hp,
              effectiveness: effectiveness[index],
              critical: critical[index]
            )
          end

          animations.each(&:start)
          scene_update_proc { animations.each(&:update) } until animations.all?(&:done?)
          messages&.call
          show_kos(targets)
        end
      end
    end
    prepend ZVBattleMsgShowHP
  end
end
