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
    return File.join(MAIN_DIR_NAME, *args)
  end

  # @return [Boolean]
  def show_any_animation?
    return $options.show_animation
  end

  def replace_effectiveness? = show_any_animation? && REPLACE_EFFECTIVENESS
  def replace_critical_hit?  = show_any_animation? && REPLACE_CRITICAL_HIT
  def replace_unaffected?    = show_any_animation? && REPLACE_UNAFFECTED
  def replace_miss?          = show_any_animation? && REPLACE_MISS
  def replace_stat_change?   = show_any_animation? && REPLACE_STAT_CHANGE
  def replace_perish?        = show_any_animation? && REPLACE_PERISH
end
