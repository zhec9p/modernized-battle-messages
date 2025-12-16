module ZVBattleMsg
  class BattleMsgTemp
    # "Stack frame" for critical hit booleans for create_hp_animation_handler.
    # Very hacky, but avoids overriding chunks of code in damage_change, drain, heal, and show_hp_animations.
    # @return [Array<Array<Boolean>>]
    attr_accessor :critical_hits

    def initialize
      @critical_hits = []
    end
  end
end
