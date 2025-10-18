proc do
  raise 'This plugin requires PSDK 26.47 or later' if PSDK_VERSION < 6703

  check_class_names = proc do |scope, class_names|
    name_conflicts = class_names.find_all { |n| scope.const_defined?(n) }.map { |n| "#{scope}::#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  check_method_names = proc do |klass, method_names|
    name_conflicts = method_names.find_all { |n| klass.method_defined?(n) }.map { |n| "#{klass}.#{n}" }
    raise "Name conflict with #{name_conflicts.join(', ')}" unless name_conflicts.empty?
  end

  if Object.const_defined?(:ZVBattleMsg)
    check_class_names.call(
      ZVBattleMsg, %i[
        PopupMessage
        PopupMessagePreset
        SuperEffectivePopup
        CriticalHitPopup
        UnaffectedPopup
        MissPopup
        StatChangePopup
        PerishAnimation
        BattleMsgTemp
        HitPopupAnimation
      ]
    )
  end

  check_method_names.call(
    Battle::Visual, %i[
      zv_show_unaffected_animation
      zv_show_miss_animation
      zv_show_perish_animation
      zv_hit_criticality_message
    ]
  )
end.call
