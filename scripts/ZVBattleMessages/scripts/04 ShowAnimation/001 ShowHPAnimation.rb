module Battle
  class Visual
    module ZVBattleMsgShowHP
      def zv_configure_hp_animation_handler(...)
        super
        @zv_hp_animators.add(ZVBattleUI::PopupsOnHitAnimator.new(@scene))
      end

      def show_hp_animations(*args, **kwargs, &block)
        critical_hits = @scene.logic.zv_battle_msg_internal.critical_hits.last || []
        super(*args, critical: critical_hits, **kwargs, &block)
      end
    end
    prepend ZVBattleMsgShowHP
  end

  module VisualMock
    module ZVBattleMsgMockShowHP
      def show_hp_animations(*args, **kwargs, &block)
        super(*args, critical: [], **kwargs, &block)
      end
    end
    prepend ZVBattleMsgMockShowHP
  end
end
