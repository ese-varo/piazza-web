require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WINDOW_SIZE = [1400, 1400]
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end

class MobileSystemTestCase < ApplicationSystemTestCase
  def visit_with_mobile_size(path)
    visit path
    current_window.resize_to(375, 812)
  end

  teardown do
    current_window.resize_to(*ApplicationSystemTestCase::WINDOW_SIZE)
  end
end
