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

  # @param args [Array<String>]
  # @return [String]
  def file_join(*args)
    return File.join(Configs.zv_battle_msg.dir_name, *args)
  end
end
