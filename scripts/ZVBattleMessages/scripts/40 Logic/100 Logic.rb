module Battle
  class Logic
    module ZVBattleMsgLogic
      def initialize(...)
        super
        $game_temp.zv_battle_msg_internal = Game_Temp::ZVBattleMsgTemp.new
      end
    end
    prepend ZVBattleMsgLogic
  end
end
