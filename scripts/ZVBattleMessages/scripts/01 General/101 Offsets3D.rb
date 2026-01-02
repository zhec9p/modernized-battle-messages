module ZVBattleMsg
  module Offsets3D
    # @return [Integer]
    def x_offset
      offset = position_offsets[@target_sprite.bank][0]
      offset += Graphics.width / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end

    # @return [Integer]
    def y_offset
      offset = position_offsets[@target_sprite.bank][1]
      offset += Graphics.height / 2 if Battle::BATTLE_CAMERA_3D
      return offset
    end
  end
end
