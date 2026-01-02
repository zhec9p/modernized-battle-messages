module Battle
  class Scene
    module ZVBattleMsgDisplayMessage
      def display_message(message, *_args, **_kwargs, &_block)
        return super unless message.is_a?(ZVBattleMsg::SilentTextMessage)

        zv_log_battle_message(message)
        return nil
      end
    end
    prepend ZVBattleMsgDisplayMessage
  end
end
