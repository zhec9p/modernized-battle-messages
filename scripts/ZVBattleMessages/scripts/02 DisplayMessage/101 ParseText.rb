class Object
  module ZVBattleMsgParseText
    def parse_text_with_pokemon(file_id, text_id, *_args, **_kwargs, &_block)
      message = super
      Configs.zv_battle_msg.apply_silence_settings(message, file_id, text_id)
      return message
    end

    def parse_text_with_2pokemon(file_id, text_id, *_args, **_kwargs, &_block)
      message = super
      Configs.zv_battle_msg.apply_silence_settings(message, file_id, text_id)
      return message
    end

    def parse_text(file_id, text_id, *_args, **_kwargs, &_block)
      message = super
      Configs.zv_battle_msg.apply_silence_settings(message, file_id, text_id)
      return message
    end
  end
  prepend ZVBattleMsgParseText
end
