module ZVBattleMsg
  module_function

  # @return [String]
  def home_language
    return 'en'
  end

  # @param filename [String]
  # @return [String]
  def translate_animation_filename(filename)
    new_filename = filename
    new_filename += "_#{$options.language}" if $options.language != home_language
    return new_filename if RPG::Cache.animation_exist?(new_filename)

    return filename
  end
end
