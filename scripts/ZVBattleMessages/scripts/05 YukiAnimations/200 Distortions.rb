module Yuki
  module Animation
    module ZVBattleMsgYukiDistortion
      DISTORTIONS[:zv_abs_function] = proc do |x|
        y = 1.0 - (x - 0.5).abs * 2.0
        next y.clamp(0.0, 1.0)
      end
    end
    prepend ZVBattleMsgYukiDistortion
  end
end
