module Battle
  class Logic
    module ZVBattleMsgLogic
      attr_reader :zv_battle_msg_internal

      def initialize(...)
        super
        @zv_battle_msg_internal = ZVBattleUI::BattleMsgTemp.new
      end
    end
    prepend ZVBattleMsgLogic
  end
end
