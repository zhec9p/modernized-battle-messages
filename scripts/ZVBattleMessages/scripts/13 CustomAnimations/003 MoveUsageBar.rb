module ZVBattleMsg
  class MoveUsageBarAnimation < UI::SpriteStack
    include Offsets3D
    include HideShow

    # @param viewport [Viewport]
    # @param scene [Battle::Scene]
    # @param move [Battle::Move]
    def initialize(viewport, scene)
      super(viewport, default_cache: :interface)
      @scene = scene

      create_background
      create_icon
      create_text
    end

    # @param move [Battle::Move]
    def data=(move)
      super(move.user)
      @user_name = move.user.given_name
      @move_name = move.name
    end

    # Create the animation
    def create_animation
      @animation_handler = Yuki::Animation::Handler.new
    end

    # Update the animations
    def update
      @animation_handler.update
    end

    # Tell if the animations are done
    # @return [Boolean]
    def done?
      return @animation_handler.done?
    end

    private

    def create_background
      @background = add_sprite(0, 0, NO_INITIAL_IMAGE, type: Background)
    end

    def create_icon
      add_sprite(*icon_coordinates, NO_INITIAL_IMAGE, false, type: PokemonIconSprite)
    end

    def create_text
      dimensions = [0, nil]

      with_font(user_font_id) do
        add_text(*user_text_coordinates, *dimensions, :user_name, color: user_color_id, type: SymText)
      end

      with_font(move_font_id) do
        add_text(*move_text_coordinates, *dimensions, :move_name, color: move_color_id, type: SymText)
      end
    end

    class Background < Sprite
      # @param pokemon [PFM::PokemonBattler]
      def data=(user)
        return unless (self.visible = user)

        set_bitmap(background_filename(user), :interface)
      end

      # @param user [PFM::PokemonBattler]
      # @return [String]
      def background_filename(user)
        config = Configs.zv_battle_msg
        return config.interface_path('usage_bar_enemy') if user.bank != 0
        return config.interface_path('usage_bar_player') if user.from_party?

        return config.interface_path('usage_bar_ally')
      end
    end

    def icon_coordinates = [2, 1]
    def user_text_coordinates = [39, 0]
    def user_font_id  = 20
    def user_color_id = 9
    def move_text_coordinates = [39, Fonts.line_height(user_font_id) + 2]
    def move_font_id  = 0
    def move_color_id = 9
  end
end
