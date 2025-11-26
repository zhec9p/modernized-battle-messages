module ZVBattleMsg
  class CriticalHitPopup < PopupMessage
    include PopupMessageBasicAnimation

    private

    # Filename of the sprite to use in the popup message
    # @return [String]
    def popup_filename
      return file_join(DIR_NAME, 'critical-hit')
    end
  end
end
