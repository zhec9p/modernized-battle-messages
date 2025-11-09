module ZVBattleMsg
  class CriticalHitPopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return File.join(Constants::DIR_NAME, DIR_NAME, 'critical-hit')
    end
  end
end
