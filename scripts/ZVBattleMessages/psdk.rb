# rubocop:disable Metrics/BlockLength
proc do
  # rubocop:enable Metrics/BlockLength
  raise 'This plugin requires PSDK 26.50 or newer' if PSDK_VERSION < 6706

  check_classes = proc do |namespace, class_names|
    name_conflicts = class_names.find_all { |n| namespace.const_defined?(n) }
    name_conflicts = name_conflicts.map { |n| "#{namespace}::#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  check_instance_methods = proc do |klass, method_names|
    name_conflicts = method_names.find_all { |n| klass.method_defined?(n) }
    name_conflicts = name_conflicts.map { |n| "#{klass}.#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  check_singleton_methods = proc do |klass, method_names|
    name_conflicts = method_names.find_all { |n| klass.singleton_methods.include?(n) }
    name_conflicts = name_conflicts.map { |n| "#{klass}.#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  if Object.const_defined?(:ZVBattleMsg)
    check_classes.call(
      ZVBattleMsg, %i[
        PopupMessage
        SuperEffectivePopup
        CriticalHitPopup
        UnaffectedPopup
        MissPopup
        StatChangePopup
        PerishAnimation
        HitPopupAnimation
        BattleMsgTemp
      ]
    )

    check_singleton_methods.call(
      ZVBattleMsg, %i[
        home_language
        translate_animation_filename
      ]
    )
  end

  check_instance_methods.call(
    Battle::Visual, %i[
      zv_show_unaffected_animation
      zv_show_miss_animation
      zv_show_perish_animation
    ]
  )
end.call
