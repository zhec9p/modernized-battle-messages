module Configs
  module Project
    class ZVBattleMsg
      # Class to manage damage popup numbers settings
      class DamageNumbers
        MEASUREMENTS = %i[percent points]

        # Is this enabled?
        # @return [Boolean]
        attr_reader :enable

        # Unit of measurement to display damage popup numbers in
        # @return [Symbol] :percent, :points
        #   :percent = As a percentage of the battler's max HP
        #   :points = As an exact HP quantity
        attr_reader :measurement

        # String representation for the unit of measurement
        # @return [String]
        attr_reader :unit_text

        # Font ID of the damage popup numbers
        # @return [Integer]
        attr_reader :font_id

        # Color ID of the damage popup numbers
        # @return [Integer]
        attr_reader :hurt_color

        # Color ID of the healing popup numbers
        # @return [Integer]
        attr_reader :heal_color

        # @param settings [Hash]
        def initialize(settings)
          @enable      = settings[:enable]
          @measurement = settings[:measurement].to_sym
          @unit_text   = settings[:unit_text]
          @font_id     = settings[:font_id]
          @hurt_color  = settings[:hurt_color]
          @heal_color  = settings[:heal_color]

          raise 'Invalid measurement choice' unless MEASUREMENTS.include?(@measurement)
        end
      end

      # Class to manage message silencing settings
      class SilenceMessages
        class Message
          # ID of the CSV file where this message is located
          # @return [Integer]
          attr_reader :csv_id

          # Text ID where this message is located
          # @return [Integer]
          attr_reader :text_id

          # @param v [Hash]
          def initialize(v)
            @csv_id  = v[:csv_id]
            @text_id = v[:text_id]
          end
        end

        # Is this enabled?
        # @return [Boolean]
        attr_reader :enable

        # List of messages
        # @return [Array<Message>]
        attr_reader :messages

        # @param settings [Array<Hash>]
        def initialize(settings)
          @enable = settings[:enable]
          @messages = settings[:messages].map { |h| Message.new(h) }
        end
      end

      # ID of this plugin's CSV file
      # @return [Integer]
      attr_accessor :csv_id

      # Prefix name for this plugin's assets, used in the following ways:
      # - graphics/animations/$PREFIX/* (Here, prefix is the subfolder name)
      # - audio/se/$PREFIX-* (Here, prefix is the prefix of the filenames, followed by '-')
      # @return [String]
      attr_accessor :prefix

      # Replace the messages displayed for super-effective and not-very-effective hits with popup animations?
      # @return [Boolean]
      attr_accessor :replace_effectiveness

      # Replace the message displayed for a critical hit with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_critical_hit

      # Replace the message displayed when a move doesn't affect a battler with a popup animation?
      # @return [Boolean]
      attr_accessor :replace_unaffected

      # Replace the message displayed when an attack misses with a popup and battler animation?
      # @return [Boolean]
      attr_accessor :replace_miss

      # Replace the message displayed when a battler's stat stage changes with a popup animation?
      # @return [Boolean]
      # @note This also speeds up the vanilla stat change animation, which the popup will overlap with.
      attr_accessor :replace_stat_change

      # Replace the message displayed for a battler's perish count with a custom animation?
      # @return [Boolean]
      attr_accessor :replace_perish

      # Damage popup numbers settings
      # @return [Configs::Project::ZVBattleMsg::DamageNumbers]
      attr_reader :damage_numbers

      # Set damage popup numbers settings
      # @param settings [Hash]
      def damage_numbers=(settings)
        @damage_numbers = DamageNumbers.new(settings)
      end

      # Set battle scene messages to silence
      # @param settings [Hash]
      def silence_messages=(settings)
        @silence_messages = SilenceMessages.new(settings)
      end

      # Check if a battle scene message should be silenced
      # @param csv_id [Integer] CSV ID of the battle scene message
      # @param text_id [Integer] Text ID of the battle scene message
      # @return [Boolean]
      def silence_message?(csv_id, text_id)
        return false unless $scene.is_a?(Battle::Scene)
        return false unless @silence_messages.enable

        return @silence_messages.messages.any? do |m|
          next m.csv_id == csv_id && m.text_id == text_id
        end
      end

      # Silence a battle scene message if applicable depending on settings
      # @param message [String]
      # @param csv_id [Integer] CSV ID of the message
      # @param text_id [Integer] Text ID of the message
      def apply_silence_settings(message, csv_id, text_id)
        return unless silence_message?(csv_id, text_id)

        message.singleton_class.prepend(::ZVBattleMsg::SilentSceneMessage)
      end

      # Relative path to a graphics file for this plugin starting from graphics/animations/
      # @param filename [String]
      # @return [String]
      def animation_path(filename)
        return File.join(prefix, filename)
      end

      # Relative path to a SE file for this plugin starting from audio/se/
      # @param filename [String]
      # @return [String]
      def se_path(filename)
        return "#{prefix}-#{filename}"
      end

      # rubocop:disable Metric/MethodLength
      def initialize
        self.csv_id                = 93_208
        self.prefix                = 'zv-battle-messages'
        self.replace_effectiveness = true
        self.replace_critical_hit  = true
        self.replace_unaffected    = true
        self.replace_miss          = true
        self.replace_stat_change   = true
        self.replace_perish        = true

        self.damage_numbers = {
          enable: true,
          measurement: :percent,
          unit_text: '',
          font_id: 0,
          hurt_color: 9,
          heal_color: 13
        }

        self.silence_messages = {
          enable: true,
          messages: [
            {
              csv_id: 19,
              text_id: 243,
              comment: 'poison/toxic status end of turn'
            },
            {
              csv_id: 19,
              text_id: 261,
              comment: 'burn status end of turn'
            }
          ]
        }
      end
      # rubocop:enable Metric/MethodLength
    end
  end

  # @!method self.zv_battle_msg
  # @return [Configs::Project::ZVBattleMsg]
  register(:zv_battle_msg, File.join('plugins', 'zv_battle_msg_config'), :json, false, Project::ZVBattleMsg)
end
