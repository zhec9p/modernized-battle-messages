class Game_Temp
  module ZVBattleMsgGameTemp
    attr_accessor :zv_battle_msg_internal

    class ZVBattleMsgTemp
      # "Stack frame" for critical hit booleans for show_hp_animation.
      # This hacky approach avoids overriding chunks of code in damage_change, drain, and heal methods.
      # @return [Array<Array<Boolean>>]
      attr_accessor :critical_hits

      def initialize
        @critical_hits = []
      end
    end

    def initialize(...)
      super
      @zv_battle_msg_internal = ZVBattleMsgTemp.new
    end
  end
  prepend ZVBattleMsgGameTemp
end
