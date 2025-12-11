module ZVBattleMsg
  class CriticalHitPopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return Configs.zv_battle_msg.filepath('critical-hit')
    end
  end
end
