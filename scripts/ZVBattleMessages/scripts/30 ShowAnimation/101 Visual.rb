module Battle
  class Visual
    module ZVBattleMsgVisual
      def create_graphics(...)
        zv_create_usage_bars
        super
      end

      def create_animations(...)
        zv_create_animation_usage_bars
        super
      end

      def update(...)
        super
        zv_update_usage_bars
      end

      def zv_create_usage_bars
        @zv_move_usage_bar = ZVBattleMsg::MoveUsageBar.new(@viewport_sub, @scene)
        @zv_bag_usage_bar = ZVBattleMsg::BagUsageBar.new(@viewport_sub, @scene)
      end

      # Create the ability bars animations
      def zv_create_animation_usage_bars
        @zv_move_usage_bar.create_animation
        @zv_bag_usage_bar.create_animation
      end

      # Update the Ability bars
      def zv_update_usage_bars
        @zv_move_usage_bar.update
        @zv_bag_usage_bar.update
      end
    end
    prepend ZVBattleMsgVisual
  end
end
